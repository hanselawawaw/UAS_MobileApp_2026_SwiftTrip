import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';

class CouponOverlay extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCancel;
  final VoidCallback onUse;

  const CouponOverlay({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const ShapeDecoration(
        color: Color(0xFFF6F6F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──────────────────────────────────────────────────
          Center(
            child: Text(
              langProvider.translate('use_coupon'),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Coupon label ────────────────────────────────────────────
          Text(
            langProvider.translate('coupon_label'),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // ── Input row ───────────────────────────────────────────────
          Row(
            children: [
              const Icon(
                Icons.discount_outlined,
                size: 20,
                color: Colors.black54,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: langProvider.translate('have_coupon_hint'),
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0x99999999),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const Icon(Icons.copy_outlined, size: 18, color: Colors.black45),
            ],
          ),

          const Divider(color: Color(0x4D000000), thickness: 1),
          const SizedBox(height: 12),

          // ── Action buttons ──────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onCancel,
                child: Container(
                  width: 60,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFDFDFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    langProvider.translate('cancel_button'),
                    style: TextStyle(
                      color: const Color(0xFF999999),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      shadows: [
                        Shadow(
                          offset: Offset.zero,
                          blurRadius: 8,
                          color: Colors.black.withValues(alpha: 0.25),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onUse,
                child: Container(
                  width: 60,
                  height: 28,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2B99E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    langProvider.translate('use_button'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
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
