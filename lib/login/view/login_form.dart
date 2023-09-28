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
        return state.status == ButtonPushStatus.loginChange ||
                state.status == ButtonPushStatus.loginEnd ||
                state.status == ButtonPushStatus.initialScreen
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
        return state.status == ButtonPushStatus.loginChange ||
                state.status == ButtonPushStatus.loginEnd ||
                state.status == ButtonPushStatus.initialScreen
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
        switch (state.status) {
          case ButtonPushStatus.initialScreen || ButtonPushStatus.loginEnd:
            return Container();
          case ButtonPushStatus.loginChange:
            return ColoredBox(
              color: Colors.red,
              child: _OutFieldAnimation(
                boxHeight: 88,
                onEnd: context.read<AnimationCubit>().onLoginEnd,
                inputWidget: _DummyConfirmPasswordInput(),
              ),
            );
          case ButtonPushStatus.signupChange || ButtonPushStatus.signupEnd:
            return _ConfirmPasswordInput();
        }
      },
    );
  }
}

class _LoginButtonGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimationCubit, AnimationState>(
      builder: (context, state) {
        return state.status == ButtonPushStatus.loginChange ||
                state.status == ButtonPushStatus.loginEnd ||
                state.status == ButtonPushStatus.initialScreen
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
        return state.status == ButtonPushStatus.loginChange ||
                state.status == ButtonPushStatus.loginEnd ||
                state.status == ButtonPushStatus.initialScreen
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
        switch (state.status) {
          case ButtonPushStatus.initialScreen || ButtonPushStatus.loginEnd:
            return const _GoogleLoginButton();
          case ButtonPushStatus.loginChange:
            return const _InFieldAnimation(
              boxHeight: 40,
              colorEnd: Colors.transparent,
              inputWidget: _GoogleLoginButton(
                enableTap: false,
              ),
            );
          case ButtonPushStatus.signupChange:
            return const _OutFieldAnimation(
              boxHeight: 40,
              colorEnd: Colors.transparent,
              inputWidget: _GoogleLoginButton(
                enableTap: false,
              ),
            );
          case ButtonPushStatus.signupEnd:
            return Container();
        }
      },
    );
  }
}

class _InFieldAnimation extends StatefulWidget {
  final Widget inputWidget;
  final double boxHeight;
  final VoidCallback? onEnd;
  final Color colorEnd;
  const _InFieldAnimation({
    required this.inputWidget,
    required this.boxHeight,
    this.colorEnd = Colors.white,
    this.onEnd,
  });
  @override
  State<_InFieldAnimation> createState() => _InFieldAnimationState();
}

class _InFieldAnimationState extends State<_InFieldAnimation> {
  double height = 0;
  double offset = 1;
  bool inEndAnimation = false;
  Color color = Colors.cyan;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then(
      (value) => setState(() {
        height = widget.boxHeight;
        Future.delayed(const Duration(seconds: 1)).then(
          (value) => setState(() {
            inEndAnimation = true;
            offset = 0;
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: double.infinity,
      child: AnimatedContainer(
        curve: Curves.bounceOut,
        height: height,
        duration: const Duration(seconds: 1),
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 500),
          offset: Offset(offset, 0),
          curve: Curves.easeOutQuint,
          onEnd: () {
            widget.onEnd!();
            setState(() {
              color = widget.colorEnd;
            });
          },
          child: inEndAnimation
              ? ColoredBox(
                  color: widget.colorEnd,
                  child: Center(child: widget.inputWidget),
                )
              : Container(),
        ),
      ),
    );
  }
}

class _OutFieldAnimation extends StatefulWidget {
  final Widget inputWidget;
  final double boxHeight;
  final VoidCallback? onEnd;
  final Color colorEnd;
  const _OutFieldAnimation({
    required this.inputWidget,
    required this.boxHeight,
    this.colorEnd = Colors.white,
    this.onEnd,
  });
  @override
  State<_OutFieldAnimation> createState() => _OutFieldAnimationState();
}

class _OutFieldAnimationState extends State<_OutFieldAnimation> {
  late double height;
  double offset = 0;
  bool inEndAnimation = false;

  @override
  void initState() {
    super.initState();
    height = widget.boxHeight;
    Future.delayed(Duration.zero).then(
      (value) => setState(() {
        offset = 1;
        Future.delayed(const Duration(milliseconds: 500)).then(
          (value) => setState(() {
            inEndAnimation = true;
            height = 0;
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        offset: Offset(offset, 0),
        curve: Curves.easeOutQuint,
        child: ColoredBox(
          color: inEndAnimation ? Colors.transparent : widget.colorEnd,
          child: AnimatedContainer(
            curve: Curves.bounceOut,
            height: height,
            duration: const Duration(seconds: 1),
            onEnd: () => widget.onEnd!(),
            child: inEndAnimation
                ? Container()
                : Center(child: widget.inputWidget),
          ),
        ),
      ),
    );
  }
}
