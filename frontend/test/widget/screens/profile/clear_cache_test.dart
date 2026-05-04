import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/screens/profile/clear_cache.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/cache_row.dart';

class _TestAssetBundle extends CachingAssetBundle {
  static final ByteData _svgBytes = ByteData.view(
    Uint8List.fromList(
      utf8.encode(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10"><rect width="10" height="10" fill="black"/></svg>',
      ),
    ).buffer,
  );

  @override
  Future<ByteData> load(String key) async => _svgBytes;
}

void main() {
  setUp(() {});

  group('Profile Settings (Cache) - Widget Test', () {
    testWidgets('renders loading then cache rows and total cache', (tester) async {
      // Arrange
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: _TestAssetBundle(),
          child: const MaterialApp(home: ClearCacheScreen()),
        ),
      );

      // Assert loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Act
      await tester.pumpAndSettle();

      // Assert loaded content
      expect(find.text('Clear Cache'), findsNWidgets(2));
      expect(find.byType(CacheRow), findsNWidgets(3));
      expect(find.text('Total Cache:'), findsOneWidget);
      expect(find.text('304 kb'), findsOneWidget);
    });

    testWidgets('tap clear cache updates values and shows snackbar', (tester) async {
      // Arrange
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: _TestAssetBundle(),
          child: const MaterialApp(home: ClearCacheScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Clear Cache').last);
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert
      expect(find.text('0 kb'), findsNWidgets(4));
      expect(find.text('Cache cleared successfully'), findsOneWidget);
    });
  });
}
