import 'package:stocking/features/product/models/product_model.dart';
import 'package:stocking/core/services/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import '../enums/sort_option.dart';

class HomeViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  // AutoComplete sugestions list
  List<String> productNameSuggestions = [];
  List<String> locationSuggestions = [];
  List<String> storedBySuggestions = [];

  final TextEditingController nameFilterController = TextEditingController();
  final TextEditingController locationFilterController =
      TextEditingController();
  final TextEditingController storedByFilterController =
      TextEditingController();
  DateTime? selectedDate;

  // Variable to hold the current sort option
  SortOption _currentSortOption = SortOption.dateNewest;
  SortOption get currentSortOption => _currentSortOption;

  List<Product> get filteredProducts => _filteredProducts;

  HomeViewModel() {
    Hive.box<Product>(
      HiveService.productBoxName,
    ).listenable().addListener(_processProducts);
    _loadSuggestions();
    _processProducts();
  }

  void _loadSuggestions() {
    final allProducts = _hiveService.getAllProducts();
    productNameSuggestions = allProducts.map((p) => p.name).toSet().toList();
    locationSuggestions = allProducts
        .where((p) => p.location != null)
        .map((p) => p.location!)
        .toSet()
        .toList();
    storedBySuggestions = allProducts
        .where((p) => p.storedBy != null)
        .map((p) => p.storedBy!)
        .toSet()
        .toList();
  }

  void _processProducts() {
    _products = _hiveService.getAllProducts();

    // 1. Apply Filters
    var tempProducts = _products.where((product) {
      final nameMatch =
          nameFilterController.text.isEmpty ||
          product.name.toLowerCase().contains(
            nameFilterController.text.toLowerCase(),
          );
      final locationMatch =
          locationFilterController.text.isEmpty ||
          (product.location?.toLowerCase().contains(
                locationFilterController.text.toLowerCase(),
              ) ??
              false);
      final storedByMatch =
          storedByFilterController.text.isEmpty ||
          (product.storedBy?.toLowerCase().contains(
                storedByFilterController.text.toLowerCase(),
              ) ??
              false);
      final dateMatch =
          selectedDate == null ||
          (product.registrationDate.year == selectedDate!.year &&
              product.registrationDate.month == selectedDate!.month &&
              product.registrationDate.day == selectedDate!.day);
      return nameMatch && locationMatch && storedByMatch && dateMatch;
    }).toList();

    // 2. Apply Sorting
    switch (_currentSortOption) {
      case SortOption.dateNewest:
        tempProducts.sort(
          (a, b) => b.registrationDate.compareTo(a.registrationDate),
        );
        break;
      case SortOption.dateOldest:
        tempProducts.sort(
          (a, b) => a.registrationDate.compareTo(b.registrationDate),
        );
        break;
      case SortOption.nameAZ:
        tempProducts.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case SortOption.nameZA:
        tempProducts.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;
      case SortOption.locationAZ:
        tempProducts.sort(
          (a, b) => (a.location ?? '').toLowerCase().compareTo(
            (b.location ?? '').toLowerCase(),
          ),
        );
        break;
      case SortOption.locationZA:
        tempProducts.sort(
          (a, b) => (b.location ?? '').toLowerCase().compareTo(
            (a.location ?? '').toLowerCase(),
          ),
        );
        break;
      case SortOption.storedByAZ:
        tempProducts.sort(
          (a, b) => (a.storedBy ?? '').toLowerCase().compareTo(
            (b.storedBy ?? '').toLowerCase(),
          ),
        );
        break;
      case SortOption.storedByZA:
        tempProducts.sort(
          (a, b) => (b.storedBy ?? '').toLowerCase().compareTo(
            (a.storedBy ?? '').toLowerCase(),
          ),
        );
        break;
    }

    _filteredProducts = tempProducts;
    notifyListeners();
  }

  void changeSortOrder(SortOption option) {
    _currentSortOption = option;
    _processProducts();
  }

  void applyFilters() {
    _processProducts();
  }

  void clearFilters() {
    nameFilterController.clear();
    locationFilterController.clear();
    storedByFilterController.clear();
    selectedDate = null;
    _processProducts();
  }

  void setFilterDate(DateTime? date) {
    selectedDate = date;
    _processProducts();
  }

  Future<void> deleteProduct(Product product) async {
    await _hiveService.deleteProduct(product);
  }

  @override
  void dispose() {
    Hive.box<Product>(
      HiveService.productBoxName,
    ).listenable().removeListener(_processProducts);
    nameFilterController.dispose();
    locationFilterController.dispose();
    storedByFilterController.dispose();
    super.dispose();
  }
}