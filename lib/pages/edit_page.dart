// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/blocs/note_bloc/note_bloc.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

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
  late ValueNotifier<bool> _markDown;
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
    _markDown = ValueNotifier(widget.initialNote?.markdown ?? false);
  }

  Future save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var date = DateTime.now().millisecondsSinceEpoch;
      var note = Note()
        ..id = _noteId != null ? _noteId! : date
        ..title = _titleTextController!.text
        ..body = _contentTextController!.text
        ..markdown = _markDown.value
        ..created = date;

      _noteBloc.add(_noteId != null ? UpdateNote(note) : AddNote(note));
      Navigator.pop(context);
      // Pop twice when editing
      if (_noteId != null) {
        Navigator.maybePop(context);
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
          return (await _showDirtyDialog(context)) ?? false;
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
                  if (await _showDeleteDialog(context) ?? false) {
                    _noteBloc.add(DeleteNote(widget.initialNote!));
                    Navigator.of(context).pop();
                    Navigator.of(context).maybePop();
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
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    child: ValueListenableBuilder(
                      valueListenable: _markDown,
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return CheckboxListTile(
                          title: Text("Markdown"),
                          value: _markDown.value,
                          onChanged: (value) {
                            _markDown.value = !_markDown.value;
                            Navigator.maybePop(context);
                          },
                        );
                      },
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
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
                        height: 10,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _markDown,
                        builder:
                            (BuildContext context, bool mdIsOn, Widget? child) {
                          return mdIsOn
                              ? MarkdownAutoPreview(
                                  controller: _contentTextController,
                                  toolbarBackground:
                                      Theme.of(context).bottomAppBarColor,
                                  expandableBackground:
                                      Theme.of(context).backgroundColor,
                                  decoration: InputDecoration(
                                    hintText: 'Text with markdown support',
                                  ),
                                  emojiConvert: true,
                                  minLines: 5,
                                  maxLines: 20,
                                  //expands: true,
                                )
                              : TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Content',
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: _contentTextController,
                                  validator: (val) => val!.isNotEmpty
                                      ? null
                                      : 'Content must not be empty',
                                  keyboardType: TextInputType.multiline,
                                  minLines: 5,
                                  maxLines: 20,
                                );
                        },
                      ),
                    ]))
          ]),
        ),
      ),
    );
  }

  Future<bool?> _showDirtyDialog(BuildContext context) async {
    return await showDialog<bool>(
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
        });
  }

  Future<bool?> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete note?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Tap \'YES\' to confirm note deletion.'),
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
        });
  }
}
