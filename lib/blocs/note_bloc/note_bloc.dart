// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:slovo/database/note.dart';
import 'package:slovo/database/note_dao.dart';
import 'package:slovo/utils/backup.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteDao _noteDao = NoteDao();

  NoteBloc() : super(NotesLoading()) {
    on<LoadNotes>((event, emit) async {
      // debugPrint("on<LoadNotes>");
      _reloadNotes(emit);
    });

    on<AddNote>((event, emit) async {
      // debugPrint("on<AddNote>");
      emit(NotesLoading());
      await _noteDao.insert(event.note);
      _reloadNotes(emit);
    });

    on<DeleteNote>((event, emit) async {
      // debugPrint("on<DeleteNote>");
      await _noteDao.delete(event.note);
      emit(NotesLoading());
      _reloadNotes(emit);
    });

    on<UpdateNote>((event, emit) async {
      // debugPrint("on<UpdateNote>");
      emit(NotesLoading());
      await _noteDao.update(event.updatedNote);
      _reloadNotes(emit);
    });

    on<SaveBackup>((event, emit) async {
      // debugPrint("on<SaveBackup>");
      final notes = _noteDao.getAll();
      var file = await GetIt.I<Backup>().writeBackup(notes);
      debugPrint(file != null ? "Backup Saved" : "Saving is impossible");
      if (file != null) {
        GetIt.I<Backup>().share(message: "Backup Saved. Share file?");
      }
    });

    on<ImportFromFile>((event, emit) async {
      //debugPrint("on<ImportFromFile> ${event.fromBackup}");
      emit(NotesLoading());
      var newNotes = (event.fromBackup)
          ? await GetIt.I<Backup>().readNotes()
          : await GetIt.I<Backup>().readFromFilePicker();
      if (newNotes != null) {
        await _noteDao.addAll(newNotes);
      }
      _reloadNotes(emit);
    });
  }

  void _reloadNotes(Emitter<NoteState> emit) {
    final notes = _noteDao.getAll();
    emit(NotesLoaded(notes));
  }
}
