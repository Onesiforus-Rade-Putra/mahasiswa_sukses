import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  Widget _diagonalBar({
    required double width,
    required double height,
    required double top,
    required double left,
    required List<Color> colors,
    double angle = -0.72,
    double radius = 30,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }

  Widget _whiteLine({
    required double width,
    required double top,
    required double left,
    double angle = -0.72,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: width,
          height: 2,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF2A3F),
                  Color(0xFFE31C3D),
                  Color(0xFFC10F2D),
                  Color(0xFF7A0012),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          _diagonalBar(
            width: 420,
            height: 88,
            top: 12,
            left: -90,
            colors: const [
              Color(0x22FFFFFF),
              Color(0x00FFFFFF),
            ],
            radius: 40,
          ),
          _diagonalBar(
            width: 470,
            height: 92,
            top: 175,
            left: -110,
            colors: const [
              Color(0x55FF334A),
              Color(0x00FF334A),
            ],
            radius: 40,
          ),
          _diagonalBar(
            width: 360,
            height: 86,
            top: 505,
            left: -25,
            colors: const [
              Color(0x66FF001E),
              Color(0x11FF001E),
            ],
            radius: 40,
          ),
          _diagonalBar(
            width: 430,
            height: 90,
            top: 170,
            left: -80,
            colors: const [
              Color(0x44FF2D45),
              Color(0x11FF2D45),
            ],
            radius: 40,
          ),
          _diagonalBar(
            width: 420,
            height: 92,
            top: 245,
            left: 40,
            colors: const [
              Color(0x33000000),
              Color(0x11000000),
            ],
            radius: 40,
          ),
          _diagonalBar(
            width: 280,
            height: 84,
            top: 640,
            left: 120,
            colors: const [
              Color(0x66FF001E),
              Color(0x11FF001E),
            ],
            radius: 40,
          ),
          _whiteLine(
            width: 70,
            top: 42,
            left: 230,
          ),
          _whiteLine(
            width: 135,
            top: 145,
            left: 100,
          ),
          _whiteLine(
            width: 78,
            top: 585,
            left: 235,
          ),
        ],
      ),
    );
  }
}
