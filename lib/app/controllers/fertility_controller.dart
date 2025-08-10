import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/fertility_model.dart';
import '../data/services/storage_service.dart';
import '../data/services/fertility_calculation_service.dart';
import '../data/services/notification_service.dart';
import 'medicine_controller.dart'; // Add this import

class FertilityController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final FertilityCalculationService _calculationService = Get.find<FertilityCalculationService>();
  final NotificationService _notificationService = Get.find<NotificationService>();

  // Observables
  final Rx<FertilityData?> currentData = Rx<FertilityData?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isFirstTime = true.obs;
  final RxList<PeriodEntry> periodHistory = <PeriodEntry>[].obs;

  // Form variables
  final Rx<DateTime?> periodStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> periodEndDate = Rx<DateTime?>(null);
  final RxInt cycleLength = 28.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    isLoading.value = true;
    
    // Check if it's first time
    isFirstTime.value = _storageService.isFirstTime();
    
    if (!isFirstTime.value) {
      // Load existing data
      final data = await _storageService.getLatestFertilityData();
      currentData.value = data;
    }
    
    isLoading.value = false;
  }

  Future<void> setupInitialData({
    required DateTime startDate,
    required DateTime endDate,
    int cycleLength = 28,
  }) async {
    isLoading.value = true;

    try {
      // Calculate fertility data
      final ovulationDate = _calculationService.calculateOvulationDate(startDate, cycleLength);
      final nextPeriodDate = _calculationService.calculateNextPeriodDate(startDate, cycleLength);
      final fertileDays = _calculationService.calculateFertileDays(ovulationDate);

      final fertilityData = FertilityData(
        id: 0, // Will be set by database
        periodStart: startDate,
        periodEnd: endDate,
        cycleLength: cycleLength,
        nextPeriodDate: nextPeriodDate,
        ovulationDate: ovulationDate,
        fertileDays: fertileDays,
      );

      // Save to database
      await _storageService.saveFertilityData(fertilityData);
      
      // Update state
      currentData.value = fertilityData;
      isFirstTime.value = false;
      _storageService.setFirstTime(false);

      // Schedule notifications
      await _scheduleNotifications(fertilityData);

      Get.defaultDialog(
        title:  '✅ Success',
        content: Text('Fertility tracking has been set up successfully!'),
        onConfirm: () {
          Get.back();
          Get.back();
        },
        textConfirm: "Dashbaord"
      );

      // Get.snackbar(
      //   '✅ Success',
      //   'Fertility tracking has been set up successfully!',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green[100],
      //   colorText: Colors.green[800],
      //   duration: const Duration(seconds: 3),
      //   margin: const EdgeInsets.all(16),
      //   borderRadius: 8,
      // );
    } catch (e) {
      // print("$e");
       Get.defaultDialog(
        title:  '❌ Error',
        content: Text('Failed to setup fertility tracking: $e'),
        onConfirm: () {
          Get.back();
        },
        textConfirm: "Retry"
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _scheduleNotifications(FertilityData data) async {
    // Schedule period reminder (1 day before expected period)
    final periodReminderDate = data.nextPeriodDate.subtract(const Duration(days: 1));
    await _notificationService.schedulePeriodReminder(
      id: 1000,
      scheduledTime: periodReminderDate,
      title: 'Period Reminder 🌸',
      body: 'Your period is expected tomorrow. Be prepared!',
    );

    // Schedule fertile window reminder
    if (data.fertileDays.isNotEmpty) {
      final fertileReminderDate = data.fertileDays.first;
      await _notificationService.schedulePeriodReminder(
        id: 1001,
        scheduledTime: fertileReminderDate,
        title: 'Fertile Window Started 🌸',
        body: 'Your fertile window has begun. Good luck!',
      );
    }
  }

  String getFertilityStatusForDate(DateTime date) {
    if (currentData.value == null) return 'normal';
    
    final data = currentData.value!;
    final periodDays = _calculationService.calculatePeriodDays(
      data.periodStart, 
      data.periodEnd
    );

    return _calculationService.getFertilityStatus(
      date,
      periodDays: periodDays,
      fertileDays: data.fertileDays,
      ovulationDate: data.ovulationDate,
      nextPeriodDate: data.nextPeriodDate,
    );
  }

  // Add method to get medicines for a specific date
  List<String> getMedicinesForDate(DateTime date) {
    try {
      final medicineController = Get.find<MedicineController>();
      final medicines = medicineController.medicines;
      
      List<String> dayMedicines = [];
      
      for (var medicine in medicines) {
        if (!medicine.isActive) continue;
        
        for (var time in medicine.scheduledTimes) {
          // Check if this medicine has a schedule for this day
          // For simplicity, we'll assume all medicines are daily
          dayMedicines.add('${medicine.name} at ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
        }
      }
      
      return dayMedicines;
    } catch (e) {
      return [];
    }
  }

  Future<void> updatePeriodData(DateTime startDate, DateTime endDate) async {
    if (currentData.value == null) return;

    isLoading.value = true;
    try {
      // Recalculate based on new period data
      await setupInitialData(
        startDate: startDate,
        endDate: endDate,
        cycleLength: cycleLength.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setCycleLength(int length) {
    cycleLength.value = length;
  }

  void setPeriodDates(DateTime start, DateTime end) {
    periodStartDate.value = start;
    periodEndDate.value = end;
  }
}