import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_transformer_page_view/another_transformer_page_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/app/app.dart';

import 'package:flutter_firebase_login/login/cubit/login_cubit.dart';
import 'package:flutter_firebase_login/screens/cubit/screens_cubit.dart';

import 'package:flutter_firebase_login/screens/view/widgets/animated_button.dart';
import 'package:flutter_firebase_login/screens/view/widgets/animated_text.dart';
import 'package:flutter_firebase_login/screens/view/widgets/animated_text_form_field.dart';
import 'package:flutter_firebase_login/screens/view/widgets/color_helper.dart';
import 'package:flutter_firebase_login/screens/view/widgets/constants.dart';
import 'package:flutter_firebase_login/screens/view/widgets/custom_page_transformer.dart';
import 'package:flutter_firebase_login/screens/view/widgets/dart_helper.dart';
import 'package:flutter_firebase_login/screens/view/widgets/expandable_container.dart';
import 'package:flutter_firebase_login/screens/view/widgets/fade_in.dart';
import 'package:flutter_firebase_login/screens/view/widgets/hero_text.dart';
import 'package:flutter_firebase_login/screens/view/widgets/login_messages.dart';
import 'package:flutter_firebase_login/screens/view/widgets/login_theme.dart';
import 'package:flutter_firebase_login/screens/view/widgets/login_user_type.dart';
import 'package:flutter_firebase_login/screens/view/widgets/matrix.dart';
import 'package:flutter_firebase_login/screens/view/widgets/paddings.dart';
import 'package:flutter_firebase_login/screens/view/widgets/text_field_utils.dart';
import 'package:flutter_firebase_login/screens/view/widgets/theme.dart';

import 'package:flutter_firebase_login/sign_up/sign_up.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

import 'package:sign_in_button/sign_in_button.dart';

part 'login_screen.dart';
part 'recover_password_screen.dart';

class LoginForm extends StatefulWidget {
  final ImageProvider? logo;
  final String? titleTag;
  final String? logoTag;
  final String? title;
  const LoginForm(
      {super.key, this.logo, this.titleTag, this.logoTag, this.title});

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  static const int _loginPageIndex = 0;
  int _pageIndex = _loginPageIndex;

  static const loadingDuration = Duration(milliseconds: 400);

  final TransformerPageController _pageController = TransformerPageController();

  late AnimationController _loadingController;

  late AnimationController _logoController;
  late AnimationController _titleController;

