import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/note_bloc/note_bloc.dart';
import 'package:my_notepad/pages/edit_page.dart';
import 'package:my_notepad/pages/note_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NoteBloc _noteBloc;
  bool _compactMode = false;

  @override
  void initState() {
    super.initState();
    _noteBloc = BlocProvider.of<NoteBloc>(context);
    // Events can be passed into the bloc by calling add.
    _noteBloc.add(LoadNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notepad'),
      ),
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Column(
              children: [
                const Text(
                  'Options',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text("Compact mode"),
            value: _compactMode,
            onChanged: (value) {
              _noteBloc.add(CompactTiles(value));
              setState(() => _compactMode = value);
            },
          )
        ]),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //_noteBloc.add(AddRandomNote());
          goToNotePage(note: null);
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
                subtitle:
                    _compactMode ? null : Text(note.isPoem ? 'poem' : 'text'),
                trailing: _buildUpdateDeleteButtons(note),
                onTap: () {
                  goToNotePage(note: note, edit: false);
                },
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
            goToNotePage(note: displayedNote);
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

  void goToNotePage({required Note? note, bool edit = true}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      if (edit) {
        return EditNotePage(initialNote: note);
      } else {
        return NotePage(note: note);
      }
    }));
  }
}
