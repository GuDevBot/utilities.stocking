import '../viewmodels/register_product_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterProductView extends StatelessWidget {
  const RegisterProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProductViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Register Product'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Product Name *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return viewModel.productNameSuggestions.where((
                      String option,
                    ) {
                      return option.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                    });
                  },
                  onSelected: (String selection) {
                    viewModel.nameController.text = selection;
                  },
                  fieldViewBuilder:
                      (
                        BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        // Sincroniza o valor inicial ou quando o campo é limpo
                        Future.microtask(
                          () => fieldTextEditingController.text =
                              viewModel.nameController.text,
                        );

                        return TextField(
                          controller:
                              fieldTextEditingController, // Usar o controller do Autocomplete
                          focusNode: fieldFocusNode,
                          decoration: const InputDecoration(
                            hintText: 'Ex: M8 Hex Screw',
                          ),
                          // Sincronizar de volta para a ViewModel
                          onChanged: (String value) {
                            viewModel.nameController.text = value;
                          },
                        );
                      },
                ),
                const SizedBox(height: 24),

                const Text(
                  'Quantity *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: viewModel.quantityController,
                  decoration: const InputDecoration(hintText: 'Ex: 100'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 24),

                const Text(
                  'Storage Location (Optional)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return viewModel.locationSuggestions.where((String option) {
                      return option.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                    });
                  },
                  onSelected: (String selection) {
                    viewModel.locationController.text = selection;
                  },
                  fieldViewBuilder:
                      (
                        BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        Future.microtask(
                          () => fieldTextEditingController.text =
                              viewModel.locationController.text,
                        );
                        return TextField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          decoration: const InputDecoration(
                            hintText: 'Ex: Shelf A-02, Box 15',
                          ),
                          onChanged: (String value) {
                            viewModel.locationController.text = value;
                          },
                        );
                      },
                ),
                const SizedBox(height: 24),

                const Text(
                  'Storage by (Optional)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return viewModel.storedBySuggestions.where((String option) {
                      return option.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                    });
                  },
                  onSelected: (String selection) {
                    viewModel.storedByController.text = selection;
                  },
                  fieldViewBuilder:
                      (
                        BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        Future.microtask(
                          () => fieldTextEditingController.text =
                              viewModel.storedByController.text,
                        );
                        return TextField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          decoration: const InputDecoration(
                            hintText: 'Ex: Thomas Edison',
                          ),
                          onChanged: (String value) {
                            viewModel.storedByController.text = value;
                          },
                        );
                      },
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          final success = await viewModel.saveProduct();
                          if (!context.mounted) return;
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product saved successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          } else if (viewModel.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(viewModel.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Product',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}