import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_utils/methods.dart';
import '../../_utils/test_manager.dart';

void main() {
  group('<Name> Screen Unit Tests', () {
    var testManager = TestManager();

    setUp(() async {
      await testManager.init();
    });

    Future<void> init<Name>Screen(WidgetTester tester) async {
      await testManager.initScreen(tester);
    }

    testWidgets('Screen Test', (tester) async {
      await init<Name>Screen(tester);
      // expect(find.byType(<Name>Screen), findsOneWidget);
    });

    testOverflowWithSizes((tester) async {
      await init<Name>Screen(tester);
    }, [
      const Size(400, 600),
      const Size(400, 800),
      const Size(400, 850),
      const Size(400, 900),
      const Size(400, 1000),
      const Size(400, 1100),
      const Size(400, 1200),
      const Size(400, 1300),
      const Size(400, 1400),
      const Size(400, 1500),
      testManager.screenSize,
    ]);

    tearDown(() {
      testManager.dispose();
    });
  });
}
