part of '../login_form.dart';

class _InFieldAnimation extends StatefulWidget {
  final Widget inputWidget;
  final double boxHeight;
  final VoidCallback? onEnd;
  final Color colorEnd;
  final Color color;
  final bool isReverse;
  const _InFieldAnimation({
    required this.inputWidget,
    required this.boxHeight,
    this.isReverse = false,
    this.color = const Color(0xFFCC3333),
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
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
    offset = widget.isReverse ? -offset : offset;
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
  final Color color;
  final bool isReverse;

  const _OutFieldAnimation({
    required this.inputWidget,
    required this.boxHeight,
    this.isReverse = false,
    this.color = const Color(0xFF99CC99),
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
        offset = widget.isReverse ? -offset : offset;
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
      color: widget.color,
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

class _TextRotation extends StatelessWidget {
  final bool reversedText;
  const _TextRotation({this.reversedText = false});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTextStyle(
      style: TextStyle(
          fontSize: 15, color: theme.primaryColor, fontWeight: FontWeight.bold),
      child: AnimatedTextKit(
        totalRepeatCount: 1,
        pause: Duration.zero,
        animatedTexts: [
          RotateAnimatedText(
            reversedText ? 'SIGN UP' : 'LOG IN',
            duration: const Duration(milliseconds: 250),
          ),
          RotateAnimatedText(
            reversedText ? 'LOG IN' : 'SIGN UP',
            duration: const Duration(milliseconds: 250),
            rotateOut: false,
          ),
        ],
      ),
    );
  }
}
