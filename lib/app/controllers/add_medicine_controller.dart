import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/medicine_model.dart';
import 'medicine_controller.dart';

class AddMedicineController extends GetxController {
  final MedicineController _medicineController = Get.find<MedicineController>();
  
  // Form controllers
  late TextEditingController nameController;
  late TextEditingController notesController;
  
  // Form state
  final RxList<DateTime> scheduledTimes = <DateTime>[].obs;
  final Rx<MedicineType> selectedType = MedicineType.tablet.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void clearForm() {
    nameController.clear();
    notesController.clear();
    scheduledTimes.clear();
    selectedType.value = MedicineType.tablet;
  }

  void addScheduleTime(DateTime time) {
    if (!scheduledTimes.any((t) => t.hour == time.hour && t.minute == time.minute)) {
      scheduledTimes.add(time);
      scheduledTimes.sort((a, b) => a.compareTo(b));
    } else {
      Get.snackbar(
        'Duplicate Time',
        'This time is already added',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeScheduleTime(int index) {
    scheduledTimes.removeAt(index);
  }

  void selectMedicineType(MedicineType type) {
    selectedType.value = type;
  }

  Future<void> saveMedicine() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter medicine name');
      return;
    }

    if (scheduledTimes.isEmpty) {
      Get.snackbar('Error', 'Please add at least one schedule time');
      return;
    }

    isLoading.value = true;
    
    try {
      await _medicineController.addMedicine(
        name: nameController.text.trim(),
        type: selectedType.value,
        scheduledTimes: scheduledTimes.toList(),
        notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      );
      
      // Clear form after successful addition
      clearForm();
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to add medicine: $e');
    } finally {
      isLoading.value = false;
    }
  }
}