part of 'note_bloc.dart';

@immutable
abstract class NoteEvent extends Equatable {
  NoteEvent([List props = const []]) : super(); // super(props)

  @override
  List<Object> get props => [];
}

class LoadNotes extends NoteEvent {}

class AddRandomNote extends NoteEvent {}

class AddNote extends NoteEvent {
  final Note note;
  AddNote(this.note) : super([note]);
}

// class EditNote extends NoteEvent {
//   final Note note;
//   EditNote(this.note) : super([note]);
// }

// class UpdateWithRandomNote extends NoteEvent {
//   final Note updatedNote;
//   UpdateWithRandomNote(this.updatedNote) : super([updatedNote]);
// }

class UpdateNote extends NoteEvent {
  final Note updatedNote;
  UpdateNote(this.updatedNote) : super([updatedNote]);
}

class DeleteNote extends NoteEvent {
  final Note note;
  DeleteNote(this.note) : super([note]);
}
