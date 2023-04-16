import 'package:encryption_playground/model/chat.dart';
import 'package:encryption_playground/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'users_state.freezed.dart';

@freezed
class UsersState with _$UsersState {
  const factory UsersState({
    required bool isLoading,
    required List<User> users,
    required UsersEvent? event,
  }) = _UsersState;

  factory UsersState.initial() => const UsersState(
        isLoading: false,
        users: [],
        event: null,
      );
}

@freezed
class UsersEvent with _$UsersEvent {
  const factory UsersEvent.openChat(Chat chat, User userToChatWith) = _OpenChat;
  const factory UsersEvent.logOut() = _LogOut;
}
