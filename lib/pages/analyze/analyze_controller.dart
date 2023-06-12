import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyzeController extends GetxController {
  final currentIndex = 0.obs;
  final currentxl = ''.obs;
  final currentUrl = ''.obs;

  late final TextEditingController urlController;

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

  void updateCurrentUrl(String url) => currentUrl.value = url;

  void updateCurrentXlFromIndex(int index) => currentxl.value = xl[index];
  void updateCurrentXlFromProps(String url) => currentxl.value = url;

  void updateCurrentIndex(int index) => currentIndex.value = index;

  @override
  void onInit() {
    super.onInit();
    urlController = TextEditingController();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}
}
