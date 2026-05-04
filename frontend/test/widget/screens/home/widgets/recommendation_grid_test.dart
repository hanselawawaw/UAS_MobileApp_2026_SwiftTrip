import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/home/home.dart';
import 'package:swifttrip_frontend/screens/home/widgets/recommendation_grid.dart';
import 'package:swifttrip_frontend/screens/destination/models/destination_model.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';

// ─── Helper: buat DestinationModel dengan semua required fields ───────────────
// FIX: RecommendationGrid pakai List<DestinationModel>, bukan RecommendationItem.
// Required fields: id, title, imageUrl, rating.

DestinationModel makeDestination({
  String id = '1',
  String title = 'The Langham',
  String imageUrl = '',
  String location = 'Jakarta',
  double rating = 4.5,
}) {
  return DestinationModel(
    id: id,
    title: title,
    imageUrl: imageUrl,
    location: location,
    rating: rating,
  );
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

Widget buildTestableWidget(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ],
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

// ─── Widget Tests: Home - Recommendation ────────────────────────────────────

void main() {
  group('Home - Recommendation Widget Tests', () {
    // ── navigateToDetail() via GestureDetector ────────────────────────────

    group('navigateToDetail() - GestureDetector on RecommendationItem', () {
      testWidgets('should display recommendation item title and location',
          (WidgetTester tester) async {
        // Arrange
        final items = [
          makeDestination(title: 'The Langham', location: 'Jakarta'),
        ];

        // Act
        await tester.pumpWidget(
          buildTestableWidget(
            RecommendationGrid(items: items, onItemTap: (_) {}),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.text('The Langham'), findsOneWidget);
        expect(find.text('Jakarta'), findsOneWidget);
      });

      testWidgets('should trigger onItemTap callback when item is tapped',
          (WidgetTester tester) async {
        // Arrange
        DestinationModel? tappedItem;
        final items = [
          makeDestination(id: '2', title: 'The Ritz-Carlton', location: 'Bali'),
        ];

        // Act
        await tester.pumpWidget(
          buildTestableWidget(
            RecommendationGrid(
              items: items,
              onItemTap: (item) => tappedItem = item,
            ),
          ),
        );
        await tester.pump();
        await tester.tap(find.text('The Ritz-Carlton'));
        await tester.pump();

        // Assert
        expect(tappedItem, isNotNull);
        expect(tappedItem!.title, equals('The Ritz-Carlton'));
      });

      testWidgets('should render grid with correct item count',
          (WidgetTester tester) async {
        // Arrange
        final items = List.generate(
          4,
          (i) => makeDestination(id: '$i', title: 'Hotel $i', location: 'City $i'),
        );

        // Act
        await tester.pumpWidget(
          buildTestableWidget(
            RecommendationGrid(items: items, onItemTap: (_) {}),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.textContaining('Hotel'), findsNWidgets(4));
      });
    });

    // ── handleImageError() via Image.network ──────────────────────────────

    group('handleImageError() - Image.network fallback', () {
      testWidgets('should render grid widget when items list is empty',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          buildTestableWidget(
            RecommendationGrid(items: const [], onItemTap: (_) {}),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.byType(RecommendationGrid), findsOneWidget);
      });

      testWidgets('should render item even when imageUrl is empty string',
          (WidgetTester tester) async {
        // Arrange — imageUrl kosong, fallback container ditampilkan
        final items = [
          makeDestination(title: 'Unknown Hotel', location: 'Unknown City', imageUrl: ''),
        ];

        // Act
        await tester.pumpWidget(
          buildTestableWidget(
            RecommendationGrid(items: items, onItemTap: (_) {}),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.text('Unknown Hotel'), findsOneWidget);
      });

      testWidgets('should show loading indicator when HomePage is loading',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          buildTestableWidget(const HomePage()),
        );
        // Pump sekali saja agar loading state masih terlihat
        await tester.pump();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    // ── SliverGrid renders correctly ──────────────────────────────────────

    group('SliverGrid layout rendering', () {
      testWidgets('should render RecommendationGrid without throwing',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          buildTestableWidget(
            RecommendationGrid(items: const [], onItemTap: (_) {}),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.byType(RecommendationGrid), findsOneWidget);
      });

      testWidgets('should render multiple items in a grid layout',
          (WidgetTester tester) async {
        // Arrange
        final items = [
          makeDestination(id: '1', title: 'Hotel A', location: 'Kota A'),
          makeDestination(id: '2', title: 'Hotel B', location: 'Kota B'),
        ];

        // Act
        await tester.pumpWidget(
          buildTestableWidget(
            RecommendationGrid(items: items, onItemTap: (_) {}),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.text('Hotel A'), findsOneWidget);
        expect(find.text('Hotel B'), findsOneWidget);
      });

      testWidgets('should show location text for each item',
          (WidgetTester tester) async {
        // Arrange
        final items = [
          makeDestination(id: '1', title: 'Hotel A', location: 'Bandung'),
          makeDestination(id: '2', title: 'Hotel B', location: 'Lombok'),
        ];

        // Act
        await tester.pumpWidget(
          buildTestableWidget(
            RecommendationGrid(items: items, onItemTap: (_) {}),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.text('Bandung'), findsOneWidget);
        expect(find.text('Lombok'), findsOneWidget);
      });
    });
  });
} 