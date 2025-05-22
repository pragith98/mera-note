import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mera_note/data/repositories/note_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository noteRepository;

  NotesBloc({required this.noteRepository}) : super(NotesInitialState()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<FilterNotesByCategoryEvent>(_onFilterNotesByCategory);
  }

  Future<void> _onLoadNotes(
    LoadNotesEvent event, 
    Emitter<NotesState> emit
  ) async {
    emit(NotesLoadingState());
    try {
      final notes = await noteRepository.getAll();
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
      await noteRepository.create(event.note);
      final notes = await noteRepository.getAll();
      emit(NotesLoadedState(notes: notes));
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
      await noteRepository.update(event.note.id, event.note);
      final notes = await noteRepository.getAll();
      emit(NotesLoadedState(notes: notes));
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
      await noteRepository.delete(event.noteId);
      final notes = await noteRepository.getAll();
      emit(NotesLoadedState(notes: notes));
    } catch (e) {
      emit(NotesErrorState(e.toString()));
    }
  }

  Future<void> _onFilterNotesByCategory(
    FilterNotesByCategoryEvent event, 
    Emitter<NotesState> emit
  ) async {
    if (state is! NotesLoadedState) return;

    final filteredNotes = await noteRepository.filterByCategory(event.categoryId);
    emit(NotesLoadedState(
      notes: filteredNotes,
      selectedCategoryId: event.categoryId,
    ));
  }
} 