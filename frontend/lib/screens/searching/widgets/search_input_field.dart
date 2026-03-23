import 'package:flutter/material.dart';

class SearchInputField extends StatelessWidget {
  final String? label;
  final IconData icon;
  final String value;
  final Widget? trailing;

  const SearchInputField({
    super.key,
    this.label,
    required this.icon,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 24,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      ],
    );
  }
}
