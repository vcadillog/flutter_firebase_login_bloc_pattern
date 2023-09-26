part of 'animations_cubit.dart';

enum ButtonPushStatus {
  loginScreen,
  signupScreen,
  onChangeScreen,
  onFinished,
}

final class AnimationState extends Equatable {
  // const AnimationState({this.signUpPushed = false});
  const AnimationState({this.status = ButtonPushStatus.loginScreen});
  // final bool signUpPushed;
  final ButtonPushStatus status;
  @override
  // List<Object?> get props => [signUpPushed];
  List<Object?> get props => [status];
}
