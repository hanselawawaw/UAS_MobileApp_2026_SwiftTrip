import 'package:flutter/material.dart';

class HoldToConfirmBar extends StatefulWidget {
  final VoidCallback onConfirmed;

  const HoldToConfirmBar({
    super.key,
    required this.onConfirmed,
  });

  @override
  State<HoldToConfirmBar> createState() => _HoldToConfirmBarState();
}

class _HoldToConfirmBarState extends State<HoldToConfirmBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  static const Duration _holdDuration = Duration(milliseconds: 800);
  static const double _triggerThreshold = 0.95;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _holdDuration);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoldStart() => _controller.forward();

  void _onHoldEnd() {
    if (_progress.value >= _triggerThreshold) {
      widget.onConfirmed();
      _controller.reset();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
        top: 20,
      ),
      child: GestureDetector(
        onTapDown: (_) => _onHoldStart(),
        onTapUp: (_) => _onHoldEnd(),
        onTapCancel: _onHoldEnd,
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, child) {
            final scale = _progress.value;

            return Container(
              width: double.infinity,
              height: 50,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ── OUTER LIGHT BLUE CIRCLE ───────────────────────────────
                  if (scale > 0)
                    Transform.scale(
                      scale: scale * 12,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF90CAF9).withOpacity(0.45),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                  // ── INNER DARK BLUE CIRCLE ────────────────────────────────
                  if (scale > 0)
                    Transform.scale(
                      scale: scale * 10,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1565C0),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                  // ── LABEL ─────────────────────────────────────────────────
                  Text(
                    scale >= _triggerThreshold
                        ? 'Confirmed!'
                        : 'Hold to Confirm',
                    style: TextStyle(
                      color: scale > 0.3 ? Colors.white : Colors.black54,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
