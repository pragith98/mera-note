import '../../models/note.dart';

abstract class NotesEvent {
  const NotesEvent();
}

class LoadNotesEvent extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final Note note;

  const AddNoteEvent(this.note);
}

class UpdateNoteEvent extends NotesEvent {
  final Note note;

  const UpdateNoteEvent(this.note);
}

class DeleteNoteEvent extends NotesEvent {
  final String noteId;

  const DeleteNoteEvent(this.noteId);
}

class FilterNotesByCategoryEvent extends NotesEvent {
  final String categoryId;

  const FilterNotesByCategoryEvent(this.categoryId);
} 