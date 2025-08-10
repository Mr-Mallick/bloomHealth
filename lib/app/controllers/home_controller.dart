import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  
  final List<String> tabTitles = [
    'Fertility',
    'Hydration',
    'Medicines',
  ];

  final List<String> tabIcons = [
    '🌸',
    '💧',
    '💊',
  ];

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  String get currentTitle => tabTitles[selectedIndex.value];
  String get currentIcon => tabIcons[selectedIndex.value];
}