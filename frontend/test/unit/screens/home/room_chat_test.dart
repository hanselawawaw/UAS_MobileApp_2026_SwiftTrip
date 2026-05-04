import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/home/models/chat_message.dart';
import 'package:swifttrip_frontend/screens/home/services/chat_service.dart';

class MockChatService extends Mock implements ChatService {}

void main() {
  late MockChatService mockChatService;
  late ChatService chatService;

  setUp(() {
    mockChatService = MockChatService();
    chatService = ChatService();
  });

  group('Home AI Chatbot - Unit Test', () {
    test('ChatMessage.text toJson serializes expected fields', () {
      // Arrange
      const message = ChatMessage.text(type: MsgType.user, text: 'hello');

      // Act
      final json = message.toJson();

      // Assert
      expect(json['type'], equals('user'));
      expect(json['text'], equals('hello'));
      expect(json.containsKey('ticket'), isFalse);
    });

    test('ChatMessage.fromJson deserializes text message', () {
      // Arrange
      final json = <String, dynamic>{'type': 'ai', 'text': 'Welcome'};

      // Act
      final message = ChatMessage.fromJson(json);

      // Assert
      expect(message.type, equals(MsgType.ai));
      expect(message.text, equals('Welcome'));
      expect(message.ticket, isNull);
    });

    test('ChatService.getInitialMessages(home) returns initial AI message', () async {
      // Arrange
      const context = 'home';

      // Act
      final messages = await chatService.getInitialMessages(context);

      // Assert
      expect(messages, isNotEmpty);
      expect(messages.first.type, equals(MsgType.ai));
      expect(messages.first.text, contains('Hello! Where would you like to travel today?'));
    });

    test('MockChatService can be stubbed with mocktail', () async {
      // Arrange
      final expected = <ChatMessage>[
        const ChatMessage.text(type: MsgType.ai, text: 'stubbed'),
      ];
      when(() => mockChatService.getInitialMessages(any())).thenAnswer((_) async => expected);

      // Act
      final result = await mockChatService.getInitialMessages('home');

      // Assert
      expect(result, equals(expected));
      verify(() => mockChatService.getInitialMessages('home')).called(1);
    });
  });
}
