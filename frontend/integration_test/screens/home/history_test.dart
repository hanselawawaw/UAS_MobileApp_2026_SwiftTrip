import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/home/history.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('HistoryPage Integration', () {
    testWidgets('HistoryPage renders with History title', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const HistoryPage()));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(HistoryPage), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
    });
  });
}
