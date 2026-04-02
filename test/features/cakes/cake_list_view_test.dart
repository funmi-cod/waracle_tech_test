import 'dart:async';

import 'package:cake_it_app/src/features/cakes/bloc/cake_bloc.dart';
import 'package:cake_it_app/src/features/cakes/bloc/cake_event.dart';
import 'package:cake_it_app/src/features/cakes/data/cake_repository.dart';
import 'package:cake_it_app/src/features/cakes/models/cake.dart';
import 'package:cake_it_app/src/features/cakes/view/cake_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// A fake repository to control returned data without using mockito.
// This allows testing the real CakeListBloc and its integration with the UI
class FakeCakeRepository implements CakeRepository {
  final List<Cake> cakesToReturn;
  final bool shouldFail;
  final bool hangForever;

  FakeCakeRepository({
    this.cakesToReturn = const [],
    this.shouldFail = false,
    this.hangForever = false,
  });

  @override
  Future<List<Cake>> getCakes() async {
    if (hangForever) {
      final completer = Completer<List<Cake>>();
      return completer.future; // Never completes
    }
    if (shouldFail) {
      throw Exception('Server error');
    }
    return cakesToReturn;
  }
}

void main() {
// Helper function to wrap the widget under test with MaterialApp and BlocProvider.
  Widget createWidgetUnderTest(CakeBloc bloc) {
    return MaterialApp(
      home: BlocProvider<CakeBloc>.value(
        value: bloc,
        child: const CakeListView(),
      ),
    );
  }

  group('CakeListView Widget Tests', () {
    testWidgets(
        'displays CircularProgressIndicator when state is CakeListInitial',
        (WidgetTester tester) async {
      final bloc = CakeBloc(cakeRepository: FakeCakeRepository());
      await tester.pumpWidget(createWidgetUnderTest(bloc));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
      'displays CircularProgressIndicator when state is CakeListLoading',
      (WidgetTester tester) async {
        final bloc =
            CakeBloc(cakeRepository: FakeCakeRepository(hangForever: true));
        bloc.add(FetchCakes());
        await tester.pumpWidget(createWidgetUnderTest(bloc));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('displays list of cakes when state is CakeListLoaded',
        (WidgetTester tester) async {
      final mockCakes = [
        Cake(title: 'Red Velvet', description: 'A tasty red cake', image: ''),
        Cake(
            title: 'Black Forest cake',
            description: 'A yummy black forest cake',
            image: ''),
      ];
      final repository = FakeCakeRepository(cakesToReturn: mockCakes);
      final bloc = CakeBloc(cakeRepository: repository);

      bloc.add(FetchCakes());
      await tester.pumpWidget(createWidgetUnderTest(bloc));
      await tester.pumpAndSettle();

      expect(find.text('Red Velvet'), findsOneWidget);
      expect(find.text('A tasty red cake'), findsOneWidget);
      expect(find.text('Black Forest cake'), findsOneWidget);
      expect(find.text('A yummy black forest cake'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets(
        'displays error message and retry button when state is CakeListError',
        (WidgetTester tester) async {
      final repository = FakeCakeRepository(shouldFail: true);
      final bloc = CakeBloc(cakeRepository: repository);

      bloc.add(FetchCakes());
      await tester.pumpWidget(createWidgetUnderTest(bloc));
      await tester.pumpAndSettle();

      expect(find.text('Failed to load cakes: Exception: Server error'),
          findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
