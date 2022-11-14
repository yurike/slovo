// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/pages/edit_page.dart';

class NotePage extends StatefulWidget {
  final Note? note;

  const NotePage({Key? key, required this.note}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    Note? note = widget.note;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Note',
          ),
          actions: <Widget>[
            if (widget.note != null)
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  goEditPage(widget.note);
                },
              ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            goEditPage(widget.note);
          },
          child: ListView(children: <Widget>[
            ListTile(
                title: Text(
              note?.title ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            ListTile(title: Text(note?.body ?? ''))
          ]),
        ));
  }

  void goEditPage(Note? note) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditNotePage(
        initialNote: note,
      );
    }));
  }
}
