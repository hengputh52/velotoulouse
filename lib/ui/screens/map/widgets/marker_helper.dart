import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// MarkerHelper — LOC-04
/// Draws custom map markers:
/// • Blue circle with number → bikes available
/// • Gray pill "EMPTY" → no bikes
class MarkerHelper {
  /// 🔵 Blue numbered marker — shows available bike count
  static Future<BitmapDescriptor> numbered(int count) async {
    const double size = 80;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Shadow
    canvas.drawCircle(
      const Offset(size / 2, size / 2 - 4),
      30,
      Paint()
        ..color = Colors.black.withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // White ring
    canvas.drawCircle(
      const Offset(size / 2, size / 2 - 4),
      28,
      Paint()..color = Colors.white,
    );
    // Blue fill
    canvas.drawCircle(
      const Offset(size / 2, size / 2 - 4),
      24,
      Paint()..color = const Color(0xFF1275E2),
    );
    // Number text
    final tp = TextPainter(
      text: TextSpan(
        text: '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(size / 2 - tp.width / 2, size / 2 - 4 - tp.height / 2),
    );
    // Pin tail
    canvas.drawPath(
      Path()
        ..moveTo(size / 2 - 7, size / 2 + 20)
        ..lineTo(size / 2 + 7, size / 2 + 20)
        ..lineTo(size / 2, size / 2 + 38)
        ..close(),
      Paint()..color = const Color(0xFF1275E2),
    );

    return _toDescriptor(recorder, size, size);
  }

  static Future<BitmapDescriptor> empty() async {
    const double w = 90, h = 42;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final rrect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, w, h - 10),
      const Radius.circular(10),
    );

    canvas.drawRRect(
      rrect.shift(const Offset(0, 3)),
      Paint()
        ..color = Colors.black.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF9E9E9E));
    // Tail
    canvas.drawPath(
      Path()
        ..moveTo(w / 2 - 6, h - 10)
        ..lineTo(w / 2 + 6, h - 10)
        ..lineTo(w / 2, h)
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
    tp.paint(
      canvas,
      Offset(w / 2 - tp.width / 2, (h - 10) / 2 - tp.height / 2),
    );

    return _toDescriptor(recorder, w, h);
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
