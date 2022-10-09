import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/note_bloc/note_bloc.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NoteBloc _noteBloc;

  @override
  void initState() {
    super.initState();
    _noteBloc = BlocProvider.of<NoteBloc>(context);
    // Events can be passed into the bloc by calling add.
    // We want to start loading fruits right from the start.
    _noteBloc.add(LoadNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notepad'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _noteBloc.add(AddRandomNote());
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder(
      bloc: _noteBloc,
      // Whenever there is a new state emitted from the bloc, builder runs.
      builder: (BuildContext context, NoteState state) {
        if (state is NotesLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is NotesLoaded) {
          return ListView.builder(
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final displayedFruit = state.notes[index];
              return ListTile(
                title: Text(displayedFruit.name),
                subtitle: Text(displayedFruit.isPoem ? 'poem' : 'text'),
                trailing: _buildUpdateDeleteButtons(displayedFruit),
              );
            },
          );
        }
        throw "Impossible error";
      },
    );
  }

  Row _buildUpdateDeleteButtons(Note displayedNote) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _noteBloc.add(UpdateWithRandomNote(displayedNote));
          },
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            _noteBloc.add(DeleteNote(displayedNote));
          },
        ),
      ],
    );
  }
}
