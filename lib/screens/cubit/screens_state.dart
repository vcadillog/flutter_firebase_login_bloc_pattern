part of 'screens_cubit.dart';

enum Screens {
  login,
  signup,
  recoverPassword,
}

final class ScreensState extends Equatable {
  const ScreensState({
    this.screen = Screens.login,
    this.oldScreen = Screens.login,
  });

  final Screens screen;
  final Screens oldScreen;

  @override
  List<Object?> get props => [
        screen,
        oldScreen,
      ];
  ScreensState copyWith({
    Screens? screen,
    Screens? oldScreen,
  }) {
    return ScreensState(
      screen: screen ?? this.screen,
      oldScreen: oldScreen ?? this.oldScreen,
    );
  }
}
