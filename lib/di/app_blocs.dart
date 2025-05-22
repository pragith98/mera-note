import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mera_note/blocs/categories/categories_bloc.dart';
import 'package:mera_note/blocs/notes/notes_bloc.dart';
import 'package:mera_note/data/datasource/hive_datasource.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getAppBlocs(BuildContext context) {
  return [
    BlocProvider(
      create: (context) => CategoriesBloc(
        categoryRepository: context.read<HiveDatasource>().categories
      ),
      lazy: false,
    ),
    BlocProvider(
      create: (context) => NotesBloc(
        noteRepository: context.read<HiveDatasource>().notes
      ),
      lazy: false,
    ),
  ];
}