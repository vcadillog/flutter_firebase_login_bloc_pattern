import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/forgot_password/forgot_password.dart';
import 'package:flutter_firebase_login/login/login.dart';
import 'package:flutter_firebase_login/screens/cubit/screens_cubit.dart';
import 'package:flutter_firebase_login/sign_up/sign_up.dart';
// import 'package:flutter_firebase_login/screens/view/main_screen.dart';
import 'package:flutter_firebase_login/login/view/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ScreensCubit(),
            ),
            BlocProvider(
              create: (_) =>
                  LoginCubit(context.read<AuthenticationRepository>()),
            ),
            BlocProvider(
              create: (_) =>
                  SignUpCubit(context.read<AuthenticationRepository>()),
            ),
            BlocProvider(
              create: (_) =>
                  ForgotPasswordCubit(context.read<AuthenticationRepository>()),
            ),
          ],
          child: const LoginForm(),
        ),
      ),
    );
  }
}
