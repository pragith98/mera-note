import 'package:hive_flutter/hive_flutter.dart';
import 'package:mera_note/data/models/category.dart';
import 'package:mera_note/data/models/note.dart';
import 'package:mera_note/data/repositories/category_repository.dart';
import 'package:mera_note/data/repositories/note_repository.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatasource {
  NoteRepository? _notes;
  CategoryRepository? _categories;

  NoteRepository get notes {
    if (_notes == null) {
      throw StateError('HiveDatasource not initialized. Call init() first.');
    }
    return _notes!;
  }

  CategoryRepository get categories {
    if (_categories == null) {
      throw StateError('HiveDatasource not initialized. Call init() first.');
    }
    return _categories!;
  }

  static const String _notesBoxName = 'notes';
  static const String _categoriesBoxName = 'categories';

  static Future<void> initializeHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(CategoryAdapter());
  }

  Future<void> init() async {
    try {
      final notesBox = await _notesBox;
      final categoriesBox = await _categoriesBox;
      _notes = NoteRepository(notesBox: notesBox);
      _categories = CategoryRepository(categoriesBox: categoriesBox);
    } catch (e) {
      throw Exception('Failed to initialize HiveDatasource: $e');
    }
  }

  Future<Box<Note>> get _notesBox async {
    if (!Hive.isBoxOpen(_notesBoxName)) {
      return await Hive.openBox<Note>(_notesBoxName);
    }
    return Hive.box<Note>(_notesBoxName);
  }

  Future<Box<Category>> get _categoriesBox async {
    if (!Hive.isBoxOpen(_categoriesBoxName)) {
      return await Hive.openBox<Category>(_categoriesBoxName);
    }
    return Hive.box<Category>(_categoriesBoxName);
  }

  Future<void> close() async {
    if (Hive.isBoxOpen(_notesBoxName)) {
      await Hive.box<Note>(_notesBoxName).close();
    }
    if (Hive.isBoxOpen(_categoriesBoxName)) {
      await Hive.box<Category>(_categoriesBoxName).close();
    }
  }
}