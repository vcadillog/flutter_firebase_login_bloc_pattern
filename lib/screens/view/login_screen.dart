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
    with TickerProviderStateMixin {
  late AnimationController _switchAuthController;
  late AnimationController _postSwitchAuthController;

  late AnimationController _formLoadingController;

  late AnimationController _submitController;

  late Animation<double> _buttonScaleAnimation;

  Interval? _textButtonLoadingAnimationInterval;

  static const loginScreen = 0;
  static const signupScreen = 1;
  static const recoverPasswordScreen = 2;

  var _isLoading = false;
  var _isSubmitting = false;
  var isLogin = true;
  bool isValidLogin = false;
  bool isValidSignup = false;
  bool submitPushed = false;

  bool get buttonEnabled => !_isLoading && !_isSubmitting;

  bool _userError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;

  @override
  void initState() {
    super.initState();
    _formLoadingController = widget.formLoadingController;

    _textButtonLoadingAnimationInterval =
        const Interval(.6, 1.0, curve: Curves.easeOut);

    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.loadingController,
        curve: const Interval(.4, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _switchAuthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
    _switchAuthController.dispose();
    _postSwitchAuthController.dispose();
    _submitController.dispose();
    super.dispose();
  }

  void _switchScreenMode(int screen) {
    if (screen == signupScreen) {
      _switchAuthController.forward();
    } else if (screen == loginScreen) {
      _switchAuthController.reverse();
    }
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
            child: BlocBuilder<ScreensCubit, ScreensState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: cardPadding,
                        right: cardPadding,
                        top: cardPadding + 10,
                      ),
                      width: cardWidth,
                      child: AutofillGroup(
                        child: MultiBlocListener(
                          listeners: [
                            BlocListener<LoginCubit, LoginState>(
                              listenWhen: (previous, current) =>
                                  state.screen == Screens.login,
                              listener: (context, state) {
                                isValidLogin = state.isValid;
                                _userError = state.email.displayError != null;
                                _passwordError =
                                    state.password.displayError != null;
                              },
                            ),
                            BlocListener<SignUpCubit, SignUpState>(
                              listenWhen: (previous, current) =>
                                  state.screen == Screens.signup,
                              listener: (context, state) {
                                isValidSignup = state.isValid;
                                _userError = state.email.displayError != null;
                                // TODO: DISPLAY EXPLICIT ERRORS
                                print(state.password.error);
                                _passwordError =
                                    state.password.displayError != null;
                              },
                            ),
                          ],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _UserField(
                                onChanged: (email) {
                                  if (state.screen == Screens.login) {
                                    context
                                        .read<LoginCubit>()
                                        .emailChanged(email!);
                                  } else if (state.screen == Screens.signup) {
                                    context
                                        .read<SignUpCubit>()
                                        .emailChanged(email!);
                                  }
                                },
                                width: textFieldWidth,
                                enabled: true,
                                loadingController: _formLoadingController,
                                isSubmitting: _isSubmitting,
                                userType: LoginUserType.email,
                                messages: widget.messages,
                                validator: (String? value) {
                                  return _userError ? 'Invalid email' : null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _PasswordField(
                                onChanged: (password) {
                                  if (state.screen == Screens.login) {
                                    context
                                        .read<LoginCubit>()
                                        .passwordChanged(password!);
                                  } else if (state.screen == Screens.signup) {
                                    context
                                        .read<SignUpCubit>()
                                        .passwordChanged(password!);
                                  }
                                },
                                enabled: true,
                                width: textFieldWidth,
                                loadingController: _formLoadingController,
                                isSubmitting: _isSubmitting,
                                messages: widget.messages,
                                validator: (String? value) {
                                  return _passwordError
                                      ? 'Invalid password'
                                      : null;
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ExpandableContainer(
                      backgroundColor: _switchAuthController.isCompleted
                          ? null
                          : widget.theme.colorScheme.secondary,
                      controller: _switchAuthController,
                      initialState: state.screen == Screens.login
                          ? ExpandableContainerState.shrunk
                          : ExpandableContainerState.expanded,
                      alignment: Alignment.topLeft,
                      color: widget.theme.cardTheme.color,
                      width: cardWidth,
                      padding: const EdgeInsets.symmetric(
                        horizontal: cardPadding,
                      ),
                      onExpandCompleted: () =>
                          _postSwitchAuthController.forward(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: BlocListener<SignUpCubit, SignUpState>(
                              listenWhen: (previous, current) =>
                                  state.screen == Screens.signup,
                              listener: (context, state) {
                                _confirmPasswordError =
                                    state.confirmedPassword.displayError !=
                                        null;
                              },
                              child: _ConfirmPasswordField(
                                onChanged: (confirmPassword) => context
                                    .read<SignUpCubit>()
                                    .confirmedPasswordChanged(confirmPassword!),
                                enabled: true,
                                width: textFieldWidth,
                                loadingController: _formLoadingController,
                                isSubmitting: _isSubmitting,
                                messages: widget.messages,
                                validator: (String? value) {
                                  return _confirmPasswordError
                                      ? 'Password does not match'
                                      : null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: Paddings.fromRBL(cardPadding),
                      width: cardWidth,
                      child: Column(
                        children: <Widget>[
                          _ForgotPassword(
                            loadingController: _formLoadingController,
                            messages: widget.messages,
                            onPressed: () {
                              context
                                  .read<ScreensCubit>()
                                  .changeScreen(Screens.recoverPassword);
                              widget.pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                          ),
                          MultiBlocListener(
                            listeners: [
                              BlocListener<LoginCubit, LoginState>(
                                listenWhen: (previous, current) =>
                                    state.screen == Screens.login,
                                listener: (context, state) {
                                  if (state.status.isSuccess) {
                                    context
                                        .read<AppBloc>()
                                        .add(const AppAnimationFinished());
                                  } else if (state.status.isFailure &&
                                      submitPushed) {
                                    submitPushed = false;
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
                                        state.errorMessage!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      duration: const Duration(seconds: 3),
                                    ).show(context);

                                    Future.delayed(const Duration(seconds: 1))
                                        .then((value) {
                                      _submitController.reverse();
                                    });
                                  }
                                },
                              ),
                              BlocListener<SignUpCubit, SignUpState>(
                                listenWhen: (previous, current) =>
                                    state.screen == Screens.signup,
                                listener: (context, state) {
                                  if (state.status.isSuccess) {
                                    context
                                        .read<AppBloc>()
                                        .add(const AppAnimationFinished());
                                  } else if (state.status.isFailure &&
                                      submitPushed) {
                                    submitPushed = false;
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
                                        state.errorMessage!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      duration: const Duration(seconds: 3),
                                    ).show(context);

                                    Future.delayed(const Duration(seconds: 1))
                                        .then((value) {
                                      _submitController.reverse();
                                    });
                                  }
                                },
                              ),
                            ],
                            child: _SubmitButton(
                              submitController: _submitController,
                              buttonScaleAnimation: _buttonScaleAnimation,
                              loadingController: _formLoadingController,
                              isLogin: state.screen == Screens.login,
                              messages: widget.messages,
                              onPressed: () {
                                if (state.screen == Screens.login &&
                                    isValidLogin) {
                                  submitPushed = true;
                                  _submitController.forward();
                                  context
                                      .read<LoginCubit>()
                                      .logInWithCredentials();
                                } else if (state.screen == Screens.signup &&
                                    isValidSignup) {
                                  submitPushed = true;
                                  _submitController.forward();
                                  context
                                      .read<SignUpCubit>()
                                      .signUpFormSubmitted();
                                } else {
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
                                    messageText: const Text(
                                      'Invalid user or password',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ).show(context);
                                }
                              },
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              final stateLogin =
                                  context.watch<LoginCubit>().state;
                              final stateSignup =
                                  context.watch<SignUpCubit>().state;
                              return _SwitchButton(
                                theme: widget.theme,
                                loadingController: _formLoadingController,
                                messages: widget.messages,
                                loginTheme: widget.loginTheme,
                                isLogin: state.screen == Screens.login,
                                onPressed: () {
                                  if (state.screen == Screens.login) {
                                    context
                                        .read<ScreensCubit>()
                                        .changeScreen(Screens.signup);

                                    context.read<SignUpCubit>().emailChanged(
                                          stateLogin.email.value,
                                        );

                                    context.read<SignUpCubit>().passwordChanged(
                                          stateLogin.password.value,
                                        );

                                    _switchScreenMode(signupScreen);
                                  } else if (state.screen == Screens.signup) {
                                    context
                                        .read<ScreensCubit>()
                                        .changeScreen(Screens.login);

                                    context.read<LoginCubit>().emailChanged(
                                          stateSignup.email.value,
                                        );

                                    context.read<LoginCubit>().passwordChanged(
                                          stateSignup.password.value,
                                        );

                                    _switchScreenMode(loginScreen);
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
                            key:
                                const Key('loginForm_googleLogin_raisedButton'),
                            submitController: _submitController,
                            buttonScaleAnimation: _buttonScaleAnimation,
                            loadingController: _formLoadingController,
                            messages: widget.messages,
                            onPressed: () {
                              context.read<LoginCubit>().logInWithGoogle();
                              submitPushed = true;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
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
    // _nameController = TextEditingController(text: 'Email');
    _nameController = TextEditingController();
    _nameTextFieldLoadingAnimationInterval = const Interval(0, .85);
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
      // focusNode: _userFocusNode,
      // onFieldSubmitted: (value) {
      //   FocusScope.of(context).requestFocus(_passwordFocusNode);
      // },
      // validator: widget.userValidator,
      // onSaved: (value) => auth.email = value!,
      // enabled: !_isSubmitting,
      initialIsoCode: null,
      // initialIsoCode: widget.initialIsoCode,
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

  const _PasswordField({
    super.key,
    required this.width,
    required this.messages,
    required this.loadingController,
    required this.isSubmitting,
    required this.enabled,
    this.onChanged,
    this.validator,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  late TextEditingController _passController;
  Interval? _passTextFieldLoadingAnimationInterval;

  @override
  void initState() {
    super.initState();
    // _passController = TextEditingController(text: 'Password');
    _passController = TextEditingController();
    _passTextFieldLoadingAnimationInterval = const Interval(.15, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPasswordTextFormField(
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      controller: _passController,
      animatedWidth: widget.width,
      validator: widget.validator,
      loadingController: widget.loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: widget.messages.passwordHint,
      autofillHints: widget.isSubmitting ? null : [AutofillHints.password],
      textInputAction: TextInputAction.done,
      initialIsoCode: null,
    );
  }
}

class _ConfirmPasswordField extends StatefulWidget {
  final double width;
  final LoginMessages messages;
  final AnimationController loadingController;
  final bool isSubmitting;
  final bool enabled;
  final FormFieldSetter<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const _ConfirmPasswordField({
    super.key,
    required this.width,
    required this.messages,
    required this.loadingController,
    required this.isSubmitting,
    required this.enabled,
    this.onChanged,
    this.validator,
  });

  @override
  State<_ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<_ConfirmPasswordField>
    with SingleTickerProviderStateMixin {
  late AnimationController _postSwitchAuthController;
  late TextEditingController _confirmPassController;
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _postSwitchAuthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _confirmPassController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedPasswordTextFormField(
      onChanged: widget.onChanged,
      validator: widget.validator,
      animatedWidth: widget.width,
      enabled: widget.enabled,
      loadingController: widget.loadingController,
      inertiaController: _postSwitchAuthController,
      inertiaDirection: TextFieldInertiaDirection.right,
      labelText: widget.messages.confirmPasswordHint,
      controller: _confirmPassController,
      textInputAction: TextInputAction.done,
      focusNode: _confirmPasswordFocusNode,
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
    // floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 10),
    return ScaleTransition(
      scale: widget.buttonScaleAnimation,
      child: AnimatedButton(
        controller: widget.submitController,
        // text: auth.isLogin ? messages.loginButton : messages.signupButton,
        text: widget.isLogin
            ? widget.messages.loginButton
            : widget.messages.signupButton,
        // text: widget.messages.loginButton,
        onPressed: () {
          widget.onPressed?.call();
        },
      ),
    );
  }
}

class _SwitchButton extends StatefulWidget {
  final ThemeData theme;
  final AnimationController loadingController;
  final LoginMessages messages;
  final LoginTheme loginTheme;
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
  Interval? _textButtonLoadingAnimationInterval;
  @override
  void initState() {
    super.initState();

    _textButtonLoadingAnimationInterval =
        const Interval(.6, 1.0, curve: Curves.easeOut);
  }

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
        // onPressed: () => (),
        padding: widget.loginTheme.authButtonPadding ??
            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textColor: widget.loginTheme.switchAuthTextColor ?? calculatedTextColor,
        child: AnimatedText(
          text: !widget.isLogin
              ? widget.messages.loginButton
              : widget.messages.signupButton,
          // text: widget.messages.signupButton,
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

class _GoogleButton extends StatefulWidget {
  final AnimationController loadingController;
  final AnimationController submitController;
  final LoginMessages messages;
  final Animation<double> buttonScaleAnimation;
  final VoidCallback? onPressed;
  const _GoogleButton({
    super.key,
    required this.submitController,
    required this.loadingController,
    required this.messages,
    required this.buttonScaleAnimation,
    this.onPressed,
  });

  @override
  State<_GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<_GoogleButton>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 10),
    return ScaleTransition(
      scale: widget.buttonScaleAnimation,
      child: SignInButton(
        Buttons.googleDark,
        text: "Sign up with Google",
        onPressed: () {
          widget.onPressed?.call();
          widget.submitController.forward();
        },
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
