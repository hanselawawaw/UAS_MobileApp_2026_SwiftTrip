import 'package:flutter/material.dart';

class CustomerServiceMenu extends StatelessWidget {
  const CustomerServiceMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 844,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Color(0xFF15233E)),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              width: 390,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Container(
                    width: double.infinity,
                    height: 47,
                    decoration: const BoxDecoration(color: Color(0x00F6F6F6)),
                    child: Stack(
                      children: [
                        const Positioned(
                          left: 35.33,
                          top: 15.33,
                          child: Text(
                            '9:41',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.66,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 300,
                          top: 16,
                          child: SizedBox(
                            width: 73,
                            height: 16,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 46.66,
                                  top: 2.33,
                                  child: SizedBox(
                                    width: 25,
                                    height: 12,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 2,
                                          top: 2,
                                          child: Container(
                                            width: 18.66,
                                            height: 8,
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1.33),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 347,
            top: 59,
            child: SizedBox(
              width: 25,
              height: 25,
              child: Stack(
                children: [
                  const Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(width: 25, height: 25),
                  ),
                  Positioned(
                    left: 5,
                    top: 6,
                    child: Container(
                      transform: Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(0.75),
                      width: 20.52,
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 5,
                    top: 20,
                    child: Container(
                      transform: Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(-0.75),
                      width: 20.52,
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 74,
            top: 412,
            child: SizedBox(
              width: 241,
              height: 20,
              child: Stack(
                children: [
                  const Positioned(
                    left: -64,
                    top: 0,
                    child: SizedBox(
                      width: 370,
                      child: Text(
                        'Customer Service',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFFF00),
                          fontSize: 28,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0.71,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -46,
                    top: -40,
                    child: Container(
                      width: 333,
                      height: 100,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: -40,
                    child: Container(
                      height: 100,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFFF00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
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
