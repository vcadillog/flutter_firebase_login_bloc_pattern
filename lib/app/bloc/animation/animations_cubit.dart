import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'animations_state.dart';

class AnimationCubit extends Cubit<AnimationState> {
  AnimationCubit() : super(const AnimationState());

  void inProgress() {
    emit(
      const AnimationState(status: ButtonPushStatus.onChangeScreen),
    );
  }

  void toSignup() {
    emit(
      const AnimationState(
        status: ButtonPushStatus.signupScreen,
      ),
    );
  }

  void toLogin() {
    emit(
      const AnimationState(),
    );
  }
}
