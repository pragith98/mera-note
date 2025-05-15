import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/note.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final Box<Note> notesBox;

  NotesBloc({required this.notesBox}) : super(NotesInitialState()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<FilterNotesByCategoryEvent>(_onFilterNotesByCategory);
  }

  void _onLoadNotes(
    LoadNotesEvent event, 
    Emitter<NotesState> emit
  ) {
    emit(NotesLoadingState());
    try {
      final notes = notesBox.values.toList();
      emit(NotesLoadedState(notes: notes));
    } catch (e) {
      emit(NotesErrorState(e.toString()));
    }
  }

  void _onAddNote(
    AddNoteEvent event, 
    Emitter<NotesState> emit
  ) async {
    if (state is! NotesLoadedState) return;

    try {
      await notesBox.put(event.note.id, event.note);
      emit(NotesLoadedState(notes: notesBox.values.toList()));
    } catch (e) {
      emit(NotesErrorState(e.toString()));
    }
  }

  void _onUpdateNote(
    UpdateNoteEvent event, 
    Emitter<NotesState> emit
  ) async {
    if (state is! NotesLoadedState) return;

    try {
      await notesBox.put(event.note.id, event.note);
      emit(NotesLoadedState(notes: notesBox.values.toList()));
    } catch (e) {
      emit(NotesErrorState(e.toString()));
    }
  }

  void _onDeleteNote(
    DeleteNoteEvent event, 
    Emitter<NotesState> emit
  ) async {
    if (state is! NotesLoadedState) return;

    try {
      await notesBox.delete(event.noteId);
      emit(NotesLoadedState(notes: notesBox.values.toList()));
    } catch (e) {
      emit(NotesErrorState(e.toString()));
    }
  }

  void _onFilterNotesByCategory(
    FilterNotesByCategoryEvent event, 
    Emitter<NotesState> emit
  ) {
    if (state is! NotesLoadedState) return;

    final filteredNotes = event.categoryId.isEmpty
        ? notesBox.values.toList()
        : notesBox.values
            .where((note) => note.categoryId == event.categoryId)
            .toList();
    emit(NotesLoadedState(
      notes: filteredNotes,
      selectedCategoryId: event.categoryId,
    ));
  }
} 