import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:platform_vip_analysis/components/menu_pannel.dart';
import 'package:platform_vip_analysis/components/search_bar.dart';
import 'package:platform_vip_analysis/utils/log_utils.dart';

import 'analyze_controller.dart';

class AnalyzePage extends GetView<AnalyzeController> {
  AnalyzePage(this.currentUrl, this.currentxl, {Key? key}) : super(key: key);
  final String currentUrl;
  final String currentxl;

  late InAppWebViewController _webView;
  late BuildContext currentContext;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<AnalyzeController>(() => AnalyzeController());
    currentContext = context;
    controller.updateCurrentXlFromProps(currentxl);
    LogUtils.d("current url: ${controller.currentUrl.value}");
    controller.updateCurrentUrl(controller.currentxl.value + currentUrl);

    LogUtils.d("current url: ${controller.currentUrl.value}");

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Obx(
            () => SearchBar(
              urlController: controller.urlController,
              targetContent: controller.currentUrl.value,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // 页面主体
              Expanded(
                child: InAppWebView(
                  initialUrlRequest:
                      URLRequest(url: Uri.parse(controller.currentUrl.value)),
                  onLoadStop: (controller, url) {
                    LogUtils.d('Finished loading: $url');
                  },
                  onWebViewCreated: (controller) {
                    _webView = controller;
                  },
                  initialOptions: _options,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: MenuPanel(
          onItemSelected: (index) {
            controller.updateCurrentIndex(index);
          },
          currentIndex: controller.currentIndex.value,
          children: menuWidgets(),
        ),
      ),
    );
  }

  final InAppWebViewGroupOptions _options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),

    /// android 支持HybridComposition
    android: AndroidInAppWebViewOptions(
      // 这两个才是安卓混合内容加载
      useHybridComposition: true,
      mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    ),
    ios: IOSInAppWebViewOptions(
      // iOS混合内容加载
      allowsInlineMediaPlayback: true,
    ),
  );

  List<Widget> menuWidgets() {
    return [
      GestureDetector(
        onTap: () => _onIconTapped(0),
        child: const Icon(
          IconData(0xe6c2, fontFamily: 'AntdIcons'),
          size: 33,
          color: Colors.grey,
        ),
      ),
      GestureDetector(
        onTap: () => _onIconTapped(1),
        child: const Icon(
          IconData(0xe6c4, fontFamily: 'AntdIcons'),
          size: 33,
          color: Colors.grey,
        ),
      ),
      // GestureDetector(
      //   onTap: () => _onIconTapped(2),
      //   child: Obx(() => IconWithBadge(
      //         icon: IconData(0xe6b5, fontFamily: 'AntdIcons'),
      //         hasBadge: !controller.isResource.value,
      //       )),
      // ),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _onIconTapped(2),
        child: const Icon(
          IconData(0xe7ef, fontFamily: 'AntdIcons'),
          size: 23,
          color: Colors.grey,
        ),
      ),
      GestureDetector(
        onTap: () => _onIconTapped(3),
        child: const Icon(
          IconData(0xe6dc, fontFamily: 'AntdIcons'),
          size: 30,
          color: Colors.grey,
        ),
      ),
    ];
  }

  _onIconTapped(int index) {
    switch (index) {
      case 0:
        // 网页后退
        break;
      case 1:
        // 网页前进
        break;
      // case 2:
      // 3、去播放详情页
      // _refreshPage();
      // Get.to(AnalyzePage());
      // LogUtils.d("current url: ${controller.currentUrl.value}");
      // LogUtils.d("current xl: ${controller.currentxl.value}");
      // break;
      case 2:
        // 2、弹出选择框
        showJkModalBottomSheet();

        break;
      case 3:
        // 退出网页
        Get.back();
        break;
    }
  }

  void showJkModalBottomSheet() {
    showModalBottomSheet(
        context: currentContext,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return BrnCommonActionSheet(
            title: "切换线路",
            actions: controller.actions,
            clickCallBack: (
              int index,
              BrnCommonActionSheetItem actionEle,
            ) {
              controller.updateCurrentXlFromIndex(index);
              controller
                  .updateCurrentUrl('${controller.currentxl.value}$currentUrl');
              _refreshPage(controller.currentUrl.value);
            },
          );
        });
  }

  void _refreshPage(String url) {
    _webView.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)));
  }
}
