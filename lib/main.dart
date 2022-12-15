import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:cryptography_flutter/cryptography_flutter.dart';

import 'package:slovo/blocs/settings_bloc/settings_bloc.dart';
import 'package:slovo/pages/homepage.dart';
import 'package:slovo/blocs/note_bloc/note_bloc.dart';
import 'package:slovo/settings/theme_class.dart';
import 'package:slovo/utils/backup.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //FlutterCryptography.enable();
  await Hive.initFlutter();
  await Hive.openBox('notes');
  GetIt.I.registerSingleton<Backup>(Backup());
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(App());
  FlutterNativeSplash.remove();
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteBloc>(
          create: (BuildContext context) => NoteBloc(),
        ),
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) => SettingsBloc(),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyNotepad',
            themeMode:
                state.darkMode ? ThemeMode.dark : ThemeMode.light, // system?
            theme: ThemeClass.lightTheme,
            darkTheme: ThemeClass.darkTheme,
            home: HomePage(),
          );
        },
      ),
    );
  }
}
