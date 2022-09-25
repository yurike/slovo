import 'package:sembast/sembast.dart';
import 'app_database.dart';
import 'note.dart';

class NoteDao {
  static const String NOTE_STORE_NAME = 'notes';
  final _noteStore = intMapStoreFactory.store(NOTE_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Note note) async {
    print("insert note ${note.name}");
    await _noteStore.add(await _db, note.toMap());
  }

  Future update(Note note) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(note.id));
    await _noteStore.update(
      await _db,
      note.toMap(),
      finder: finder,
    );
  }

  Future delete(Note note) async {
    final finder = Finder(filter: Filter.byKey(note.id));
    await _noteStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Note>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _noteStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final note = Note.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      note.id = snapshot.key;
      return note;
    }).toList();
  }
}
