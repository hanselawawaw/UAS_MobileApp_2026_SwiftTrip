import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../main/main_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────────────────────

enum _MsgType { ai, user, ticket }

class _ChatMessage {
  final _MsgType type;
  final String? text;
  final _TicketData? ticket;

  const _ChatMessage.text({required this.type, required String this.text})
    : ticket = null;

  const _ChatMessage.ticket({required _TicketData this.ticket})
    : type = _MsgType.ticket,
      text = null;
}

class _TicketData {
  final String from;
  final String to;
  final String date;
  final String departure;
  final String arrive;
  final String train;
  final String carriage;
  final String seat;

  const _TicketData({
    required this.from,
    required this.to,
    required this.date,
    required this.departure,
    required this.arrive,
    required this.train,
    required this.carriage,
    required this.seat,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// ROOM CHAT PAGE
// ─────────────────────────────────────────────────────────────────────────────

class RoomChatPage extends StatefulWidget {
  const RoomChatPage({super.key});

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isBotTyping = false;

  final List<_ChatMessage> _messages = [
    const _ChatMessage.text(type: _MsgType.ai, text: 'What can i help?'),
    const _ChatMessage.text(type: _MsgType.user, text: 'To Jakarta'),
    const _ChatMessage.ticket(
      ticket: _TicketData(
        from: 'Jakarta',
        to: 'Solo',
        date: '19/2/2026',
        departure: '9:00',
        arrive: '11:00',
        train: '1234',
        carriage: '01',
        seat: 'B',
      ),
    ),
    const _ChatMessage.ticket(
      ticket: _TicketData(
        from: 'Malang',
        to: 'Surabaya',
        date: '19/2/2026',
        departure: '9:00',
        arrive: '11:00',
        train: '1234',
        carriage: '01',
        seat: 'B',
      ),
    ),
  ];

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

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage.text(type: _MsgType.user, text: text));
      _inputController.clear();
      _isBotTyping = true;
    });

    _scrollToBottom();

    // Simulate AI response after delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isBotTyping = false;
        _messages.add(
          const _ChatMessage.text(
            type: _MsgType.ai,
            text:
                'I found some options for you. Let me know if you need more details!',
          ),
        );
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Top Bar ──────────────────────────────────────────────────────
          _ChatTopBar(),

          // ── Messages ─────────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (_isBotTyping && i == _messages.length) {
                  return const _TypingIndicator();
                }
                final msg = _messages[i];
                if (msg.type == _MsgType.ticket) {
                  return _TicketCard(ticket: msg.ticket!);
                }
                return _ChatBubble(message: msg);
              },
            ),
          ),

          // ── Input Bar ────────────────────────────────────────────────────
          _ChatInputBar(controller: _inputController, onSend: _sendMessage),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _ChatTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 15,
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Row(
        children: [
          // Logo
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/swifttrip_logo.svg',
              height: 30,
            ),
          ),
          const Spacer(),
          // Bookmark icon
          const Icon(
            Icons.bookmark_border_outlined,
            size: 24,
            color: Colors.black,
          ),
          const SizedBox(width: 16),
          // Close / X icon
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, size: 24, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CHAT BUBBLE  (AI left / User right)
// ─────────────────────────────────────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == _MsgType.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF2B99E3) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isUser ? 20 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.text!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isUser ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TICKET CARD
// ─────────────────────────────────────────────────────────────────────────────

class _TicketCard extends StatefulWidget {
  final _TicketData ticket;

  const _TicketCard({required this.ticket});

  @override
  State<_TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<_TicketCard> {
  bool _isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── FROM / TO ───────────────────────────────────────────────────
          Row(
            children: [
              _TicketCol(
                label: 'FROM',
                value: widget.ticket.from,
                valueBig: true,
              ),
              const SizedBox(width: 40),
              _TicketCol(label: 'TO', value: widget.ticket.to, valueBig: true),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFE0E0E0)),

          // ── DATE / DEPARTURE / ARRIVE ───────────────────────────────────
          Row(
            children: [
              _TicketCol(label: 'DATE', value: widget.ticket.date),
              const SizedBox(width: 20),
              _TicketCol(label: 'DEPARTURE', value: widget.ticket.departure),
              const SizedBox(width: 20),
              _TicketCol(label: 'ARRIVE', value: widget.ticket.arrive),
            ],
          ),
          const SizedBox(height: 10),

          // ── TRAIN / CARRIAGE / SEAT + TAMBAH button ─────────────────────
          Row(
            children: [
              _TicketCol(label: 'TRAIN', value: widget.ticket.train),
              const SizedBox(width: 20),
              _TicketCol(label: 'CARRIAGE', value: widget.ticket.carriage),
              const SizedBox(width: 20),
              _TicketCol(label: 'SEAT', value: widget.ticket.seat),
              const Spacer(),
              // Tambah button
              GestureDetector(
                onTap: _isAdded
                    ? null
                    : () {
                        setState(() {
                          _isAdded = true;
                        });
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _isAdded
                        ? const Color(0xFFDEDEDE)
                        : const Color(0xFF2B99E3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isAdded ? 'Ditambahkan' : 'Tambah',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: _isAdded ? const Color(0xFFAAAAAA) : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TicketCol extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBig;

  const _TicketCol({
    required this.label,
    required this.value,
    this.valueBig = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: valueBig ? 16 : 12,
            fontWeight: valueBig ? FontWeight.w700 : FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPING INDICATOR  (3 animated dots)
// ─────────────────────────────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    final offset =
                        sin((_controller.value * 2 * pi) - (i * pi / 2)) * 3;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 7,
                      height: 7,
                      transform: Matrix4.translationValues(0, offset, 0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2B99E3),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INPUT BAR  (bottom search bar)
// ─────────────────────────────────────────────────────────────────────────────

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatInputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 14,
      ),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: const StadiumBorder(),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onSend(),
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'Lets AI Help Your Journey',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.40),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            GestureDetector(
              onTap: onSend,
              child: SvgPicture.asset('assets/icons/magnifier.svg', height: 20),
            ),
          ],
        ),
      ),
    );
  }
}
