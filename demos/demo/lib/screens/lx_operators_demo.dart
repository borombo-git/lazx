import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';

import '../view_model/operators_demo_view_model.dart';

class LxOperatorsDemoView extends LazxView<OperatorsDemoViewModel> {
  @override
  OperatorsDemoViewModel getViewModel() => OperatorsDemoViewModel();

  @override
  Widget build(BuildContext context, OperatorsDemoViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Stream Operators Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Debounce section ---
            const Text(
              'Debounce',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Type to search...',
                border: OutlineInputBorder(),
              ),
              onChanged: viewModel.updateQuery,
            ),
            const SizedBox(height: 8),
            LazxBuilder<String>(
              data: viewModel.query,
              builder: (context, value) => Text('Raw: "$value"'),
            ),
            LazxBuilder<String>(
              data: viewModel.debouncedQuery,
              builder: (context, value) => Text(
                'Debounced (300ms): "$value"',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 32),

            // --- Throttle section ---
            const Text(
              'Throttle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: viewModel.increment,
              child: const Text('Tap rapidly'),
            ),
            const SizedBox(height: 8),
            LazxBuilder<int>(
              data: viewModel.counter,
              builder: (context, value) => Text('Raw count: $value'),
            ),
            LazxBuilder<int>(
              data: viewModel.throttledCounter,
              builder: (context, value) => Text(
                'Throttled (1s): $value',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 32),

            // --- Distinct section ---
            const Text(
              'Distinct',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: viewModel.toggleStatus,
                  child: const Text('Toggle status'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: viewModel.pushSameStatus,
                  child: const Text('Push same'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LazxBuilder<String>(
              data: viewModel.status,
              builder: (context, value) => Text('Raw status: "$value"'),
            ),
            LazxBuilder<String>(
              data: viewModel.distinctStatus,
              builder: (context, value) => Text(
                'Distinct: "$value"',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
