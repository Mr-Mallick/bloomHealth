import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../fertility/fertility_page.dart';
import '../fluid/fluid_page.dart';
import '../medicine/medicine_page.dart';
import '../../widgets/custom_bottom_navigation.dart';

class HomePage extends GetView<HomeController> {
  final List<Widget> _pages = [
    FertilityPage(),
    FluidPage(),
    MedicinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: _pages,
      )),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}