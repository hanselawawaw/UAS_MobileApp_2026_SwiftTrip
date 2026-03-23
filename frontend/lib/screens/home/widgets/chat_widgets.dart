import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../main/main_screen.dart';
import '../order_ticket.dart';
import '../models/chat_message.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class ChatTopBar extends StatelessWidget {
  const ChatTopBar({super.key});

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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderTicketPage(),
                ),
              );
            },
            child: const Icon(
              Icons.bookmark_border_outlined,
              size: 24,
              color: Colors.black,
            ),
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

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatBubbleWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MsgType.user;

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

class ChatTicketCard extends StatefulWidget {
  final TicketData ticket;

  const ChatTicketCard({super.key, required this.ticket});

  @override
  State<ChatTicketCard> createState() => _ChatTicketCardState();
}

class _ChatTicketCardState extends State<ChatTicketCard> {
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
              TicketCol(
                label: 'FROM',
                value: widget.ticket.from,
                valueBig: true,
              ),
              const SizedBox(width: 40),
              TicketCol(label: 'TO', value: widget.ticket.to, valueBig: true),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFE0E0E0)),

          // ── DATE / DEPARTURE / ARRIVE ───────────────────────────────────
          Row(
            children: [
              TicketCol(label: 'DATE', value: widget.ticket.date),
              const SizedBox(width: 20),
              TicketCol(label: 'DEPARTURE', value: widget.ticket.departure),
              const SizedBox(width: 20),
              TicketCol(label: 'ARRIVE', value: widget.ticket.arrive),
            ],
          ),
          const SizedBox(height: 10),

          // ── TRAIN / CARRIAGE / SEAT + TAMBAH button ─────────────────────
          Row(
            children: [
              TicketCol(label: 'TRAIN', value: widget.ticket.train),
              const SizedBox(width: 20),
              TicketCol(label: 'CARRIAGE', value: widget.ticket.carriage),
              const SizedBox(width: 20),
              TicketCol(label: 'SEAT', value: widget.ticket.seat),
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

class TicketCol extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBig;

  const TicketCol({
    super.key,
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

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
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

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({super.key, required this.controller, required this.onSend});

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
