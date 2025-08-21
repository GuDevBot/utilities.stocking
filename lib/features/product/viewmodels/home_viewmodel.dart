import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stocking/core/services/hive_service.dart';
import 'package:stocking/features/product/models/product_model.dart';

class HomeViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  // Controladores para os filtros
  final TextEditingController nameFilterController = TextEditingController();
  final TextEditingController locationFilterController = TextEditingController();
  final TextEditingController storedByFilterController = TextEditingController();

  DateTime? selectedDate;

  List<Product> get filteredProducts => _filteredProducts;

  HomeViewModel() {
    // Ouvir mudanças na caixa do Hive para atualizar a UI automaticamente
    Hive.box<Product>(HiveService.productBoxName).listenable().addListener(loadProducts);
    loadProducts();
  }

  /// Carrega ou recarrega os produtos do Hive e aplica os filtros atuais.
  void loadProducts() {
    _products = _hiveService.getAllProducts();
    // Inverte a lista para mostrar os mais recentes primeiro
    _products = _products.reversed.toList();
    applyFilters(); 
  }

  Future<void> deleteProduct(Product product) async {
    await _hiveService.deleteProduct(product);
  }

  /// Aplica os filtros com base nos valores dos controladores.
  void applyFilters() {
    _filteredProducts = _products.where((product) {
      final nameMatch = nameFilterController.text.isEmpty ||
          product.name.toLowerCase().contains(nameFilterController.text.toLowerCase());

      final locationMatch = locationFilterController.text.isEmpty ||
          (product.location?.toLowerCase().contains(locationFilterController.text.toLowerCase()) ?? false);

      final storedByMatch = storedByFilterController.text.isEmpty ||
          (product.storedBy?.toLowerCase().contains(storedByFilterController.text.toLowerCase()) ?? false);

      final dateMatch = selectedDate == null ||
          (product.registrationDate.year == selectedDate!.year &&
           product.registrationDate.month == selectedDate!.month &&
           product.registrationDate.day == selectedDate!.day);

      return nameMatch && locationMatch && storedByMatch && dateMatch;
    }).toList();

    notifyListeners();
  }
  
  /// Limpa todos os filtros e recarrega a lista original.
  void clearFilters() {
    nameFilterController.clear();
    locationFilterController.clear();
    storedByFilterController.clear();
    selectedDate = null;
    applyFilters();
  }

  /// Atualiza a data selecionada e reaplica os filtros
  void setFilterDate(DateTime? date) {
    selectedDate = date;
    applyFilters();
  }

  @override
  void dispose() {
    nameFilterController.dispose();
    locationFilterController.dispose();
    storedByFilterController.dispose();
    super.dispose();
  }
}