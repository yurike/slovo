import 'dart:async';

import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  static final AppDatabase _singleton = AppDatabase._();
  static AppDatabase get instance => _singleton;

  // Приватный конструктор. Позволяет создавать инстансы только изнутри класса
  AppDatabase._();

  // Completer для превращения синхронного кода в асинхронный + доп.фичи
  late Completer<Database> _dbOpenCompleter;
  late Database _database;

  Future<Database> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    // final appDocumentDir = await getApplicationDocumentsDirectory();
    // final dbPath = join(appDocumentDir.path, 'demo.db');
    // final database = await databaseFactoryIo.openDatabase(dbPath);

    // File path to a file in the current directory
    String dbPath = 'sample.db';
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbPath);

    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter.complete(db);
  }
}
