import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/memberships/membership_list/membership_list_state.dart';
import 'package:resipal_core/domain/use_cases/memberships/watch_memberships_by_community.dart';
import 'package:resipal_core/services/logger_service.dart';

class MemberListCubit extends Cubit<MembershipListState> {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  final WatchMembershipsByCommunity _watchMembers = WatchMembershipsByCommunity();
  StreamSubscription? _streamSubscription;

  MemberListCubit() : super(InitialState());

  Future<void> initialize() async {
    try {
      emit(LoadingState());

      final communityId = _sessionService.communityId;

      _streamSubscription = _watchMembers
          .call(communityId)
          .listen(
            (members) {
              if (members.isEmpty) {
                emit(EmptyState());
              } else {
                emit(LoadedState(members));
              }
            },
            onError: (e, s) {
              _logger.logException(
                exception: e, 
                stackTrace: s, 
                featureArea: 'MemberListCubit.initialize / listener'
              );
              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(
        exception: e, 
        stackTrace: s, 
        featureArea: 'MemberListCubit.initialize'
      );
      emit(ErrorState());
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}