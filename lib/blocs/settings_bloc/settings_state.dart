part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool darkMode;
  final bool compactMode;
  final bool showButtons;

  const SettingsState({
    required this.darkMode,
    required this.compactMode,
    required this.showButtons,
  });

  @override
  List<Object> get props => [darkMode, compactMode, showButtons];
}
