part of 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.theme,
    required this.loginTheme,
    required this.formLoadingController,
    required this.pageController,
    required this.loadingController,
    required this.messages,
  });

  final AnimationController loadingController;
  final PageController pageController;
  final ThemeData theme;
  final LoginTheme loginTheme;
  final AnimationController formLoadingController;
  final LoginMessages messages;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _switchFormController;

  @override
  void initState() {
    super.initState();

    _switchFormController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _switchFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = min(MediaQuery.of(context).size.width * 0.75, 360.0);
    const cardPadding = 16.0;
    final textFieldWidth = cardWidth - cardPadding * 2;
    return FittedBox(
      child: _LoginInitialTransition(
        loadingController: widget.loadingController,
        child: Card(
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                _LoginFormGroup(
                  cardPadding: cardPadding,
                  cardWidth: cardWidth,
                  textFieldWidth: textFieldWidth,
                  formLoadingController: widget.formLoadingController,
                  messages: widget.messages,
                ),
                _ConfirmPasswordField(
                  width: textFieldWidth,
                  messages: widget.messages,
                  loadingController: widget.loadingController,
                  cardPadding: cardPadding,
                  cardWidth: cardWidth,
                  theme: widget.theme,
                  switchFormController: _switchFormController,
                ),
                _ControlButtonsGroup(
                  cardPadding: cardPadding,
                  cardWidth: cardWidth,
                  textFieldWidth: textFieldWidth,
                  formLoadingController: widget.formLoadingController,
                  messages: widget.messages,
                  loadingController: widget.loadingController,
                  pageController: widget.pageController,
                  switchFormController: _switchFormController,
                  theme: widget.theme,
                  loginTheme: widget.loginTheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserField extends StatefulWidget {
  final double width;
  final LoginMessages messages;
  final AnimationController loadingController;
  final bool isSubmitting;
  final LoginUserType userType;
  final bool enabled;
  final FormFieldSetter<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? initialText;

  const _UserField({
    super.key,
    required this.width,
    required this.messages,
    required this.loadingController,
    required this.isSubmitting,
    required this.userType,
    required this.enabled,
    this.onChanged,
    this.validator,
    this.initialText,
  });

  @override
  State<_UserField> createState() => _UserFieldState();
}

class _UserFieldState extends State<_UserField> {
  final _userFieldKey = GlobalKey<FormFieldState>();

  late TextEditingController _nameController;
  Interval? _nameTextFieldLoadingAnimationInterval;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialText);
    _nameTextFieldLoadingAnimationInterval = const Interval(0, .85);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTextFormField(
      enabled: widget.enabled,
      textFormFieldKey: _userFieldKey,
      onChanged: widget.onChanged,
      validator: widget.validator,
      userType: widget.userType,
      controller: _nameController,
      width: widget.width,
      loadingController: widget.loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: widget.messages.userHint ??
          TextFieldUtils.getLabelText(
            widget.userType,
          ),
      autofillHints: widget.isSubmitting
          ? null
          : [
              TextFieldUtils.getAutofillHints(
                widget.userType,
              ),
            ],
      prefixIcon: TextFieldUtils.getPrefixIcon(
        widget.userType,
      ),
      keyboardType: TextFieldUtils.getKeyboardType(
        widget.userType,
      ),
      textInputAction: TextInputAction.next,
      // enabled: !_isSubmitting,
      initialIsoCode: null,
    );
  }
}

class _PasswordField extends StatefulWidget {
  final double width;
  final LoginMessages messages;
  final AnimationController loadingController;
  final bool isSubmitting;
  final bool enabled;
  final FormFieldSetter<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int? errorMaxLines;
  final String? initialText;

  const _PasswordField({
    super.key,
    required this.width,
    required this.messages,
    required this.loadingController,
    required this.isSubmitting,
    required this.enabled,
    this.onChanged,
    this.validator,
    this.errorMaxLines = 1,
    this.initialText,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  late TextEditingController _passwordController;
  Interval? _passwordTextFieldLoadingAnimationInterval;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: widget.initialText);
    _passwordTextFieldLoadingAnimationInterval = const Interval(.15, 1.0);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPasswordTextFormField(
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      errorMaxLines: widget.errorMaxLines,
      controller: _passwordController,
      animatedWidth: widget.width,
      validator: widget.validator,
      loadingController: widget.loadingController,
      interval: _passwordTextFieldLoadingAnimationInterval,
      labelText: widget.messages.passwordHint,
      autofillHints: widget.isSubmitting ? null : [AutofillHints.password],
      textInputAction: TextInputAction.done,
      initialIsoCode: null,
    );
  }
}

class _ForgotPassword extends StatefulWidget {
  final AnimationController loadingController;
  final LoginMessages messages;
  final VoidCallback? onPressed;

  const _ForgotPassword({
    super.key,
    required this.loadingController,
    required this.messages,
    this.onPressed,
  });
  @override
  State<_ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<_ForgotPassword> {
  Interval? _textButtonLoadingAnimationInterval;

  @override
  void initState() {
    super.initState();

    _textButtonLoadingAnimationInterval =
        const Interval(.6, 1.0, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      controller: widget.loadingController,
      fadeDirection: FadeDirection.bottomToTop,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval,
      child: TextButton(
        onPressed: () => widget.onPressed?.call(),
        child: Text(
          widget.messages.forgotPasswordButton,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final AnimationController loadingController;
  final AnimationController submitController;
  final LoginMessages messages;
  final Animation<double> buttonScaleAnimation;
  final bool isLogin;
  final VoidCallback? onPressed;
  const _SubmitButton({
    super.key,
    required this.loadingController,
    required this.messages,
    required this.buttonScaleAnimation,
    this.isLogin = true,
    this.onPressed,
    required this.submitController,
  });

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.buttonScaleAnimation,
      child: AnimatedButton(
        controller: widget.submitController,
        text: widget.isLogin
            ? widget.messages.loginButton
            : widget.messages.signupButton,
        onPressed: () {
          widget.onPressed?.call();
        },
      ),
    );
  }
}

class _SwitchButton extends StatefulWidget {
  final ThemeData theme;
  final LoginTheme loginTheme;
  final AnimationController loadingController;
  final LoginMessages messages;
  final VoidCallback? onPressed;
  final bool buttonEnabled;
  final bool isLogin;
  const _SwitchButton({
    super.key,
    required this.theme,
    required this.loadingController,
    required this.messages,
    required this.loginTheme,
    this.onPressed,
    this.buttonEnabled = true,
    this.isLogin = true,
  });
  @override
  State<_SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<_SwitchButton> {
  final Interval _textButtonLoadingAnimationInterval =
      const Interval(.6, 1.0, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final calculatedTextColor =
        (widget.theme.cardTheme.color!.computeLuminance() < 0.5)
            ? Colors.white
            : widget.theme.primaryColor;
    return FadeIn(
      controller: widget.loadingController,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval,
      fadeDirection: FadeDirection.topToBottom,
      child: MaterialButton(
        disabledTextColor: widget.theme.primaryColor,
        onPressed: widget.buttonEnabled ? () => widget.onPressed?.call() : null,
        padding: widget.loginTheme.authButtonPadding ??
            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textColor: widget.loginTheme.switchAuthTextColor ?? calculatedTextColor,
        child: AnimatedText(
          text: !widget.isLogin
              ? widget.messages.loginButton
              : widget.messages.signupButton,
          textRotation: AnimatedTextRotation.down,
        ),
      ),
    );
  }
}

class _TitleProviders extends StatelessWidget {
  final LoginMessages messages;
  final Animation<double> buttonScaleAnimation;

  const _TitleProviders({
    super.key,
    required this.messages,
    required this.buttonScaleAnimation,
  });
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: buttonScaleAnimation,
      child: Row(
        children: <Widget>[
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(messages.providersTitleFirst),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final AnimationController loadingController;
  final LoginMessages messages;
  final Animation<double> buttonScaleAnimation;
  final VoidCallback? onPressed;
  const _GoogleButton({
    super.key,
    required this.loadingController,
    required this.messages,
    required this.buttonScaleAnimation,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: buttonScaleAnimation,
      child: SignInButton(
        Buttons.googleDark,
        text: "Sign up with Google",
        onPressed: () => onPressed?.call(),
      ),
    );
  }
}

class _LoginInitialTransition extends StatefulWidget {
  final Widget child;
  final AnimationController loadingController;

  const _LoginInitialTransition({
    super.key,
    required this.child,
    required this.loadingController,
  });
  @override
  State<_LoginInitialTransition> createState() =>
      _LoginInitialTransitionState();
}

class _LoginInitialTransitionState extends State<_LoginInitialTransition> {
  late Animation<double> _flipAnimation;
  @override
  void initState() {
    super.initState();
    _flipAnimation = Tween<double>(begin: pi / 2, end: 0).animate(
      CurvedAnimation(
        parent: widget.loadingController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) => Transform(
        transform: Matrix.perspective()..rotateX(_flipAnimation.value),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}

class _LoginFormGroup extends StatelessWidget {
  final double cardPadding;
  final double cardWidth;
  final double textFieldWidth;
  final AnimationController formLoadingController;
  final LoginMessages messages;

  const _LoginFormGroup({
    super.key,
    required this.cardPadding,
    required this.cardWidth,
    required this.textFieldWidth,
    required this.formLoadingController,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    String passwordErrorCases(SignUpState state) {
      switch (state.password.displayError) {
        case PasswordValidationError.noWhitespaces:
          return "Whitespaces are not allowed";
        case PasswordValidationError.invalid:
          return 'Password must be at least 8 characters long and have one letter and one number.';
        case PasswordValidationError.invalidLen:
          return 'Password must be at least 8 characters long.';
        case PasswordValidationError.invalidLenLetter:
          return 'Password must be at least 8 characters long and have one letter.';
        case PasswordValidationError.invalidLenNumber:
          return 'Password must be at least 8 characters long and have one number.';
        case PasswordValidationError.invalidLetter:
          return 'Password must include at least one letter.';
        case PasswordValidationError.invalidLetterNum:
          return 'Password must include at least one number and one letter.';
        case PasswordValidationError.invalidNumber:
          return 'Password must include at least one number.';
        default:
          return '';
      }
    }

    return Container(
      padding: EdgeInsets.only(
        left: cardPadding,
        right: cardPadding,
        top: cardPadding + 10,
      ),
      width: cardWidth,
      child: AutofillGroup(
        child: BlocBuilder<ScreensCubit, ScreensState>(
          builder: (context, stateScreen) {
            String passwordError = '';
            bool userError = false;

            return MultiBlocListener(
              listeners: [
                BlocListener<LoginCubit, LoginState>(
                  listenWhen: (previous, current) =>
                      stateScreen.screen == Screens.login,
                  listener: (context, state) {
                    userError = state.email.displayError != null;
                    if (state.password.error != null) {
                      passwordError = 'Invalid password';
                    } else {
                      passwordError = '';
                    }
                  },
                ),
                BlocListener<SignUpCubit, SignUpState>(
                  listenWhen: (previous, current) =>
                      stateScreen.screen == Screens.signup,
                  listener: (context, state) {
                    userError = state.email.displayError != null;
                    passwordError = passwordErrorCases(state);
                  },
                ),
              ],
              child: Builder(
                builder: (context) {
                  final stateLogin = context.watch<LoginCubit>().state;
                  final stateSignup = context.watch<SignUpCubit>().state;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _UserField(
                        initialText: stateScreen.screen == Screens.login
                            ? stateLogin.email.value
                            : stateSignup.email.value,
                        onChanged: (email) {
                          if (stateScreen.screen == Screens.login) {
                            context.read<LoginCubit>().emailChanged(email!);
                          } else if (stateScreen.screen == Screens.signup) {
                            context.read<SignUpCubit>().emailChanged(email!);
                          }
                        },
                        width: textFieldWidth,
                        enabled: true,
                        loadingController: formLoadingController,
                        isSubmitting: false,
                        // isSubmitting: _isSubmitting,
                        userType: LoginUserType.email,
                        messages: messages,
                        validator: (String? value) {
                          return userError ? 'Invalid email' : null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _PasswordField(
                        initialText: stateScreen.screen == Screens.login
                            ? stateLogin.password.value
                            : stateSignup.password.value,
                        onChanged: (password) {
                          if (stateScreen.screen == Screens.login) {
                            context
                                .read<LoginCubit>()
                                .passwordChanged(password!);
                          } else if (stateScreen.screen == Screens.signup) {
                            context
                                .read<SignUpCubit>()
                                .passwordChanged(password!);
                          }
                        },
                        enabled: true,
                        errorMaxLines: 3,
                        width: textFieldWidth,
                        loadingController: formLoadingController,
                        // isSubmitting: _isSubmitting,
                        isSubmitting: false,
                        messages: messages,
                        validator: (String? value) {
                          return passwordError != '' ? passwordError : null;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ConfirmPasswordField extends StatefulWidget {
  final double width;
  final LoginMessages messages;
  final AnimationController loadingController;
  final double cardPadding;
  final double cardWidth;
  final ThemeData theme;
  final AnimationController switchFormController;

  const _ConfirmPasswordField({
    super.key,
    required this.width,
    required this.messages,
    required this.loadingController,
    required this.cardPadding,
    required this.cardWidth,
    required this.theme,
    required this.switchFormController,
  });

  @override
  State<_ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<_ConfirmPasswordField>
    with SingleTickerProviderStateMixin {
  late AnimationController _postSwitchFormController;

  bool _confirmPasswordError = false;

  @override
  void initState() {
    super.initState();
    _postSwitchFormController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _postSwitchFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreensCubit, ScreensState>(
      builder: (context, state) {
        return ExpandableContainer(
          backgroundColor: widget.switchFormController.isCompleted
              ? null
              : widget.theme.colorScheme.secondary,
          controller: widget.switchFormController,
          initialState: state.screen == Screens.login
              ? ExpandableContainerState.shrunk
              : ExpandableContainerState.expanded,
          alignment: Alignment.topLeft,
          color: widget.theme.cardTheme.color,
          width: widget.cardWidth,
          padding: EdgeInsets.symmetric(
            horizontal: widget.cardPadding,
          ),
          onExpandCompleted: () => _postSwitchFormController.forward(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: BlocConsumer<SignUpCubit, SignUpState>(
                  listenWhen: (previous, current) =>
                      state.screen == Screens.signup,
                  listener: (context, state) {
                    _confirmPasswordError =
                        state.confirmedPassword.displayError != null;
                  },
                  builder: (context, state) {
                    return _PasswordField(
                      initialText: state.confirmedPassword.value,
                      onChanged: (confirmPassword) =>
                          context.read<SignUpCubit>().confirmedPasswordChanged(
                                confirmPassword!,
                              ),
                      enabled: true,
                      errorMaxLines: 3,
                      width: widget.width,
                      loadingController: widget.loadingController,
                      // isSubmitting: _isSubmitting,
                      isSubmitting: false,
                      messages: widget.messages,
                      validator: (String? value) {
                        return _confirmPasswordError
                            ? 'Password does not match'
                            : null;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ControlButtonsGroup extends StatefulWidget {
  final double cardPadding;
  final double cardWidth;
  final double textFieldWidth;
  final AnimationController formLoadingController;
  final AnimationController loadingController;
  final AnimationController switchFormController;
  final PageController pageController;
  final LoginMessages messages;
  final ThemeData theme;
  final LoginTheme loginTheme;

  const _ControlButtonsGroup({
    super.key,
    required this.cardPadding,
    required this.cardWidth,
    required this.textFieldWidth,
    required this.formLoadingController,
    required this.messages,
    required this.loadingController,
    required this.pageController,
    required this.switchFormController,
    required this.theme,
    required this.loginTheme,
  });
  @override
  State<_ControlButtonsGroup> createState() => _ControlButtonsGroupState();
}

class _ControlButtonsGroupState extends State<_ControlButtonsGroup>
    with TickerProviderStateMixin {
  late Animation<double> _buttonScaleAnimation;
  late AnimationController _postSwitchAuthController;
  late AnimationController _submitController;

  static const forgotScreenPage = 1;
  bool submitPushed = false;

  @override
  void initState() {
    super.initState();
    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.loadingController,
        curve: const Interval(.4, 1.0, curve: Curves.easeOutBack),
      ),
    );
    _postSwitchAuthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _submitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _postSwitchAuthController.dispose();
    _submitController.dispose();
    super.dispose();
  }

  void submitFailureFlushbar(String message, {bool onPushedSubmit = false}) {
    Flushbar(
      backgroundColor: Colors.red,
      boxShadows: const [
        BoxShadow(
          color: Colors.red,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      icon: const Icon(
        FontAwesomeIcons.triangleExclamation,
        color: Colors.yellow,
      ),
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: const Duration(seconds: 3),
    ).show(context);

    if (!onPushedSubmit) {
      submitPushed = false;
      Future.delayed(const Duration(seconds: 1)).then((_) {
        _submitController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Paddings.fromRBL(widget.cardPadding),
      width: widget.cardWidth,
      child: Column(
        children: <Widget>[
          _ForgotPassword(
            loadingController: widget.formLoadingController,
            messages: widget.messages,
            onPressed: () {
              context
                  .read<ScreensCubit>()
                  .changeScreen(Screens.recoverPassword);
              widget.pageController.animateToPage(
                forgotScreenPage,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
          Builder(
            builder: (context) {
              final stateLogin = context.watch<LoginCubit>().state;
              final stateSignup = context.watch<SignUpCubit>().state;
              final stateScreen = context.watch<ScreensCubit>().state;
              return MultiBlocListener(
                listeners: [
                  BlocListener<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state.status.isSuccess) {
                        context
                            .read<AppBloc>()
                            .add(const AppAnimationFinished());
                      } else if (state.status.isFailure && submitPushed) {
                        submitFailureFlushbar(
                          state.errorMessage!,
                        );
                      }
                    },
                  ),
                  BlocListener<SignUpCubit, SignUpState>(
                    listenWhen: (previous, current) =>
                        stateScreen.screen == Screens.signup,
                    listener: (context, state) {
                      if (state.status.isSuccess) {
                        context
                            .read<AppBloc>()
                            .add(const AppAnimationFinished());
                      } else if (state.status.isFailure && submitPushed) {
                        submitFailureFlushbar(
                          state.errorMessage!,
                        );
                      }
                    },
                  ),
                ],
                child: _SubmitButton(
                  submitController: _submitController,
                  buttonScaleAnimation: _buttonScaleAnimation,
                  loadingController: widget.formLoadingController,
                  isLogin: stateScreen.screen == Screens.login,
                  messages: widget.messages,
                  onPressed: () {
                    if (stateScreen.screen == Screens.login) {
                      if (stateLogin.isValid) {
                        submitPushed = true;
                        _submitController.forward();
                        context.read<LoginCubit>().logInWithCredentials();
                      } else {
                        String text = '';
                        if (stateLogin.email.isNotValid) {
                          text += 'Invalid user';
                        }
                        if (stateLogin.password.isNotValid) {
                          text +=
                              text == '' ? 'Invalid password.' : ' & password.';
                        } else {
                          text += '.';
                        }

                        submitFailureFlushbar(
                          text,
                          onPushedSubmit: true,
                        );
                      }
                    } else if (stateScreen.screen == Screens.signup) {
                      if (stateSignup.isValid) {
                        submitPushed = true;
                        _submitController.forward();
                        context.read<SignUpCubit>().signUpFormSubmitted();
                      } else {
                        String text = '';
                        if (stateSignup.email.isNotValid &&
                            stateSignup.password.isNotValid &&
                            stateSignup.confirmedPassword.isNotValid) {
                          text += 'Invalid user, password & confirm password.';
                        } else {
                          if (stateSignup.email.isNotValid) {
                            text += 'Invalid user';
                          }
                          if (stateSignup.password.isNotValid) {
                            text +=
                                text == '' ? 'Invalid password' : ' & password';
                          }
                          if (stateSignup.confirmedPassword.isNotValid) {
                            text += text == ''
                                ? 'Invalid confirm password.'
                                : ' & confirm password.';
                          } else {
                            text += '.';
                          }
                        }

                        submitFailureFlushbar(
                          text,
                          onPushedSubmit: true,
                        );
                      }
                    }
                  },
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final stateLogin = context.watch<LoginCubit>().state;
              final stateSignup = context.watch<SignUpCubit>().state;
              final stateScreen = context.watch<ScreensCubit>().state;
              return _SwitchButton(
                theme: widget.theme,
                loadingController: widget.formLoadingController,
                messages: widget.messages,
                loginTheme: widget.loginTheme,
                isLogin: stateScreen.screen == Screens.login,
                onPressed: () {
                  if (stateScreen.screen == Screens.login) {
                    context.read<ScreensCubit>().changeScreen(Screens.signup);
                    context.read<SignUpCubit>().replaceUserInfo(
                          stateLogin.email.value,
                          stateLogin.password.value,
                        );
                    widget.switchFormController.forward();
                  } else if (stateScreen.screen == Screens.signup) {
                    context.read<ScreensCubit>().changeScreen(Screens.login);
                    context.read<LoginCubit>().replaceUserInfo(
                          stateSignup.email.value,
                          stateSignup.password.value,
                        );
                    widget.switchFormController.reverse();
                  }
                },
              );
            },
          ),
          _TitleProviders(
            messages: widget.messages,
            buttonScaleAnimation: _buttonScaleAnimation,
          ),
          _GoogleButton(
            key: const Key('loginForm_googleLogin_raisedButton'),
            buttonScaleAnimation: _buttonScaleAnimation,
            loadingController: widget.formLoadingController,
            messages: widget.messages,
            onPressed: () {
              _submitController.forward();
              context.read<LoginCubit>().logInWithGoogle();
              submitPushed = true;
            },
          ),
        ],
      ),
    );
  }
}
