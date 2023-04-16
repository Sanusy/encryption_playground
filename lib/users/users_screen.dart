import 'package:encryption_playground/chat/chat_screen.dart';
import 'package:encryption_playground/login/login_screen.dart';
import 'package:encryption_playground/users/users_cubit.dart';
import 'package:encryption_playground/users/users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UsersCubit()..loadUsers(),
      child: BlocConsumer<UsersCubit, UsersState>(
        listener: (context, UsersState state) {
          state.event?.when(openChat: (chat, userToChatWith) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  chat: chat,
                  userToChatWith: userToChatWith,
                ),
              ),
            );
          }, logOut: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          });
        },
        builder: (context, state) {
          late final Widget body;
          if (state.isLoading) {
            body = const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.users.isEmpty) {
            body = const Center(
              child: Text('There are no other users'),
            );
          } else {
            body = ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  onTap: () => context.read<UsersCubit>().onOpenChat(user),
                  title: Text(user.userEmail),
                );
              },
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Users'),
            ),
            body: body,
          );
        },
      ),
    );
  }
}
