import 'package:bloc/bloc.dart';
import 'package:encryption_playground/main.dart';
import 'package:encryption_playground/model/user.dart';
import 'package:encryption_playground/users/users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState.initial());

  Future<void> loadUsers() async {
    emit(state.copyWith(isLoading: true));

    final currentUserId = firebaseService.currentUserId!;
    final users = await firebaseService.loadUsers();

    emit(state.copyWith(
      isLoading: false,
      users: users.where((user) => user.id != currentUserId).toList(),
    ));
  }

  Future<void> onOpenChat(User userToChatWith) async {
    emit(state.copyWith(isLoading: true));
    final chat = await firebaseService.chatWithUser(userToChatWith);

    emit(state.copyWith(
      isLoading: false,
      event: UsersEvent.openChat(chat, userToChatWith),
    ));
  }

  Future<void> onLogOut(User userToChatWith) async {
    emit(state.copyWith(isLoading: true));
    await firebaseService.logOut();
    await encryptionService.clearKeys();

    emit(state.copyWith(
      isLoading: false,
      event: const UsersEvent.logOut(),
    ));
  }
}
