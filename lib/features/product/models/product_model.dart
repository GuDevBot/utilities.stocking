import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  String? location;

  @HiveField(2)
  String? storedBy;

  @HiveField(3)
  late DateTime registrationDate;
  
  // Novo campo obrigatório
  @HiveField(4)
  late int quantity;

  Product({
    required this.name,
    required this.quantity, // Adicionado ao construtor
    this.location,
    this.storedBy,
  }) {
    registrationDate = DateTime.now();
  }
}