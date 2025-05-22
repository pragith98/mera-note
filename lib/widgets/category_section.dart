import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mera_note/blocs/categories/categories_bloc.dart';
import 'package:mera_note/blocs/categories/categories_state.dart';
import 'package:mera_note/blocs/notes/notes_bloc.dart';
import 'package:mera_note/blocs/notes/notes_event.dart';
import 'package:mera_note/blocs/notes/notes_state.dart';
import 'package:mera_note/helpers/hex_color_helper.dart';
import 'package:mera_note/data/models/category.dart';
import 'package:mera_note/widgets/category_form.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  Future<void> _showCategoryDialog(
    BuildContext context,
    Category category,
  ) async {
    showDialog<bool>(
      context: context,
      builder: (context) => CategoryForm(category: category),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is! CategoriesLoadedState) {
          return const SizedBox.shrink();
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected:
                    context.watch<NotesBloc>().state is NotesLoadedState &&
                    (context.watch<NotesBloc>().state as NotesLoadedState)
                            .selectedCategoryId ==
                        null,
                onSelected:
                    (_) => context.read<NotesBloc>().add(
                      const FilterNotesByCategoryEvent(''),
                    ),
              ),
              const SizedBox(width: 8),
              ...state.categories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category.name),
                    deleteIconColor: HexColorHelper(category.color.toString()),
                    deleteIcon: Icon(Icons.tour_sharp),
                    selected:
                        context.watch<NotesBloc>().state is NotesLoadedState &&
                        (context.watch<NotesBloc>().state as NotesLoadedState)
                                .selectedCategoryId ==
                            category.id,
                    onSelected:
                        (_) => context.read<NotesBloc>().add(
                          FilterNotesByCategoryEvent(category.id),
                        ),
                    onDeleted: () => _showCategoryDialog(context, category),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
