import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/blocs/note_bloc/note_bloc.dart';
import 'package:my_notepad/pages/edit_page.dart';
import 'package:my_notepad/pages/note_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NoteBloc _noteBloc;
  bool _darkMode = false;
  bool _compactMode = false;
  bool _showButtons = true;

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
      backgroundColor: _darkMode
          ? Theme.of(context).primaryColorDark
          : Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('My Notepad'),
      ),
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            decoration: const BoxDecoration(
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
            title: const Text("Dark mode"),
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          SwitchListTile(
            title: const Text("Compact mode"),
            value: _compactMode,
            onChanged: (value) {
              //_noteBloc.add(CompactTiles(value));
              setState(() => _compactMode = value);
            },
          ),
          SwitchListTile(
            title: const Text("Show buttons"),
            value: _showButtons,
            onChanged: (value) {
              setState(() => _showButtons = value);
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
                subtitle: _compactMode ? null : _buildSubtitle(note),
                trailing: _showButtons ? _buildUpdateDeleteButtons(note) : null,
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

  Text _buildSubtitle(Note note) {
    String txt = note.body.trim().replaceAll("\n", " ");
    int end = txt.length > 70 ? 70 : txt.length;
    txt = txt.substring(0, end);
    return Text(
      txt,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Row _buildUpdateDeleteButtons(Note displayedNote) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
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
