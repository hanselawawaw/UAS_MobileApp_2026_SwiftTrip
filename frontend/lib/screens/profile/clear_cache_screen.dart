import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClearCacheScreen extends StatefulWidget {
  const ClearCacheScreen({super.key});

  @override
  State<ClearCacheScreen> createState() => _ClearCacheScreenState();
}

class _ClearCacheScreenState extends State<ClearCacheScreen> {
  double _searchCache = 103;
  double _userCache = 0;
  double _downloadCache = 201;

  double get _totalCache => _searchCache + _userCache + _downloadCache;

  void _clearAllCache() {
    setState(() {
      _searchCache = 0;
      _userCache = 0;
      _downloadCache = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Cache cleared successfully',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Color(0xFF1B2236),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _fmtKb(double kb) {
    if (kb == 0) return '0 kb';
    return '${kb.toStringAsFixed(0)} kb';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: null,
      body: Column(
        children: [
          // ── Top Bar ────────────────────────────────────────────────────
          Container(
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
                  child: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ──────────────────────────────────────────────────────
            const Text(
              'Clear Cache',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const Divider(height: 24),

            // ── Cache rows ─────────────────────────────────────────────────
            _CacheRow(label: 'Search Cache', valueKb: _searchCache),
            const SizedBox(height: 6),
            _CacheRow(label: 'User Cache', valueKb: _userCache),
            const SizedBox(height: 6),
            _CacheRow(label: 'Download Cache', valueKb: _downloadCache),

            const Divider(height: 32),

            // ── Total ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Cache:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _fmtKb(_totalCache),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Clear Cache button (right-aligned) ─────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _clearAllCache,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Clear Cache',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
    );
  }
}

class _CacheRow extends StatelessWidget {
  final String label;
  final double valueKb;

  const _CacheRow({required this.label, required this.valueKb});

  @override
  Widget build(BuildContext context) {
    final display = valueKb == 0
        ? '0 kb'
        : '${valueKb.toStringAsFixed(0)} kb';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        Text(
          display,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}