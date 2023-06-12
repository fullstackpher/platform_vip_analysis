import 'package:get/get.dart';
import 'analyze_controller.dart';

class AnalyzeBinding extends Bindings {
    @override
    void dependencies() {
    Get.lazyPut<AnalyzeController>(() => AnalyzeController());
    }
}
