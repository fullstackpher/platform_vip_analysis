import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:platform_vip_analysis/components/icon_with_badge.dart';
import 'package:platform_vip_analysis/components/menu_pannel.dart';
import 'package:platform_vip_analysis/components/search_bar.dart';
import 'package:platform_vip_analysis/pages/analyze/analyze_view.dart';
import 'package:platform_vip_analysis/utils/log_utils.dart';

import 'website_controller.dart';

class WebsitePage extends GetView<WebsiteController> {
  final String url;

  WebsitePage(this.url, {Key? key}) : super(key: key);

  late InAppWebViewController? mobileController;
  late BuildContext currentContext;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<WebsiteController>(() => WebsiteController());
    currentContext = context;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Obx(() => SearchBar(
                urlController: controller.urlController,
                targetContent: controller.currentUrl.value,
              )),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(this.url)),
            initialOptions: _mobileOptions,
            onLoadStart: (controller, url) async {
              LogUtils.d("移动端URL onLoadStart =>: $url");
            },
            onLoadStop: (controller, url) async {
              LogUtils.d("移动端URL onLoadStop =>: $url");
              final title = await controller.getTitle();
              upgradeLoadedState(url.toString(), title!);
            },
            onWebViewCreated: _onMobileWebViewCreated,
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url;
              if (url!.scheme != 'https' && url.scheme != 'http') {
                return NavigationActionPolicy.CANCEL;
              } else {
                // 否则允许页面继续加载
                return NavigationActionPolicy.ALLOW;
              }
            },
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

  void upgradeLoadedState(String url, String title) async {
    // 更新操作
    controller.updateCurrentResource(url, title);
    if (isLegalUrl(url)) {
      EasyLoading.showToast("解析到视频资源，点击可播放");
      controller.updateIsResource(true);
    } else {
      controller.updateIsResource(false);
    }
  }

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
      GestureDetector(
        onTap: () => _onIconTapped(2),
        child: Obx(() => IconWithBadge(
              icon: IconData(0xe6b5, fontFamily: 'AntdIcons'),
              hasBadge: !controller.isResource.value,
            )),
      ),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _onIconTapped(3),
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0)
              .animate(controller.animationController),
          child: const Icon(
            IconData(0xe7ef, fontFamily: 'AntdIcons'),
            size: 23,
            color: Colors.grey,
          ),
        ),
      ),
      GestureDetector(
        onTap: () => _onIconTapped(4),
        child: const Icon(
          IconData(0xe6dc, fontFamily: 'AntdIcons'),
          size: 30,
          color: Colors.grey,
        ),
      ),
    ];
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
              controller.updateCurrentXl(index);
            },
          );
        });
  }

  void _onIconTappedAnimated() {
    if (controller.animationController.isAnimating) {
      controller.animationController.stop();
    } else {
      controller.animationController.reset();
      controller.animationController.forward();
    }
  }

  Future<void> _refreshPageWithRotation() async {
    // 启动旋转图标动画
    _onIconTappedAnimated();

    // 加载网页
    await _refreshPage();
  }

  Future<void> _refreshPage() async {
    await mobileController!.reload();
  }

  _onIconTapped(int index) async {
    switch (index) {
      case 0:
        // 网页后退
        mobileController!.goBack();
        break;
      case 1:
        // 网页前进
        mobileController!.goForward();
        break;
      case 2:
        // 3、去播放详情页
        _refreshPage();
        final currentUrl = controller.currentUrl.value;
        final currentXl = controller.currentxl.value;

        Get.to(AnalyzePage(currentUrl, currentXl));
        LogUtils.d("current url: ${controller.currentUrl.value}");
        LogUtils.d("current xl: ${controller.currentxl.value}");
        break;
      case 3:
        // 1、刷新网页
        _refreshPage();

        // 2、弹出选择框
        showJkModalBottomSheet();

        // 3、切换线路

        break;
      case 4:
        // 退出网页
        Get.back();
        break;
    }
  }

  final InAppWebViewGroupOptions _mobileOptions = InAppWebViewGroupOptions(
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

  void _onMobileWebViewCreated(controller) async {
    mobileController = controller;
  }

  bool isLegalUrl(String url) {
    final urlRegExp =
        RegExp(r'^(?:http|https):\/\/(?:[\w-]+\.)+[\w-]+(?:\/[\w-./?%&=]*)?$');
    final resourceExp = RegExp(r'(vid|html|drawer|fpos|columnid)');
    return urlRegExp.hasMatch(url) && resourceExp.hasMatch(url);
  }
}
