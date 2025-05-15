import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/category.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final Box<Category> categoriesBox;

  CategoriesBloc({required this.categoriesBox}) : super(CategoriesInitialState()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  void _onLoadCategories(
    LoadCategories event, 
    Emitter<CategoriesState> emit
  ) {
    emit(CategoriesLoadingState());
    try {
      final categories = categoriesBox.values.toList();
      emit(CategoriesLoadedState(categories: categories));
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }

  void _onAddCategory(
    AddCategoryEvent event, 
    Emitter<CategoriesState> emit
  ) async {
    if (state is! CategoriesLoadedState) return;
    
    try {
      await categoriesBox.put(event.category.id, event.category);
      emit(CategoriesLoadedState(categories: categoriesBox.values.toList()));
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }

  void _onUpdateCategory(
    UpdateCategoryEvent event, 
    Emitter<CategoriesState> emit
  ) async {
    if (state is! CategoriesLoadedState) return;

    try {
      await categoriesBox.put(event.category.id, event.category);
      emit(CategoriesLoadedState(categories: categoriesBox.values.toList()));
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }

  void _onDeleteCategory(
    DeleteCategoryEvent event, 
    Emitter<CategoriesState> emit
  ) async {
    if (state is! CategoriesLoadedState) return;
    
    try {
      await categoriesBox.delete(event.categoryId);
      emit(CategoriesLoadedState(categories: categoriesBox.values.toList()));
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }
} 