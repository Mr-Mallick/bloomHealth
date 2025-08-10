import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../theme/app_colors.dart';

class CustomBottomNavigation extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Obx(() => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurface,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: controller.selectedIndex.value == 0
                      ? AppColors.primaryLight.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '🌸',
                  style: TextStyle(
                    fontSize: controller.selectedIndex.value == 0 ? 24 : 20,
                  ),
                ),
              ),
              label: 'Fertility',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: controller.selectedIndex.value == 1
                      ? AppColors.primaryLight.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '💧',
                  style: TextStyle(
                    fontSize: controller.selectedIndex.value == 1 ? 24 : 20,
                  ),
                ),
              ),
              label: 'Hydration',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: controller.selectedIndex.value == 2
                      ? AppColors.primaryLight.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '💊',
                  style: TextStyle(
                    fontSize: controller.selectedIndex.value == 2 ? 24 : 20,
                  ),
                ),
              ),
              label: 'Medicine',
            ),
          ],
        )),
      ),
    );
  }
}