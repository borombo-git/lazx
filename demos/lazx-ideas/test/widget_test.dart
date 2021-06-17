import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx_idea/app.dart';

import 'package:lazx_idea/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(StarterApp());

    expect(find.text('Hello Flutter 🐦'), findsOneWidget);
  });
}
