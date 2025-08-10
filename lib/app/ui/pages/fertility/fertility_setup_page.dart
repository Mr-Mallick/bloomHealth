import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/fertility_controller.dart';
import '../../../utils/responsive_utils.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';

class FertilitySetupPage extends GetView<FertilityController> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Setup Fertility Tracker'),
      backgroundColor: AppColors.primary,
    ),
    body: SingleChildScrollView(
      padding: ResponsiveUtils.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Let\'s track your cycle! 🌸',
            style: TextStyle(
              fontSize: ResponsiveUtils.titleFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.cardPadding / 2),
          Text(
            'Please provide information about your last period to calculate your fertile days and predict your next cycle.',
            style: TextStyle(
              fontSize: ResponsiveUtils.bodyFontSize,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: ResponsiveUtils.sectionSpacing),
          _buildPeriodStartSection(),
          SizedBox(height: ResponsiveUtils.cardPadding),
          _buildPeriodEndSection(),
          SizedBox(height: ResponsiveUtils.cardPadding),
          _buildCycleLengthSection(),
          SizedBox(height: ResponsiveUtils.sectionSpacing * 1.5),
          Obx(() => CustomButton(
            text: 'Setup Tracking',
            onPressed: controller.isLoading.value ? null : _onSetupPressed,
            isLoading: controller.isLoading.value,
          )),
        ],
      ),
    ),
  );
}

 Widget _buildPeriodStartSection() {
  return Card(
    elevation: 2,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all(ResponsiveUtils.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last Period Start Date',
            style: TextStyle(
              fontSize: ResponsiveUtils.headingFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.cardPadding / 2),
          Text(
            'When did your last period start?',
            style: TextStyle(
              fontSize: ResponsiveUtils.bodyFontSize,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: ResponsiveUtils.cardPadding),
          Obx(() => InkWell(
            onTap: () => _selectStartDate(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.cardPadding,
                vertical: ResponsiveUtils.cardPadding,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.periodStartDate.value != null
                        ? _formatDate(controller.periodStartDate.value!)
                        : 'Select date',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.bodyFontSize,
                      color: controller.periodStartDate.value != null
                          ? AppColors.onBackground
                          : AppColors.onSurface,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today, 
                    color: AppColors.primary,
                    size: ResponsiveUtils.iconSize,
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    ),
  );
}


  Widget _buildPeriodEndSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last Period End Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'When did your last period end?',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => InkWell(
              onTap: controller.periodStartDate.value != null ? () => _selectEndDate() : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.periodStartDate.value != null
                        ? AppColors.primary
                        : AppColors.onSurface.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.periodEndDate.value != null
                          ? _formatDate(controller.periodEndDate.value!)
                          : controller.periodStartDate.value != null
                              ? 'Select end date'
                              : 'Select start date first',
                      style: TextStyle(
                        fontSize: 16,
                        color: controller.periodEndDate.value != null
                            ? AppColors.onBackground
                            : controller.periodStartDate.value != null
                                ? AppColors.onSurface
                                : AppColors.onSurface.withOpacity(0.5),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: controller.periodStartDate.value != null
                          ? AppColors.primary
                          : AppColors.onSurface.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleLengthSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Average Cycle Length',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'How many days is your typical cycle? (Average is 28 days)',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.cycleLength.value} days',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (controller.cycleLength.value > 21) {
                          controller.setCycleLength(controller.cycleLength.value - 1);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppColors.primary,
                    ),
                    IconButton(
                      onPressed: () {
                        if (controller.cycleLength.value < 40) {
                          controller.setCycleLength(controller.cycleLength.value + 1);
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            )),
            Obx(() => Slider(
              value: controller.cycleLength.value.toDouble(),
              min: 21,
              max: 40,
              divisions: 19,
              activeColor: AppColors.primary,
              onChanged: (value) => controller.setCycleLength(value.round()),
            )),
          ],
        ),
      ),
    );
  }

  void _selectStartDate() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().subtract(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      controller.periodStartDate.value = date;
      // Reset end date if it's before start date
      if (controller.periodEndDate.value != null &&
          controller.periodEndDate.value!.isBefore(date)) {
        controller.periodEndDate.value = null;
      }
    }
  }

  void _selectEndDate() async {
    if (controller.periodStartDate.value == null) return;

    final date = await showDatePicker(
      context: Get.context!,
      initialDate: controller.periodStartDate.value!.add(const Duration(days: 3)),
      firstDate: controller.periodStartDate.value!,
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      controller.periodEndDate.value = date;
    }
  }

  void _onSetupPressed() {
    if (controller.periodStartDate.value == null ||
        controller.periodEndDate.value == null) {
      Get.snackbar(
        'Incomplete Information',
        'Please select both start and end dates for your last period.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    controller.setupInitialData(
      startDate: controller.periodStartDate.value!,
      endDate: controller.periodEndDate.value!,
      cycleLength: controller.cycleLength.value,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}