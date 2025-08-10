import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/fertility_controller.dart';
import '../../../routes/app_pages.dart';
import '../../widgets/fertility_calendar.dart';
import '../../theme/app_colors.dart';

class FertilityPage extends GetView<FertilityController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertility Tracker'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isFirstTime.value) {
          return _buildFirstTimeSetup();
        }

        return _buildFertilityDashboard();
      }),
    );
  }

  Widget _buildFirstTimeSetup() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🌸',
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome to Bloom Health!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Let\'s set up your cycle tracking to predict your fertile days and next period.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Get.toNamed(Routes.FERTILITY_SETUP),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFertilityDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(),
          const SizedBox(height: 20),
          _buildCalendarSection(),
          const SizedBox(height: 20),
          _buildLegend(),
          const SizedBox(height: 20),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final data = controller.currentData.value;
    if (data == null) return const SizedBox.shrink();

    final today = DateTime.now();
    final daysToNextPeriod = data.nextPeriodDate.difference(today).inDays;
    final status = controller.getFertilityStatusForDate(today);

    return Container(
      width: Get.width,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primaryLight.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Text(
                _getStatusMessage(status, daysToNextPeriod),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _getStatusDescription(status),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FertilityCalendar(),
      ),
    );
  }

  Widget _buildLegend() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Legend',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildLegendItem('Period', AppColors.period),
            _buildLegendItem('Fertile Days', AppColors.fertile),
            _buildLegendItem('Ovulation', AppColors.ovulation),
            _buildLegendItem('Predicted Period', AppColors.predicted),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed(Routes.FERTILITY_SETUP),
                icon: const Icon(Icons.edit),
                label: const Text('Update Period'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getStatusMessage(String status, int daysToNextPeriod) {
    switch (status) {
      case 'period':
        return 'Period in Progress 🌸';
      case 'fertile':
        return 'Fertile Window 🌟';
      case 'ovulation':
        return 'Ovulation Day 🎯';
      default:
        return 'Next Period in $daysToNextPeriod days';
    }
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'period':
        return 'Take care of yourself during this time';
      case 'fertile':
        return 'This is your fertile window - good luck!';
      case 'ovulation':
        return 'Peak fertility day - highest chance of conception';
      default:
        return 'Regular cycle day';
    }
  }
}