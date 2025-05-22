import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? color;

  Category({
    String? id,
    required this.name,
    this.color,
  }) : id = id ?? const Uuid().v4();

  Category copyWith({
    String? name,
    String? color,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
} 