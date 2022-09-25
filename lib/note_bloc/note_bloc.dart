import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/database/note_dao.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteDao _noteDao = NoteDao();

  NoteBloc() : super(NotesLoading()) {
    on<LoadNotes>((event, emit) async {
      final notes = await _noteDao.getAllSortedByName();
      emit(NotesLoaded(notes));
      // yield NotesLoading();
      // yield* _reloadNotes();
    });
    on<AddRandomNote>((event, emit) async {
      print("AddRandomNote event"); // TODO
      await _noteDao.insert(RandomFruitGenerator.getRandomFruit());
      final notes = await _noteDao.getAllSortedByName();
      emit(NotesLoaded(notes));
      //yield* _reloadNotes();
    });
  }

  @override
  NoteState get initialState => NotesLoading();

  // TODO : deprecate?
  // Stream<NoteState> mapEventToState(
  //   NoteEvent event,
  // ) async* {
  //   if (event is LoadNotes) {
  //     yield NotesLoading();
  //     yield* _reloadNotes();
  //   } else if (event is AddRandomNote) {
  //     await _noteDao.insert(RandomFruitGenerator.getRandomFruit());
  //     yield* _reloadNotes();
  //   } else if (event is UpdateWithRandomNote) {
  //     final newFruit = RandomFruitGenerator.getRandomFruit();
  //     newFruit.id = event.updatedNote.id;
  //     await _noteDao.update(newFruit);
  //     yield* _reloadNotes();
  //   } else if (event is DeleteNote) {
  //     await _noteDao.delete(event.note);
  //     yield* _reloadNotes();
  //   }
  // }

  Stream<NoteState> _reloadNotes() async* {
    print("_reloadNotes");
    final notes = await _noteDao.getAllSortedByName();
    yield NotesLoaded(notes);
  }
}

class RandomFruitGenerator {
  static final _fruits = [
    Note(name: 'Banana', isPoem: true),
    Note(name: 'Strawberry', isPoem: true),
    Note(name: 'Kiwi', isPoem: false),
    Note(name: 'Apple', isPoem: true),
    Note(name: 'Pear', isPoem: true),
    Note(name: 'Lemon', isPoem: false),
  ];

  static Note getRandomFruit() {
    return _fruits[Random().nextInt(_fruits.length)];
  }
}
