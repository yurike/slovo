import 'package:hive_flutter/hive_flutter.dart';
import 'note.dart';

class NoteDao {
  final Box _box = Hive.box('notes');

  Future insert(Note note) async {
    _box.add(note.toMap());
  }

  Future update(Note note) async {
    _box.put(note.id, note.toMap());
  }

  Future delete(Note note) async {
    //print("delete ${note.name}");
    _box.delete(note.id);
  }

  List<Note> getAllSortedByName() {
    //print("getAllSortedByName" + _box.values.toString());
    return _box.keys.map((key) {
      final value = _box.get(key);
      final note = Note.fromMap(value);
      note.id = key; // here id is created
      return note;
    }).toList();
  }
}
