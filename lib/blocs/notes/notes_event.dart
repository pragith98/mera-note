import 'package:equatable/equatable.dart';
import '../../models/note.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final Note note;

  const AddNote(this.note);

  @override
  List<Object?> get props => [note];
}

class UpdateNote extends NotesEvent {
  final Note note;

  const UpdateNote(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NotesEvent {
  final String noteId;

  const DeleteNote(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class FilterNotesByCategory extends NotesEvent {
  final String categoryId;

  const FilterNotesByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
} 