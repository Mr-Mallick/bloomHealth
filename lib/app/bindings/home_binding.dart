import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/fertility_controller.dart';
import '../controllers/fluid_controller.dart';
import '../controllers/medicine_controller.dart';
import '../data/services/fertility_calculation_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FertilityCalculationService>(() => FertilityCalculationService());
    Get.lazyPut<FertilityController>(() => FertilityController());
    Get.lazyPut<FluidController>(() => FluidController());
    Get.lazyPut<MedicineController>(() => MedicineController());
  }
}