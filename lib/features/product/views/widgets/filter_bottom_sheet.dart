import 'package:stocking/features/product/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != widget.viewModel.selectedDate) {
      widget.viewModel.setFilterDate(picked);
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
            const Text(
              'Filter Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue value) {
                if (value.text.isEmpty) return const Iterable.empty();
                return widget.viewModel.productNameSuggestions.where(
                  (s) => s.toLowerCase().contains(value.text.toLowerCase()),
                );
              },
              onSelected: (selection) =>
                  widget.viewModel.nameFilterController.text = selection,
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (value) =>
                      widget.viewModel.nameFilterController.text = value,
                  decoration: const InputDecoration(labelText: 'Product name'),
                );
              },
            ),
            const SizedBox(height: 16),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue value) {
                if (value.text.isEmpty) return const Iterable.empty();
                return widget.viewModel.locationSuggestions.where(
                  (s) => s.toLowerCase().contains(value.text.toLowerCase()),
                );
              },
              onSelected: (selection) =>
                  widget.viewModel.locationFilterController.text = selection,
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (value) =>
                      widget.viewModel.locationFilterController.text = value,
                  decoration: const InputDecoration(
                    labelText: 'Storage location',
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue value) {
                if (value.text.isEmpty) return const Iterable.empty();
                return widget.viewModel.storedBySuggestions.where(
                  (s) => s.toLowerCase().contains(value.text.toLowerCase()),
                );
              },
              onSelected: (selection) =>
                  widget.viewModel.storedByFilterController.text = selection,
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (value) =>
                      widget.viewModel.storedByFilterController.text = value,
                  decoration: const InputDecoration(labelText: 'Stored by'),
                );
              },
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Register date',
                border: OutlineInputBorder(),
              ),
              child: InkWell(
                onTap: () => _selectDate(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.viewModel.selectedDate == null
                          ? 'Select a date'
                          : DateFormat(
                              'dd/MM/yyyy',
                            ).format(widget.viewModel.selectedDate!),
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
                    child: const Text('Clean Filters'),
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
                    child: const Text('Apply'),
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