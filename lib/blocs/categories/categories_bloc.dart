import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mera_note/data/repositories/category_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoryRepository categoryRepository;

  CategoriesBloc({required this.categoryRepository}) : super(CategoriesInitialState()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event, 
    Emitter<CategoriesState> emit
  ) async {
    emit(CategoriesLoadingState());
    try {
      final categories = await categoryRepository.getAll();
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
      await categoryRepository.create(event.category);
      final categories = await categoryRepository.getAll();
      emit(CategoriesLoadedState(categories: categories));
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
      await categoryRepository.update(event.category.id, event.category);
      final categories = await categoryRepository.getAll();
      emit(CategoriesLoadedState(categories: categories));
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
      await categoryRepository.delete(event.categoryId);
      final categories = await categoryRepository.getAll();
      emit(CategoriesLoadedState(categories: categories));
    } catch (e) {
      emit(CategoriesErrorState(e.toString()));
    }
  }
} 