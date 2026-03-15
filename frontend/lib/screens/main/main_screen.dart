import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../home/home.dart';
import '../cart/cart.dart';
import '../searching/searching.dart';
import '../destination/destination.dart';
import '../profile/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    HomePage(
      onNavigateToDestination: () {
        setState(() {
          _selectedIndex = 3;
        });
      },
    ),
    const CartPage(),
    const SearchingPage(),
    const DestinationPage(),
    const ProfilePage(),
  ];

  final List<Widget> _navIcons = [
    const Icon(Icons.home_outlined, size: 28, color: Colors.white),
    const Icon(Icons.shopping_cart_outlined, size: 28, color: Colors.white),
    SvgPicture.string(
      '''<svg width="31" height="31" viewBox="0 0 31 31" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M27.5059 1.25C28.1003 1.25246 28.6695 1.48983 29.0898 1.91016C29.5102 2.33048 29.7475 2.89972 29.75 3.49414C29.7524 4.0869 29.5211 4.65668 29.1064 5.08008L23.2559 10.9287C22.9602 11.2244 22.8319 11.6486 22.9141 12.0586L26.082 27.8184C26.096 27.8878 26.0901 28.1079 25.8643 28.458C25.6489 28.7917 25.3114 29.1136 24.9443 29.3291C24.5608 29.5542 24.2845 29.5843 24.165 29.5654C24.1447 29.5622 24.0433 29.574 23.9258 29.2725L19.29 17.375C19.1368 16.9818 18.7958 16.6923 18.3828 16.6055C18.0213 16.5296 17.6471 16.6176 17.3594 16.8408L17.2422 16.9453L11.2227 22.9648C10.9627 23.2248 10.8298 23.5858 10.8604 23.9521C11.0122 25.775 11.0688 26.7203 10.8721 27.5205C10.7669 27.9482 10.574 28.3726 10.1904 28.8936L7.32031 24.1084C7.24123 23.9766 7.13897 23.8607 7.01855 23.7666L6.8916 23.6797L2.10547 20.8086C2.62664 20.4247 3.0517 20.2322 3.47949 20.127C4.27933 19.9302 5.22462 19.987 7.04688 20.1396C7.41341 20.1704 7.77503 20.0374 8.03516 19.7773L14.0547 13.7598C14.3532 13.4613 14.4812 13.0323 14.3945 12.6191C14.3078 12.2061 14.0183 11.8642 13.625 11.7109L1.72754 7.07422C1.4262 6.9568 1.43786 6.8556 1.43457 6.83496C1.4156 6.71541 1.44578 6.43939 1.6709 6.05566C1.88636 5.68848 2.20844 5.35099 2.54199 5.13574C2.89191 4.91005 3.11151 4.90402 3.18066 4.91797H3.18164L18.9404 8.08594C19.3506 8.16837 19.7755 8.03994 20.0713 7.74414L25.916 1.89746C26.3398 1.48056 26.9114 1.24757 27.5059 1.25Z" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''',
      width: 28,
      height: 28,
      fit: BoxFit.contain,
    ),
    const Icon(Icons.domain_outlined, size: 28, color: Colors.white),
    const Icon(Icons.person_outline, size: 28, color: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF6F6F6),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.transparent,
        color: const Color(0xFF1B2236),
        buttonBackgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        height: 70,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: List.generate(_navIcons.length, (index) {
          final isSelected = _selectedIndex == index;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF5A9AE5) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(child: _navIcons[index]),
          );
        }),
      ),
    );
  }
}