  late AnimationController _formLoadingController;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: loadingDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          _logoController.forward();
          _titleController.forward();
        }
        if (status == AnimationStatus.reverse) {
          _logoController.reverse();
          _titleController.reverse();
        }
        if (status == AnimationStatus.completed) {
          _formLoadingController.forward();
        }
      });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _loadingController.forward();
      }
    });

    _logoController = AnimationController(
      vsync: this,
      duration: loadingDuration,
    );
    _titleController = AnimationController(
      vsync: this,
      duration: loadingDuration,
    );

    _formLoadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
      reverseDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _loadingController.dispose();
    _logoController.dispose();
    _titleController.dispose();

    _formLoadingController.dispose();
    super.dispose();
  }

  ThemeData _mergeTheme({
    required ThemeData theme,
    required LoginTheme loginTheme,
  }) {
    final blackOrWhite =
        theme.brightness == Brightness.light ? Colors.black54 : Colors.white;
    final primaryOrWhite = theme.brightness == Brightness.light
        ? theme.primaryColor
        : Colors.white;
    final originalPrimaryColor = loginTheme.primaryColor ?? theme.primaryColor;
    final primaryDarkShades = getDarkShades(originalPrimaryColor);
    final primaryColor = primaryDarkShades.length == 1
        ? lighten(primaryDarkShades.first!)
        : primaryDarkShades.first;
    final primaryColorDark = primaryDarkShades.length >= 3
        ? primaryDarkShades[2]
        : primaryDarkShades.last;
    final accentColor = loginTheme.accentColor ?? theme.colorScheme.secondary;
    final errorColor = loginTheme.errorColor ?? theme.colorScheme.error;
    // the background is a dark gradient, force to use white text if detect default black text color
    final isDefaultBlackText = theme.textTheme.displaySmall!.color ==
        Typography.blackMountainView.displaySmall!.color;
    final titleStyle = theme.textTheme.displaySmall!
        .copyWith(
          color: loginTheme.accentColor ??
              (isDefaultBlackText
                  ? Colors.white
                  : theme.textTheme.displaySmall!.color),
          fontSize: loginTheme.beforeHeroFontSize,
          fontWeight: FontWeight.w300,
        )
        .merge(loginTheme.titleStyle);
    final footerStyle = theme.textTheme.bodyLarge!
        .copyWith(
          color: loginTheme.accentColor ??
              (isDefaultBlackText
                  ? Colors.white
                  : theme.textTheme.displaySmall!.color),
        )
        .merge(loginTheme.footerTextStyle);
    final textStyle = theme.textTheme.bodyMedium!
        .copyWith(color: blackOrWhite)
        .merge(loginTheme.bodyStyle);
    final textFieldStyle = theme.textTheme.titleMedium!
        .copyWith(color: blackOrWhite, fontSize: 14)
        .merge(loginTheme.textFieldStyle);
    final buttonStyle = theme.textTheme.labelLarge!
        .copyWith(color: Colors.white)
        .merge(loginTheme.buttonStyle);
    final cardTheme = loginTheme.cardTheme;
    final inputTheme = loginTheme.inputTheme;
    final buttonTheme = loginTheme.buttonTheme;
    final roundBorderRadius = BorderRadius.circular(100);

    LoginThemeHelper.loginTextStyle = titleStyle;

    TextStyle labelStyle;

    if (loginTheme.primaryColorAsInputLabel) {
      labelStyle = TextStyle(color: primaryColor);
    } else {
      labelStyle = TextStyle(color: blackOrWhite);
    }

    return theme.copyWith(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      cardTheme: theme.cardTheme.copyWith(
        clipBehavior: cardTheme.clipBehavior,
        color: cardTheme.color ?? theme.cardColor,
        elevation: cardTheme.elevation ?? 12.0,
        margin: cardTheme.margin ?? const EdgeInsets.all(4.0),
        shape: cardTheme.shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        filled: inputTheme.filled,
        fillColor: inputTheme.fillColor ??
            Color.alphaBlend(
              primaryOrWhite.withOpacity(.07),
              Colors.grey.withOpacity(.04),
            ),
        contentPadding: inputTheme.contentPadding ??
            const EdgeInsets.symmetric(vertical: 4.0),
        errorStyle: inputTheme.errorStyle ?? TextStyle(color: errorColor),
        labelStyle: inputTheme.labelStyle ?? labelStyle,
        enabledBorder: inputTheme.enabledBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: roundBorderRadius,
            ),
        focusedBorder: inputTheme.focusedBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor!, width: 1.5),
              borderRadius: roundBorderRadius,
            ),
        errorBorder: inputTheme.errorBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: errorColor),
              borderRadius: roundBorderRadius,
            ),
        focusedErrorBorder: inputTheme.focusedErrorBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: errorColor, width: 1.5),
              borderRadius: roundBorderRadius,
            ),
        disabledBorder: inputTheme.disabledBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: roundBorderRadius,
            ),
      ),
      floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
        backgroundColor: buttonTheme.backgroundColor ?? primaryColor,
        splashColor: buttonTheme.splashColor ?? theme.colorScheme.secondary,
        elevation: buttonTheme.elevation ?? 4.0,
        highlightElevation: buttonTheme.highlightElevation ?? 2.0,
        shape: buttonTheme.shape ?? const StadiumBorder(),
      ),
      // put it here because floatingActionButtonTheme doesnt have highlightColor property
      highlightColor:
          loginTheme.buttonTheme.highlightColor ?? theme.highlightColor,
      textTheme: theme.textTheme.copyWith(
        displaySmall: titleStyle,
        bodyMedium: textStyle,
        titleMedium: textFieldStyle,
        titleSmall: footerStyle,
        labelLarge: buttonStyle,
      ),
      colorScheme: Theme.of(context)
          .colorScheme
          .copyWith(secondary: accentColor)
          .copyWith(error: errorColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginTheme = LoginTheme();
    final messages = LoginMessages();
    final deviceSize = MediaQuery.of(context).size;
    final theme = _mergeTheme(theme: Theme.of(context), loginTheme: loginTheme);
    final cardInitialHeight = loginTheme.cardInitialHeight ?? 300;
    final cardTopPosition = loginTheme.cardTopPosition ??
        max(deviceSize.height / 2 - cardInitialHeight / 2, 85);

    final headerMargin = loginTheme.headerMargin ?? 15;
    final headerHeight = cardTopPosition - headerMargin;
    return Theme(
      data: theme,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: _RotateLoading(
              loadingController: _loadingController,
              child: Container(
                height: deviceSize.height,
                width: deviceSize.width,
                padding: EdgeInsets.only(top: cardTopPosition),
                child: TransformerPageView(
                  itemCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  index: _pageIndex,
                  pageController: _pageController,
                  transformer: CustomPageTransformer(),
                  itemBuilder: (BuildContext context, int index) {
                    return BlocBuilder<ScreensCubit, ScreensState>(
                      builder: (context, state) {
                        return Align(
                          alignment: Alignment.topCenter,
                          child: state.screen == Screens.login ||
                                  state.screen == Screens.signup
                              ? LoginScreen(
                                  loadingController: _loadingController,
                                  pageController: _pageController,
                                  formLoadingController: _formLoadingController,
                                  loginTheme: loginTheme,
                                  theme: theme,
                                  messages: messages,
                                )
                              : _ForgotPasswordScreen(
                                  formLoadingController: _formLoadingController,
                                  pageController: _pageController,
                                  loginTheme: loginTheme,
                                  theme: theme,
                                  messages: messages,
                                ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: cardTopPosition - headerHeight - headerMargin,
            child: _Header(
              logoController: _logoController,
              titleController: _titleController,
              height: headerHeight,
              logo: widget.logo,
              logoWidth: loginTheme.logoWidth ?? 0.75,
              title: widget.title,
              titleTag: widget.titleTag,
              loginTheme: loginTheme,
            ),
          ),
          const Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({
    this.logo,
    this.logoTag,
    this.logoWidth = 0.75,
    this.title,
    this.titleTag,
    this.height = 250.0,
    this.logoController,
    this.titleController,
    required this.loginTheme,
  });

  final ImageProvider? logo;
  final String? logoTag;
  final double logoWidth;
  final String? title;
  final String? titleTag;
  final double height;
  final LoginTheme loginTheme;
  final AnimationController? logoController;
  final AnimationController? titleController;

  @override
  __HeaderState createState() => __HeaderState();
}

class __HeaderState extends State<_Header> {
  double _titleHeight = 0.0;

  /// https://stackoverflow.com/a/56997641/9449426
  double getEstimatedTitleHeight() {
    if (DartHelper.isNullOrEmpty(widget.title)) {
      return 0.0;
    }

    final theme = Theme.of(context);
    final renderParagraph = RenderParagraph(
      TextSpan(
        text: widget.title,
        style: theme.textTheme.displaySmall!.copyWith(
          fontSize: widget.loginTheme.beforeHeroFontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    renderParagraph.layout(const BoxConstraints());

    return renderParagraph
        .getMinIntrinsicHeight(widget.loginTheme.beforeHeroFontSize)
        .ceilToDouble();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _titleHeight = getEstimatedTitleHeight();
  }

  @override
  void didUpdateWidget(_Header oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.title != oldWidget.title) {
      _titleHeight = getEstimatedTitleHeight();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const gap = 5.0;
    final logoHeight = min(
      (widget.height - MediaQuery.of(context).padding.top) - _titleHeight - gap,
      kMaxLogoHeight,
    );
    final displayLogo = widget.logo != null && logoHeight >= kMinLogoHeight;
    final cardWidth = min(MediaQuery.of(context).size.width * 0.75, 360.0);

    var logo = displayLogo
        ? Image(
            image: widget.logo!,
            filterQuality: FilterQuality.high,
            height: logoHeight,
            width: widget.logoWidth * cardWidth,
          )
        : const SizedBox.shrink();

    if (widget.logoTag != null) {
      logo = Hero(
        tag: widget.logoTag!,
        child: logo,
      );
    }

    Widget? title;
    if (widget.titleTag != null && !DartHelper.isNullOrEmpty(widget.title)) {
      title = HeroText(
        widget.title,
        key: kTitleKey,
        tag: widget.titleTag,
        largeFontSize: widget.loginTheme.beforeHeroFontSize,
        smallFontSize: widget.loginTheme.afterHeroFontSize,
        style: theme.textTheme.displaySmall,
        viewState: ViewState.enlarged,
      );
    } else if (!DartHelper.isNullOrEmpty(widget.title)) {
      title = Text(
        widget.title!,
        key: kTitleKey,
        style: theme.textTheme.displaySmall,
      );
    } else {
      title = null;
    }

    return SafeArea(
      child: SizedBox(
        height: widget.height - MediaQuery.of(context).padding.top,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (displayLogo)
              FadeIn(
                controller: widget.logoController,
                offset: .25,
                fadeDirection: FadeDirection.topToBottom,
                child: logo,
              ),
            const SizedBox(height: gap),
            FadeIn(
              controller: widget.titleController,
              offset: .5,
              fadeDirection: FadeDirection.topToBottom,
              child: title,
            ),
          ],
        ),
      ),
    );
  }
}

class _RotateChangeRoute extends StatefulWidget {
  final Widget child;

  const _RotateChangeRoute({super.key, required this.child});
  @override
  State<_RotateChangeRoute> createState() => _RotateChangeRouteState();
}

class _RotateChangeRouteState extends State<_RotateChangeRoute>
    with SingleTickerProviderStateMixin {
  static const cardSizeScaleEnd = .2;
  // Card specific animations

  late Animation<double> _cardSizeAnimation;
  late Animation<double> _cardSize2AnimationX;
  late Animation<double> _cardSize2AnimationY;
  late Animation<double> _cardRotationAnimation;
  late AnimationController _routeTransitionController;
  // TODO: PAGE TRANSLATION
  late Animation<double> _cardOverlayHeightFactorAnimation;
  late Animation<double> _cardOverlaySizeAndOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _routeTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _cardSizeAnimation =
        Tween<double>(begin: 1.0, end: cardSizeScaleEnd).animate(
      CurvedAnimation(
        parent: _routeTransitionController,
        curve: const Interval(
          0,
          .27272727 /* ~300ms */,
          curve: Curves.easeInOutCirc,
        ),
      ),
    );

    _cardOverlayHeightFactorAnimation =
        Tween<double>(begin: double.minPositive, end: 1.0).animate(
      CurvedAnimation(
        parent: _routeTransitionController,
        curve: const Interval(.27272727, .5),
      ),
    );

    _cardOverlaySizeAndOpacityAnimation =
        Tween<double>(begin: 1.0, end: 0).animate(
      CurvedAnimation(
        parent: _routeTransitionController,
        curve: const Interval(.5, .72727272),
      ),
    );

    _cardSize2AnimationX =
        Tween<double>(begin: 1, end: 1).animate(_routeTransitionController);

    _cardSize2AnimationY =
        Tween<double>(begin: 1, end: 1).animate(_routeTransitionController);

    _cardRotationAnimation = Tween<double>(begin: 0, end: pi / 2).animate(
      CurvedAnimation(
        parent: _routeTransitionController,
        curve: const Interval(
          .72727272,
          1 /* ~300ms */,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _routeTransitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _cardSize2AnimationX,
      builder: (context, snapshot) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateZ(_cardRotationAnimation.value)
          ..scale(_cardSizeAnimation.value, _cardSizeAnimation.value)
          ..scale(_cardSize2AnimationX.value, _cardSize2AnimationY.value),
        child: widget.child,
      ),
    );
  }
}

class _RotateLoading extends StatefulWidget {
  final Widget child;
  final AnimationController loadingController;

  const _RotateLoading(
      {super.key, required this.child, required this.loadingController});
  @override
  State<_RotateLoading> createState() => _RotateLoadingState();
}

class _RotateLoadingState extends State<_RotateLoading>
    with SingleTickerProviderStateMixin {
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
    // TODO: implement build
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) => Transform(
        transform: Matrix.perspective()..rotateX(_flipAnimation.value),
        alignment: Alignment.center,
        child: child,
      ),
      child: widget.child,
    );
  }
}
