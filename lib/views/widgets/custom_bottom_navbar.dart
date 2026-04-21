import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.forum_outlined,
    Icons.psychology_outlined,
    Icons.bar_chart_rounded,
    Icons.settings,
  ];

  static const List<String> _labels = [
    'Home',
    'Forum',
    'Quiz',
    'Leaderboard',
    'Setelan',
  ];

  @override
  Widget build(BuildContext context) {
    const Color navColor = Color(0xFFED1E28);

    return SafeArea(
      top: false,
      child: SizedBox(
        height: 122,
        child: LayoutBuilder(
          builder: (context, constraints) {
            const double circleSize = 60;
            const double bodyHeight = 100;

            final double width = constraints.maxWidth;
            final double itemWidth = width / 5;

            const List<double> itemOffsets = [10, 5, 0, -5, -10];

            final double centerX = (itemWidth * currentIndex) +
                (itemWidth / 2) +
                itemOffsets[currentIndex];

            final double circleLeft = centerX - (circleSize / 2);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CustomPaint(
                    size: Size(width, bodyHeight),
                    painter: _NavbarPainter(
                      activeCenterX: centerX,
                      color: navColor,
                    ),
                    child: SizedBox(
                      height: bodyHeight,
                      child: Row(
                        children: List.generate(5, (index) {
                          final bool isActive = index == currentIndex;

                          return SizedBox(
                            width: itemWidth,
                            child: Transform.translate(
                              offset: Offset(itemOffsets[index], 0),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: InkWell(
                                    onTap: () => onTap?.call(index),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 31,
                                        bottom: 19,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (!isActive)
                                            Icon(
                                              _icons[index],
                                              color: Colors.white,
                                              size: 26,
                                            )
                                          else
                                            const SizedBox(height: 30),
                                          const SizedBox(height: 3),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              _labels[index],
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: isActive
                                                    ? FontWeight.w700
                                                    : FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  left: circleLeft,
                  top: 18,
                  child: GestureDetector(
                    onTap: () => onTap?.call(currentIndex),
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        color: navColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _icons[currentIndex],
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavbarPainter extends CustomPainter {
  final double activeCenterX;
  final Color color;

  _NavbarPainter({
    required this.activeCenterX,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 10;
    const double topY = 16;
    const double notchRadius = 43;
    const double notchDepth = 44;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, topY + radius)
      ..quadraticBezierTo(0, topY, radius, topY)
      ..lineTo(activeCenterX - notchRadius, topY)
      ..cubicTo(
        activeCenterX - notchRadius + 12,
        topY,
        activeCenterX - 28,
        topY + notchDepth,
        activeCenterX,
        topY + notchDepth,
      )
      ..cubicTo(
        activeCenterX + 28,
        topY + notchDepth,
        activeCenterX + notchRadius - 12,
        topY,
        activeCenterX + notchRadius,
        topY,
      )
      ..lineTo(size.width - radius, topY)
      ..quadraticBezierTo(size.width, topY, size.width, topY + radius)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NavbarPainter oldDelegate) {
    return oldDelegate.activeCenterX != activeCenterX ||
        oldDelegate.color != color;
  }
}
