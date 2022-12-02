import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:my_notepad/database/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class Backup {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    return path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/backup.json');
  }

  Future<File?> writeBackup(List<Note> notes) async {
    if (kIsWeb || !await Permission.storage.request().isGranted) {
      return Future.value(null);
    }
    final file = await _localFile;
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    String encoded = jsonEncode(notes);
    return file.writeAsString(encoded);
  }

  void share({String message = "Share backup"}) async {
    File file = await _localFile;
    Share.shareFiles([file.path], text: message);
  }

  Future<List<Note>> readNotes([bool local = true, File? selectedFile]) async {
    //debugPrint("readNotes $local ${selectedFile?.path}");
    try {
      File file;
      if (local) {
        file = await _localFile;
      } else {
        file = selectedFile!;
      }

      final jsonContents = await file.readAsString();
      List<dynamic> jsonResponse = json.decode(jsonContents);
      return jsonResponse.map((i) => Note.fromJson(i)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return []; // If encountering an empty array
    }
  }

  Future<List<Note>?> readFromFilePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null && result.files.isNotEmpty) {
      List<Note> notes = [];
      if (kIsWeb) {
        final fileBytes = result.files.first.bytes;
        //final fileName = result.files.first.name;
        var activeNotes = json.decode(utf8.decode(fileBytes!))["activeNotes"];
        for (var aNote in activeNotes) {
          // debugPrint(DateTime.tryParse(aNote["creationDate"])
          //     ?.millisecondsSinceEpoch
          //     .toString());
          notes.add(Note.fromSimpleNoteJson(aNote));
        }
        //notes = activeNotes.map((i) => Note.fromSimpleNoteJson(i)).toList();

      } else {
        File file = File(result.files.single.path!);
        notes = await readNotes(false, file);
      }

      //writePeople(notes);
      return notes;
    } else {
      return null;
      //return Future.value(readNotes());
    }
  }
}
