import 'package:get/get.dart';
import '../ui/pages/home/home_page.dart';
import '../ui/pages/fertility/fertility_page.dart';
import '../ui/pages/fertility/fertility_setup_page.dart';
import '../ui/pages/fluid/fluid_page.dart';
import '../ui/pages/fluid/fluid_setup_page.dart';
import '../ui/pages/medicine/medicine_page.dart';
import '../ui/pages/medicine/add_medicine_page.dart';
import '../bindings/home_binding.dart';
import '../bindings/fertility_binding.dart';
import '../bindings/fluid_binding.dart';
import '../bindings/medicine_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FERTILITY,
      page: () => FertilityPage(),
      binding: FertilityBinding(),
    ),
    GetPage(
      name: _Paths.FERTILITY_SETUP,
      page: () => FertilitySetupPage(),
      binding: FertilityBinding(),
    ),
    GetPage(
      name: _Paths.FLUID,
      page: () => FluidPage(),
      binding: FluidBinding(),
    ),
    GetPage(
      name: _Paths.FLUID_SETUP,
      page: () => FluidSetupPage(),
      binding: FluidBinding(),
    ),
    GetPage(
      name: _Paths.MEDICINE,
      page: () => MedicinePage(),
      binding: MedicineBinding(),
    ),
    GetPage(
      name: _Paths.ADD_MEDICINE,
      page: () => AddMedicinePage(),
      binding: MedicineBinding(),
    ),
  ];
}