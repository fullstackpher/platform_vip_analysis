import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebsiteController extends GetxController
    with SingleGetTickerProviderMixin {
  late final AnimationController animationController;
  late final TextEditingController urlController;

  final currentUrl = ''.obs;
  final currentTitle = ''.obs;
  final currentIndex = 0.obs;
  final isResource = false.obs;
  final currentxl = 'https://jx.m3u8.tv/jiexi/?url='.obs;

  List<BrnCommonActionSheetItem> actions = [
    BrnCommonActionSheetItem(
      '诺讯解析',
      actionStyle: BrnCommonActionSheetItemStyle.link,
    ),
    BrnCommonActionSheetItem(
      'm3u8解析',
      actionStyle: BrnCommonActionSheetItemStyle.link,
    ),
    BrnCommonActionSheetItem(
      'ok解析',
      actionStyle: BrnCommonActionSheetItemStyle.link,
    ),
    BrnCommonActionSheetItem(
      '通用线路1',
      actionStyle: BrnCommonActionSheetItemStyle.link,
    ),
    BrnCommonActionSheetItem(
      '通用线路2',
      actionStyle: BrnCommonActionSheetItemStyle.link,
    ),
  ];

  List<String> xl = [
    'https://www.nxflv.com/?url=',
    'https://jx.m3u8.tv/jiexi/?url=',
    'https://okjx.cc/?url=',
    'https://jx.bozrc.com:4433/player/?url=',
    'https://jx.playerjy.com/?url=',
  ];

  void updateCurrentXl(int index) => currentxl.value = xl[index];

  void updateIsResource(bool isResourced) => isResource.value = isResourced;

  void updateCurrentIndex(int index) => currentIndex.value = index;

  void updateCurrentResource(String url, String title) {
    currentUrl.value = url;
    currentTitle.value = title;
  }

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
