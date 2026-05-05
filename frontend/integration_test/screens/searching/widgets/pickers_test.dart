import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/searching/widgets/pickers.dart';
import '../../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('Pickers Integration', () {
    testWidgets('PassengerCount model works correctly', (tester) async {
      const count = PassengerCount(adults: 2, children: 1, infants: 0);

      expect(count.total, 3);
      expect(count.displayLabel, contains('2 Adults'));
      expect(count.displayLabel, contains('1 Child'));
    });

    testWidgets('formatDisplayDate returns formatted date', (tester) async {
      final date = DateTime(2026, 3, 27);
      final formatted = formatDisplayDate(date);

      expect(formatted, contains('27'));
      expect(formatted, contains('Mar'));
      expect(formatted, contains('2026'));
    });
  });
}
