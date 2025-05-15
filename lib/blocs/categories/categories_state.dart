import 'package:equatable/equatable.dart';
import '../../models/category.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitialState extends CategoriesState { }

class CategoriesLoadingState extends CategoriesState { }

class CategoriesLoadedState extends CategoriesState {
  final List<Category> categories;

  const CategoriesLoadedState({required this.categories});

  @override
  List<Object?> get props => [categories];

  CategoriesLoadedState copyWith({
    List<Category>? categories,
  }) {
    return CategoriesLoadedState(
      categories: categories ?? this.categories,
    );
  }
}

class CategoriesErrorState extends CategoriesState {
  final String message;

  const CategoriesErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 