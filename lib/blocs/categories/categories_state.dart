import 'package:equatable/equatable.dart';
import '../../models/category.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];

  CategoriesLoaded copyWith({
    List<Category>? categories,
  }) {
    return CategoriesLoaded(
      categories: categories ?? this.categories,
    );
  }
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object?> get props => [message];
} 