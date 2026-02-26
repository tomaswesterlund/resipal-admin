import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/auth/auth_state.dart';
import 'package:resipal_core/lib.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AuthService _authService = GetIt.I<AuthService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  AuthCubit() : super(InitialState());

  Future initialize() async {
    try {
      emit(LoadingState());
      await Future.delayed(Duration.zero);

      if (_authService.userIsSignedIn) {
        final userId = _authService.getSignedInUserId();

        await FetchUsers().call();
        await FetchCommunities().call();
        await FetchApplications().byUserId(userId);
        await FetchMemberships().byUserId(userId);

        final userOnboarded = await UserIsOnboarded().call(userId);
        if (userOnboarded == false) {
          emit(UserNotOnboarded());
          return;
        }

        final userAccessRegistry = GetUserAccessRegistry().call(userId);

        if (userAccessRegistry.adminMemberships.isNotEmpty) {
          // TODO: Update this logic, ust get first for now
          final membership = userAccessRegistry.adminMemberships.first;
          await _sessionService.startWatchers(userId: userId, communityId: membership.community.id);

          final user = GetUser().call(userId);
          final community = GetCommunityById().call(membership.community.id);

          emit(UserSignedIn(community, user));
          return;
        }

        if (userAccessRegistry.adminMemberships.isEmpty) {
          emit(UserHasNoAdminMembership());
          return;
        }

        throw Exception('Unknown state!');
      } else {
        emit(UserNotSignedIn());
      }
    } catch (e, s) {
      _logger.logException(exception: e, featureArea: 'AuthCubit.initialize', stackTrace: s);
      emit(ErrorState());
    }
  }
}
