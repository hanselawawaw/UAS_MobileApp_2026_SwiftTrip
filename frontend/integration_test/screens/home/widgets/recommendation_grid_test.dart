import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/home/widgets/recommendation_grid.dart';
import 'package:swifttrip_frontend/screens/destination/models/destination_model.dart';
import '../../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('RecommendationGrid Integration', () {
    testWidgets('RecommendationGrid renders with sample items', (tester) async {
      final items = [
        DestinationModel(
          id: '1',
          title: 'Bali',
          location: 'Indonesia',
          imageUrl: '',
          rating: 4.5,
        ),
      ];

      await tester.pumpWidget(
        wrapWithProviders(RecommendationGrid(items: items)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RecommendationGrid), findsOneWidget);
      expect(find.text('Bali'), findsOneWidget);
    });
  });
}
