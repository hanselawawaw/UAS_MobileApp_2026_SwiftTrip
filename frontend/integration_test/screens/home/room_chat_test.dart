import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/home/room_chat.dart';
import 'package:swifttrip_frontend/screens/home/services/chat_service.dart';
import 'package:swifttrip_frontend/screens/home/widgets/chat_widgets.dart';

class MockChatService extends Mock implements ChatService {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockChatService mockChatService;

  setUp(() {
    mockChatService = MockChatService();
  });

  group('Home AI Chatbot - Integration Test', () {
    testWidgets('full flow: open page, type query, submit query, UI updates', (tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: RoomChatPage()));
      await tester.pumpAndSettle();

      final input = find.byType(TextField);
      final sendControl = find.descendant(
        of: find.byType(ChatInputBar),
        matching: find.byType(GestureDetector),
      );

      expect(find.byType(RoomChatPage), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(input, findsOneWidget);
      expect(sendControl, findsWidgets);

      // Act
      await tester.enterText(input, 'Need travel suggestions');
      await tester.tap(sendControl.last);
      await tester.pump();
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      // Assert
      expect(find.text('Need travel suggestions'), findsOneWidget);
      final textFieldWidget = tester.widget<TextField>(input);
      expect(textFieldWidget.controller?.text, isEmpty);
    });
  });

  test('mocktail setup creates mock instance', () {
    expect(mockChatService, isA<MockChatService>());
  });
}
