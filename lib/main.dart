import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notepad/pages/homepage.dart';
import 'package:my_notepad/note_bloc/note_bloc.dart';
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
    return BlocProvider<NoteBloc>(
      create: (BuildContext context) => NoteBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyNotepad',
        themeMode: ThemeMode.dark,
        theme: ThemeClass.lightTheme,
        darkTheme: ThemeClass.darkTheme,
        // theme: ThemeData(
        //     colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
        //         .copyWith(secondary: Colors.teal)),
        home: HomePage(),
      ),
    );
  }
}
