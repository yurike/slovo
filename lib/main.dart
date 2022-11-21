import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notepad/blocs/settings_bloc/settings_bloc.dart';
import 'package:my_notepad/pages/homepage.dart';
import 'package:my_notepad/blocs/note_bloc/note_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_notepad/settings/theme_class.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('notes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrapping the whole app with BlocProvider to get access to NoteBloc everywhere
    // BlocProvider extends InheritedWidget.
    return MultiBlocProvider(
      //create: (BuildContext context) => NoteBloc(),
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
            // theme: ThemeData(
            //     colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
            //         .copyWith(secondary: Colors.teal)),
            home: HomePage(),
          );
        },
      ),
    );
  }
}
