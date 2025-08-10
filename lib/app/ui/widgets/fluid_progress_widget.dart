import 'package:flutter/material.dart';
import 'animated_water_wave.dart';
import '../../utils/responsive_utils.dart';

class FluidProgressWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double currentAmount;
  final double goalAmount;
  final double? customSize; // Optional custom size

  const FluidProgressWidget({
    Key? key,
    required this.progress,
    required this.currentAmount,
    required this.goalAmount,
    this.customSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dynamic size based on screen width
    final size = customSize ?? ResponsiveUtils.progressWidgetSize;
    
    return AnimatedWaterWave(
      progress: progress.clamp(0.0, 1.0),
      waveColor: _getWaveColor(progress),
      backgroundColor: Colors.blue[100]!,
      size: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${currentAmount.toInt()}ml',
            style: TextStyle(
              fontSize: size * 0.08,
              fontWeight: FontWeight.bold,
              color: progress > 0.5 ? Colors.white : Colors.blue[800],
            ),
          ),
          SizedBox(height: size * 0.01),
          Text(
            'of ${goalAmount.toInt()}ml',
            style: TextStyle(
              fontSize: size * 0.05,
              color: progress > 0.5 
                  ? Colors.white.withOpacity(0.8) 
                  : Colors.blue[600],
            ),
          ),
          SizedBox(height: size * 0.01),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: size * 0.06,
              fontWeight: FontWeight.w600,
              color: progress > 0.5 ? Colors.white : Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  Color _getWaveColor(double progress) {
    if (progress >= 1.0) {
      return Colors.green[400]!;
    } else if (progress >= 0.75) {
      return Colors.blue[400]!;
    } else if (progress >= 0.5) {
      return Colors.blue[500]!;
    } else if (progress >= 0.25) {
      return Colors.blue[600]!;
    } else {
      return Colors.blue[300]!;
    }
  }
}