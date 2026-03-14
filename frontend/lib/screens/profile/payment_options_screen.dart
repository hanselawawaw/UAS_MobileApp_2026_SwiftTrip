import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

class _PaymentMethod {
  final String id;
  final String name;

  const _PaymentMethod({required this.id, required this.name});
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT OPTIONS SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class PaymentOptionsScreen extends StatefulWidget {
  const PaymentOptionsScreen({super.key});

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  // Which payment method is currently expanded (null = none)
  String? _expandedId;

  final List<_PaymentMethod> _methods = const [
    _PaymentMethod(id: 'abc', name: 'ABC'),
    _PaymentMethod(id: 'masterbank', name: 'Master Bank'),
    _PaymentMethod(id: 'visa', name: 'Visa'),
  ];

  // Per-method form controllers
  final Map<String, TextEditingController> _cardNumberControllers = {};
  final Map<String, TextEditingController> _expireControllers = {};
  final Map<String, TextEditingController> _cvcControllers = {};

  @override
  void initState() {
    super.initState();
    for (final m in _methods) {
      _cardNumberControllers[m.id] = TextEditingController();
      _expireControllers[m.id] = TextEditingController();
      _cvcControllers[m.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _cardNumberControllers.values) c.dispose();
    for (final c in _expireControllers.values) c.dispose();
    for (final c in _cvcControllers.values) c.dispose();
    super.dispose();
  }

  void _toggle(String id) {
    setState(() => _expandedId = _expandedId == id ? null : id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Bar ────────────────────────────────────────────────────
          _TopBar(),

          // ── Title + Divider ────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text(
              'Payment Options',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: Colors.black,
              ),
            ),
          ),
          const Divider(height: 20, indent: 20, endIndent: 20),

          // ── Payment methods list ───────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
              itemCount: _methods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final method = _methods[i];
                final isExpanded = _expandedId == method.id;
                return _PaymentCard(
                  method: method,
                  isExpanded: isExpanded,
                  onTap: () => _toggle(method.id),
                  cardNumberController: _cardNumberControllers[method.id]!,
                  expireController: _expireControllers[method.id]!,
                  cvcController: _cvcControllers[method.id]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
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
          SvgPicture.asset('assets/icons/swifttrip_logo.svg', height: 30),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT CARD  — accordion item
// ─────────────────────────────────────────────────────────────────────────────

class _PaymentCard extends StatelessWidget {
  final _PaymentMethod method;
  final bool isExpanded;
  final VoidCallback onTap;
  final TextEditingController cardNumberController;
  final TextEditingController expireController;
  final TextEditingController cvcController;

  const _PaymentCard({
    required this.method,
    required this.isExpanded,
    required this.onTap,
    required this.cardNumberController,
    required this.expireController,
    required this.cvcController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header row ─────────────────────────────────────────────────
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Percentage / badge icon
                  SvgPicture.asset(
                    'assets/icons/percentage.svg',
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 14),
                  // Name
                  Expanded(
                    child: Text(
                      method.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Chevron / check icon
                  AnimatedRotation(
                    turns: isExpanded ? 0 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.chevron_right,
                      size: 24,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded form ─────────────────────────────────────────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _CardForm(
              cardNumberController: cardNumberController,
              expireController: expireController,
              cvcController: cvcController,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD FORM  — Card Number + Expire + CVC
// ─────────────────────────────────────────────────────────────────────────────

class _CardForm extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController expireController;
  final TextEditingController cvcController;

  const _CardForm({
    required this.cardNumberController,
    required this.expireController,
    required this.cvcController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Number ─────────────────────────────────────────────────
          const Text(
            'Card Number',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          _InputBox(
            controller: cardNumberController,
            hintText: '****-****-****-***',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
          ),
          const SizedBox(height: 12),

          // ── Expire + CVC ────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expire
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expire',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _InputBox(
                      controller: expireController,
                      hintText: 'DD/MM/YYYY',
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _DateFormatter(),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // CVC
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CVC',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _InputBox(
                      controller: cvcController,
                      hintText: '.........',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(
                        Icons.credit_card_outlined,
                        size: 18,
                        color: Colors.black54,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INPUT BOX
// ─────────────────────────────────────────────────────────────────────────────

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final bool obscureText;

  const _InputBox({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            const SizedBox(width: 10),
            prefixIcon!,
          ],
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              obscureText: obscureText,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.black26,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: prefixIcon == null ? 12 : 6,
                  right: 12,
                  bottom: 2,
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TEXT FORMATTERS
// ─────────────────────────────────────────────────────────────────────────────

/// Formats card number as ****-****-****-***
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('-', '');
    if (digits.length > 16) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('-');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formats date as DD/MM/YYYY
class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    if (digits.length > 8) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}