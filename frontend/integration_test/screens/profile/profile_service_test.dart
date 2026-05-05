import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/profile/profile.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('ProfileService Integration', () {
    testWidgets('ProfilePage renders menu items for language, cache, logout', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const ProfilePage()));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });
  });
}
