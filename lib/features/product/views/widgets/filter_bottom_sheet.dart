import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocking/features/product/viewmodels/home_viewmodel.dart';

class FilterBottomSheet extends StatefulWidget {
  final HomeViewModel viewModel;

  const FilterBottomSheet({super.key, required this.viewModel});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.viewModel.selectedDate ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    
    if (picked != null && picked != widget.viewModel.selectedDate) {
        widget.viewModel.setFilterDate(picked);
        // Atualiza a UI localmente para mostrar a data
        setState(() {}); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Filtrar Produtos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            TextField(
                controller: widget.viewModel.nameFilterController,
                decoration: const InputDecoration(labelText: 'Nome do produto')),
            const SizedBox(height: 16),

            TextField(
                controller: widget.viewModel.locationFilterController,
                decoration: const InputDecoration(labelText: 'Local de armazenagem')),
            const SizedBox(height: 16),
            
            TextField(
                controller: widget.viewModel.storedByFilterController,
                decoration: const InputDecoration(labelText: 'Armazenado por')),
            const SizedBox(height: 16),
            
            // Campo de Data
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Data de registro',
                border: OutlineInputBorder(),
              ),
              child: InkWell(
                onTap: () => _selectDate(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.viewModel.selectedDate == null
                          ? 'Selecione uma data'
                          : DateFormat('dd/MM/yyyy').format(widget.viewModel.selectedDate!),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      widget.viewModel.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Limpar Filtros'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.viewModel.applyFilters();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}