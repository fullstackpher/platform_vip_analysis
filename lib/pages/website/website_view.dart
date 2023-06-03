import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:platform_vip_analysis/pages/website/widgets/menu_pannel.dart';
import 'package:platform_vip_analysis/pages/website/widgets/search_bar.dart';
import 'package:platform_vip_analysis/pages/website/widgets/video_player.dart';
import 'package:platform_vip_analysis/utils/log_utils.dart';
import 'website_controller.dart';

class WebsitePage extends GetView<WebsiteController> {
  final String url;

  WebsitePage(this.url, {Key? key}) : super(key: key);

  late InAppWebViewController? pcController;
  late InAppWebViewController? mobileController;
  late final dio = Dio();
  late final globalContext;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => WebsiteController());
    LogUtils.d("构建build URL: ${controller.toPcUrl.value}");
    globalContext = context;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Obx(() => SearchBar(
              urlController: controller.urlController,
              targetContent: controller.toPcUrl.value)),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // PC webview
              Obx(
                () => InAppWebView(
                  initialUrlRequest:
                      URLRequest(url: Uri.parse(controller.toPcUrl.value)),
                  onLoadStop: (controller, url) async {
                    LogUtils.d("当前网页的URL: $url");
                    final targetTitle = await controller.getTitle();

                    LogUtils.d("当前网页的标题: $targetTitle");
                    upgradePcUrl(url.toString(), targetTitle!);
                    LogUtils.d("PC网页URL加载完成....");
                  },
                  onWebViewCreated: _onPcWebViewCreated,
                  initialOptions: _pcOptions,
                ),
              ),

              // 移动端Webview
              InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(this.url)),
                initialOptions: _mobileOptions,
                onLoadStart: (controller, url) {
                  LogUtils.d("移动端网页URL加载开始: $url");
                },
                onLoadStop: (controller, url) {
                  upgradeLoadedState(url.toString());
                },
                onWebViewCreated: _onMobileWebViewCreated,
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final url = navigationAction.request.url;
                  if (url!.scheme != 'https' && url.scheme != 'http') {
                    LogUtils.d(
                        "app:// => current URL 【${Uri.decodeFull(url.toString())}】");
                    return NavigationActionPolicy.CANCEL;
                  } else {
                    // 否则允许页面继续加载
                    LogUtils.d("https:// => current URL 【$url】");
                    return NavigationActionPolicy.ALLOW;
                  }
                },
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

  void upgradePcUrl(String url, String title) {
    controller.updatePcPageState(url, title);

    bool isLoaded = isLegalUrl(controller.targetUrl.value);
    LogUtils.d("PC网页URL: isLegalURL: $isLoaded");

    /* 此处修改判断逻辑 */
    if (isLoaded) {
      controller.updatePcLoaded();
    }

    LogUtils.d("PC网页URL: targetUrl: ${controller.targetUrl.value}");
    LogUtils.d("PC网页URL: targetTitle: ${controller.targetTitle.value}");
    LogUtils.d("PC网页URL: isLoaded: ${controller.isLoaded.value}");

    if (controller.isLoaded.value) {
      EasyLoading.showToast("检测到资源，点击可播放");
      LogUtils.d("URL 检测到资源，点击可播放");
    }
  }

  void upgradeLoadedState(String url) async {
    var pcUrl = url.startsWith('https://m.iqiyi.com')
        ? url.replaceFirst("https://m.", 'https://www.')
        : url;

    controller.updateToPcUrl(pcUrl);
    if (controller.isLoaded.value) {
      controller.updatePcLoaded();
    }

    LogUtils.d("to PC URL: ${controller.toPcUrl.value}");
  }

  List<Widget> menuWidgets() {
    LogUtils.d("底部菜单URL: controller.isLoaded: ${controller.isLoaded.value}");

    return [
      GestureDetector(
        onTap: () => _onIconTapped(0),
        child: const Icon(
          Icons.keyboard_arrow_left_outlined,
          size: 33,
          color: Colors.grey,
        ),
      ),
      GestureDetector(
        onTap: () => _onIconTapped(1),
        child: const Icon(
          Icons.keyboard_arrow_right_outlined,
          size: 33,
          color: Colors.grey,
        ),
      ),
      GestureDetector(
        onTap: () => _onIconTapped(2),
        child: Obx(
          () => Icon(
            Icons.slideshow,
            size: 30,
            color: controller.isLoaded.value ? Colors.redAccent : Colors.grey,
          ),
        ),
      ),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _onIconTapped(3),
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0)
              .animate(controller.animationController),
          child: const Icon(
            Icons.refresh_rounded,
            size: 30,
            color: Colors.grey,
          ),
        ),
      ),
      GestureDetector(
        onTap: () => _onIconTapped(4),
        child: const Icon(
          // Icons.refresh_rounded
          Icons.close_rounded,
          size: 30,
          color: Colors.grey,
        ),
      ),
    ];
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
    LogUtils.d("刷新网页URL: ${controller.targetUrl.value}");
    await _refreshPage();
  }

  Future<void> _refreshPage() async {
    await mobileController!.reload();
    await pcController!.loadUrl(
        urlRequest: URLRequest(url: Uri.parse(controller.toPcUrl.value)));
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

        // 刷新网页
        _refreshPage();
        // 弹出面板 - 嗅探资源
        _detectionResource();
        resourceSniffer(globalContext);
        // 点击播放

        break;
      case 3:
        _refreshPageWithRotation();
        _detectionResource();
        break;
      case 4:
        // 退出网页
        Get.back();
        break;
    }
  }

  void _detectionResource() {
    if (controller.isLoaded.value) {
      EasyLoading.showToast("检测到资源，点击可播放");
      LogUtils.d("URL 检测到资源，点击可播放");
    }
  }

  void resourceSniffer(context) async {
    try {
      controller.updateResource(controller.targetUrl.value);
      LogUtils.d("请求的URL: ${controller.resource.value}");
      final res = await dio.get(controller.resource.value);
      LogUtils.d("响应数据: $res");
      Map<String, dynamic> data = json.decode(res.data.toString());
      String videoUrl = data['url'];
      LogUtils.d("finalURL: $videoUrl");
      if (videoUrl.isNotEmpty) {
        int? result = await _showResourcePanel(context, videoUrl);
        LogUtils.d("result: $result");
      }
    } catch (e) {
      EasyLoading.showToast(e.toString());
      LogUtils.e("Error Info: $e");
    }
  }

  final InAppWebViewGroupOptions _mobileOptions = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      userAgent:
          "Mozilla/5.0 (Linux; Android 9; SM-N950N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Mobile Safari/537.36",
    ),
  );

  final InAppWebViewGroupOptions _pcOptions = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      userAgent:
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.16299',
    ),
  );

  void _onPcWebViewCreated(controller) {
    pcController = controller;
  }

  void _onMobileWebViewCreated(controller) {
    mobileController = controller;
  }

  bool isLegalUrl(String url) {
    final urlRegExp =
        RegExp(r'^(?:http|https):\/\/(?:[\w-]+\.)+[\w-]+(?:\/[\w-./?%&=]*)?$');
    final mobileRegExp = RegExp(r'^https?://m\..+', caseSensitive: false);
    return urlRegExp.hasMatch(url) && !mobileRegExp.hasMatch(url);
  }

  Future<int?> _showResourcePanel(context, String videoUrl) async {
    return showModalBottomSheet<int>(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          height: 80,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10.0),
                child: const Align(
                  alignment: FractionalOffset.topCenter,
                  child: Text('嗅探结果'),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      width: double.infinity,
                      child: Text(
                        videoUrl.length > 20
                            ? '${videoUrl.substring(0, 50)}...'
                            : videoUrl,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        Get.to(VideoPlayer(
                            url: videoUrl,
                            title: controller.targetTitle.value));
                      },
                      icon: const Icon(
                        Icons.play_circle_fill_outlined,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
