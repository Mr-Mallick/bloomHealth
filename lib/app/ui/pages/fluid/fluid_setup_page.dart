import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/fluid_controller.dart';
import '../../widgets/custom_button.dart';

class FluidSetupPage extends GetView<FluidController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration Settings'),
        backgroundColor: Colors.blue[400],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customize Your Hydration Goals 💧',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Set your daily water intake goal and reminder preferences.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            _buildDailyGoalSection(),
            const SizedBox(height: 20),
            _buildReminderSection(),
            const SizedBox(height: 20),
            _buildReminderTimeSection(),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Save Settings',
              onPressed: _onSavePressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyGoalSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Goal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'How much water do you want to drink daily?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
              children: [
                Text(
                  '${controller.dailyGoal.value.toInt()} ml',
                                    style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Slider(
                  value: controller.dailyGoal.value,
                  min: 1000,
                  max: 4000,
                  divisions: 30,
                  activeColor: Colors.blue[400],
                  onChanged: (value) => controller.setDailyGoal(value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1L', style: TextStyle(color: Colors.blue[600])),
                    Text('4L', style: TextStyle(color: Colors.blue[600])),
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reminders',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Obx(() => Switch(
                  value: controller.reminderEnabled.value,
                  onChanged: controller.toggleReminder,
                  activeColor: Colors.blue[400],
                )),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Get notified to drink water regularly',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => controller.reminderEnabled.value
                ? Column(
                    children: [
                      const Text(
                        'Reminder Interval',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<int>(
                        value: controller.reminderInterval.value,
                        isExpanded: true,
                        items: [30, 45, 60, 90, 120].map((interval) {
                          return DropdownMenuItem(
                            value: interval,
                            child: Text('Every $interval minutes'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.setReminderInterval(value);
                          }
                        },
                      ),
                    ],
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderTimeSection() {
    return Obx(() => controller.reminderEnabled.value
        ? Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reminder Time Range',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Set when you want to receive reminders',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeSelector(
                          'Start Time',
                          controller.startTime.value,
                          (time) => controller.setReminderTimes(time, controller.endTime.value),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimeSelector(
                          'End Time',
                          controller.endTime.value,
                          (time) => controller.setReminderTimes(controller.startTime.value, time),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink());
  }

  Widget _buildTimeSelector(String label, DateTime time, Function(DateTime) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _selectTime(time, onChanged),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _selectTime(DateTime currentTime, Function(DateTime) onChanged) async {
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.fromDateTime(currentTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[400]!,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      final newTime = DateTime(2024, 1, 1, time.hour, time.minute);
      onChanged(newTime);
    }
  }

  void _onSavePressed() {
    controller.updateSettings();
    Get.back();
  }
}