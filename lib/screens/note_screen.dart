import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mera_note/services/alert_service.dart';
import 'package:mera_note/widgets/delete_confirmation.dart';
import '../blocs/notes/notes_bloc.dart';
import '../blocs/notes/notes_event.dart';
import '../blocs/categories/categories_bloc.dart';
import '../blocs/categories/categories_state.dart';
import '../models/note.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({super.key, this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _contentController = TextEditingController(text: widget.note?.content);
    _selectedCategoryId = widget.note?.categoryId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => DeleteConfirmation(
            title: 'Delete Note',
            content: 'Are you sure you want to delete this note?',
          ),
    );

    if (mounted && shouldDelete == true) {
      try {
        context.read<NotesBloc>().add(DeleteNoteEvent(widget.note!.id));
        Navigator.popUntil(context, (route) => route.isFirst);
        AlertService.showSuccess(context, "Note deleted");
      } catch (e) {
        AlertService.showError(context, "Failed to delete note");
      }
    }
  }

  void _saveNote() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    final note =
        widget.note?.copyWith(
          title: _titleController.text,
          content: _contentController.text,
          categoryId: _selectedCategoryId,
        ) ??
        Note(
          title: _titleController.text,
          content: _contentController.text,
          categoryId: _selectedCategoryId!,
        );

    if (widget.note == null) {
      context.read<NotesBloc>().add(AddNoteEvent(note));
    } else {
      context.read<NotesBloc>().add(UpdateNoteEvent(note));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
            ),
          IconButton(icon: const Icon(Icons.check), onPressed: _saveNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                if (state is! CategoriesLoadedState) {
                  return const SizedBox.shrink();
                }
                return DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      state.categories.map((category) {
                        return DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
