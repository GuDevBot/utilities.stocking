import 'package:stocking/core/services/hive_service.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class RegisterProductViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController storedByController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  List<String> productNameSuggestions = [];
  List<String> locationSuggestions = [];
  List<String> storedBySuggestions = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  RegisterProductViewModel() {
    _loadSuggestions();
  }
  
  void _loadSuggestions() {
    final allProducts = _hiveService.getAllProducts();

    // Use sets to avoid duplicate suggestions
    final nameSet = <String>{};
    final locationSet = <String>{};
    final storedBySet = <String>{};

    for (var product in allProducts) {
      nameSet.add(product.name);
      if (product.location != null && product.location!.isNotEmpty) {
        locationSet.add(product.location!);
      }
      if (product.storedBy != null && product.storedBy!.isNotEmpty) {
        storedBySet.add(product.storedBy!);
      }
    }

    productNameSuggestions = nameSet.toList();
    locationSuggestions = locationSet.toList();
    storedBySuggestions = storedBySet.toList();
  }
  
  Future<bool> saveProduct() async {
    _errorMessage = null;

    if (nameController.text.isEmpty) {
      _errorMessage = "Product name is required";
      notifyListeners();
      return false;
    }
    if (quantityController.text.isEmpty) {
      _errorMessage = "Quantity is required";
      notifyListeners();
      return false;
    }
    
    final quantity = int.tryParse(quantityController.text);
    if (quantity == null || quantity <= 0) {
      _errorMessage = "Please, enter a valid quantity (number greater than zero).";
      notifyListeners();
      return false;
    }

    _setLoading(true);

    final newProduct = Product(
      name: nameController.text,
      quantity: quantity,
      location: locationController.text.isNotEmpty ? locationController.text : null,
      storedBy: storedByController.text.isNotEmpty ? storedByController.text : null,
    );

    try {
      await _hiveService.addProduct(newProduct);
      clearFields();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = "Erro saving product: $e";
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  void clearFields() {
    nameController.clear();
    locationController.clear();
    storedByController.clear();
    quantityController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    storedByController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}