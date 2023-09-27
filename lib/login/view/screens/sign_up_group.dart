part of '../login_form.dart';

/// HANDLES ALL THE ANIMATIONS

class _EmailAltInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 80,
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
                labelText: 'Email',
                helperText: '',
                errorText:
                    state.email.displayError != null ? 'Invalid email' : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignUpAltButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: TextButton(
            key: const Key('loginForm_createAccount_flatButton'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: const Color(0xFFFFD600),
            ),
            onPressed: () => state.isValid
                ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                : null,
            child: Text(
              'SIGN UP',
              style: TextStyle(
                color: state.isValid ? theme.primaryColor : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordAltInput extends StatefulWidget {
  @override
  State<_PasswordAltInput> createState() => _PasswordAltInputState();
}

class _PasswordAltInputState extends State<_PasswordAltInput> {
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
          child: SizedBox(
            height: 80,
            child: TextField(
              key: const Key('signUpForm_passwordInput_textField'),
              onChanged: (password) =>
                  context.read<SignUpCubit>().passwordChanged(password),
              obscureText: !viewPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon:
                    const Icon(FontAwesomeIcons.lock, color: Colors.grey),
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
                labelText: 'Password',
                helperText: '',
                errorText: errorText.isEmpty ? null : errorText,
                errorMaxLines: 3,
              ),
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
  double height = 0;
  bool finishedAnim = false;
  bool finishedDisplacement = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) => setState(() {
        height = 88;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AnimationCubit, AnimationState>(
      builder: (context, state) {
        return AnimatedContainer(
          color: !finishedAnim ? Colors.cyan : Colors.white,
          curve: Curves.bounceOut,
          height: state.status == ButtonPushStatus.signupScreen ? height : 0,
          duration: const Duration(seconds: 1),
          onEnd: () => setState(() {
            if (state.status == ButtonPushStatus.onChangeScreen) {
              context.read<AnimationCubit>().toLogin();
            }
            finishedAnim = true;
            Future.delayed(Duration.zero).then(
              (value) => setState(() {
                finishedDisplacement = true;
              }),
            );
          }),
          child: !finishedAnim ||
                  state.status == ButtonPushStatus.onChangeScreen
              ? Container(
                  color: theme.scaffoldBackgroundColor,
                )
              : AnimatedSlide(
                  duration: const Duration(milliseconds: 500),
                  offset: Offset(finishedDisplacement ? 0 : 1, 0),
                  curve: Curves.bounceOut,
                  child: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                      child: BlocBuilder<SignUpCubit, SignUpState>(
                        builder: (context, state) {
                          return TextField(
                            key: const Key(
                              'signUpForm_confirmedPasswordInput_textField',
                            ),
                            onChanged: (confirmPassword) => context
                                .read<SignUpCubit>()
                                .confirmedPasswordChanged(confirmPassword),
                            obscureText: !viewPassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              prefixIcon: const Icon(FontAwesomeIcons.lock,
                                  color: Colors.grey),
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
                              errorText:
                                  state.confirmedPassword.displayError != null
                                      ? 'Passwords do not match'
                                      : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _DummyGoogleLoginButton extends StatefulWidget {
  @override
  State<_DummyGoogleLoginButton> createState() =>
      _DummyGoogleLoginButtonState();
}

class _DummyGoogleLoginButtonState extends State<_DummyGoogleLoginButton> {
  bool finishedAnim = false;
  bool finishedDisplacement = false;
  double height = 40;
  Color color = Colors.cyan;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) => setState(() {
        // height = 0;
        finishedDisplacement = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<AnimationCubit, AnimationState>(
      listener: (context, state) {
        if (state.status == ButtonPushStatus.onChangeScreen) {
          height = 40;
          color = theme.scaffoldBackgroundColor;
        }
      },
      builder: (context, state) {
        return AnimatedContainer(
          color: !finishedAnim ? theme.scaffoldBackgroundColor : Colors.white,
          curve: Curves.bounceOut,
          width: 500,
          height: state.status != ButtonPushStatus.loginScreen ? height : 0,
          duration: const Duration(seconds: 1),
          child: finishedAnim || state.status == ButtonPushStatus.onChangeScreen
              ? Container(
                  height: height,
                  color: color,
                )
              : AnimatedSlide(
                  duration: const Duration(milliseconds: 500),
                  offset: Offset(finishedDisplacement ? 1 : 0, 0),
                  curve: Curves.bounceOut,
                  onEnd: () => setState(() {
                    height = 0;
                    finishedAnim = true;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton.icon(
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
                        size: 20,
                      ),
                      onPressed: () => (),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _LoginAltButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextButton(
        key: const Key('loginForm_continue_raisedButton'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.transparent,
        ),
        onPressed: () {
          context.read<SignUpCubit>().resetForms();
          context.read<AnimationCubit>().inProgress();
        },
        child: const Text('LOGIN'),
      ),
    );
  }
}
