import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

import '../view_model/computed_demo_view_model.dart';

class LxComputedDemoView extends LazxView<ComputedDemoViewModel> {
  @override
  ComputedDemoViewModel getViewModel() => ComputedDemoViewModel();

  @override
  Widget build(BuildContext context, ComputedDemoViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Computed Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Full Name section ---
            const Text(
              'Full Name (string concat)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'First name',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: 'John'),
              onChanged: viewModel.updateFirstName,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Last name',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: 'Doe'),
              onChanged: viewModel.updateLastName,
            ),
            const SizedBox(height: 8),
            LazxBuilder<String>(
              data: viewModel.fullName,
              builder: (context, value) => Text(
                'Computed: "$value"',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 32),

            // --- Price calculation section ---
            const Text(
              'Total (arithmetic)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LazxBuilder<double>(
              data: viewModel.price,
              builder: (context, value) =>
                  Text('Unit price: \$${value?.toStringAsFixed(2)}'),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: viewModel.decrementQuantity,
                  icon: const Icon(Icons.remove),
                ),
                LazxBuilder<int>(
                  data: viewModel.quantity,
                  builder: (context, value) => Text('Qty: $value'),
                ),
                IconButton(
                  onPressed: viewModel.incrementQuantity,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            LazxBuilder<double>(
              data: viewModel.total,
              builder: (context, value) => Text(
                'Total: \$${value?.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 32),

            // --- Form validation section ---
            const Text(
              'Form Valid (boolean)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Email (must contain @)',
                border: OutlineInputBorder(),
              ),
              onChanged: viewModel.updateEmail,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Password (min 6 chars)',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: viewModel.updatePassword,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                LazxBuilder<bool>(
                  data: viewModel.acceptedTerms,
                  builder: (context, value) => Checkbox(
                    value: value,
                    onChanged: viewModel.toggleTerms,
                  ),
                ),
                const Text('Accept terms'),
              ],
            ),
            const SizedBox(height: 8),
            LazxBuilder<bool>(
              data: viewModel.isFormValid,
              builder: (context, value) => Text(
                value == true ? 'Form is VALID' : 'Form is INVALID',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: value == true ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
