/// Testing utilities for Lazx reactive types.
///
/// Import this in your test files to get helpers like [waitForState],
/// [waitForValue], [expectStateSequence], and [expectEmits].
///
/// ```dart
/// import 'package:lazx/lazx_testing.dart';
/// ```
///
/// These helpers are intentionally **not** exported from `package:lazx/lazx.dart`
/// so they are never bundled into production code.
library lazx_testing;

export 'src/testing/lazx_test_helpers.dart';
