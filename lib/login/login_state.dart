import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    required bool isLoading,
    required LoginEvent? event,
  }) = _LoginState;

  factory LoginState.initial() => const LoginState(
        isLoading: false,
        event: null,
      );
}

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.userLoggedIn() = _UserLoggeddIn;
}
