import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/searching/land_vehicle.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('LandVehicle Integration', () {
    testWidgets('LandVehicleSearch renders with Scaffold', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const LandVehicleSearch()));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(LandVehicleSearch), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
