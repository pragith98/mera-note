import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/notes/notes_bloc.dart';
import '../blocs/notes/notes_state.dart';
import '../blocs/notes/notes_event.dart';
import '../blocs/categories/categories_bloc.dart';
import '../blocs/categories/categories_state.dart';
import '../blocs/categories/categories_event.dart';
import '../models/note.dart';
import '../models/category.dart';
import 'note_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mera Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => _showCategoryDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(context),
          Expanded(
            child: _buildNotesList(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: context.read<NotesBloc>(),
                ),
                BlocProvider.value(
                  value: context.read<CategoriesBloc>(),
                ),
              ],
              child: const NoteScreen(),
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: context.watch<NotesBloc>().state is NotesLoaded &&
                      (context.watch<NotesBloc>().state as NotesLoaded)
                          .selectedCategoryId ==
                          null,
                  onSelected: (_) => context
                      .read<NotesBloc>()
                      .add(const FilterNotesByCategory('')),
                ),
                const SizedBox(width: 8),
                ...state.categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(category.name),
                      selected: context.watch<NotesBloc>().state is NotesLoaded &&
                          (context.watch<NotesBloc>().state as NotesLoaded)
                              .selectedCategoryId ==
                              category.id,
                      onSelected: (_) => context
                          .read<NotesBloc>()
                          .add(FilterNotesByCategory(category.id)),
                      onDeleted: () => _showCategoryDialog(context, category),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNotesList(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NotesLoaded) {
          if (state.notes.isEmpty) {
            return const Center(
              child: Text('No notes yet. Create one by tapping the + button.'),
            );
          }
          return ListView.builder(
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return _buildNoteCard(context, note);
            },
          );
        } else if (state is NotesError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          _formatDate(note.updatedAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: context.read<NotesBloc>(),
                ),
                BlocProvider.value(
                  value: context.read<CategoriesBloc>(),
                ),
              ],
              child: NoteScreen(note: note),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    Category category,
    List<Note> notes,
  ) async {
    final hasAssociatedNotes = notes.any((note) => note.categoryId == category.id);

    if (hasAssociatedNotes) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cannot Delete Category'),
          content: Text(
            'The category "${category.name}" cannot be deleted because it has associated notes. '
            'Please reassign or delete the associated notes first.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (context.mounted) {
        context.read<CategoriesBloc>().add(DeleteCategory(category.id));
        Navigator.pop(context); // Close the edit dialog
      }
    }
  }

  Future<void> _showCategoryDialog(BuildContext context, [Category? category]) async {
    final TextEditingController controller = TextEditingController(text: category?.name);
    final TextEditingController colorController = TextEditingController(text: category?.color);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'Enter category name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(
                labelText: 'Color (optional)',
                hintText: 'Enter color hex code',
              ),
            ),
          ],
        ),
        actions: [
          if (category != null)
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  final notesState = context.read<NotesBloc>().state;
                  if (notesState is NotesLoaded) {
                    _showDeleteConfirmation(context, category, notesState.notes);
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
              if (controller.text.isNotEmpty) {
                if (category == null) {
                  context.read<CategoriesBloc>().add(
                        AddCategory(
                          Category(
                            name: controller.text,
                            color: colorController.text.isNotEmpty
                                ? colorController.text
                                : null,
                          ),
                        ),
                      );
                } else {
                  context.read<CategoriesBloc>().add(
                        UpdateCategory(
                          category.copyWith(
                            name: controller.text,
                            color: colorController.text.isNotEmpty
                                ? colorController.text
                                : null,
                          ),
                        ),
                      );
                }
                Navigator.pop(context);
              }
            },
            child: Text(category == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }
} 