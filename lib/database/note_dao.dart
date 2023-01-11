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

  Future delete(Note note) async {
    _box.delete(note.id);
  }

  List<Note> getAll() {
    //debugPrint("getAllSortedByName ${_box.values.length}");
    return _box.keys.map((key) {
      final value = _box.get(key);
      final note = Note.fromJson(value);
      note.id = key; // here id is created
      return note;
    }).toList();
  }

  Future addAll(List<Note> notes) async {
    for (Note n in notes) {
      _box.add(n.toJson());
    }
  }
}
