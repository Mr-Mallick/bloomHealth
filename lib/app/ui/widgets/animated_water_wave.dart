import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedWaterWave extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color waveColor;
  final Color backgroundColor;
  final Widget? child;
  final double size;

  const AnimatedWaterWave({
    Key? key,
    required this.progress,
    this.waveColor = Colors.blue,
    this.backgroundColor = Colors.blue,
    this.child,
    this.size = 200,
  }) : super(key: key);

  @override
  State<AnimatedWaterWave> createState() => _AnimatedWaterWaveState();
}

class _AnimatedWaterWaveState extends State<AnimatedWaterWave>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );
    _waveController.repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaterWavePainter(
              progress: widget.progress,
              waveColor: widget.waveColor,
              backgroundColor: widget.backgroundColor,
              waveOffset: _waveAnimation.value,
            ),
            child: Container(
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

class WaterWavePainter extends CustomPainter {
  final double progress;
  final Color waveColor;
  final Color backgroundColor;
  final double waveOffset;

  WaterWavePainter({
    required this.progress,
    required this.waveColor,
    required this.backgroundColor,
    required this.waveOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Create circular clip
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: radius)));

    // Calculate water level
    final waterLevel = size.height * (1 - progress);

    // Draw wave
    final wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, waterLevel);

    for (double x = 0; x <= size.width; x++) {
      final normalizedX = x / size.width;
      final y = waterLevel + 
          math.sin((normalizedX * 4 * math.pi) + waveOffset) * 8 +
          math.sin((normalizedX * 2 * math.pi) + waveOffset * 1.5) * 4;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);

    // Draw border circle
    final borderPaint = Paint()
      ..color = waveColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(WaterWavePainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.waveOffset != waveOffset;
  }
}