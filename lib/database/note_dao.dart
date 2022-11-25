import 'package:hive_flutter/hive_flutter.dart';
import 'note.dart';

class NoteDao {
  final Box _box = Hive.box('notes');

  Future insert(Note note) async {
    _box.add(note.toJson());
  }

  Future update(Note note) async {
    _box.put(note.id, note.toJson());
  }

  Future addAll(List<Note> notes) async {
    // TODO
    //print("addAll ${notes.first.title}");
    for (Note n in notes) {
      _box.add(n.toJson());
    }
  }

  Future delete(Note note) async {
    //print("delete ${note.name}");
    _box.delete(note.id);
  }

  List<Note> getAllSortedByName() {
    print("getAllSortedByName ${_box.values.length}");
    // List<Note> notes = [];
    // Note note;
    // for (var key in _box.keys) {
    //   note = Note.fromJson(_box.get(key)); // .cast<String, dynamic>()
    //   note.id = key;
    //   notes.add(note);
    // }
    // return notes;

    return _box.keys.map((key) {
      final value = _box.get(key);
      final note = Note.fromJson(value);
      note.id = key; // here id is created
      return note;
    }).toList();
  }
}
