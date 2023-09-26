import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'animations_state.dart';

class AnimationCubit extends Cubit<AnimationState> {
  bool isLogin = true;
  AnimationCubit() : super(const AnimationState());
  void inProgress() {
    emit(
      const AnimationState(status: ButtonPushStatus.onChangeScreen),
    );
  }

  void finishedAnimation() {
    isLogin = !isLogin;
    emit(
      AnimationState(
        status: isLogin
            ? ButtonPushStatus.loginScreen
            : ButtonPushStatus.signupScreen,
      ),
    );
  }
}
