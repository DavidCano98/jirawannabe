import 'package:get/get.dart';
import 'package:jirawannabe/controllers/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}