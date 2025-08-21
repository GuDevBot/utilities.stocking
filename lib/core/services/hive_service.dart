import 'package:stocking/features/product/models/product_model.dart';
import 'package:hive/hive.dart';

class HiveService {
  // Nome da nossa "caixa" (box) para ser usado em todo o app
  static const String productBoxName = 'products';

  final Box<Product> _productBox = Hive.box<Product>(productBoxName);

  // Adiciona um novo produto ao banco de dados Hive.
  Future<void> addProduct(Product product) async {
    await _productBox.add(product);
  }

  /// Retorna uma lista de todos os produtos armazenados.
  List<Product> getAllProducts() {
    return _productBox.values.toList();
  }

  /// Deleta um produto.
  Future<void> deleteProduct(Product product) async {
    await product.delete();
  }
}