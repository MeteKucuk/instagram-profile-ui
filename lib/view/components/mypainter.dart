import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - 70);
    p.relativeQuadraticBezierTo(size.width / 2, 60, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(
        p,
        Paint()
          ..color = const Color(0xFFE5D4D0)
          ..shader = const LinearGradient(colors: [
            Color.fromARGB(255, 241, 218, 214),
            Color.fromARGB(255, 229, 217, 214)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
              .createShader(Rect.fromLTRB(0, 0, size.width, size.height)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
