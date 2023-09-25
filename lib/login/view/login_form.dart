import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/app/bloc/animation/animations_cubit.dart';
import 'package:flutter_firebase_login/login/login.dart';
import 'package:flutter_firebase_login/sign_up/sign_up.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: BlocBuilder<AnimationCubit, AnimationState>(
        builder: (context, state) {
          return Align(
            alignment: const Alignment(0, -1 / 3),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/bloc_logo_small.png',
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      width: 350,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 22.5),
                          _EmailInput(),
                          const SizedBox(height: 8),
                          _PasswordInput(),
                          const SizedBox(height: 8),
                          _LoginButton(),
                          const SizedBox(height: 8),
                          _SignUpButton(),
                          const SizedBox(height: 4),
                          _GoogleLoginButton(),
                          const SizedBox(height: 25)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              prefixIcon:
                  const Icon(FontAwesomeIcons.solidUser, color: Colors.grey),
              labelText: 'email',
              helperText: '',
              errorText:
                  state.email.displayError != null ? 'Invalid email' : null,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool viewPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: !viewPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              prefixIcon: const Icon(FontAwesomeIcons.lock, color: Colors.grey),
              suffixIcon: GestureDetector(
                child: Icon(
                  viewPassword
                      ? FontAwesomeIcons.solidEye
                      : FontAwesomeIcons.eye,
                  color: Colors.grey,
                ),
                onTap: () => setState(() {
                  viewPassword = !viewPassword;
                }),
              ),
              labelText: 'password',
              helperText: '',
              errorText: state.password.displayError != null
                  ? 'Invalid password'
                  : null,
              errorMaxLines: 3,
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final stateLogin = context.watch<LoginCubit>().state;
        final stateAnimation =
            context.watch<AnimationCubit>().state.signUpPushed;
        return stateLogin.status.isInProgress
            ? const CircularProgressIndicator()
            : TextButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: stateAnimation
                      ? Colors.transparent
                      : const Color(0xFFFFD600),
                ),
                onPressed: stateLogin.isValid
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : () => (),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: stateLogin.isValid ? Colors.purple : Colors.grey,
                  ),
                ),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton.icon(
        key: const Key('loginForm_googleLogin_raisedButton'),
        label: const Text(
          'SIGN IN WITH GOOGLE',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: theme.colorScheme.secondary,
        ),
        icon: const Icon(
          FontAwesomeIcons.google,
          color: Colors.white,
        ),
        onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AnimationCubit, AnimationState>(
      builder: (context, state) {
        return TextButton(
          key: const Key('loginForm_createAccount_flatButton'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            // backgroundColor: const Color(0xFFFFD600),
            backgroundColor: state.signUpPushed
                ? const Color(0xFFFFD600)
                : Colors.transparent,
          ),
          onPressed: () {
            context.read<AnimationCubit>().signupPressed();
            FocusScope.of(context).unfocus();
            Navigator.of(context).push<void>(
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const SignUpPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          child: Text(
            'SIGNUP',
            style: TextStyle(color: theme.primaryColor),
          ),
        );
      },
    );
  }
}
