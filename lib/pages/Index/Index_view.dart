import 'package:flutter/material.dart';
import 'package:platform_vip_analysis/global.dart';
import 'package:platform_vip_analysis/pages/Index/Index_controller.dart';
import 'package:platform_vip_analysis/pages/home/home_view.dart';
import 'package:platform_vip_analysis/pages/login/login_view.dart';
import 'package:platform_vip_analysis/pages/splash/spalsh_view.dart';
import 'package:get/get.dart';

class IndexPage extends GetView<IndexController> {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: controller.isloadWelcomePage.isTrue
              ? SplashPage()
              : Global.isOfflineLogin
                  ? HomePage()
                  : LoginPage(),
        ));
  }
}
