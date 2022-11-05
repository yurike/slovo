import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:my_notepad/database/note.dart';
import 'package:my_notepad/database/note_dao.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteDao _noteDao = NoteDao();

  NoteBloc() : super(NotesLoading()) {
    on<LoadNotes>((event, emit) async {
      print("on<LoadNotes>");
      final notes = _noteDao.getAllSortedByName();
      emit(NotesLoaded(notes));
      // yield NotesLoading();
      // yield* _reloadNotes();
    });

    on<AddRandomNote>((event, emit) async {
      print("on<AddRandomNote>");
      await _noteDao.insert(RandomFruitGenerator.getRandomFruit());
      emit(NotesLoading()); // без этого не обновляется
      final notes = _noteDao.getAllSortedByName();
      emit(NotesLoaded(notes));
      //yield* _reloadNotes();
    });

    on<DeleteNote>((event, emit) async {
      print("on<DeleteNote>");
      await _noteDao.delete(event.note);
      emit(NotesLoading());
      final notes = _noteDao.getAllSortedByName();
      emit(NotesLoaded(notes));
    });

    on<UpdateWithRandomNote>((event, emit) async {
      print("on<UpdateWithRandomNote>");
      emit(NotesLoading());
      final newNote = RandomFruitGenerator.getRandomFruit();
      newNote.id = event.updatedNote.id;
      await _noteDao.update(newNote);
      final notes = _noteDao.getAllSortedByName();
      emit(NotesLoaded(notes));
    });
  }

  @override
  NoteState get initialState => NotesLoading();
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
