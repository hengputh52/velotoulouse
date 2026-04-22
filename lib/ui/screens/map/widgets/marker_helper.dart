import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// • Orange-red pill with bike icon + count  → bikes available
/// • Gray pill "EMPTY"                        → no bikes
class MarkerHelper {
  static Future<BitmapDescriptor> numbered(int count) async {
    const double w = 110;
    const double h = 52;
    const double tailH = 12;
    const double totalH = h + tailH;
    const double radius = h / 2;
    const Color pillColor = Color(0xFFE8472E);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Drop shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(3, 5, w - 6, h),
        const Radius.circular(radius),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Pill body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, w, h),
        const Radius.circular(radius),
      ),
      Paint()..color = pillColor,
    );

    // Pointed tail
    canvas.drawPath(
      Path()
        ..moveTo(w / 2 - 8, h - 1)
        ..lineTo(w / 2 + 8, h - 1)
        ..lineTo(w / 2, totalH - 2)
        ..close(),
      Paint()..color = pillColor,
    );

    // Divider line between icon and number
    canvas.drawLine(
      Offset(h, 12),
      Offset(h, h - 12),
      Paint()
        ..color = Colors.white.withOpacity(0.35)
        ..strokeWidth = 1.5,
    );

    // Bike icon (left side) — draw a simple bike using paths
    _drawBikeIcon(canvas, centerX: h / 2, centerY: h / 2, size: 24);

    // Count text (right side)
    final rightSectionX = h;
    final rightSectionW = w - rightSectionX;
    final countPainter = TextPainter(
      text: TextSpan(
        text: '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    countPainter.paint(
      canvas,
      Offset(
        rightSectionX + rightSectionW / 2 - countPainter.width / 2,
        h / 2 - countPainter.height / 2,
      ),
    );

    return _toDescriptor(recorder, w, totalH);
  }

  /// Draw a simple bike icon using canvas primitives
  static void _drawBikeIcon(
    Canvas canvas, {
    required double centerX,
    required double centerY,
    required double size,
  }) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final r = size / 2 * 0.55; // wheel radius

    // Left wheel
    canvas.drawCircle(Offset(centerX - r * 1.1, centerY + r * 0.4), r, paint);
    // Right wheel
    canvas.drawCircle(Offset(centerX + r * 1.1, centerY + r * 0.4), r, paint);

    // Frame: left axle → center-top → right axle
    final leftAxle = Offset(centerX - r * 1.1, centerY + r * 0.4);
    final rightAxle = Offset(centerX + r * 1.1, centerY + r * 0.4);
    final top = Offset(centerX, centerY - r * 0.6);

    canvas.drawLine(leftAxle, top, paint);
    canvas.drawLine(top, rightAxle, paint);
    canvas.drawLine(
      leftAxle,
      Offset(centerX + r * 0.1, centerY + r * 0.4),
      paint,
    );

    // Handlebar
    canvas.drawLine(
      Offset(centerX + r * 0.7, centerY - r * 0.6),
      Offset(centerX + r * 1.3, centerY - r * 0.6),
      paint,
    );
    // Seat
    canvas.drawLine(
      Offset(centerX - r * 0.5, centerY - r * 0.5),
      Offset(centerX + r * 0.2, centerY - r * 0.5),
      paint,
    );
  }

  static Future<BitmapDescriptor> empty() async {
    const double w = 90;
    const double h = 38;
    const double tailH = 10;
    const double totalH = h + tailH;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, w, h),
      const Radius.circular(h / 2),
    );

    // Shadow
    canvas.drawRRect(
      rrect.shift(const Offset(0, 3)),
      Paint()
        ..color = Colors.black.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Body
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF9E9E9E));

    // Tail
    canvas.drawPath(
      Path()
        ..moveTo(w / 2 - 6, h - 1)
        ..lineTo(w / 2 + 6, h - 1)
        ..lineTo(w / 2, totalH - 1)
        ..close(),
      Paint()..color = const Color(0xFF9E9E9E),
    );

    // EMPTY text
    final tp = TextPainter(
      text: const TextSpan(
        text: 'EMPTY',
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(w / 2 - tp.width / 2, h / 2 - tp.height / 2));

    return _toDescriptor(recorder, w, totalH);
  }

  static Future<BitmapDescriptor> _toDescriptor(
    ui.PictureRecorder recorder,
    double w,
    double h,
  ) async {
    final img = await recorder.endRecording().toImage(w.toInt(), h.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
