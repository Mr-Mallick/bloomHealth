import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/fertility_controller.dart';
import '../../utils/responsive_utils.dart';
import '../theme/app_colors.dart';

class FertilityCalendar extends GetView<FertilityController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.currentData.value;
      if (data == null) return const SizedBox.shrink();

      return TableCalendar<String>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        
        // Add onDaySelected callback for the enhancement
        onDaySelected: (selectedDay, focusedDay) {
          _showDayInfo(selectedDay);
        },
        
        // Calendar Style
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: const TextStyle(color: AppColors.onSurface),
          holidayTextStyle: const TextStyle(color: AppColors.onSurface),
          
          // Default day style
          defaultTextStyle: const TextStyle(
            color: AppColors.onBackground,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          
          // Today's style
          todayDecoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          
          // Selected day style
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          
          // Remove markers completely
          markersMaxCount: 0,
          markerDecoration: const BoxDecoration(),
        ),
        
        // Header Style
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.primary),
          rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.primary),
        ),
        
        // Day Builder - Clean design without icons
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return _buildCleanDayCell(day);
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildCleanDayCell(day, isToday: true);
          },
          outsideBuilder: (context, day, focusedDay) {
            return _buildCleanDayCell(day, isOutside: true);
          },
        ),
      );
    });
  }

  // Clean calendar cell without emoji icons
  Widget _buildCleanDayCell(DateTime day, {bool isToday = false, bool isOutside = false}) {
    final status = controller.getFertilityStatusForDate(day);
    final dayNumber = day.day;

    Color backgroundColor = Colors.transparent;
    Color textColor = isOutside ? Colors.grey[400]! : AppColors.onBackground;
    Color borderColor = Colors.transparent;

    // Determine styling based on fertility status
    switch (status) {
      case 'period':
        backgroundColor = AppColors.period;
        textColor = Colors.white;
        break;
      case 'fertile':
        backgroundColor = AppColors.fertile;
        textColor = Colors.white;
        break;
      case 'ovulation':
        backgroundColor = AppColors.ovulation;
        textColor = Colors.white;
        break;
      case 'predicted_period':
        backgroundColor = AppColors.predicted;
        textColor = Colors.white;
        break;
    }

    // Override for today
    if (isToday && status == 'normal') {
      borderColor = AppColors.secondary;
      backgroundColor = AppColors.secondary.withOpacity(0.1);
    } else if (isToday && status != 'normal') {
      // Add a subtle border for today when it has status
      borderColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: borderColor != Colors.transparent
            ? Border.all(color: borderColor, width: 2)
            : null,
        // Add subtle shadow for special days
        boxShadow: status != 'normal' && !isOutside
            ? [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '$dayNumber',
          style: TextStyle(
            color: textColor,
            fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // Keep the same bottom sheet functionality
  void _showDayInfo(DateTime selectedDay) {
    final status = controller.getFertilityStatusForDate(selectedDay);
    final data = controller.currentData.value;
    if (data == null) return;

    // Get medicines for this day
    final dayMedicines = controller.getMedicinesForDate(selectedDay);

    // Calculate days until/since various events
    final today = DateTime.now();
    final daysFromToday = selectedDay.difference(DateTime(today.year, today.month, today.day)).inDays;
    final daysToNextPeriod = data.nextPeriodDate.difference(selectedDay).inDays;
    final daysToOvulation = data.ovulationDate.difference(selectedDay).inDays;

   Get.bottomSheet(
    Container(
      constraints: BoxConstraints(
        maxHeight: ResponsiveUtils.bottomSheetMaxHeight,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: ResponsiveUtils.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.sectionSpacing),
              
              // Header with responsive sizing
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.cardPadding),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusEmoji(status),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.isSmallScreen ? 28 : 32,
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.cardPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                                Text(
                          _formatDate(selectedDay),
                          style: TextStyle(
                            fontSize: ResponsiveUtils.titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          _getRelativeDateText(daysFromToday),
                          style: TextStyle(
                            fontSize: ResponsiveUtils.bodyFontSize,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.sectionSpacing),
              
              // Status information with responsive padding
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveUtils.cardPadding),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(status).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusTitle(status),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.headingFontSize,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(status),
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.cardPadding / 2),
                    Text(
                      _getStatusDescription(status, selectedDay, data),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.bodyFontSize,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveUtils.cardPadding),
              
              // Medicine information with responsive sizing
              if (dayMedicines.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveUtils.cardPadding),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '💊', 
                            style: TextStyle(fontSize: ResponsiveUtils.iconSize),
                          ),
                          SizedBox(width: ResponsiveUtils.cardPadding / 2),
                          Text(
                            'Medicines Today',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.headingFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveUtils.cardPadding / 2),
                      ...dayMedicines.take(3).map((medicine) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.cardPadding / 4,
                        ),
                        child: Text(
                          '• $medicine',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.bodyFontSize,
                            color: Colors.purple[700],
                          ),
                        ),
                      )),
                      if (dayMedicines.length > 3)
                        Text(
                          '... and ${dayMedicines.length - 3} more',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.captionFontSize,
                            color: Colors.purple[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.cardPadding),
              ],
              
              // Additional cycle information
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveUtils.cardPadding),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cycle Information',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.headingFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.cardPadding),
                    
                    if (status != 'period') ...[
                      _buildInfoRow(
                        '🩸',
                        'Next Period',
                        daysToNextPeriod > 0 
                          ? 'In $daysToNextPeriod days'
                          : daysToNextPeriod == 0 
                            ? 'Expected today'
                            : '${-daysToNextPeriod} days overdue',
                      ),
                    ],
                    
                    if (status != 'ovulation') ...[
                      _buildInfoRow(
                        '🎯',
                        'Ovulation',
                        daysToOvulation > 0 
                          ? 'In $daysToOvulation days'
                          : daysToOvulation == 0 
                            ? 'Expected today'
                            : '${-daysToOvulation} days ago',
                      ),
                    ],
                    
                    _buildInfoRow(
                      '📊',
                      'Cycle Length',
                      '${data.cycleLength} days',
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: ResponsiveUtils.sectionSpacing),
              
              // Responsive close button
              SizedBox(
                width: double.infinity,
                height: ResponsiveUtils.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.bodyFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              // Add responsive bottom padding
              SizedBox(height: ResponsiveUtils.cardPadding),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    enableDrag: true,
  );
}

