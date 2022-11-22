import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notepad/blocs/settings_bloc/settings_bloc.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/blocs/note_bloc/note_bloc.dart';
import 'package:my_notepad/pages/edit_page.dart';
import 'package:my_notepad/pages/note_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NoteBloc>(context).add(LoadNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notepad'),
      ),
      drawer: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Drawer(
            child: ListView(children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  children: [
                    Text('Options',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
              SwitchListTile(
                title: const Text("Dark mode"),
                value: state.darkMode,
                onChanged: (value) => context
                    .read<SettingsBloc>()
                    .add(SetMode(value, state.compactMode, state.showButtons)),
              ),
              SwitchListTile(
                title: const Text("Compact mode"),
                value: state.compactMode,
                onChanged: (value) => context
                    .read<SettingsBloc>()
                    .add(SetMode(state.darkMode, value, state.showButtons)),
              ),
              SwitchListTile(
                title: const Text("Show buttons"),
                value: state.showButtons,
                onChanged: (value) => context
                    .read<SettingsBloc>()
                    .add(SetMode(state.darkMode, state.compactMode, value)),
              )
            ]),
          );
        },
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => goToNotePage(note: null),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<NoteBloc, NoteState>(
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
              return BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  return ListTile(
                    title: Text(note.title),
                    subtitle:
                        settingsState.compactMode ? null : _buildSubtitle(note),
                    trailing: settingsState.showButtons
                        ? _buildUpdateDeleteButtons(note)
                        : null,
                    onTap: () {
                      goToNotePage(note: note, edit: false);
                    },
                  );
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
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            BlocProvider.of<NoteBloc>(context).add(DeleteNote(displayedNote));
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
