import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/note.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final Box<Note> notesBox;

  NotesBloc({required this.notesBox}) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<FilterNotesByCategory>(_onFilterNotesByCategory);
  }

  void _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) {
    emit(NotesLoading());
    try {
      final notes = notesBox.values.toList();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  void _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      try {
        await notesBox.put(event.note.id, event.note);
        emit(NotesLoaded(
          notes: notesBox.values.toList(),
          selectedCategoryId: currentState.selectedCategoryId,
        ));
      } catch (e) {
        emit(NotesError(e.toString()));
      }
    }
  }

  void _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      try {
        await notesBox.put(event.note.id, event.note);
        emit(NotesLoaded(
          notes: notesBox.values.toList(),
          selectedCategoryId: currentState.selectedCategoryId,
        ));
      } catch (e) {
        emit(NotesError(e.toString()));
      }
    }
  }

  void _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      try {
        await notesBox.delete(event.noteId);
        emit(NotesLoaded(
          notes: notesBox.values.toList(),
          selectedCategoryId: currentState.selectedCategoryId,
        ));
      } catch (e) {
        emit(NotesError(e.toString()));
      }
    }
  }

  void _onFilterNotesByCategory(
      FilterNotesByCategory event, Emitter<NotesState> emit) {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final filteredNotes = event.categoryId.isEmpty
          ? notesBox.values.toList()
          : notesBox.values
              .where((note) => note.categoryId == event.categoryId)
              .toList();
      emit(NotesLoaded(
        notes: filteredNotes,
        selectedCategoryId: event.categoryId,
      ));
    }
  }
} 