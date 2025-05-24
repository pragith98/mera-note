import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mera_note/widgets/adsterra_banner_ad.dart';
import 'package:mera_note/widgets/category_form.dart';
import 'package:mera_note/widgets/category_section.dart';
import 'package:mera_note/widgets/network_aware.dart';
import 'package:mera_note/widgets/note_list.dart';
import '../blocs/notes/notes_bloc.dart';
import '../blocs/categories/categories_bloc.dart';
import 'note_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _showCategoryDialog(BuildContext context) async {
    showDialog<bool>(context: context, builder: (context) => CategoryForm());
  }

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
          CategorySection(),
          Expanded(child: NoteList()),
          NetworkAware(onlineChild: AdsterraBannerAd())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
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
                      child: const NoteScreen(),
                    ),
              ),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
