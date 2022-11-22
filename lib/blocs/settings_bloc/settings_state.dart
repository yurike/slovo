part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool darkMode;
  final bool compactMode;
  const SettingsState({
    required this.darkMode,
    required this.compactMode,
  });

  @override
  List<Object> get props => [darkMode, compactMode];
}
