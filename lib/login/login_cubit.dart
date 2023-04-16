import 'package:bloc/bloc.dart';
import 'package:encryption_playground/login/login_state.dart';
import 'package:encryption_playground/main.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(isLoading: true));
    final userPublicKey = await encryptionService.generateUserKeys();

    await firebaseService.logInWithGoogle(userPublicKey);

    emit(state.copyWith(
      isLoading: false,
      event: const LoginEvent.userLoggedIn(),
    ));
  }
}
