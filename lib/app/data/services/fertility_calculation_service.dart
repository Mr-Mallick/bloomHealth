import 'package:get/get.dart';

class FertilityCalculationService extends GetxService {
  
  // Calculate ovulation date (typically 14 days before next period)
  DateTime calculateOvulationDate(DateTime periodStart, int cycleLength) {
    return periodStart.add(Duration(days: cycleLength - 14));
  }

  // Calculate next period date
  DateTime calculateNextPeriodDate(DateTime lastPeriodStart, int cycleLength) {
    return lastPeriodStart.add(Duration(days: cycleLength));
  }

  // Calculate fertile window (5 days before ovulation + ovulation day)
  List<DateTime> calculateFertileDays(DateTime ovulationDate) {
    List<DateTime> fertileDays = [];
    
    // 5 days before ovulation
    for (int i = 5; i >= 1; i--) {
      fertileDays.add(ovulationDate.subtract(Duration(days: i)));
    }
    
    // Ovulation day
    fertileDays.add(ovulationDate);
    
    return fertileDays;
  }

  // Calculate period days
  List<DateTime> calculatePeriodDays(DateTime startDate, DateTime endDate) {
    List<DateTime> periodDays = [];
    DateTime currentDate = startDate;
    
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      periodDays.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    return periodDays;
  }

  // Get fertility status for a specific date
  String getFertilityStatus(DateTime date, {
    required List<DateTime> periodDays,
    required List<DateTime> fertileDays,
    required DateTime ovulationDate,
    required DateTime nextPeriodDate,
  }) {
    // Check if it's a period day
    for (DateTime periodDay in periodDays) {
      if (_isSameDay(date, periodDay)) {
        return 'period';
      }
    }
    
    // Check if it's ovulation day
    if (_isSameDay(date, ovulationDate)) {
      return 'ovulation';
    }
    
    // Check if it's a fertile day
    for (DateTime fertileDay in fertileDays) {
      if (_isSameDay(date, fertileDay)) {
        return 'fertile';
      }
    }
    
    // Check if it's predicted period
    if (_isSameDay(date, nextPeriodDate)) {
      return 'predicted_period';
    }
    
    return 'normal';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  // Calculate cycle statistics
  Map<String, dynamic> calculateCycleStats(List<DateTime> periodStarts) {
    if (periodStarts.length < 2) {
      return {
        'averageCycleLength': 28,
        'shortestCycle': 28,
        'longestCycle': 28,
        'cycleVariation': 0,
      };
    }

    List<int> cycleLengths = [];
    for (int i = 1; i < periodStarts.length; i++) {
      int cycleLength = periodStarts[i].difference(periodStarts[i-1]).inDays;
      cycleLengths.add(cycleLength);
    }

    int total = cycleLengths.reduce((a, b) => a + b);
    double average = total / cycleLengths.length;
    int shortest = cycleLengths.reduce((a, b) => a < b ? a : b);
    int longest = cycleLengths.reduce((a, b) => a > b ? a : b);
    int variation = longest - shortest;

    return {
      'averageCycleLength': average.round(),
      'shortestCycle': shortest,
      'longestCycle': longest,
      'cycleVariation': variation,
    };
  }
}