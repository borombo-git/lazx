import 'package:flutter/material.dart';

import '../lazx.dart';
import 'view_model_provider.dart';

/// [LxViewModelProvider] is an mixin used on the [LazxWidget] to allow the widget
/// to access a [LazxViewModel] inside his tree structure
mixin LxViewModelProvider {
  T viewModel<T extends LazxViewModel>(BuildContext context) {
    return ViewModelProvider.getViewModel(context);
  }
}

/// [StatelessViewModelProvider] is an extension that allows every
/// [StatelessWidget] to access a [LazxViewModel] inside his tree structure
extension StatelessViewModelProvider on StatelessWidget {
  T viewModel<T extends LazxViewModel>(BuildContext context) =>
      ViewModelProvider.getViewModel(context);
}

/// [StateViewModelProvider] is an extension that allows every [State] to access
/// a [LazxViewModel] inside his tree structure
extension StateViewModelProvider on State {
  T viewModel<T extends LazxViewModel>(BuildContext context) =>
      ViewModelProvider.getViewModel(context);
}
