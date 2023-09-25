import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/app/bloc/animation/animations_cubit.dart';
import 'package:flutter_firebase_login/sign_up/sign_up.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
      child: Align(
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
                      _ConfirmPasswordInput(),
                      const SizedBox(height: 8),
                      _SignUpButton(),
                      const SizedBox(height: 8),
                      _LoginButton(),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
          // onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
          onPressed: () => state.signUpPushed
              ? null
              : context.read<AnimationCubit>().signupPressed(),
          child: Text(
            'SIGNUP',
            style: TextStyle(color: theme.primaryColor),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            key: const Key('signUpForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<SignUpCubit>().emailChanged(email),
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
  State<_PasswordInput> createState() => _PasswordSInputState();
}

class _PasswordSInputState extends State<_PasswordInput> {
  bool viewPassword = false;

  String errorText = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        switch (state.password.displayError) {
          case PasswordValidationError.invalid:
            errorText =
                'Password must be at least 8 characters long and have one letter and a number.';
          case PasswordValidationError.invalidLen:
            errorText = 'Password must be at least 8 characters long.';
          case PasswordValidationError.invalidLenLetter:
            errorText =
                'Password must be at least 8 characters long and one letter.';
          case PasswordValidationError.invalidLenNumber:
            errorText =
                'Password must be at least 8 characters long and one number.';
          case PasswordValidationError.invalidLetter:
            errorText = 'Password must include at least one letter.';
          case PasswordValidationError.invalidLetterNum:
            errorText = 'Password must include at least one number and letter.';
          case PasswordValidationError.invalidNumber:
            errorText = 'Password must include at least one number.';
          default:
            errorText = '';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            key: const Key('signUpForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<SignUpCubit>().passwordChanged(password),
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
              errorText: errorText.isEmpty ? null : errorText,
              errorMaxLines: 3,
            ),
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatefulWidget {
  @override
  State<_ConfirmPasswordInput> createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<_ConfirmPasswordInput> {
  bool viewPassword = false;
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            key: const Key('signUpForm_confirmedPasswordInput_textField'),
            onChanged: (confirmPassword) => context
                .read<SignUpCubit>()
                .confirmedPasswordChanged(confirmPassword),
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
              labelText: 'Confirm password',
              helperText: '',
              errorText: state.confirmedPassword.displayError != null
                  ? 'passwords do not match'
                  : null,
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
    return BlocBuilder<AnimationCubit, AnimationState>(
      builder: (context, state) {
        return TextButton(
          key: const Key('loginForm_continue_raisedButton'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: state.signUpPushed
                ? Colors.transparent
                : const Color(0xFFFFD600),
          ),
          onPressed: () {
            context.read<AnimationCubit>().signupPressed();
            Navigator.pop(context);
          },
          child: const Text('LOGIN'),
        );
      },
    );
  }
}
