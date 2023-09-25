part of 'animations_cubit.dart';

final class AnimationState extends Equatable {
  const AnimationState({this.signUpPushed = false});
  final bool signUpPushed;
  @override
  List<Object?> get props => [signUpPushed];
}
