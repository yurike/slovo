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
    });

    on<AddNote>((event, emit) async {
      print("on<AddNote>");
      emit(NotesLoading()); // без этого не обновляется
      await _noteDao.insert(event.note);
      final notes = _noteDao.getAllSortedByName();
      emit(NotesLoaded(notes));
    });

    // on<EditNote>((event, emit) async {
    //   print("on<EditNote>");
    //   emit(NoteEdit(event.note));
    // });

    on<DeleteNote>((event, emit) async {
      print("on<DeleteNote>");
      await _noteDao.delete(event.note);
      emit(NotesLoading());
      final notes = _noteDao.getAllSortedByName();
      emit(NotesLoaded(notes));
    });

    on<UpdateNote>((event, emit) async {
      print("on<UpdateNote>");
      emit(NotesLoading());
      //newNote.id = event.updatedNote.id;
      await _noteDao.update(event.updatedNote);
      final notes = _noteDao.getAllSortedByName();
      emit(NotesLoaded(notes));
    });
  }

  @override
  NoteState get initialState => NotesLoading();
}
