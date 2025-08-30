import 'package:stocking/features/product/views/widgets/filter_bottom_sheet.dart';
import 'package:stocking/features/product/views/register_product_view.dart';
import 'package:stocking/features/product/viewmodels/home_viewmodel.dart';
import 'package:stocking/features/product/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../enums/sort_option.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // Function to show the delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    HomeViewModel viewModel,
    Product product,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Do you have sure you want to delet the "${product.name}" product?',
                ),
                const Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                viewModel.deleteProduct(product);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getSortOptionText(SortOption option) {
    switch (option) {
      case SortOption.dateNewest: return 'Date (Most Recent)';
      case SortOption.dateOldest: return 'Date (Oldest)';
      case SortOption.nameAZ: return 'Name (A-Z)';
      case SortOption.nameZA: return 'Name (Z-A)';
      case SortOption.locationAZ: return 'Place (A-Z)';
      case SortOption.locationZA: return 'Place (Z-A)';
      case SortOption.storedByAZ: return 'Stored by (A-Z)';
      case SortOption.storedByZA: return 'Stored by (Z-A)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Products'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => FilterBottomSheet(viewModel: viewModel),
                  );
                },
              ),
              PopupMenuButton<SortOption>(
                icon: const Icon(Icons.sort),
                onSelected: (SortOption result) {
                  viewModel.changeSortOrder(result);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
                  for (var option in SortOption.values)
                    PopupMenuItem<SortOption>(
                      value: option,
                      child: Text(_getSortOptionText(option)),
                    ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Sorted by: ${_getSortOptionText(viewModel.currentSortOption)}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              Expanded(
                child: viewModel.filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No products registered or found.',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: viewModel.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = viewModel.filteredProducts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  product.quantity.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                product.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.location != null && product.location!.isNotEmpty)
                                    Text('Place: ${product.location}'),
                                  if (product.storedBy != null && product.storedBy!.isNotEmpty)
                                    Text('By: ${product.storedBy}'),
                                  Text(
                                    'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(product.registrationDate)}',
                                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                    context,
                                    viewModel,
                                    product,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterProductView()),
              );
            },
            tooltip: 'Add Produto',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}