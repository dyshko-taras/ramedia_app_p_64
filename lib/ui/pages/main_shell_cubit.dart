import 'package:bloc/bloc.dart';

import 'main_shell_state.dart';

class MainShellCubit extends Cubit<MainShellState> {
  MainShellCubit({required int initialIndex})
      : super(MainShellState(currentIndex: initialIndex));

  void setTab(int index) {
    if (index == state.currentIndex) return;
    emit(state.copyWith(currentIndex: index));
  }
}

