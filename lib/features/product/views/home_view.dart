import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocking/features/product/models/product_model.dart';
import 'package:stocking/features/product/viewmodels/home_viewmodel.dart';
import 'package:stocking/features/product/views/register_product_view.dart';
import 'package:stocking/features/product/views/widgets/filter_bottom_sheet.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // Função para mostrar o diálogo de confirmação
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
          title: const Text('Confirmar Exclusão'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Você tem certeza que deseja excluir o produto "${product.name}"?',
                ),
                const Text('Esta ação não pode ser desfeita.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Estoque de Produtos'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // Mostra o modal de filtro
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => FilterBottomSheet(viewModel: viewModel),
                  );
                },
              ),
            ],
          ),
          body: viewModel.filteredProducts.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum produto cadastrado ou encontrado.',
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
                              Text('Local: ${product.location}'),
                            if (product.storedBy != null && product.storedBy!.isNotEmpty)
                              Text('Por: ${product.storedBy}'),
                            Text(
                              'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(product.registrationDate)}',
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterProductView()),
              );
            },
            tooltip: 'Adicionar Produto',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
