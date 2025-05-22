import 'package:hive/hive.dart';
import 'package:mera_note/data/models/category.dart';

class CategoryRepository {
  final Box<Category> categoriesBox;

  CategoryRepository({required this.categoriesBox});

  Future<List<Category>> getAll() async {
    try {
      return categoriesBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  Future<void> create(Category category) async {
    try {
      await categoriesBox.put(category.id, category);
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  Future<void> update(String id, Category category) async {
    try {
      await categoriesBox.put(id, category);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await categoriesBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}