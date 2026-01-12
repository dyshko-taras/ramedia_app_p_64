import 'package:equatable/equatable.dart';

class MainShellState extends Equatable {
  const MainShellState({
    required this.currentIndex,
  });

  final int currentIndex;

  MainShellState copyWith({
    int? currentIndex,
  }) {
    return MainShellState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [currentIndex];
}

