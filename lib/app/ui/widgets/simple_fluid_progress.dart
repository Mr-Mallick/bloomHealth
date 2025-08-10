import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SimpleFluidProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double currentAmount;
  final double goalAmount;
  final double size;

  const SimpleFluidProgress({
    Key? key,
    required this.progress,
    required this.currentAmount,
    required this.goalAmount,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle with gradient
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.blue[50]!,
                  Colors.blue[100]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // Progress indicator
          CircularPercentIndicator(
            radius: size / 2 - 10,
            lineWidth: 12.0,
            percent: progress.clamp(0.0, 1.0),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '💧',
                  style: TextStyle(fontSize: size * 0.12),
                ),
                const SizedBox(height: 4),
                Text(
                  '${currentAmount.toInt()}ml',
                  style: TextStyle(
                    fontSize: size * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                Text(
                  'of ${goalAmount.toInt()}ml',
                  style: TextStyle(
                    fontSize: size * 0.05,
                    color: Colors.blue[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: size * 0.06,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            progressColor: _getProgressColor(progress),
            backgroundColor: Colors.blue[200]!,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1000,
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) {
      return Colors.green[400]!;
    } else if (progress >= 0.75) {
      return Colors.blue[400]!;
    } else if (progress >= 0.5) {
      return Colors.blue[500]!;
    } else {
      return Colors.blue[600]!;
    }
  }
}