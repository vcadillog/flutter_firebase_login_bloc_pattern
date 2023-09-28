part of 'animations_cubit.dart';

enum ButtonPushStatus {
  initialScreen,
  loginEnd,
  loginChange,
  signupEnd,
  signupChange,
}

final class AnimationState extends Equatable {
  // const AnimationState({this.signUpPushed = false});
  const AnimationState({this.status = ButtonPushStatus.initialScreen});
  // final bool signUpPushed;
  final ButtonPushStatus status;
  @override
  // List<Object?> get props => [signUpPushed];
  List<Object?> get props => [status];
}
