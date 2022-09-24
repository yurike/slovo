part of 'note_bloc.dart';

@immutable
abstract class NoteEvent extends Equatable {
  NoteEvent([List props = const []]) : super(); // super(props)

  @override
  List<Object> get props => [];
}

class LoadNotes extends NoteEvent {}

class AddRandomNote extends NoteEvent {}

class UpdateWithRandomNote extends NoteEvent {
  final Note updatedNote;

  UpdateWithRandomNote(this.updatedNote) : super([updatedNote]);
}

class DeleteNote extends NoteEvent {
  final Note note;

  DeleteNote(this.note) : super([note]);
}
