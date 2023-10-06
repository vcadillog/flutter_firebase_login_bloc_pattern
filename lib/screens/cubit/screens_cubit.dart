import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'screens_state.dart';

class ScreensCubit extends Cubit<ScreensState> {
  ScreensCubit() : super(const ScreensState());

  void changeScreen(Screens screen) {
    emit(
      state.copyWith(
        screen: screen,
        oldScreen: screen != Screens.recoverPassword ? screen : null,
      ),
    );
  }
}
