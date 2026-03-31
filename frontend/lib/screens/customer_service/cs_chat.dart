import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import 'onboarding.dart';
import '../home/models/chat_message.dart';
import '../home/widgets/chat_widgets.dart';
import '../home/services/chat_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CS CHAT PAGE
// ─────────────────────────────────────────────────────────────────────────────

class CsChatPage extends StatefulWidget {
  final String ticketId; // Kept to avoid breaking references

  const CsChatPage({super.key, required this.ticketId});

  @override
  State<CsChatPage> createState() => _CsChatPageState();
}

class _CsChatPageState extends State<CsChatPage> {
  final TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  List<ChatMessage> _messages = [];
  bool _isBotTyping = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final msgs = await _chatService.getInitialMessages('support');
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
    _replyController.dispose();
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

  void _handleSendReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage.text(type: MsgType.user, text: text));
      _replyController.clear();
      _isBotTyping = true;
    });

    _scrollToBottom();

    final response = await _chatService.sendMessage(text, 'support');
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
          // ── Top Bar ────────────────────────────────────────────────────
          TopBar(
            showBackButton: true,
            showHamburger: true,
            onHamburgerTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingPage()),
              );
            },
          ),

          // ── Chat Content ───────────────────────────────────────────────
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
                      if (msg.type == MsgType.ticket) {
                        return ChatTicketCard(ticket: msg.ticket!);
                      }
                      return ChatBubbleWidget(message: msg);
                    },
                  ),
          ),
          ChatInputBar(controller: _replyController, onSend: _handleSendReply),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
