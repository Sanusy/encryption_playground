import 'package:encryption_playground/login/login_cubit.dart';
import 'package:encryption_playground/login/login_state.dart';
import 'package:encryption_playground/users/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, LoginState state) {
          state.event?.when(userLoggedIn: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const UsersScreen(),
              ),
            );
          });
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Log in'),
            ),
            body: Center(
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : OutlinedButton(
                      onPressed: context.read<LoginCubit>().logInWithGoogle,
                      child: const Text('Log in with google'),
                    ),
            ),
          );
        },
      ),
    );
  }
}
