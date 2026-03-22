import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';
import 'onboarding.dart';
import 'models/cs_chat_models.dart';
import 'widgets/cs_question_card.dart';
import 'widgets/cs_feedback_card.dart';
import 'widgets/cs_reply_bar.dart';
import 'services/customer_service_service.dart';

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
  final CustomerServiceService _service = CustomerServiceService();

  CsQuestion? _question;
  List<CsFeedbackEntry> _feedbackThread = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatData();
  }

  Future<void> _loadChatData() async {
    final question = await _service.getQuestionDetail(widget.ticketId);
    final thread = await _service.getFeedbackThread(widget.ticketId);
    if (mounted) {
      setState(() {
        _question = question;
        _feedbackThread = thread;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _handleSendReply() async {
    final body = _replyController.text.trim();
    if (body.isEmpty) return;

    await _service.postReply(widget.ticketId, body);
    
    _replyController.clear();
    // Re-fetch to show new reply
    await _loadChatData(); 
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
                : Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            if (_question != null)
                              CsQuestionCard(question: _question!),
                            
                            const SizedBox(height: 16),
                            const Divider(color: Color(0x4D000000), thickness: 1),
                            const SizedBox(height: 8),

                            const Text(
                              'Feedback:',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 2.19,
                                color: Color(0xFF2B99E3),
                              ),
                            ),
                            const SizedBox(height: 8),

                            ..._feedbackThread.map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: CsFeedbackCard(entry: entry),
                                )),
                          ],
                        ),
                      ),

                      // ── Reply Bar at Bottom ─────────────────────────────────
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: CsReplyBar(
                          controller: _replyController,
                          onSend: _handleSendReply,
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
