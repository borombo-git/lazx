import 'dart:async';

import 'package:flutter/material.dart';

import '../../lazx.dart';

/// [LazxValueBuilder] is a type for a callback function that receives a [T]
/// value from a [LazxObserver]. Returns void — used for side effects
/// (navigation, logging, etc.), not for building widgets.
typedef LazxValueBuilder<T> = void Function(T? value);

/// A [LazxObserverBuilder] listens to a [LazxObserver] and triggers a callback
/// each time the value changes.
///
/// This is a side-effect widget — it renders nothing visible but reacts to
/// data changes. Useful for triggering navigation, showing snackbars, etc.
///
/// It's the same concept as a [LazxBuilder], but for a [LazxObserver] and
/// with a void callback instead of a widget builder.
///
/// ```dart
/// LazxObserverBuilder<bool>(
///   data: authManager.authenticated,
///   builder: (authenticated) {
///     if (authenticated == true) {
///       navigator.pushReplacement(HomeScreen());
///     }
///   },
/// )
/// ```
class LazxObserverBuilder<T> extends StatefulWidget {
  /// The [data] that will be listened to execute the [builder] callback
  final LazxObserver<T> data;

  /// The callback that will be called each time the [data] is updated,
  /// passing the new value
  final LazxValueBuilder<T> builder;

  const LazxObserverBuilder({required this.data, required this.builder});

  @override
  _LazxObserverBuilderState<T> createState() =>
      _LazxObserverBuilderState<T>();
}

/// [_LazxObserverBuilderState] manages the stream subscription lifecycle
class _LazxObserverBuilderState<T> extends State<LazxObserverBuilder<T>> {
  /// Subscription to the observer stream, canceled on dispose
  StreamSubscription<T>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.data.stream.listen((data) {
      if (!mounted) return;
      widget.builder(data);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
