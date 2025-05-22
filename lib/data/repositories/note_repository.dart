import 'package:hive/hive.dart';
import 'package:mera_note/data/models/note.dart';

class NoteRepository {
  final Box<Note> notesBox;

  NoteRepository({required this.notesBox});

  Future<List<Note>> getAll() async {
    try {
      return notesBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get notes: $e');
    }
  }

  Future<void> create(Note note) async {
    try {
      await notesBox.put(note.id, note);
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  Future<void> update(String id, Note note) async {
    try {
      await notesBox.put(id, note);
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await notesBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  Future<List<Note>> filterByCategory(String categoryId) async {
    try {
      return categoryId.isEmpty
        ? notesBox.values.toList()
        : notesBox.values
          .where((note) => note.categoryId == categoryId)
          .toList();
    } catch (e) {
      throw Exception('Failed to get notes: $e');
    }
  }
}