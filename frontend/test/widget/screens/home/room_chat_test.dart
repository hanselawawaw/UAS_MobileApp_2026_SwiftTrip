import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/home/room_chat.dart';
import 'package:swifttrip_frontend/screens/home/services/chat_service.dart';
import 'package:swifttrip_frontend/screens/home/widgets/chat_widgets.dart';

class MockChatService extends Mock implements ChatService {}

void main() {
  late MockChatService mockChatService;

  setUp(() {
    mockChatService = MockChatService();
  });

  group('Home AI Chatbot - Widget Test', () {
    testWidgets('renders loading state then chat content with ListView.builder and TextField', (tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: RoomChatPage()));

      // Assert loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Act
      await tester.pumpAndSettle();

      // Assert content
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ChatInputBar), findsOneWidget);
      expect(find.byType(ChatTopBar), findsOneWidget);
    });

    testWidgets('submitting empty/whitespace input does not append user message', (tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: RoomChatPage()));
      await tester.pumpAndSettle();

      final input = find.byType(TextField);
      expect(input, findsOneWidget);

      // Act
      await tester.enterText(input, '   ');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('   '),
        ),
        findsNothing,
      );
    });

    testWidgets('submitting non-empty input appends user message and clears input controller', (tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: RoomChatPage()));
      await tester.pumpAndSettle();

      final input = find.byType(TextField);
      expect(input, findsOneWidget);

      // Act
      await tester.enterText(input, 'Hi bot');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      expect(find.text('Hi bot'), findsOneWidget);
      final textFieldWidget = tester.widget<TextField>(input);
      expect(textFieldWidget.controller?.text, isEmpty);
    });

    testWidgets('send control in ChatInputBar is tappable (GestureDetector)', (tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: RoomChatPage()));
      await tester.pumpAndSettle();

      final sendControl = find.descendant(
        of: find.byType(ChatInputBar),
        matching: find.byType(GestureDetector),
      );
      expect(sendControl, findsWidgets);

      // Act
      await tester.enterText(find.byType(TextField), 'Plan my trip');
      await tester.tap(sendControl.last);
      await tester.pump();

      // Assert
      expect(find.text('Plan my trip'), findsOneWidget);
    });
  });

  test('mocktail setup creates mock instance', () {
    expect(mockChatService, isA<MockChatService>());
  });
}
