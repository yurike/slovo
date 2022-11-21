import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(darkMode: false)) {
    on<SetDarkMode>((event, emit) {
      emit(SettingsState(darkMode: event.isDark));
    });
  }
}
