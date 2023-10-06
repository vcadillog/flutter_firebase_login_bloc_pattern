part of 'main_screen.dart';

class _ForgotPasswordScreen extends StatefulWidget {
  const _ForgotPasswordScreen({
    super.key,
    required this.formLoadingController,
    required this.pageController,
    required this.theme,
    required this.loginTheme,
    required this.messages,
  });
  final AnimationController formLoadingController;
  final PageController pageController;
  final ThemeData theme;
  final LoginTheme loginTheme;
  final LoginMessages messages;
  @override
  State<_ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<_ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formRecoverKey = GlobalKey();
  late AnimationController _submitController;
  @override
  void initState() {
    super.initState();

    _submitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _submitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.75, 360.0);
    const cardPadding = 16.0;
    final textFieldWidth = cardWidth - cardPadding * 2;

    return FittedBox(
      child: Card(
        child: Container(
          padding: const EdgeInsets.only(
            left: cardPadding,
            top: cardPadding + 10.0,
            right: cardPadding,
            bottom: cardPadding,
          ),
          width: cardWidth,
          alignment: Alignment.center,
          child: Form(
            key: _formRecoverKey,
            autovalidateMode: AutovalidateMode.always,
            child: BlocBuilder<ScreensCubit, ScreensState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Text(
                      widget.messages.recoverPasswordIntro,
                      key: kRecoverPasswordIntroKey,
                      textAlign: TextAlign.center,
                      style: widget.theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    _UserField(
                      width: textFieldWidth,
                      enabled: true,
                      loadingController: widget.formLoadingController,
                      onChanged: (newValue) => (),
                      validator: (String? value) {
                        return (value != null && value.contains('&'))
                            ? 'Do not use the & char.'
                            : null;
                      },

                      // isSubmitting: _isSubmitting,
                      isSubmitting: false,
                      userType: LoginUserType.email,
                      messages: widget.messages,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.messages.recoverPasswordDescription,
                      key: kRecoverPasswordDescriptionKey,
                      textAlign: TextAlign.center,
                      style: widget.theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 26),
                    AnimatedButton(
                      controller: _submitController,
                      text: widget.messages.recoverPasswordButton,
                      onPressed: () {
                        _submitController.forward();
                        //TODO : ADD SIGNUP LOGIC
                      },
                    ),
                    _BackButton(
                      theme: widget.theme,
                      messages: widget.messages,
                      loginTheme: widget.loginTheme,
                      isLogin: state.screen == Screens.login,
                      onPressed: () {
                        context
                            .read<ScreensCubit>()
                            .changeScreen(state.oldScreen);
                        widget.pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
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

class _BackButton extends StatefulWidget {
  final ThemeData theme;

  final LoginMessages messages;
  final LoginTheme loginTheme;
  final VoidCallback? onPressed;
  final bool buttonEnabled;
  final bool isLogin;
  const _BackButton({
    super.key,
    required this.theme,
    required this.messages,
    required this.loginTheme,
    this.onPressed,
    this.buttonEnabled = true,
    this.isLogin = true,
  });
  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
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
    return MaterialButton(
      onPressed: () => widget.onPressed?.call(),
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textColor: widget.loginTheme.switchAuthTextColor ?? calculatedTextColor,
      child: Text(widget.messages.goBackButton),
    );
  }
}
