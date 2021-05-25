import 'package:flutter/material.dart';

import '../lazx.dart';
import 'view_model_provider.dart';

mixin LxViewModelProvider {
  T viewModel<T extends LazxViewModel>(BuildContext context) {
    return ViewModelProvider.getViewModel(context);
  }
}

extension StatelessViewModelProvider on StatelessWidget {
  T viewModel<T extends LazxViewModel>(BuildContext context) =>
      ViewModelProvider.getViewModel(context);
}

extension StateViewModelProvider on State {
  T viewModel<T extends LazxViewModel>(BuildContext context) =>
      ViewModelProvider.getViewModel(context);
}
