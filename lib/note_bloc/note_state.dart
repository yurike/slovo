part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  NoteState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

//class NoteInitial extends NoteState {}

class NotesLoading extends NoteState {}

class NotesLoaded extends NoteState {
  final List<Note> notes;

  NotesLoaded(this.notes) : super([notes]);
}
