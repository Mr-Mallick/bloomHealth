import 'package:get/get.dart';
import '../controllers/fertility_controller.dart';
import '../data/services/fertility_calculation_service.dart';

class FertilityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FertilityCalculationService>(() => FertilityCalculationService());
    Get.lazyPut<FertilityController>(() => FertilityController());
  }
}