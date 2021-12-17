import 'dart:math' as math;
import 'package:flutter/material.dart';

class Arc extends StatelessWidget {
  final double radius;
  final double stroke;
  final double startAngle;
  final double sweepAngle;
  final Color color;

  Arc({
    this.radius = 100,
    this.stroke = 5,
    this.startAngle = 0,
    this.sweepAngle = 360,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2.0,
      height: radius * 2.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: CustomPaint(
        painter: ArcPainter(
          radius: radius,
          stroke: stroke,
          startAngle: startAngle,
          sweepAngle: sweepAngle,
          color: color,
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double radius;
  final double stroke;
  final double startAngle;
  final double sweepAngle;
  final Color color;

  ArcPainter({
    required this.radius,
    required this.stroke,
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawArc(
        Rect.fromCircle(
          center: Offset(radius, radius),
          radius: radius,
        ),
        (math.pi * 2) * (startAngle / 360.0), //radians
        (math.pi * 2) * (sweepAngle / 360.0), //radians
        false,
        paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
