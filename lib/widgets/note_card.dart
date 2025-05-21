import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mera_note/blocs/categories/categories_bloc.dart';
import 'package:mera_note/blocs/notes/notes_bloc.dart';
import 'package:mera_note/models/note.dart';
import 'package:mera_note/screens/note_screen.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          _formatDate(note.updatedAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<NotesBloc>()),
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
}
