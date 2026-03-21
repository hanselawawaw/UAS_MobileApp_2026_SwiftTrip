import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryModel {
  final String label;
  final String? iconPath;
  final String? iconSvg;
  final Widget? targetPage;

  CategoryModel({
    required this.label,
    this.iconPath,
    this.iconSvg,
    this.targetPage,
  });
}

class CategoryItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (category.targetPage != null) {
          Navigator.of(context).push(SlideUpRoute(page: category.targetPage!));
        }
      },
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: OvalBorder(),
              shadows: [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: category.iconSvg != null
                  ? SvgPicture.string(
                      category.iconSvg!,
                      width: 30,
                      height: 30,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      category.iconPath!,
                      width: 30,
                      height: 30,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;
  SlideUpRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}
