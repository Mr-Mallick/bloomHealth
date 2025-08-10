import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/medicine_model.dart';
import '../data/services/storage_service.dart';
import '../data/services/notification_service.dart';

class MedicineController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final NotificationService _notificationService = Get.find<NotificationService>();

  // Observables
  final RxList<Medicine> medicines = <Medicine>[].obs;
  final RxList<MedicineIntake> todayIntakes = <MedicineIntake>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    isLoading.value = true;
    try {
      final medicineList = await _storageService.getAllMedicines();
      medicines.assignAll(medicineList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load medicines: $e');
    } finally {
      isLoading.value = false;
    }
  }

    Future<void> addMedicine({
    required String name,
    required MedicineType type,
    required List<DateTime> scheduledTimes,
    String? notes,
  }) async {
    isLoading.value = true;
    
    try {
      final medicine = Medicine(
        id: 0, // Will be set by database
        name: name,
        type: type,
        scheduledTimes: scheduledTimes,
        notes: notes,
        createdAt: DateTime.now(),
      );

      final medicineId = await _storageService.saveMedicine(medicine);
      
      // Schedule notifications for each time
      for (int i = 0; i < scheduledTimes.length; i++) {
        await _notificationService.scheduleMedicineNotification(
          id: medicineId * 1000 + i, // Unique ID for each notification
          medicineName: name,
          scheduledTime: scheduledTimes[i],
          type: type,
        );
      }

      await _loadMedicines();

       Get.defaultDialog(
        barrierDismissible: false,
        onConfirm: () {
          Get.back();
          Get.back();
        },
        title: 'Medicine Added! 💊',
        content: Text("$name has been added to your medicine list"),
        textConfirm: "Back"
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to add medicine: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> toggleMedicineStatus(int medicineId, bool isActive) async {
  //   // This would update the medicine status in the database
  //   // For now, we'll just update the local list
  //   final index = medicines.indexWhere((med) => med.id == medicineId);
  //   if (index != -1) {
  //     // Create a new medicine object with updated status
  //     // In a real implementation, you'd update the database
  //     await _loadMedicines();
  //   }
  // }

  Future<void> markMedicineAsTaken(int medicineId, DateTime scheduledTime) async {
    try {
      final medicineIntake = MedicineIntake(
        id: 0,
        medicineId: medicineId,
        scheduledTime: scheduledTime,
        takenTime: DateTime.now(),
        isTaken: true,
      );

      // Save to database (implement in storage service)
      // await _storageService.saveMedicineIntake(medicineIntake);

      final medicine = medicines.firstWhere((med) => med.id == medicineId);
      Get.snackbar(
        'Medicine Taken! ✅',
        '${medicine.name} marked as taken',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark medicine as taken: $e');
    }
  }

 Future<void> deleteMedicine(int medicineId) async {
  try {
    // Find the medicine before deleting
    final medicine = medicines.firstWhere((med) => med.id == medicineId);
    
    // Cancel all notifications for this medicine
    for (int i = 0; i < medicine.scheduledTimes.length; i++) {
      await _notificationService.cancelNotification(medicineId * 1000 + i);
    }

    // Delete from database
    await _storageService.deleteMedicine(medicineId);
    
     // Remove from local list
    medicines.removeWhere((med) => med.id == medicineId);
    
    // Success - no snackbar here since it will be shown in the UI
    // print('Medicine ${medicine.name} deleted successfully');
    
  } catch (e) {
    // Re-throw the error so it can be caught in the UI
    throw Exception('Failed to delete medicine: $e');
  }
}

Future<void> toggleMedicineStatus(int medicineId, bool isActive) async {
  try {
    await _storageService.updateMedicineStatus(medicineId, isActive);
    
    // Update local list
    final index = medicines.indexWhere((med) => med.id == medicineId);
    if (index != -1) {
      // Reload medicines to get updated data
      await _loadMedicines();
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to update medicine status: $e');
  }
}

  List<Medicine> getTodaysMedicines() {
    final now = DateTime.now();
    return medicines.where((medicine) {
      return medicine.isActive && medicine.scheduledTimes.any((time) {
        return time.hour >= 0 && time.hour <= 23; // All medicines for today
      });
    }).toList();
  }

  List<Map<String, dynamic>> getUpcomingMedicines() {
    final now = DateTime.now();
    List<Map<String, dynamic>> upcoming = [];

    for (Medicine medicine in medicines) {
      if (!medicine.isActive) continue;
      
      for (DateTime time in medicine.scheduledTimes) {
        final todayTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
        if (todayTime.isAfter(now)) {
          upcoming.add({
            'medicine': medicine,
            'scheduledTime': todayTime,
          });
        }
      }
    }

    // Sort by time
    upcoming.sort((a, b) => a['scheduledTime'].compareTo(b['scheduledTime']));
    return upcoming.take(5).toList(); // Return next 5 medicines
  }

  String getMedicineTypeIcon(MedicineType type) {
    switch (type) {
      case MedicineType.tablet:
        return '💊';
      case MedicineType.syrup:
        return '🧴';
      case MedicineType.drops:
        return '💧';
      case MedicineType.injection:
        return '💉';
      case MedicineType.capsule:
        return '💊';
    }
  }

  String getMedicineTypeName(MedicineType type) {
    switch (type) {
      case MedicineType.tablet:
        return 'Tablet';
      case MedicineType.syrup:
        return 'Syrup';
      case MedicineType.drops:
        return 'Drops';
      case MedicineType.injection:
        return 'Injection';
      case MedicineType.capsule:
        return 'Capsule';
    }
  }
}