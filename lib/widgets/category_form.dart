import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mera_note/blocs/categories/categories_bloc.dart';
import 'package:mera_note/blocs/categories/categories_event.dart';
import 'package:mera_note/blocs/notes/notes_bloc.dart';
import 'package:mera_note/blocs/notes/notes_state.dart';
import 'package:mera_note/models/category.dart';
import 'package:mera_note/models/note.dart';
import 'package:mera_note/services/alert_service.dart';
import 'package:mera_note/widgets/delete_confirmation.dart';

class CategoryForm extends StatefulWidget {
  final Category? category;
  const CategoryForm({this.category, super.key});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  late TextEditingController _nameController;
  late TextEditingController _colorController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.category?.name);
    _colorController = TextEditingController(text: widget.category?.color);
    super.initState();
  }

  Future<void> _handleDelete(List<Note> notes) async {
    final hasAssociatedNotes = notes.any(
      (note) => note.categoryId == widget.category?.id,
    );

    if (hasAssociatedNotes == true) {
      await showDialog<bool>(
        context: context,
        builder:
            (context) => DeleteConfirmation(
              title: 'Cannot Delete Category',
              content:
                  "The category '${widget.category!.name}' cannot be deleted because it has associated notes.Please reassign or delete the associated notes first.",
              isActionDisabled: true,
            ),
      );
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => DeleteConfirmation(
            title: 'Delete Category',
            content: 'Are you sure you want to delete this category?',
          ),
    );

    if (mounted && shouldDelete == true) {
      try {
        context.read<CategoriesBloc>().add(
          DeleteCategoryEvent(widget.category!.id),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
        AlertService.showSuccess(context, "Category deleted");
      } catch (e) {
        AlertService.showError(context, "Failed to delete category");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              hintText: 'Enter category name',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _colorController,
            decoration: const InputDecoration(
              labelText: 'Color (optional)',
              hintText: 'Enter color hex code',
            ),
          ),
        ],
      ),
      actions: [
        if (widget.category != null)
          TextButton(
            onPressed: () {
              if (context.mounted) {
                final noteState = context.read<NotesBloc>().state;
                if (noteState is NotesLoadedState) {
                  _handleDelete(noteState.notes);
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              if (widget.category == null) {
                context.read<CategoriesBloc>().add(
                  AddCategoryEvent(
                    Category(
                      name: _nameController.text,
                      color:
                          _colorController.text.isNotEmpty
                              ? _colorController.text
                              : null,
                    ),
                  ),
                );
              } else {
                context.read<CategoriesBloc>().add(
                  UpdateCategoryEvent(
                    widget.category!.copyWith(
                      name: _nameController.text,
                      color:
                          _colorController.text.isNotEmpty
                              ? _colorController.text
                              : null,
                    ),
                  ),
                );
              }
              Navigator.pop(context);
            }
          },
          child: Text(widget.category == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
