part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool darkMode;
  const SettingsState({required this.darkMode});

  @override
  List<Object> get props => [darkMode];
}
