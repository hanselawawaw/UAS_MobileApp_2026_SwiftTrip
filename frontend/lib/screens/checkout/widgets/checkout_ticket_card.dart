import 'package:flutter/material.dart';
import '../../cart/models/cart_models.dart';

class CheckoutTicketCard extends StatelessWidget {
  final CartTicket ticket;

  const CheckoutTicketCard({super.key, required this.ticket});

  String _formatRp(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp. ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final isAccommodation = ticket.type == 'Accommodation Ticket';
    final headerColor = isAccommodation
        ? const Color(0xFFA83029)
        : const Color(0xFF0098FF);

    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: ShapeDecoration(
              color: headerColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  ticket.type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    ticket.bookingId,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (isAccommodation) ...[
            // ── Hotel image ──────────────────────────────────────────
            ClipRRect(
              child: ticket.imageUrl != null
                  ? Image.network(
                      ticket.imageUrl!,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 120,
                        color: const Color(0xFFE0E0E0),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.hotel,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 120,
                      color: const Color(0xFFE0E0E0),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.hotel,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
            ),

            // ── DATE / STAY / BED ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  _LabelValue(label: 'DATE', value: ticket.stayDate ?? '-'),
                  const SizedBox(width: 24),
                  _LabelValue(label: 'STAY', value: ticket.stayDuration ?? '-'),
                  const SizedBox(width: 24),
                  _LabelValue(label: 'BED', value: ticket.bedType ?? '-'),
                ],
              ),
            ),

            // ── LOCATION ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: _LabelValue(
                label: 'LOCATION',
                value: ticket.location ?? '-',
              ),
            ),
          ] else ...[
            // ── Class label (shared for all transport) ───────────────
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, bottom: 6),
              child: Text(
                ticket.classLabel,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const _TicketDivider(),

            // ── FROM / TO (shared) ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child:
                  (ticket.type == 'Plane Ticket' &&
                      ticket.flightRoute != null &&
                      ticket.flightRoute!.isNotEmpty)
                  ? _FlightBreadcrumb(codes: ticket.flightRoute!)
                  : Row(
                      children: [
                        _LabelValue(
                          label: 'FROM',
                          value: ticket.from ?? '-',
                          isLarge: true,
                        ),
                        const SizedBox(width: 100),
                        _LabelValue(
                          label: 'TO',
                          value: ticket.to ?? '-',
                          isLarge: true,
                        ),
                      ],
                    ),
            ),

            const _TicketDivider(),

            // ── DATE / DEPARTURE / ARRIVE (shared) ───────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  _LabelValue(label: 'DATE', value: ticket.date ?? '-'),
                  const SizedBox(width: 40),
                  _LabelValue(
                    label: 'DEPARTURE',
                    value: ticket.departure ?? '-',
                  ),
                  const SizedBox(width: 40),
                  _LabelValue(label: 'ARRIVE', value: ticket.arrive ?? '-'),
                ],
              ),
            ),

            // ── Type-specific bottom row ──────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Row(children: _buildTypeSpecificRow(ticket)),
            ),
          ],

          const _TicketDivider(),

          // ── Price (shared for both types) ─────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _formatRp(ticket.priceRp),
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 15,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTypeSpecificRow(CartTicket ticket) {
    switch (ticket.type) {
      case 'Train Ticket':
        return [
          _LabelValue(label: 'OPERATOR', value: ticket.operator ?? '-'),
          const SizedBox(width: 40),
          _LabelValue(label: 'CARRIAGE', value: ticket.carriage ?? '-'),
          const SizedBox(width: 40),
          _LabelValue(label: 'SEAT', value: ticket.seat ?? '-'),
        ];
      case 'Plane Ticket':
        return [
          _LabelValue(label: 'OPERATOR', value: ticket.operator ?? '-'),
          const SizedBox(width: 40),
          _LabelValue(label: 'FLIGHT', value: ticket.flightNumber ?? '-'),
          const SizedBox(width: 40),
          _LabelValue(label: 'CLASS', value: ticket.flightClass ?? '-'),
        ];
      case 'Bus Ticket':
        return [
          _LabelValue(label: 'OPERATOR', value: ticket.operator ?? '-'),
          const SizedBox(width: 40),
          _LabelValue(label: 'CLASS', value: ticket.busClass ?? '-'),
          const SizedBox(width: 40),
          _LabelValue(label: 'BUS NO.', value: ticket.busNumber ?? '-'),
        ];
      case 'Car Ticket':
        return [
          _LabelValue(label: 'CAR', value: ticket.operator ?? '-'),
          const SizedBox(width: 40),
          _LabelValue(label: 'PLATE', value: ticket.carPlate ?? '-'),
          const SizedBox(width: 40),
          _LabelValue(label: 'DRIVER', value: ticket.driverName ?? '-'),
        ];
      default:
        return [];
    }
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;

  const _LabelValue({
    required this.label,
    required this.value,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: isLarge ? 16 : 10,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _FlightBreadcrumb extends StatelessWidget {
  final List<String> codes;
  const _FlightBreadcrumb({required this.codes});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < codes.length; i++) ...[
            Text(
              codes[i],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
              ),
            ),
            if (i < codes.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 1,
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                    const SizedBox(width: 2),
                    Transform.rotate(
                      angle: 1.57,
                      child: Icon(
                        Icons.airplanemode_active,
                        size: 10,
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      width: 4,
                      height: 1,
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _TicketDivider extends StatelessWidget {
  const _TicketDivider();
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 13,
      endIndent: 13,
      color: Colors.black.withValues(alpha: 0.30),
    );
  }
}
