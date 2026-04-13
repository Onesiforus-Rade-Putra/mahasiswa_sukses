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
        height: 96,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double totalWidth = constraints.maxWidth;
            final double itemWidth = totalWidth / 5;
            final double activeSize = 72;
            final double activeLeft =
                (itemWidth * currentIndex) + (itemWidth / 2) - (activeSize / 2);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 78,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF1E1E),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      ),
                    ),
                    child: Row(
                      children: List.generate(5, (index) {
                        final bool isActive = index == currentIndex;

                        return Expanded(
                          child: InkWell(
                            onTap: () => onTap?.call(index),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: isActive ? 24 : 8,
                                bottom: 8,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!isActive)
                                    Icon(
                                      _icons[index],
                                      color: Colors.white,
                                      size: 24,
                                    )
                                  else
                                    const SizedBox(height: 24),
                                  const SizedBox(height: 4),
                                  Text(
                                    _labels[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: isActive
                                          ? FontWeight.w700
                                          : FontWeight.w500,
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
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  left: activeLeft,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => onTap?.call(currentIndex),
                    child: Container(
                      width: activeSize,
                      height: activeSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF1E1E),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
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
