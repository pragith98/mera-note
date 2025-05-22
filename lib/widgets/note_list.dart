import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mera_note/blocs/notes/notes_bloc.dart';
import 'package:mera_note/blocs/notes/notes_event.dart';
import 'package:mera_note/blocs/notes/notes_state.dart';
import 'package:mera_note/widgets/note_card.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(LoadNotesEvent());
  }

  Future onRefresh() async {
    context.read<NotesBloc>().add(LoadNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } 
        
        if (state is NotesLoadedState) {
          if (state.notes.isEmpty) {
            return const Center(
              child: Text('No notes yet. Create one by tapping the + button.'),
            );
          }
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return NoteCard(note: note);
              },
            ),
          );
        }
        
        if (state is NotesErrorState) {
          return Center(child: Text(state.message));
        }
        
        return const SizedBox.shrink();
      },
    );
  }
}