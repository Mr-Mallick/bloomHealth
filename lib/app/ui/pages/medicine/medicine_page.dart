import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../controllers/medicine_controller.dart';
import '../../../data/models/medicine_model.dart';
import '../../../routes/app_pages.dart';
import '../../theme/app_colors.dart';
import '../../widgets/medicine_card.dart';

class MedicinePage extends GetView<MedicineController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Tracker'),
        backgroundColor: Colors.purple[400],
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showMedicineHistory,
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
              _buildUpcomingSection(),
              const SizedBox(height: 20),
              _buildTodaysMedicinesSection(),
              const SizedBox(height: 20),
              _buildAllMedicinesSection(),
              const SizedBox(height: 100),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.ADD_MEDICINE),
        backgroundColor: Colors.purple[400],
        icon: const Icon(Icons.add),
        label: const Text('Add Medicine'),
      ),
    );
  }

  Widget _buildUpcomingSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.purple[50]!,
              Colors.purple[100]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '⏰',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  'Upcoming Medicines',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              final upcoming = controller.getUpcomingMedicines();
              
              if (upcoming.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '✅',
                          style: TextStyle(fontSize: 40, color: Colors.purple[300]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No upcoming medicines for today',
                          style: TextStyle(
                            color: Colors.purple[600],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcoming.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = upcoming[index];
                  final medicine = item['medicine'];
                  final scheduledTime = item['scheduledTime'];

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple[200]!),
                    ),
                    child: Row(
                      children: [
                        Text(
                          controller.getMedicineTypeIcon(medicine.type),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicine.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${scheduledTime.hour.toString().padLeft(2, '0')}:${scheduledTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: Colors.purple[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => controller.markMedicineAsTaken(
                            medicine.id,
                            scheduledTime,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[400],
                            minimumSize: const Size(60, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Take',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysMedicinesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Schedule',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple[800],
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final todaysMedicines = controller.getTodaysMedicines();
              
              if (todaysMedicines.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '💊',
                          style: TextStyle(fontSize: 40, color: Colors.purple[300]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No medicines scheduled for today',
                          style: TextStyle(
                            color: Colors.purple[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
    
              return AnimationLimiter(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todaysMedicines.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: MedicineCard(
                            medicine: todaysMedicines[index],
                            showSchedule: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAllMedicinesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Medicines',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple[800],
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.medicines.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '💊',
                          style: TextStyle(fontSize: 40, color: Colors.purple[300]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No medicines added yet',
                          style: TextStyle(
                            color: Colors.purple[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to add your first medicine',
                          style: TextStyle(
                            color: Colors.purple[500],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return AnimationLimiter(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.medicines.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: MedicineCard(
                            medicine: controller.medicines[index],
                            onDelete: () => _showDeleteConfirmation(controller.medicines[index]),
                            onToggle: (isActive) => controller.toggleMedicineStatus(
                              controller.medicines[index].id,
                              isActive,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showMedicineHistory() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Medicine History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
            ),
            const Divider(),
            const Expanded(
              child: Center(
                child: Text('History feature coming soon!'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

 void _showDeleteConfirmation(Medicine medicine) {
  // Ensure no duplicate dialogs by checking if one is already open
  if (Get.isDialogOpen ?? false) {
    return;
  }
  
  Get.dialog(
    AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange[600]),
          const SizedBox(width: 8),
          const Text('Delete Medicine'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to delete:'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Text(
                  controller.getMedicineTypeIcon(medicine.type),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        controller.getMedicineTypeName(medicine.type),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This action cannot be undone.',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back(); // Close dialog first
            
            // Then delete medicine with confirmation message
            controller.deleteMedicine(medicine.id).then((_) {
              Get.snackbar(
                '✅ Deleted',
                '${medicine.name} has been deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green[100],
                colorText: Colors.green[800],
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.all(16),
                borderRadius: 8,
              );
            }).catchError((error) {
              Get.snackbar(
                '❌ Error',
                'Failed to delete ${medicine.name}: $error',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red[100],
                colorText: Colors.red[800],
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.all(16),
                borderRadius: 8,
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
    barrierDismissible: false, // Prevent accidental dismissal
  );
}
}