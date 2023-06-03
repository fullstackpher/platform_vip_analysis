import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:platform_vip_analysis/components/components.dart';
import 'package:platform_vip_analysis/components/custom_scaffold.dart';
import 'package:platform_vip_analysis/pages/home/home_controller.dart';
import 'package:platform_vip_analysis/pages/website/website_view.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  final List<String> appNames = [
    '腾讯视频',
    '爱奇艺',
    '优酷视频',
    '芒果TV',
    '搜狐视频',
    '乐视视频',
    'PP视频',
    'M1905电影网',
  ];

  final List<String> appUrls = [
    "https://m.v.qq.com/",
    "https://m.iqiyi.com/",
    "https://m.youku.com",
    "https://m.mgtv.com",
    "https://m.tv.sohu.com/",
    "https://m.le.com/",
    "https://m.pptv.com/",
    "https://m.1905.com",
  ];

  String dirname = "assets/images";

  late List<String?> appIcons = [
    "$dirname/qq.png",
    "$dirname/iqiyi.png",
    "$dirname/youku.png",
    "$dirname/mgtv.png",
    "$dirname/souhu.png",
    "$dirname/letv.png",
    "$dirname/pp.png",
    "$dirname/1905.png",
  ];

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    return BaseScaffold(
      appBar: MyAppBar(
        centerTitle: true,
        title: MyTitle('首页'),
        leadingType: AppBarBackType.None,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Obx(() => Center(child: Text(controller.count.toString()))),
            // TextButton(onPressed: () => controller.increment(), child: Text('count++')),
            // GetBuilder<HomeController>(builder: (_) {
            //   return Text(controller.userName);
            // }),
            // TextButton(onPressed: () => controller.changeUserName(), child: Text('changeName')),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                    padding: const EdgeInsets.all(8),
                    child:
                        Text('使用说明: 选择视频网站，进入到要播放到视频界面，检测视频资源，点击下方播放按钮即可播放')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: appNames.length,
                      gridDelegate: MyGridDelegate(
                        crossAxisCount: 4,
                        mainAxisSpacing: 1,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(WebsitePage(appUrls[index]));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // ImageIcon(
                              //   AssetImage(appIcons[index]!),
                              //   size: 30,
                              // ),
                              Image(
                                image: AssetImage(appIcons[index]!),
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height: 5),
                              Text(
                                appNames[index],
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyGridDelegate extends SliverGridDelegate {
  final int crossAxisCount;
  final double mainAxisSpacing;

  const MyGridDelegate({
    required this.crossAxisCount,
    this.mainAxisSpacing = 0,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double usableWidth =
        constraints.crossAxisExtent - (crossAxisCount - 1) * mainAxisSpacing;
    final double itemWidth = usableWidth / crossAxisCount;
    final double itemHeight = itemWidth * 1.2;
    // final double aspectRatio = itemWidth / itemHeight;

    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: itemHeight + mainAxisSpacing,
      crossAxisStride: itemWidth + mainAxisSpacing,
      childMainAxisExtent: itemHeight,
      childCrossAxisExtent: itemWidth,
      reverseCrossAxis: false,
    );
  }

  @override
  bool shouldRelayout(covariant MyGridDelegate oldDelegate) {
    return crossAxisCount != oldDelegate.crossAxisCount ||
        mainAxisSpacing != oldDelegate.mainAxisSpacing;
  }
}
