import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/checkout/payment_detail.dart';
import 'package:swifttrip_frontend/screens/checkout/models/checkout_details_model.dart';
import 'package:swifttrip_frontend/screens/checkout/models/purchase_item_model.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('PaymentDetail Integration', () {
    testWidgets('PaymentDetailPage renders with Payment Successful text', (tester) async {
      final details = CheckoutDetailsModel(
        tickets: [],
        purchaseItems: [
          PurchaseItemModel(label: 'Test', amount: 'Rp. 100.000'),
        ],
        totalPrice: 'Rp. 100.000',
        discountTotal: 0,
      );

      await tester.pumpWidget(
        wrapWithProviders(PaymentDetailPage(details: details)),
      );
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(PaymentDetailPage), findsOneWidget);
      expect(find.text('Payment Successful'), findsOneWidget);
    });
  });
}
