import 'package:get/get.dart';
import 'package:zishan_hossain/feature/table_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(TableController());
  }
}