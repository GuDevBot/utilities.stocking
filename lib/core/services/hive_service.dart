import 'package:stocking/features/product/models/product_model.dart';
import 'package:hive/hive.dart';

class HiveService {
  static const String productBoxName = 'products';

  final Box<Product> _productBox = Hive.box<Product>(productBoxName);

  Future<void> addProduct(Product product) async {
    await _productBox.add(product);
  }

  List<Product> getAllProducts() {
    return _productBox.values.toList();
  }

  Future<void> deleteProduct(Product product) async {
    await product.delete();
  }
}