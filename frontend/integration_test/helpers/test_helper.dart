import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';

// Shared channel mock for flutter_secure_storage
const secureStorageChannel = MethodChannel(
  'plugins.it_nomads.com/flutter_secure_storage',
);

void mockSecureStorage() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, (call) async {
    if (call.method == 'read') return null;
    if (call.method == 'write') return null;
    if (call.method == 'delete') return null;
    if (call.method == 'deleteAll') return null;
    return null;
  });
}

void clearSecureStorageMock() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, null);
}

/// Wraps a widget with all required providers for integration testing.
Widget wrapWithProviders(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => WishlistProvider()),
    ],
    child: MaterialApp(home: child),
  );
}
