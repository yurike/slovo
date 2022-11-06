// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/note_bloc/note_bloc.dart';

class EditNotePage extends StatefulWidget {
  /// null when adding a note
  final Note? initialNote;

  const EditNotePage({Key? key, required this.initialNote}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _titleTextController;
  TextEditingController? _contentTextController;
  late NoteBloc _noteBloc;

  int? get _noteId => widget.initialNote?.id;

  @override
  void initState() {
    super.initState();
    _noteBloc = BlocProvider.of<NoteBloc>(context);
    _titleTextController =
        TextEditingController(text: widget.initialNote?.title);
    _contentTextController =
        TextEditingController(text: widget.initialNote?.body);
  }

  Future save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _noteBloc.add(AddNote(Note()
        //..id = _noteId
        ..title = _titleTextController!.text
        ..body = _contentTextController!.text
        ..date = DateTime.now().millisecondsSinceEpoch));
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // Pop twice when editing
      if (_noteId != null) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var dirty = false;
        if (_titleTextController!.text != widget.initialNote?.title) {
          dirty = true;
        } else if (_contentTextController!.text != widget.initialNote?.body) {
          dirty = true;
        }
        if (dirty) {
          return (await showDialog<bool>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Discard change?'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Content has changed.'),
                            SizedBox(
                              height: 12,
                            ),
                            Text('Tap \'CONTINUE\' to discard your changes.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text('CONTINUE'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('CANCEL'),
                        ),
                      ],
                    );
                  })) ??
              false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Note',
          ),
          actions: <Widget>[
            if (_noteId != null)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  if (await showDialog<bool>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete note?'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'Tap \'YES\' to confirm note deletion.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text('YES'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('NO'),
                                ),
                              ],
                            );
                          }) ??
                      false) {
                    _noteBloc.add(DeleteNote(widget.initialNote!));
                    //await noteProvider.deleteNote(widget.initialNote!.id);
                    // Pop twice to go back to the list
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
              ),
            // action button
            IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: () {
                save();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        controller: _titleTextController,
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Title must not be empty',
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Content',
                          border: OutlineInputBorder(),
                        ),
                        controller: _contentTextController,
                        validator: (val) => val!.isNotEmpty
                            ? null
                            : 'Description must not be empty',
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      )
                    ]))
          ]),
        ),
      ),
    );
  }
}