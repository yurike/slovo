part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

// class SetDarkMode extends SettingsEvent {
//   final bool isDark;
//   const SetDarkMode(this.isDark) : super();
// }

class SetMode extends SettingsEvent {
  final bool isDark;
  final bool isCompact;
  const SetMode(this.isDark, this.isCompact) : super();
}
