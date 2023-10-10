import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/app/app.dart';
import 'package:flutter_firebase_login/login/cubit/login_cubit.dart';
import 'package:flutter_firebase_login/sign_up/sign_up.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static const failureLogin = 1;
  static const successfulLogin = 2;
  static const otherLoginState = 0;
  static const loginScreen = true;
  static const signupScreen = false;

  late StateController _stateController;

  String? passwordError;
  String? userError;
  bool currentScreen = loginScreen;

  @override
  void initState() {
    _stateController = StateController();
    super.initState();
  }

  @override
  void dispose() {
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int observeState(FormzSubmissionStatus state) {
      switch (state) {
        case FormzSubmissionStatus.success:
          return successfulLogin;
        case FormzSubmissionStatus.failure:
          return failureLogin;
        default:
          return otherLoginState;
      }
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            userError = state.email.isNotValid ? 'Invalid user' : '';
            passwordError = state.password.isNotValid ? 'Invalid password' : '';
            _stateController.changeState(observeState(state.status));
          },
        ),
        BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            userError = state.email.isNotValid ? 'Invalid user' : '';
            passwordError = state.password.isNotValid ? 'Invalid password' : '';
            _stateController.changeState(observeState(state.status));
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final stateLogin = context.watch<LoginCubit>().state;
          final stateSignup = context.watch<SignUpCubit>().state;

          return FlutterLogin(
            logo: const AssetImage('assets/bloc_logo_small.png'),
            isBlocPattern: true,
            stateController: _stateController,
            loginAfterSignUp: false,
            autoValidateModeForm: AutovalidateMode.onUserInteraction,
            loginProviders: [
              LoginProvider(
                // icon: FontAwesomeIcons.google,
                button: Buttons.googleDark,
                label: 'Google',
                callback: () async {
                  context.read<LoginCubit>().logInWithGoogle();
                },
              ),
            ],
            onSwitchButton: () {
              if (currentScreen == loginScreen) {
                currentScreen = signupScreen;
                context
                    .read<SignUpCubit>()
                    .emailChanged(stateLogin.email.value);
                context
                    .read<SignUpCubit>()
                    .passwordChanged(stateLogin.password.value);
              } else {
                currentScreen = loginScreen;
                context
                    .read<LoginCubit>()
                    .emailChanged(stateSignup.email.value);
                context
                    .read<LoginCubit>()
                    .passwordChanged(stateSignup.password.value);
              }
            },
            onChangedUserField: (user) {
              if (currentScreen == loginScreen) {
                context.read<LoginCubit>().emailChanged(user!);
              } else {
                context.read<SignUpCubit>().emailChanged(user!);
              }
            },
            onChangedPasswordField: (password) {
              if (currentScreen == loginScreen) {
                context.read<LoginCubit>().passwordChanged(password!);
              } else {
                context.read<SignUpCubit>().passwordChanged(password!);
              }
            },
            onChangedConfirmPasswordField: (password) {
              context.read<SignUpCubit>().confirmedPasswordChanged(password!);
            },
            userValidator: (_) {
              return userError != '' ? userError ?? 'Empty email' : null;
            },
            passwordValidator: (_) {
              return passwordError != ''
                  ? passwordError ?? 'Empty password'
                  : null;
            },
            onLogin: (user) {
              context.read<LoginCubit>().logInWithCredentials();
            },
            onSignup: (user) {
              context.read<SignUpCubit>().signUpFormSubmitted();
            },
            onSubmitAnimationCompleted: () {
              context.read<AppBloc>().add(const AppAnimationFinished());
            },
            onRecoverPassword: (user) => null,
          );
        },
      ),
    );
  }
}
