import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slovo/blocs/settings_bloc/settings_bloc.dart';
import 'package:slovo/database/note.dart';
import 'package:slovo/blocs/note_bloc/note_bloc.dart';
import 'package:slovo/pages/edit_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NoteBloc>(context).add(LoadNotes());
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _goToNotePage(context, note: null),
      ),
    );
  }

  Widget _buildDrawer() {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Drawer(
          width: 250,
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
            ),
            ListTile(
              leading: TextButton(
                onPressed: () {
                  context.read<NoteBloc>().add(SaveBackup());
                  Navigator.of(context).maybePop();
                },
                child: Text('Save Backup'),
              ),
              trailing: TextButton(
                onPressed: () {
                  context.read<NoteBloc>().add(ImportFromFile(true));
                  Navigator.of(context).maybePop();
                },
                child: Text('Load Backup'),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () {
                  context.read<NoteBloc>().add(ImportFromFile(false));
                  Navigator.of(context).maybePop();
                },
                child: Text("Import SimpleNote backup"),
              ),
            )
          ]),
        );
      },
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
          state.notes
              .sort((b, a) => a.modified.compareTo(b.modified)); // sorting desc
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
                        ? _buildButtons(context, note)
                        : null,
                    onTap: () {
                      _goToNotePage(context, note: note, edit: false);
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

  Row _buildButtons(context, Note displayedNote) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _goToNotePage(context, note: displayedNote),
        ),
        // IconButton(
        //   icon: const Icon(Icons.delete_outline),
        //   onPressed: () {
        //     BlocProvider.of<NoteBloc>(context).add(DeleteNote(displayedNote));
        //   },
        // ),
      ],
    );
  }

  void _goToNotePage(context, {required Note? note, bool edit = true}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditNotePage(initialNote: note);
      //return (edit) ? EditNotePage(initialNote: note) : NotePage(note: note);
    }));
  }
}
