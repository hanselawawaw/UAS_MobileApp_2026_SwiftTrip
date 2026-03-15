import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/top_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODEL — backend-friendly, swap with fromJson later
// ─────────────────────────────────────────────────────────────────────────────

class CartTicket {
  final String type;
  final String bookingId;
  final String classLabel;
  final String from;
  final String to;
  final String date;
  final String departure;
  final String arrive;
  final String train;
  final String carriage;
  final String seat;
  final int priceRp;

  const CartTicket({
    required this.type,
    required this.bookingId,
    required this.classLabel,
    required this.from,
    required this.to,
    required this.date,
    required this.departure,
    required this.arrive,
    required this.train,
    required this.carriage,
    required this.seat,
    required this.priceRp,
  });
}

// CART PAGE
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartTicket> _tickets = [
    const CartTicket(
      type: 'Train Ticket',
      bookingId: 'ID-1231KADASMASDKAASD',
      classLabel: 'ECONOMY CLASS',
      from: 'Jakarta',
      to: 'Ngawi Barat',
      date: '19/2/2026',
      departure: '9:00',
      arrive: '11:00',
      train: '1234',
      carriage: '01',
      seat: 'A12',
      priceRp: 100000,
    ),
    const CartTicket(
      type: 'Train Ticket',
      bookingId: 'ID-1231KADASMASDKAASD',
      classLabel: 'ECONOMY CLASS',
      from: 'Jakarta',
      to: 'Solo',
      date: '19/2/2026',
      departure: '13:00',
      arrive: '16:00',
      train: '5678',
      carriage: '02',
      seat: 'B7',
      priceRp: 200000,
    ),
    const CartTicket(
      type: 'Train Ticket',
      bookingId: 'ID-7HSG2JSK8291',
      classLabel: 'BUSINESS CLASS',
      from: 'Bandung',
      to: 'Yogyakarta',
      date: '20/2/2026',
      departure: '08:30',
      arrive: '12:10',
      train: '3345',
      carriage: '03',
      seat: 'A4',
      priceRp: 350000,
    ),
  ];

  String _promoCode = '';
  int get _total => _tickets.fold(0, (sum, t) => sum + t.priceRp);

  void _removeTicket(int index) {
    setState(() => _tickets.removeAt(index));
  }

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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          const TopBar(),
          const SizedBox(height: 20),

          // ── Independent Ticket Scroll Area ────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 40,
              ),
              child: Column(
                children: List.generate(
                  _tickets.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TicketCard(
                      ticket: _tickets[i],
                      formatRp: _formatRp,
                      onDelete: () => _removeTicket(i),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Pinned Bottom Section ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 110),
            child: Column(
              children: const [
                ApplyPromotionsRow(),
                SizedBox(height: 12),
                _TotalConfirmBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// TICKET CARD
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
          // ── Blue header bar ─────────────────────────────────────────
          CardHeader(type: ticket.type, bookingId: ticket.bookingId),

          // ── Class label ─────────────────────────────────────────────
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

          // ── FROM / TO ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                LabelValue(label: 'FROM', value: ticket.from),
                const SizedBox(width: 100),
                LabelValue(label: 'TO', value: ticket.to),
              ],
            ),
          ),

          const TicketDivider(),

          // ── DATE / DEPARTURE / ARRIVE ───────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                LabelValue(label: 'DATE', value: ticket.date),
                const SizedBox(width: 40),
                LabelValue(label: 'DEPARTURE', value: ticket.departure),
                const SizedBox(width: 40),
                LabelValue(label: 'ARRIVE', value: ticket.arrive),
              ],
            ),
          ),

          // ── TRAIN / CARRIAGE / SEAT ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Row(
              children: [
                LabelValue(label: 'TRAIN', value: ticket.train),
                const SizedBox(width: 40),
                LabelValue(label: 'CARRIAGE', value: ticket.carriage),
                const SizedBox(width: 40),
                LabelValue(label: 'SEAT', value: ticket.seat),
              ],
            ),
          ),

          const TicketDivider(),

          // ── Delete button + Price ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Row(
              children: [
                // Delete button
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

                // Price
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

  const CardHeader({super.key, required this.type, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const ShapeDecoration(
        color: Color(0xFF0098FF),
        shape: RoundedRectangleBorder(
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
          Text(
            bookingId,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// LABEL + VALUE column (DATE / Jakarta etc.)
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

// DIVIDER
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

// APPLY PROMOTIONS ROW
class ApplyPromotionsRow extends StatelessWidget {
  const ApplyPromotionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 59,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.string(
            '''<svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.34471 1.73976C9.5531 1.50701 9.80824 1.32082 10.0935 1.19335C10.3787 1.06588 10.6876 1 11 1C11.3124 1 11.6213 1.06588 11.9065 1.19335C12.1918 1.32082 12.4469 1.50701 12.6553 1.73976L13.4329 2.60854C13.6552 2.85684 13.9305 3.05196 14.2383 3.17946C14.5462 3.30696 14.8788 3.36358 15.2116 3.34511L16.378 3.28068C16.69 3.26348 17.0022 3.31228 17.294 3.42391C17.5859 3.53553 17.8509 3.70746 18.0718 3.92847C18.2927 4.14948 18.4645 4.41461 18.576 4.70652C18.6875 4.99844 18.7361 5.3106 18.7188 5.6226L18.6543 6.78801C18.636 7.12055 18.6927 7.45296 18.8202 7.76065C18.9477 8.06833 19.1427 8.34341 19.3909 8.56556L20.2596 9.34323C20.4926 9.55164 20.6789 9.80685 20.8065 10.0922C20.9341 10.3775 21 10.6866 21 10.9991C21 11.3117 20.9341 11.6207 20.8065 11.9061C20.6789 12.1914 20.4926 12.4466 20.2596 12.655L19.3909 13.4327C19.1426 13.655 18.9475 13.9302 18.82 14.2381C18.6925 14.546 18.6359 14.8786 18.6543 15.2114L18.7188 16.3779C18.736 16.6899 18.6872 17.002 18.5755 17.2939C18.4639 17.5858 18.292 17.8508 18.071 18.0717C17.85 18.2926 17.5849 18.4644 17.293 18.5759C17.0011 18.6874 16.6889 18.7361 16.3769 18.7187L15.2116 18.6543C14.879 18.636 14.5466 18.6927 14.2389 18.8202C13.9313 18.9477 13.6562 19.1427 13.4341 19.3908L12.6564 20.2596C12.448 20.4926 12.1928 20.6789 11.9075 20.8065C11.6221 20.9341 11.3131 21 11.0006 21C10.688 21 10.379 20.9341 10.0936 20.8065C9.80831 20.6789 9.55311 20.4926 9.34471 20.2596L8.56705 19.3908C8.3448 19.1425 8.06954 18.9474 7.76166 18.8199C7.45378 18.6924 7.12117 18.6358 6.78845 18.6543L5.62197 18.7187C5.30996 18.7359 4.99784 18.6871 4.70599 18.5755C4.41413 18.4639 4.1491 18.2919 3.9282 18.0709C3.7073 17.8499 3.5355 17.5848 3.42402 17.2929C3.31253 17.0009 3.26388 16.6888 3.28123 16.3768L3.34566 15.2114C3.36396 14.8788 3.30726 14.5464 3.17977 14.2387C3.05228 13.9311 2.85725 13.656 2.60911 13.4338L1.74036 12.6561C1.50743 12.4477 1.32109 12.1925 1.19352 11.9072C1.06594 11.6218 1 11.3128 1 11.0002C1 10.6877 1.06594 10.3786 1.19352 10.0933C1.32109 9.80797 1.50743 9.55276 1.74036 9.34435L2.60911 8.56667C2.8574 8.34441 3.05252 8.06914 3.18001 7.76125C3.30751 7.45336 3.36412 7.12074 3.34566 6.78801L3.28123 5.62149C3.26419 5.30957 3.31311 4.99756 3.42481 4.70583C3.5365 4.4141 3.70845 4.14919 3.92944 3.92841C4.15042 3.70762 4.41548 3.53592 4.70731 3.4245C4.99914 3.31308 5.31118 3.26445 5.62308 3.28179L6.78845 3.34622C7.12098 3.36452 7.45338 3.30782 7.76106 3.18033C8.06873 3.05283 8.34381 2.8578 8.56594 2.60965L9.34471 1.73976Z" stroke="black" stroke-width="2"/>
<path d="M8.22229 8.22266H8.2334V8.23377H8.22229V8.22266ZM13.777 13.7775H13.7881V13.7886H13.777V13.7775Z" stroke="black" stroke-width="3" stroke-linejoin="round"/>
<path d="M14.3331 7.66699L7.66748 14.3328" stroke="black" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''',
            width: 22,
            height: 22,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Apply Promotions',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: 18,
          ),
        ],
      ),
    );
  }
}

// TOTAL + CONFIRM BAR
class _TotalConfirmBar extends StatelessWidget {
  const _TotalConfirmBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 59,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
              Text(
                'Rp. 300.000',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  height: 1.25,
                ),
              ),
            ],
          ),
          Container(
            width: 103,
            height: 32,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: const Color(0xFF2B99E3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: Color(0xFFE5E5E5),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
