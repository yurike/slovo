import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/note_bloc/note_bloc.dart';
import 'package:my_notepad/pages/edit_page.dart';

class HomePage extends StatefulWidget {
  @override
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
        title: const Text('My Notepad'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //_noteBloc.add(AddRandomNote());
          goEditPage(null);
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is NotesLoaded) {
          return ListView.builder(
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.isPoem ? 'poem' : 'text'),
                trailing: _buildUpdateDeleteButtons(note),
              );
            },
          );
        }
        throw "Unhandled state error";
      },
    );
  }

  Row _buildUpdateDeleteButtons(Note displayedNote) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            goEditPage(displayedNote);
            // _noteBloc.add(UpdateWithRandomNote(displayedNote));
            //_noteBloc.add(EditNote(displayedNote));
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

  void goEditPage(Note? note) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditNotePage(
        initialNote: note,
      );
    }));
  }
}
