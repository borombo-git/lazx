import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';
import 'package:mocktail/mocktail.dart';

class FakeManager extends Mock implements LazxManager {
  final data = LazxObserver<int>(initialValue: 1);

  @override
  List<LazxObserver> get props => [data];
}

class TestScreen extends LazxApp {
  final fakeManager;

  TestScreen(this.fakeManager);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  List<LazxManager> get managers => [fakeManager];
}

class TestApp extends StatelessWidget {
  final FakeManager fakeManager;

  const TestApp(this.fakeManager) : super();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestScreen(this.fakeManager),
    );
  }
}

void main() {
  group('LazxScreen tests', () {
    testWidgets('Init', (WidgetTester tester) async {
      final manager = FakeManager();
      await tester.pumpWidget(TestApp(manager));

      final testScreen = tester.widget<TestScreen>(
        find.byType(TestScreen),
      );

      expect(testScreen.fakeManager, isInstanceOf<FakeManager>());
    });
  });
}
