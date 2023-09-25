import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'animations_state.dart';

class AnimationCubit extends Cubit<AnimationState> {
  bool isLogin = false;
  AnimationCubit() : super(const AnimationState());
  void signupPressed() {
    isLogin = !isLogin;
    emit(AnimationState(signUpPushed: isLogin));
  }
}
