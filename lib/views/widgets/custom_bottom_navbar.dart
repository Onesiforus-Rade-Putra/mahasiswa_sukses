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
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 108,
        child: LayoutBuilder(
          builder: (context, constraints) {
            const double sideMargin = 0;
            const double circleSize = 74;
            const double circleStroke = 5;
            const double barHeight = 100;

            final double navWidth = constraints.maxWidth - (sideMargin * 2);
            final double itemWidth = navWidth / 5;
            final double circleLeft = sideMargin +
                (itemWidth * currentIndex) +
                (itemWidth / 2) -
                (circleSize / 2);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: sideMargin,
                  right: sideMargin,
                  bottom: 0,
                  child: SizedBox(
                    height: barHeight,
                    child: CustomPaint(
                      painter: _NavbarPainter(
                        activeCenterX:
                            (itemWidth * currentIndex) + (itemWidth / 2),
                      ),
                      child: Row(
                        children: List.generate(5, (index) {
                          final bool isActive = index == currentIndex;
                          return Expanded(
                            child: InkWell(
                              onTap: () => onTap?.call(index),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: isActive ? 40 : 18,
                                  bottom: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!isActive)
                                      Icon(
                                        _icons[index],
                                        color: Colors.white,
                                        size: 23,
                                      )
                                    else
                                      const SizedBox(height: 30),
                                    const SizedBox(height: 4),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        _labels[index],
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.5,
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
                  top: 2,
                  child: GestureDetector(
                    onTap: () => onTap?.call(currentIndex),
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF1E1E),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: circleStroke,
                        ),
                      ),
                      child: Icon(
                        _icons[currentIndex],
                        color: Colors.white,
                        size: 34,
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

  _NavbarPainter({
    required this.activeCenterX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const Color red = Color(0xFFFF1E1E);
    const double radius = 26;
    const double topY = 26;
    const double shoulderWidth = 30;
    const double liftHeight = 16;

    final paint = Paint()
      ..color = red
      ..style = PaintingStyle.fill;

    final double leftCurveStart = activeCenterX - shoulderWidth;
    final double rightCurveEnd = activeCenterX + shoulderWidth;

    final path = Path()
      ..moveTo(0, topY + radius)
      ..quadraticBezierTo(0, topY, radius, topY)
      ..lineTo(leftCurveStart, topY)
      ..cubicTo(
        leftCurveStart + 10,
        topY,
        activeCenterX - 18,
        topY - liftHeight,
        activeCenterX,
        topY - liftHeight,
      )
      ..cubicTo(
        activeCenterX + 18,
        topY - liftHeight,
        rightCurveEnd - 10,
        topY,
        rightCurveEnd,
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
    return oldDelegate.activeCenterX != activeCenterX;
  }
}
