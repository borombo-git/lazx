import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx/src/lazx_data.dart';

/// [LazxWidget] is a widget that will have a single builder function
/// that will be called each time that the [LxState] of a [LazxData] change.
///
/// A [LazwWidget] has been created to avoid using a Builder type function.
/// With just a widget, you have everything in one place and can listen to
/// state changes.
///
/// [LazxWidget] is a [StatefulWidget] that will be abstracted when used so
/// you don't have to handle the state for it.
abstract class LazxWidget extends StatefulWidget with LxViewModelProvider {
  /// The [data] that will be listened to execute the build function
  final LazxObservable data;

  const LazxWidget({Key? key, required this.data}) : super(key: key);

  /// The build function that will be used to build the widget.
  /// You also access the [LxState] and value of the [data]
  Widget build(BuildContext context, LxState state, data);

  @override
  _LazxWidgetState createState() => _LazxWidgetState();
}

/// [LazxWidgetState] Represents the state for the [LazxDataBuilder] so
/// you don't have to handle it
class _LazxWidgetState extends State<LazxWidget> {
  /// Represents the current state of your widget.
  /// By default, the state is `Initial`
  LxState _state = LxState.Initial;

  /// The state is initialized and we listen to the state of the `data` to update
  /// the [_state] and rebuild the widget
  @override
  void initState() {
    super.initState();
    widget.data.state.listen((state) {
      if (!mounted) return;
      setState(() {
        _state = state;
      });
    });
  }

  /// The build will simply return the method created in the Widget and pass the
  /// current [_state] and the value of the [LazxData] `data` each time the state
  /// of the `data` is updated.
  ///
  /// The first time, the `Initial` state is returned with the initial value of
  /// the[data]
  @override
  Widget build(BuildContext context) {
    return widget.build(context, _state,
        widget.data is LazxData ? (LazxData(widget.data)).value : null);
  }
}
