import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import 'onboarding.dart';
import '../home/models/chat_message.dart';
import '../home/widgets/chat_widgets.dart';
import '../home/services/chat_service.dart';
import 'services/customer_service_service.dart';
import 'models/cs_chat_models.dart';
import 'widgets/cs_question_card.dart';
import 'widgets/cs_feedback_card.dart';
import 'widgets/cs_reply_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CS CHAT PAGE
// ─────────────────────────────────────────────────────────────────────────────

class CsChatPage extends StatefulWidget {
  final String ticketId;

  const CsChatPage({super.key, required this.ticketId});

  @override
  State<CsChatPage> createState() => _CsChatPageState();
}

class _CsChatPageState extends State<CsChatPage> {
  final TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final CustomerServiceService _csService = CustomerServiceService();

  CsQuestion? _questionDetail;
  List<CsFeedbackEntry> _feedbacks = [];
  bool _isBotTyping = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      final detail = await _csService.getQuestionDetail(widget.ticketId);
      final thread = await _csService.getFeedbackThread(widget.ticketId);

      if (!mounted) return;

      setState(() {
        _questionDetail = detail;
        _feedbacks = thread;
        _isLoading = false;
      });

      _scrollToBottom();

      if (_feedbacks.isEmpty) {
        setState(() => _isBotTyping = true);
        _scrollToBottom();

        final aiReplies = await _csService.generateAiReply(widget.ticketId);

        if (!mounted) return;
        setState(() {
          _isBotTyping = false;
          _feedbacks.addAll(aiReplies);
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isBotTyping = false;
      });
      print('Chat init error: $e');
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
    if (text.isEmpty || _questionDetail == null) return;

    _scrollToBottom();

    setState(() {
      _feedbacks.add(
        CsFeedbackEntry(
          username: 'You',
          date: 'Just now',
          body: text,
          isAnswered: false,
        ),
      );
      _replyController.clear();
      _isBotTyping = true;
    });

    _scrollToBottom();

    try {
      // 1. Persist User Reply to Database
      await _csService.postReply(widget.ticketId, text);

      final historyForAi = <ChatMessage>[
        ChatMessage.text(type: MsgType.user, text: _questionDetail!.body),
      ];

      for (var i = 0; i < _feedbacks.length - 1; i++) {
        final feedback = _feedbacks[i];
        historyForAi.add(
          ChatMessage.text(
            type: feedback.isAnswered ? MsgType.ai : MsgType.user,
            text: feedback.body,
          ),
        );
      }

      final response = await _chatService.sendMessage(
        text,
        historyForAi,
        'support',
      );

      if (!mounted) return;

      final replyText = response.text ?? 'Ticket Information Received';

      // 2. Persist AI Follow-up to Database
      await _csService.postReply(widget.ticketId, replyText);

      setState(() {
        _isBotTyping = false;
        _feedbacks.add(
          CsFeedbackEntry(
            username: 'IT Team CS',
            date: 'Just now',
            body: replyText,
            isAnswered: true,
          ),
        );
      });
    } catch (e) {
      print('Failed to persist or send message: $e');
      if (mounted) {
        setState(() => _isBotTyping = false);
      }
    }
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
                    itemCount: 2 + _feedbacks.length + (_isBotTyping ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        return _questionDetail != null
                            ? CsQuestionCard(question: _questionDetail!)
                            : const SizedBox();
                      } else if (i == 1) {
                        return const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Divider(color: Color(0xFFD9D9D9), thickness: 1),
                            Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              child: Text(
                                'Feedback:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF2B99E3),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      final feedIdx = i - 2;
                      if (feedIdx < _feedbacks.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CsFeedbackCard(entry: _feedbacks[feedIdx]),
                        );
                      }

                      return const TypingIndicator();
                    },
                  ),
          ),
          CsReplyBar(controller: _replyController, onSend: _handleSendReply),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
