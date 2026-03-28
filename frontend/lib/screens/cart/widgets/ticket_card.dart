import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/cart_models.dart';

class TicketCard extends StatelessWidget {
  final CartTicket ticket;
  final String Function(int) formatRp;
  final VoidCallback? onDelete;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.formatRp,
    this.onDelete,
  });

  List<Widget> _buildTypeSpecificRow(CartTicket ticket) {
    switch (ticket.type) {
      case 'Train Ticket':
        return [
          LabelValue(label: 'OPERATOR', value: ticket.operator ?? '-'),
          const SizedBox(width: 40),
          LabelValue(label: 'CARRIAGE', value: ticket.carriage ?? '-'),
          const SizedBox(width: 40),
          LabelValue(label: 'SEAT', value: ticket.seat ?? '-'),
        ];

      case 'Plane Ticket':
        return [
          LabelValue(label: 'OPERATOR', value: ticket.operator ?? '-'),
          const SizedBox(width: 40),
          LabelValue(label: 'FLIGHT', value: ticket.flightNumber ?? '-'),
          const SizedBox(width: 40),
          LabelValue(label: 'CLASS', value: ticket.flightClass ?? '-'),
        ];

      case 'Bus Ticket':
        return [
          LabelValue(label: 'OPERATOR', value: ticket.operator ?? '-'),
          const SizedBox(width: 40),
          LabelValue(label: 'CLASS', value: ticket.busClass ?? '-'),
          const SizedBox(width: 40),
          LabelValue(label: 'BUS NO.', value: ticket.busNumber ?? '-'),
        ];

      case 'Car Ticket':
        return [
          LabelValue(label: 'CAR', value: ticket.operator ?? '-'),
          const SizedBox(width: 40),
          LabelValue(label: 'PLATE', value: ticket.carPlate ?? '-'),
          const SizedBox(width: 40),
          LabelValue(label: 'DRIVER', value: ticket.driverName ?? '-'),
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
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
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            type: ticket.type,
            bookingId: ticket.bookingId,
            color: ticket.type == 'Accommodation Ticket'
                ? const Color(0xFFA83029)
                : const Color(0xFF0098FF),
          ),

          if (ticket.type == 'Accommodation Ticket') ...[
            // ── Hotel image ──────────────────────────────────────────
            ClipRRect(
              child: ticket.imageUrl != null
                  ? Image.network(
                      ticket.imageUrl!,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
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
                  LabelValue(label: 'DATE', value: ticket.stayDate ?? '-'),
                  const SizedBox(width: 24),
                  LabelValue(label: 'STAY', value: ticket.stayDuration ?? '-'),
                  const SizedBox(width: 24),
                  LabelValue(label: 'BED', value: ticket.bedType ?? '-'),
                ],
              ),
            ),

            // ── LOCATION ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: LabelValue(
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

            const TicketDivider(),

            // ── FROM / TO (shared) ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: (ticket.type == 'Plane Ticket' &&
                      ticket.flightRoute != null &&
                      ticket.flightRoute!.isNotEmpty)
                  ? _FlightBreadcrumb(codes: ticket.flightRoute!)
                  : Row(
                      children: [
                        LabelValue(label: 'FROM', value: ticket.from ?? '-'),
                        const SizedBox(width: 100),
                        LabelValue(label: 'TO', value: ticket.to ?? '-'),
                      ],
                    ),
            ),

            const TicketDivider(),

            // ── DATE / DEPARTURE / ARRIVE (shared) ───────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  LabelValue(label: 'DATE', value: ticket.date ?? '-'),
                  const SizedBox(width: 40),
                  LabelValue(
                    label: 'DEPARTURE',
                    value: ticket.departure ?? '-',
                  ),
                  const SizedBox(width: 40),
                  LabelValue(label: 'ARRIVE', value: ticket.arrive ?? '-'),
                ],
              ),
            ),

            // ── Type-specific bottom row ──────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Row(children: _buildTypeSpecificRow(ticket)),
            ),
          ],

          const TicketDivider(),

          // ── Delete button + Price (shared for both types) ─────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Row(
              children: [
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0x60FF7C7C),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.string(
                          '''<svg width="15" height="15" viewBox="4.66 0.38 10.68 11.24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M7.99810 0.381836V1.00614H4.66162V2.25454H5.32893V10.3695C5.32893 10.7006 5.46954 11.0181 5.71983 11.2523C5.97012 11.4864 6.30963 11.6179 6.66354 11.6179H13.3365C13.6904 11.6179 14.0299 11.4864 14.2802 11.2523C14.5305 11.0181 14.6711 10.7006 14.6711 10.3695V2.25454H15.3384V1.00614H12.0019V0.381836H7.99810ZM6.66354 2.25454H13.3365V10.3695H6.66354V2.25454ZM7.99810 3.50295V9.12095H9.33270V3.50295H7.99810ZM10.6673 3.50295V9.12095H12.0019V3.50295H10.6673Z" fill="white"/>
</svg>''',
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  formatRp(ticket.priceRp),
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
}

class CardHeader extends StatelessWidget {
  final String type;
  final String bookingId;
  final Color color;

  const CardHeader({
    super.key,
    required this.type,
    required this.bookingId,
    this.color = const Color(0xFF0098FF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: ShapeDecoration(
        color: color,
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
            type,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              bookingId,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LabelValue extends StatelessWidget {
  final String label;
  final String value;

  const LabelValue({super.key, required this.label, required this.value});

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
            fontSize: label == 'FROM' || label == 'TO' ? 16 : 10,
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
        mainAxisAlignment: codes.length >= 6
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
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
                        width: 4, height: 1, color: Colors.black.withOpacity(0.2)),
                    const SizedBox(width: 2),
                    Transform.rotate(
                        angle: 1.57,
                        child: Icon(Icons.airplanemode_active,
                            size: 10, color: Colors.black.withOpacity(0.3))),
                    const SizedBox(width: 2),
                    Container(
                        width: 4, height: 1, color: Colors.black.withOpacity(0.2)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class TicketDivider extends StatelessWidget {
  const TicketDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 13,
      endIndent: 13,
      color: Colors.black.withOpacity(0.30),
    );
  }
}
