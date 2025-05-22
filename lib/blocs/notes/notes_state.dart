import 'package:equatable/equatable.dart';
import '../../data/models/note.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitialState extends NotesState {}

class NotesLoadingState extends NotesState {}

class NotesLoadedState extends NotesState {
  final List<Note> notes;
  final String? selectedCategoryId;

  const NotesLoadedState({
    required this.notes,
    this.selectedCategoryId,
  });

  @override
  List<Object?> get props => [notes, selectedCategoryId];

  NotesLoadedState copyWith({
    List<Note>? notes,
    String? selectedCategoryId,
  }) {
    return NotesLoadedState(
      notes: notes ?? this.notes,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class NotesErrorState extends NotesState {
  final String message;

  const NotesErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 