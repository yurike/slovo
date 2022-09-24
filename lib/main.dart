import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notepad/homepage.dart';
import 'package:my_notepad/note_bloc/note_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrapping the whole app with BlocProvider to get access to FruitBloc everywhere
    // BlocProvider extends InheritedWidget.
    return BlocProvider<NoteBloc>(
      //bloc: NoteBloc(),
      create: (BuildContext context) => NoteBloc(NotesLoading()),
      child: MaterialApp(
        title: 'MyNotepad',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow)
              .copyWith(secondary: Colors.redAccent),
        ),
        home: HomePage(),
      ),
    );
  }
}
