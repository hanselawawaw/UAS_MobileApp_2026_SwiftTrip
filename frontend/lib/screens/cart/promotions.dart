import 'package:flutter/material.dart';
import '../../widgets/top_bar.dart';

class Promotion {
  final String id;
  final String title;
  final String dateRange;
  final String description;

  const Promotion({
    required this.id,
    required this.title,
    required this.dateRange,
    required this.description,
  });
}

class PromotionsPage extends StatefulWidget {
  final Promotion? initialSelection;

  const PromotionsPage({super.key, this.initialSelection});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  Promotion? _selectedPromo;

  final List<Promotion> _promotions = const [
    Promotion(
      id: 'promo_1',
      title: 'Family Discount',
      dateRange: '12 Feb 2024 - 12 Mar 2025',
      description: 'Discount 10% with minimum Rp 1.000.000 purchases',
    ),
    Promotion(
      id: 'promo_2',
      title: 'Student Getaway',
      dateRange: '01 Jan 2024 - 31 Dec 2024',
      description: 'Discount 15% with valid student ID card',
    ),
    Promotion(
      id: 'promo_3',
      title: 'Weekend Flash Sale',
      dateRange: 'Every Saturday - Sunday',
      description: 'Cashback Rp 50.000 with no minimum purchase',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPromo = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const TopBar(showBackButton: true, showHamburger: false),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _promotions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final promo = _promotions[index];
                  final isSelected = _selectedPromo?.id == promo.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPromo = isSelected ? null : promo;
                      });
                    },
                    child: PromoCard(promotion: promo, isSelected: isSelected),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16, bottom: 40),
              child: _ConfirmButton(
                onTap: () => Navigator.pop(context, _selectedPromo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final Promotion promotion;
  final bool isSelected;

  const PromoCard({
    super.key,
    required this.promotion,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? const Color(0xFF5997F7) : Colors.white;
    final textColor = isSelected ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.discount_outlined, color: textColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promotion.title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promotion.dateRange,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promotion.description,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_ios_rounded, color: textColor, size: 20),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ConfirmButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 271,
        height: 48,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'Confirm',
          style: TextStyle(
            color: Color(0xFF616161),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
