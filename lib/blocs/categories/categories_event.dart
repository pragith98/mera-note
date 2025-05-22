import '../../data/models/category.dart';

abstract class CategoriesEvent { }

class LoadCategories extends CategoriesEvent {}

class AddCategoryEvent extends CategoriesEvent {
  final Category category;
  AddCategoryEvent(this.category);
}

class UpdateCategoryEvent extends CategoriesEvent {
  final Category category;
  UpdateCategoryEvent(this.category);
}

class DeleteCategoryEvent extends CategoriesEvent {
  final String categoryId;
  DeleteCategoryEvent(this.categoryId);
}