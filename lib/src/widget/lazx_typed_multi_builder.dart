import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../lazx.dart';

/// Typed variant of [LazxMultiBuilder] that listens to 2 [LazxData] streams
/// with full type safety.
///
/// ```dart
/// LazxMultiBuilder2<int, bool>(
///   data1: viewModel.counter,
///   data2: viewModel.isVisible,
///   builder: (context, counter, isVisible) {
///     return Text('$counter visible: $isVisible');
///   },
/// )
/// ```
class LazxMultiBuilder2<T1, T2> extends StatelessWidget {
  final LazxData<T1> data1;
  final LazxData<T2> data2;
  final Widget Function(BuildContext context, T1? value1, T2? value2) builder;

  const LazxMultiBuilder2({
    required this.data1,
    required this.data2,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: CombineLatestStream.list([data1.stream, data2.stream]),
      initialData: [data1.value, data2.value],
      builder: (context, snapshot) {
        final values = snapshot.data ?? [];
        return builder(
          context,
          values.isNotEmpty ? values[0] as T1? : null,
          values.length > 1 ? values[1] as T2? : null,
        );
      },
    );
  }
}

/// Typed variant of [LazxMultiBuilder] that listens to 3 [LazxData] streams
/// with full type safety.
///
/// ```dart
/// LazxMultiBuilder3<List<Item>, bool, String?>(
///   data1: viewModel.items,
///   data2: viewModel.isLoading,
///   data3: viewModel.errorMessage,
///   builder: (context, items, isLoading, error) => ...,
/// )
/// ```
class LazxMultiBuilder3<T1, T2, T3> extends StatelessWidget {
  final LazxData<T1> data1;
  final LazxData<T2> data2;
  final LazxData<T3> data3;
  final Widget Function(
      BuildContext context, T1? value1, T2? value2, T3? value3) builder;

  const LazxMultiBuilder3({
    required this.data1,
    required this.data2,
    required this.data3,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: CombineLatestStream.list(
          [data1.stream, data2.stream, data3.stream]),
      initialData: [data1.value, data2.value, data3.value],
      builder: (context, snapshot) {
        final values = snapshot.data ?? [];
        return builder(
          context,
          values.isNotEmpty ? values[0] as T1? : null,
          values.length > 1 ? values[1] as T2? : null,
          values.length > 2 ? values[2] as T3? : null,
        );
      },
    );
  }
}

/// Typed variant of [LazxMultiBuilder] that listens to 4 [LazxData] streams
/// with full type safety.
class LazxMultiBuilder4<T1, T2, T3, T4> extends StatelessWidget {
  final LazxData<T1> data1;
  final LazxData<T2> data2;
  final LazxData<T3> data3;
  final LazxData<T4> data4;
  final Widget Function(
      BuildContext context, T1? value1, T2? value2, T3? value3, T4? value4)
      builder;

  const LazxMultiBuilder4({
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data4,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: CombineLatestStream.list(
          [data1.stream, data2.stream, data3.stream, data4.stream]),
      initialData: [data1.value, data2.value, data3.value, data4.value],
      builder: (context, snapshot) {
        final values = snapshot.data ?? [];
        return builder(
          context,
          values.isNotEmpty ? values[0] as T1? : null,
          values.length > 1 ? values[1] as T2? : null,
          values.length > 2 ? values[2] as T3? : null,
          values.length > 3 ? values[3] as T4? : null,
        );
      },
    );
  }
}

/// Typed variant of [LazxMultiBuilder] that listens to 5 [LazxData] streams
/// with full type safety.
///
/// For more than 5 streams, use the untyped [LazxMultiBuilder].
class LazxMultiBuilder5<T1, T2, T3, T4, T5> extends StatelessWidget {
  final LazxData<T1> data1;
  final LazxData<T2> data2;
  final LazxData<T3> data3;
  final LazxData<T4> data4;
  final LazxData<T5> data5;
  final Widget Function(BuildContext context, T1? value1, T2? value2,
      T3? value3, T4? value4, T5? value5) builder;

  const LazxMultiBuilder5({
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data4,
    required this.data5,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: CombineLatestStream.list([
        data1.stream,
        data2.stream,
        data3.stream,
        data4.stream,
        data5.stream,
      ]),
      initialData: [
        data1.value,
        data2.value,
        data3.value,
        data4.value,
        data5.value,
      ],
      builder: (context, snapshot) {
        final values = snapshot.data ?? [];
        return builder(
          context,
          values.isNotEmpty ? values[0] as T1? : null,
          values.length > 1 ? values[1] as T2? : null,
          values.length > 2 ? values[2] as T3? : null,
          values.length > 3 ? values[3] as T4? : null,
          values.length > 4 ? values[4] as T5? : null,
        );
      },
    );
  }
}
