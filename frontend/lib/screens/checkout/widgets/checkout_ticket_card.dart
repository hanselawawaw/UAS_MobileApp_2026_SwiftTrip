import 'package:flutter/material.dart';
import '../models/ticket_model.dart';

class CheckoutTicketCard extends StatelessWidget {
  final TicketModel ticket;

  const CheckoutTicketCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER BAR ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 17),
            decoration: const ShapeDecoration(
              color: Color(0xFF0098FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              ticket.type.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // ── CLASS LABEL ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket.classType.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (ticket.operator != null || ticket.airline != null)
                  Text(
                    (ticket.operator ?? ticket.airline)!,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, thickness: 1, color: Color(0x1A000000)),
          ),

          // ── FROM / TO ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TicketLabelValue(
                  label: 'FROM',
                  value: ticket.from,
                  isLarge: true,
                ),
                const Icon(Icons.compare_arrows, color: Colors.black26),
                _TicketLabelValue(
                  label: 'TO',
                  value: ticket.to,
                  isLarge: true,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, thickness: 1, color: Color(0x1A000000)),
          ),

          // ── ROW 1: DATE / DEPARTURE / ARRIVE ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TicketLabelValue(label: 'DATE', value: ticket.date),
                _TicketLabelValue(label: 'DEPARTURE', value: ticket.departureTime),
                _TicketLabelValue(label: 'ARRIVE', value: ticket.arrivalTime),
              ],
            ),
          ),

          // ── ROW 2: DYNAMIC DETAILS ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildDynamicDetails(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDynamicDetails() {
    final type = ticket.type.toLowerCase();
    
    if (type.contains('flight') || type.contains('plane')) {
      return [
        _TicketLabelValue(label: 'FLIGHT', value: ticket.flightNumber ?? '-'),
        _TicketLabelValue(label: 'AIRLINE', value: ticket.airline ?? '-'),
        const SizedBox(width: 40), // Spacer
      ];
    } else if (type.contains('train')) {
      return [
        _TicketLabelValue(label: 'TRAIN', value: ticket.trainNumber ?? '-'),
        _TicketLabelValue(label: 'CARRIAGE', value: ticket.carriage ?? '-'),
        _TicketLabelValue(label: 'SEAT', value: ticket.seatNumber ?? '-'),
      ];
    } else if (type.contains('bus')) {
      return [
        _TicketLabelValue(label: 'BUS', value: ticket.busNumber ?? '-'),
        _TicketLabelValue(label: 'OPERATOR', value: ticket.operator ?? '-'),
        const SizedBox(width: 40),
      ];
    } else if (type.contains('car')) {
      return [
        _TicketLabelValue(label: 'PLATE', value: ticket.carPlate ?? '-'),
        _TicketLabelValue(label: 'OPERATOR', value: ticket.operator ?? '-'),
        const SizedBox(width: 40),
      ];
    }
    
    return [
      _TicketLabelValue(label: 'OPERATOR', value: ticket.operator ?? '-'),
      const SizedBox(width: 40),
      const SizedBox(width: 40),
    ];
  }
}

class _TicketLabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;
  final CrossAxisAlignment crossAxisAlignment;

  const _TicketLabelValue({
    required this.label,
    required this.value,
    this.isLarge = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black38,
            fontSize: 10,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: isLarge ? 18 : 13,
            fontFamily: 'Poppins',
            fontWeight: isLarge ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

