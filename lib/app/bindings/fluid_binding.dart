import 'package:get/get.dart';
import '../controllers/fluid_controller.dart';

class FluidBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FluidController>(() => FluidController());
  }
}