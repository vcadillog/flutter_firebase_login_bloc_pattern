import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'animations_state.dart';

class AnimationCubit extends Cubit<AnimationState> {
  AnimationCubit() : super(const AnimationState());

  void toSignup() {
    emit(
      const AnimationState(status: ButtonPushStatus.signupChange),
    );
  }

  void onSingupEnd() {
    emit(
      const AnimationState(
        status: ButtonPushStatus.signupEnd,
      ),
    );
  }

  void toLogin() {
    emit(
      const AnimationState(status: ButtonPushStatus.loginChange),
    );
  }

  void onLoginEnd() {
    emit(
      const AnimationState(
        status: ButtonPushStatus.loginEnd,
      ),
    );
  }
}
