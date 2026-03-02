import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/signin/signin_state.dart';
import 'package:resipal_core/lib.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthService _authService = GetIt.I<AuthService>();
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  SigninCubit() : super(InitialState());

  Future signin() async {
    try {
      emit(AdminSigningInState());
      final iosClientId = dotenv.get('GOOGLE_OAUTH_IOS_CLIENT_ID');
      final serverClientId = dotenv.get('SUPABASE_ANON_KEY');

      await _authService.signInWithGoogle(iosClientId: iosClientId, serverClientId: serverClientId);

      final authUser = _authService.getSignedInUser();
      final userId = authUser.id;

      // await _sessionService.startWatchers(userId);

      emit(AdminSignedInSuccessfullyState());
    } catch (e, stack) {
      if (e is GoogleSignInException) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          emit(InitialState());
          return;
        }
      }

      _logger.logException(exception: e, stackTrace: stack, featureArea: 'SigninCubit.signin');
      emit(ErrorState());
    }
  }
}
