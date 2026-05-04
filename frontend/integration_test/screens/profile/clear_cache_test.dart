import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  group('Profile Settings (Cache) - Integration Test', () {
    testWidgets('cache flow: load details, clear cache, verify success state', (tester) async {
      // Arrange
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: _TestAssetBundle(),
          child: const MaterialApp(home: ClearCacheScreen()),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CacheRow), findsNWidgets(3));
      expect(find.text('304 kb'), findsOneWidget);

      // Act
      await tester.tap(find.text('Clear Cache').last);
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert
      expect(find.text('Cache cleared successfully'), findsOneWidget);
      expect(find.text('0 kb'), findsNWidgets(4));
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
