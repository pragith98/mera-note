import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/category.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final Box<Category> categoriesBox;

  CategoriesBloc({required this.categoriesBox}) : super(CategoriesInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  void _onLoadCategories(LoadCategories event, Emitter<CategoriesState> emit) {
    emit(CategoriesLoading());
    try {
      final categories = categoriesBox.values.toList();
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void _onAddCategory(AddCategory event, Emitter<CategoriesState> emit) async {
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      try {
        await categoriesBox.put(event.category.id, event.category);
        emit(CategoriesLoaded(categories: categoriesBox.values.toList()));
      } catch (e) {
        emit(CategoriesError(e.toString()));
      }
    }
  }

  void _onUpdateCategory(
      UpdateCategory event, Emitter<CategoriesState> emit) async {
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      try {
        await categoriesBox.put(event.category.id, event.category);
        emit(CategoriesLoaded(categories: categoriesBox.values.toList()));
      } catch (e) {
        emit(CategoriesError(e.toString()));
      }
    }
  }

  void _onDeleteCategory(
      DeleteCategory event, Emitter<CategoriesState> emit) async {
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      try {
        await categoriesBox.delete(event.categoryId);
        emit(CategoriesLoaded(categories: categoriesBox.values.toList()));
      } catch (e) {
        emit(CategoriesError(e.toString()));
      }
    }
  }
} 