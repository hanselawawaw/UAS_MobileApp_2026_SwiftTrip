import 'package:flutter/material.dart';
import '../models/payment_method_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel paymentMethod;
  final bool isExpanded;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const Icon(Icons.discount_outlined, color: Colors.black),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    paymentMethod.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.arrow_forward_ios_rounded,
                  color: Colors.black,
                  size: isExpanded ? 28 : 20,
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 20),
            _buildInputField('Card Number', '****-****-****-****'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInputField('Expire', 'DD/MM/YYYY')),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    'CVC',
                    '***',
                    prefixIcon: Icons.credit_card_outlined,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {IconData? prefixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black87),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 20, color: Colors.black87),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
