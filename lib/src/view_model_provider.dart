import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// [ViewModelProvider] Allow Lazx Widgets to access the right viewModel with
/// the help of the Provider package.
class ViewModelProvider {
  static T getViewModel<T>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }
}
