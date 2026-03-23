import 'package:flutter/material.dart';
import 'services/chat_service.dart';
import 'models/chat_message.dart';
import 'widgets/chat_widgets.dart';

class RoomChatPage extends StatefulWidget {
  const RoomChatPage({super.key});

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _chatService = ChatService();

  List<ChatMessage> _messages = [];
  bool _isBotTyping = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final msgs = await _chatService.getInitialMessages();
    if (mounted) {
      setState(() {
        _messages = msgs;
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage.text(type: MsgType.user, text: text));
      _inputController.clear();
      _isBotTyping = true;
    });

    _scrollToBottom();

    final response = await _chatService.sendMessage(text);
    if (!mounted) return;

    setState(() {
      _isBotTyping = false;
      _messages.add(response);
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const ChatTopBar(),
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (_isBotTyping && i == _messages.length) {
                  return const TypingIndicator();
                }
                final msg = _messages[i];
                if (msg.type ==MsgType.ticket) {
                  return ChatTicketCard(ticket: msg.ticket!);
                }
                return ChatBubbleWidget(message: msg);
              },
            ),
          ),
          ChatInputBar(controller: _inputController, onSend: _sendMessage),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
