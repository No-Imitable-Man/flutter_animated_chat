import 'dart:math' as math;

import 'package:flutter/material.dart';

class WaveFormPainter extends CustomPainter {
  final double progress;
  final bool isMe;

  WaveFormPainter({required this.progress, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint activePaint = Paint()
      ..color = isMe ? Colors.white : Colors.blue
      ..strokeWidth = 2;
    final Paint inactivePaint = Paint()
      ..color = isMe ? Colors.white.withOpacity(0.3) : Colors.grey[300]!
      ..strokeWidth = 2;
    final double barWidth = 3;
    final double spacing = 2;
    final int barCount = (size.width / (barWidth + spacing)).floor();

    for (int i = 0; i < barCount; i++) {
      final double x = i * (barWidth + spacing);
      final double height = (math.sin(i * 0.5) + 1) * size.height * 0.3 + 10;
      final double y = (size.height - height) / 2;
      final Paint paint = (i / barCount) <= progress
          ? activePaint
          : inactivePaint;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, height),
          Radius.circular(barWidth / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
