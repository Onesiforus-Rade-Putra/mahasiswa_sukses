import 'package:flutter/material.dart';

class HeaderBackground extends StatelessWidget {
  final double height;
  final Widget? child;

  const HeaderBackground({
    super.key,
    this.height = 280,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.77],
          colors: [
            Color(0xFFED1E28),
            Color(0xFF871117),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: child,
    );
  }
}
