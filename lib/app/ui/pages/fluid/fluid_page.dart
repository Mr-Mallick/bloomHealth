import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../controllers/fluid_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/responsive_utils.dart';
import '../../theme/app_colors.dart';
import '../../widgets/fluid_progress_widget.dart';
import '../../widgets/simple_fluid_progress.dart';

class FluidPage extends GetView<FluidController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration Tracker'),
        backgroundColor: Colors.blue[400],
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(Routes.FLUID_SETUP),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressSection(),
              const SizedBox(height: 20),
              _buildMotivationCard(),
              const SizedBox(height: 20),
              _buildQuickAddSection(),
              const SizedBox(height: 20),
              _buildTodayIntakeHistory(),
            ],
          ),
        );
      }),
    );
  }

Widget _buildProgressSection() {
  return Container(
    width: Get.width,
    child: Card(
      elevation: 4,
      margin: ResponsiveUtils.cardMargin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.cardPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.blue[50]!,
              Colors.blue[100]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Today\'s Hydration',
              style: TextStyle(
                fontSize: ResponsiveUtils.headingFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: ResponsiveUtils.sectionSpacing),
            Obx(() => FluidProgressWidget(
              progress: controller.progressPercentage.value / 100,
              currentAmount: controller.totalIntakeToday.value,
              goalAmount: controller.dailyGoal.value,
              // Size will be automatically responsive
            )),
            SizedBox(height: ResponsiveUtils.cardPadding),
            Obx(() => Text(
              controller.getMotivationalMessage(),
              style: TextStyle(
                fontSize: ResponsiveUtils.bodyFontSize,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildMotivationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.lightBlue[50],
        ),
        child: Row(
          children: [
            Text(
              '💧',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => Text(
                controller.getMotivationalMessage(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w500,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddSection() {
  return Card(
    elevation: 2,
    margin: ResponsiveUtils.cardMargin,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all(ResponsiveUtils.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Add',
            style: TextStyle(
              fontSize: ResponsiveUtils.headingFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: ResponsiveUtils.cardPadding),
          
          // Responsive grid based on screen size
          GridView.count(
            crossAxisCount: ResponsiveUtils.isSmallScreen ? 2 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: ResponsiveUtils.gridSpacing,
            crossAxisSpacing: ResponsiveUtils.gridSpacing,
            childAspectRatio: ResponsiveUtils.isSmallScreen ? 2.2 : 2.5,
            children: controller.getQuickAddOptions().map((option) {
              return InkWell(
                onTap: () => controller.addFluidIntake(option['amount']),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        option['icon'],
                        style: TextStyle(fontSize: ResponsiveUtils.iconSize),
                      ),
                      SizedBox(width: ResponsiveUtils.cardPadding / 2),
                      Text(
                        option['label'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800],
                          fontSize: ResponsiveUtils.bodyFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: ResponsiveUtils.cardPadding),
          SizedBox(
            width: double.infinity,
            height: ResponsiveUtils.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: _showCustomAmountDialog,
              icon: Icon(Icons.add, size: ResponsiveUtils.iconSize),
              label: Text(
                'Custom Amount',
                style: TextStyle(fontSize: ResponsiveUtils.bodyFontSize),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTodayIntakeHistory() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Intake',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.todayIntakes.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        '💧',
                        style: TextStyle(fontSize: 40, color: Colors.blue[300]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No intake recorded today',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.todayIntakes.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final intake = controller.todayIntakes[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        intake.type == 'water' ? '💧' : '🥤',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    title: Text(
                      '${intake.amount.toInt()}ml ${intake.type}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${intake.date.hour.toString().padLeft(2, '0')}:${intake.date.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Colors.blue[600]),
                    ),
                    dense: true,
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showCustomAmountDialog() {
    final TextEditingController amountController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Add Custom Amount'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (ml)',
                border: OutlineInputBorder(),
                suffixText: 'ml',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                controller.addFluidIntake(amount);
                Get.back();
              } else {
                Get.snackbar(
                  'Invalid Amount',
                  'Please enter a valid amount',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}