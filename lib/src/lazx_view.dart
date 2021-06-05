import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import 'package:provider/provider.dart';

/// [LazxView] is a base widget for a screen (or other part) in your app that
/// will (optionally) have a viewModel
///
/// By default, the [LazxView] is a StatefulWidget but the state is handler here
/// directly. When used, you don't have to create a State for it, but you can
/// override all the methods of a classic state directly from your [LazxView]
/// widget.
abstract class LazxView<T extends LazxViewModel> extends StatefulWidget {
  /// Function that should be implemented in your screen to initialize and
  /// define the type of the [LazxViewModel] of your screen
  T getViewModel();

  /// Could be override to be used in the state of your widget
  void dispose(BuildContext context) {}

  void init(BuildContext context, T viewModel) {}

  /// This build function will replace the classic [build] to give you access to
  /// your viewModel
  Widget build(BuildContext context, T viewModel);

  @override
  LazxState<T> createState() => LazxState<T>();
}

/// [LazxState] Represents the state for the [LazxView] so you don't have
/// to handle it
class LazxState<T extends LazxViewModel> extends State<LazxView<T>> {
  /// [viewModel] will be your viewModel. It's keep in the state so it's linked
  /// to you screen widget lifestyle
  late T viewModel;

  /// Will init your state and get/init your [viewModel]
  @override
  void initState() {
    super.initState();
    viewModel = widget.getViewModel()..init();
    widget.init(context, viewModel);
  }

  /// Will dispose your state and do the same to your [viewModel]
  @override
  void dispose() {
    widget.dispose(context);
    viewModel.dispose();
    super.dispose();
  }

  /// This is the classic build function.
  /// It will call the build function defined in your [LazxView] and pass it
  /// the [viewModel] with the help of a [Provider]
  @override
  Widget build(BuildContext context) {
    return Provider<T>(
      create: (_) => viewModel,
      child: widget.build(context, viewModel),
    );
  }
}
