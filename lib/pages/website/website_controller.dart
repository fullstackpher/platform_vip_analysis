import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebsiteController extends GetxController
    with SingleGetTickerProviderMixin {
  late final AnimationController animationController;
  late final TextEditingController urlController;

  final toPcUrl = ''.obs;
  final targetUrl = ''.obs;
  final targetTitle = ''.obs;
  final resource = ''.obs;
  final currentIndex = 0.obs;
  final isLoaded = false.obs;

  void updateCurrentIndex(int index) => currentIndex.value = index;

  void updateToPcUrl(String url) => toPcUrl.value = url;

  void updateResource(String url) => resource.value =
      'https://j.md214.cn/home/api?type=ys&uid=4985583&key=bceinqryGINOTUY078&url=$url';

  void updatePcPageState(String url, String title) {
    targetUrl.value = url;
    targetTitle.value = title;
  }

  void updatePcLoaded() => isLoaded.toggle();

  @override
  void onInit() {
    super.onInit();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    urlController = TextEditingController();
  }

  @override
  void onClose() {
    animationController.dispose();
    urlController.dispose();
  }

  void forceUpdate() {
    update();
  }
}
