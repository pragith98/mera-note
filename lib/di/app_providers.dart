import 'package:mera_note/data/datasource/hive_datasource.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> getAppProviders() async {
  final dataSource = HiveDatasource();
  await dataSource.init();

  return [
    // Data layer
    Provider<HiveDatasource>.value(value: dataSource),

    // Dispose callback
    Provider<HiveDatasource>(
      create: (_) => dataSource,
      dispose: (_, ds) => ds.close(),
    )
  ];
}