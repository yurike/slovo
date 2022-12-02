// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/pages/edit_page.dart';
import 'package:my_notepad/utils/markdown_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

@Deprecated("Replaced with edit_page")
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
              ),
            ),
            if (widget.note != null)
              ListTile(
                title: note!.markdown
                    ? MarkdownBody(
                        data: note.body,
                        extensionSet: MarkdownExtensionSet.githubFlavored.value,
                        shrinkWrap: true,
                        onTapLink: (String text, String? href, String title) =>
                            (href != null)
                                ? _launchUrl(href)
                                : debugPrint("href is null"),
                      )
                    : Text(note.body),
              ),
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

  Future<void> _launchUrl(String href) async {
    final Uri url = Uri.parse(href);
    if (!await launchUrl(url)) {
      throw 'Could not launch $href';
    }
  }
}
