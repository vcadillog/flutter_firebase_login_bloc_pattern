import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/app/bloc/animation/animations_cubit.dart';
import 'package:flutter_firebase_login/login/login.dart';
import 'package:flutter_firebase_login/sign_up/sign_up.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'screens/login_group.dart';
part 'screens/sign_up_group.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  double initialWidth = 0;
  bool initialAnimFinished = false;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10)).then(
      (_) => setState(() {
        initialWidth = 500;
      }),
    );
    super.initState();
  }

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
                child: AnimatedContainer(
                  onEnd: () => setState(() {
                    initialAnimFinished = true;
                  }),
                  width: initialWidth,
                  duration: const Duration(milliseconds: 300),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: !initialAnimFinished
                      ? Container(
                          height: 350,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 22.5),
                            _EmailGroup(),
                            const SizedBox(height: 8),
                            _PasswordGroup(),
                            _ConfirmPasswordGroup(),
                            const SizedBox(height: 5),
                            _LoginButtonGroup(),
                            _SignUpButtonGroup(),
                            const SizedBox(height: 4),
                            _GoogleLoginGroup(),
                            const SizedBox(height: 22.5),
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

class _EmailGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimationCubit, AnimationState>(
      builder: (context, state) {
        return state.status == ButtonPushStatus.loginScreen
            ? _EmailInput()
            : _EmailAltInput();
      },
    );
  }
}

class _PasswordGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimationCubit, AnimationState>(
      builder: (context, state) {
        return state.status == ButtonPushStatus.loginScreen
            ? _PasswordInput()
            : _PasswordAltInput();
      },
    );
  }
}

class _ConfirmPasswordGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimationCubit, AnimationState>(
      builder: (context, state) {
        return state.status == ButtonPushStatus.loginScreen
            ? Container()
            : _ConfirmPasswordInput();
      },
    );
  }
}

class _LoginButtonGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimationCubit, AnimationState>(
      builder: (context, state) {
        return state.status == ButtonPushStatus.loginScreen
            ? _LoginButton()
            : _SignUpAltButton();
      },
    );
  }
}

class _SignUpButtonGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimationCubit, AnimationState>(
      builder: (context, state) {
        return state.status == ButtonPushStatus.loginScreen
            ? _SignUpButton()
            : _LoginAltButton();
      },
    );
  }
}

class _GoogleLoginGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimationCubit, AnimationState>(
      builder: (context, state) {
        return state.status == ButtonPushStatus.loginScreen
            ? _GoogleLoginButton()
            : _DummyGoogleLoginButton();
      },
    );
  }
}
