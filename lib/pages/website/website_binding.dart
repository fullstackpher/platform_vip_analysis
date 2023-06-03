import 'package:get/get.dart';
import 'website_controller.dart';

class WebsiteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebsiteController>(() => WebsiteController());
  }
}
