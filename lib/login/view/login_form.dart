import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/app/app.dart';
import 'package:flutter_firebase_login/forgot_password/forgot_password.dart';
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
  static const failureState = 1;
  static const successfulState = 2;
  static const otherState = 0;
  static const loginScreen = true;
  static const signupScreen = false;

  late StateController _stateController;

  String? passwordError;
  String? userError;
  String? userForgotPasswordError;
  bool currentScreen = loginScreen;
  bool onForgotPasswordScreen = false;

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
          return successfulState;
        case FormzSubmissionStatus.failure:
          return failureState;
        default:
          return otherState;
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
        BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            userForgotPasswordError =
                state.email.isNotValid ? 'Invalid user' : '';
            _stateController.changeState(observeState(state.status));
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final stateLogin = context.watch<LoginCubit>().state;
          final stateSignup = context.watch<SignUpCubit>().state;
          final stateForgotPassword =
              context.watch<ForgotPasswordCubit>().state;

          return FlutterLogin(
            logo: const AssetImage('assets/bloc_logo_small.png'),
            isBlocPattern: true,
            stateController: _stateController,
            loginAfterSignUp: false,
            autoValidateModeForm: AutovalidateMode.onUserInteraction,
            loginProviders: [
              LoginProvider(
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
                context.read<SignUpCubit>().replaceUserInfo(
                    stateLogin.email.value, stateLogin.password.value);
              } else {
                currentScreen = loginScreen;
                context.read<LoginCubit>().replaceUserInfo(
                    stateSignup.email.value, stateSignup.password.value);
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
              if (!onForgotPasswordScreen) {
                return userError != '' ? userError ?? 'Empty email' : null;
              } else {
                return userForgotPasswordError != ''
                    ? userForgotPasswordError ?? 'Empty email'
                    : null;
              }
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
            onChangedRecoverUser: (value) {
              context.read<ForgotPasswordCubit>().emailChanged(value!);
            },
            onForgotPasswordSwitch: () {
              if (!onForgotPasswordScreen) {
                onForgotPasswordScreen = true;
                if (currentScreen == loginScreen) {
                  context
                      .read<ForgotPasswordCubit>()
                      .emailChanged(stateLogin.email.value);
                } else {
                  context
                      .read<ForgotPasswordCubit>()
                      .emailChanged(stateSignup.email.value);
                }
              } else {
                onForgotPasswordScreen = false;
                if (currentScreen == loginScreen) {
                  context
                      .read<LoginCubit>()
                      .emailChanged(stateForgotPassword.email.value);
                } else {
                  context
                      .read<SignUpCubit>()
                      .emailChanged(stateForgotPassword.email.value);
                }
              }
            },
            onRecoverPassword: (user) {
              context.read<ForgotPasswordCubit>().recoverPassword();
            },
          );
        },
      ),
    );
  }
}