Widget _buildInfoRow(String emoji, String title, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.cardPadding / 4),
    child: Row(
      children: [
        Text(emoji, style: TextStyle(fontSize: ResponsiveUtils.iconSize)),
        SizedBox(width: ResponsiveUtils.cardPadding),
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.bodyFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.bodyFontSize,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
  

  
  String _getStatusTitle(String status) {
    switch (status) {
      case 'period':
        return 'Period Day 🌸';
      case 'fertile':
        return 'Fertile Window 🌟';
      case 'ovulation':
        return 'Ovulation Day 🎯';
      case 'predicted_period':
        return 'Expected Period 📅';
      default:
        return 'Regular Day 📆';
    }
  }

  String _getStatusDescription(String status, DateTime selectedDay, dynamic data) {
    switch (status) {
      case 'period':
        return 'This is part of your menstrual period. Take extra care of yourself, stay hydrated, and rest when needed. Track any symptoms or changes you experience.';
      case 'fertile':
        return 'You\'re in your fertile window! This is one of the best days for conception if you\'re trying to get pregnant. Your body is preparing for ovulation.';
      case 'ovulation':
        return 'This is your ovulation day - your peak fertility day with the highest chance of conception. Your egg is being released and is available for fertilization.';
      case 'predicted_period':
        return 'Your next period is expected to start on this day based on your cycle history. Keep track of any pre-menstrual symptoms.';
      default:
        return 'This is a regular day in your menstrual cycle. Continue with your normal routine and maintain good self-care habits.';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'period':
        return AppColors.period;
      case 'fertile':
        return AppColors.fertile;
      case 'ovulation':
        return AppColors.ovulation;
      case 'predicted_period':
        return AppColors.predicted;
      default:
        return AppColors.primary;
    }
  }

  String _getStatusEmoji(String status) {
    switch (status) {
      case 'period':
        return '🌸';
      case 'fertile':
        return '🌟';
      case 'ovulation':
        return '🎯';
      case 'predicted_period':
        return '📅';
      default:
        return '📆';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final day = date.day;
    String suffix = 'th';
    if (day == 1 || day == 21 || day == 31) suffix = 'st';
    else if (day == 2 || day == 22) suffix = 'nd';
    else if (day == 3 || day == 23) suffix = 'rd';
    
    return '$day$suffix ${months[date.month - 1]}, ${date.year}';
  }

  String _getRelativeDateText(int daysFromToday) {
    if (daysFromToday == 0) {
      return 'Today';
    } else if (daysFromToday == 1) {
      return 'Tomorrow';
    } else if (daysFromToday == -1) {
      return 'Yesterday';
    } else if (daysFromToday > 0) {
      return 'In $daysFromToday days';
    } else {
      return '${-daysFromToday} days ago';
    }
  }
}