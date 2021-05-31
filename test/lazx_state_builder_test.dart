import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazx/lazx.dart';

class FakeViewModel extends LazxViewModel {
  final data = LazxData<int>(0);

  @override
  List<LazxData> get props => [data];
}

void main() {
  group('LazxStateBuilder tests', () {
    group('Tests on initial builder', () {
      testWidgets('Test inital builder is called by default',
          (WidgetTester tester) async {
        final viewModel = FakeViewModel();
        var numBuilds = 0;

        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: LazxStateBuilder<int>(
            data: viewModel.data,
            initial: (context, value) {
              numBuilds++;
              return Text('$value');
            },
          ),
        ));

        expect(numBuilds, 1);
        expect(find.text('0'), findsOneWidget);

        viewModel.data.push(1);

        await tester.pumpAndSettle();

        expect(numBuilds, 2);
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('Test inital builder is called when no other state declared',
          (WidgetTester tester) async {
        final viewModel = FakeViewModel();
        var numBuilds = 0;

        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: LazxStateBuilder<int>(
            data: viewModel.data,
            initial: (context, value) {
              numBuilds++;
              return Text('$value');
            },
          ),
        ));

        expect(numBuilds, 1);
        expect(find.text('0'), findsOneWidget);

        viewModel.data.push(-1, lxState: LxState.Error);

        await tester.pumpAndSettle();

        expect(numBuilds, 2);
        expect(find.text('-1'), findsOneWidget);
      });
      testWidgets(
          'Test inital builder is not called when other corresponding state is declared',
          (WidgetTester tester) async {
        final viewModel = FakeViewModel();
        var numBuilds = 0;
        var numBuildsError = 0;

        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: LazxStateBuilder<int>(
            data: viewModel.data,
            initial: (context, value) {
              numBuilds++;
              return Text('$value');
            },
            error: (context, value) {
              numBuildsError++;
              return Text('Error');
            },
          ),
        ));

        expect(numBuilds, 1);
        expect(find.text('0'), findsOneWidget);
        expect(find.text('Error'), findsNothing);

        viewModel.data.push(-1, lxState: LxState.Error);

        await tester.pumpAndSettle();

        expect(numBuilds, 1);
        expect(numBuildsError, 1);
        expect(find.text('-1'), findsNothing);
        expect(find.text('Error'), findsOneWidget);
      });
    });

    group('Tests on other builder', () {
      testWidgets(
          'Test loading builder is called when loading state is emmited',
          (WidgetTester tester) async {
        final viewModel = FakeViewModel();
        var numBuilds = 0;
        var numBuildsLoading = 0;

        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: LazxStateBuilder<int>(
            data: viewModel.data,
            initial: (context, value) {
              numBuilds++;
              return Text('$value');
            },
            loading: (context, value) {
              numBuildsLoading++;
              return Text('Loading');
            },
          ),
        ));

        expect(numBuilds, 1);
        expect(find.text('0'), findsOneWidget);

        viewModel.data.setState(LxState.Loading);

        await tester.pumpAndSettle();

        expect(numBuilds, 1);
        expect(numBuildsLoading, 1);
        expect(find.text('0'), findsNothing);
        expect(find.text('Loading'), findsOneWidget);
      });

      testWidgets(
          'Test success builder is called when success state is emmited',
          (WidgetTester tester) async {
        final viewModel = FakeViewModel();
        var numBuilds = 0;
        var numBuildsSuccess = 0;

        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: LazxStateBuilder<int>(
            data: viewModel.data,
            initial: (context, value) {
              numBuilds++;
              return Text('$value');
            },
            success: (context, value) {
              numBuildsSuccess++;
              return Text('Success');
            },
          ),
        ));

        expect(numBuilds, 1);
        expect(find.text('0'), findsOneWidget);

        viewModel.data.setState(LxState.Success);

        await tester.pumpAndSettle();

        expect(numBuilds, 1);
        expect(numBuildsSuccess, 1);
        expect(find.text('0'), findsNothing);
        expect(find.text('Success'), findsOneWidget);
      });

      testWidgets('Test error builder is called when error state is emmited',
          (WidgetTester tester) async {
        final viewModel = FakeViewModel();
        var numBuilds = 0;
        var numBuildsError = 0;

        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: LazxStateBuilder<int>(
            data: viewModel.data,
            initial: (context, value) {
              numBuilds++;
              return Text('$value');
            },
            error: (context, value) {
              numBuildsError++;
              return Text('Error');
            },
          ),
        ));

        expect(numBuilds, 1);
        expect(find.text('0'), findsOneWidget);

        viewModel.data.setState(LxState.Error);

        await tester.pumpAndSettle();

        expect(numBuilds, 1);
        expect(numBuildsError, 1);
        expect(find.text('0'), findsNothing);
        expect(find.text('Error'), findsOneWidget);
      });
    });

    group('Tests with all the builders', () {
      testWidgets('Test each builder is called with the corresponding state',
          (WidgetTester tester) async {
        final viewModel = FakeViewModel();
        var numBuilds = 0;
        var numBuildsLoading = 0;
        var numBuildsSuccess = 0;
        var numBuildsError = 0;

        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: LazxStateBuilder<int>(
            data: viewModel.data,
            initial: (context, value) {
              numBuilds++;
              return Text('$value');
            },
            loading: (context, value) {
              numBuildsLoading++;
              return Text('Loading');
            },
            success: (context, value) {
              numBuildsSuccess++;
              return Text('Success');
            },
            error: (context, value) {
              numBuildsError++;
              return Text('Error');
            },
          ),
        ));

        expect(numBuilds, 1);
        expect(numBuildsLoading, 0);
        expect(numBuildsError, 0);
        expect(numBuildsSuccess, 0);
        expect(find.text('0'), findsOneWidget);

        viewModel.data.setState(LxState.Loading);

        await tester.pumpAndSettle();

        expect(numBuilds, 1);
        expect(numBuildsLoading, 1);
        expect(numBuildsError, 0);
        expect(numBuildsSuccess, 0);
        expect(find.text('0'), findsNothing);
        expect(find.text('Loading'), findsOneWidget);

        viewModel.data.setState(LxState.Error);

        await tester.pumpAndSettle();

        expect(numBuilds, 1);
        expect(numBuildsLoading, 1);
        expect(numBuildsError, 1);
        expect(numBuildsSuccess, 0);
        expect(find.text('0'), findsNothing);
        expect(find.text('Loading'), findsNothing);
        expect(find.text('Error'), findsOneWidget);

        viewModel.data.setState(LxState.Success);

        await tester.pumpAndSettle();

        expect(numBuilds, 1);
        expect(numBuildsLoading, 1);
        expect(numBuildsError, 1);
        expect(numBuildsSuccess, 1);
        expect(find.text('0'), findsNothing);
        expect(find.text('Loading'), findsNothing);
        expect(find.text('Error'), findsNothing);
        expect(find.text('Success'), findsOneWidget);
      });
    });
  });
}
