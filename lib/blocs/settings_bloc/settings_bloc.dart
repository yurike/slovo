import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(darkMode: false)) {
    on<SetDarkMode>((event, emit) {
      emit(SettingsState(darkMode: event.isDark));
    });
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState(darkMode: json['darkMode'] as bool);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return {'darkMode': state.darkMode};
  }
}
