import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'models/note.dart';
import 'models/category.dart';
import 'blocs/notes/notes_bloc.dart';
import 'blocs/notes/notes_event.dart';
import 'blocs/categories/categories_bloc.dart';
import 'blocs/categories/categories_event.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(CategoryAdapter());
  
  final notesBox = await Hive.openBox<Note>('notes');
  final categoriesBox = await Hive.openBox<Category>('categories');

  runApp(MyApp(
    notesBox: notesBox,
    categoriesBox: categoriesBox,
  ));
}

class MyApp extends StatelessWidget {
  final Box<Note> notesBox;
  final Box<Category> categoriesBox;

  const MyApp({
    super.key,
    required this.notesBox,
    required this.categoriesBox,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotesBloc>(
          create: (context) => NotesBloc(notesBox: notesBox)..add(LoadNotes()),
        ),
        BlocProvider<CategoriesBloc>(
          create: (context) =>
              CategoriesBloc(categoriesBox: categoriesBox)..add(LoadCategories()),
        ),
      ],
      child: MaterialApp(
        title: 'Mera Note',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
