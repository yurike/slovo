import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart';

import 'package:my_notepad/blocs/settings_bloc/settings_bloc.dart';
import 'package:my_notepad/pages/homepage.dart';
import 'package:my_notepad/blocs/note_bloc/note_bloc.dart';
import 'package:my_notepad/settings/theme_class.dart';
import 'package:my_notepad/utils/backup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterCryptography.enable();
  await Hive.initFlutter();
  await Hive.openBox('notes');
  GetIt.I.registerSingleton<Backup>(Backup());
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
