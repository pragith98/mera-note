import 'package:equatable/equatable.dart';
import '../../models/note.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;
  final String? selectedCategoryId;

  const NotesLoaded({
    required this.notes,
    this.selectedCategoryId,
  });

  @override
  List<Object?> get props => [notes, selectedCategoryId];

  NotesLoaded copyWith({
    List<Note>? notes,
    String? selectedCategoryId,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
} 