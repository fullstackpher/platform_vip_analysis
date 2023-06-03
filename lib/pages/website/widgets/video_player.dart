import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:fijkplayer_skin/schema.dart' show VideoSourceFormat;
import 'package:flutter/material.dart';
import 'package:platform_vip_analysis/pages/website/widgets/search_bar.dart';
import 'package:platform_vip_analysis/utils/log_utils.dart';

class VideoPlayer extends StatefulWidget {
  final String url;
  final String title;

  const VideoPlayer({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

// 这里实现一个皮肤显示配置项
class PlayerShowConfig implements ShowConfigAbs {
  @override
  bool drawerBtn = true;
  @override
  bool nextBtn = true;
  @override
  bool speedBtn = true;
  @override
  bool topBar = true;
  @override
  bool lockBtn = true;
  @override
  bool autoNext = true;
  @override
  bool bottomPro = true;
  @override
  bool stateAuto = true;
  @override
  bool isAutoPlay = true;
}

class _VideoPlayerState extends State<VideoPlayer> {
  // FijkPlayer实例
  final FijkPlayer player = FijkPlayer();
  final TextEditingController _urlController =
      TextEditingController(); // 声明一个文本控制器

  // 当前tab的index，默认0
  int _curTabIdx = 0;

  // 当前选中的tablist index，默认0
  int _curActiveIdx = 0;

  ShowConfigAbs vCfg = PlayerShowConfig();

  Map<String, List<Map<String, dynamic>>> xlList = {
    "video": [
      {
        "name": "切换线路",
        "list": [
          {"url": '', "name": "线路1"},
          {"url": '', "name": "线路2"},
          {"url": '', "name": "线路3"},
        ]
      }
    ]
  };

  Map<String, List<Map<String, dynamic>>> generateVideoList(String url) {
    List<Map<String, dynamic>> list = [];
    xlList['video']?.forEach((e) {
      if (e['name'] == '切换线路') {
        e['list'].forEach((element) {
          String targetUrl = url;
          Map<String, dynamic> item = {
            "url": targetUrl,
            "name": element['name']
          };
          list.add(item);
        });
      } else {
        list.add(e);
      }
    });

    return {
      "video": [
        {"name": "切换线路", "list": list}
      ]
    };
  }

  VideoSourceFormat? _videoSourceTabs;

  @override
  void initState() {
    super.initState();
    Map<String, List<Map<String, dynamic>>> mvList =
        generateVideoList(widget.url);
    LogUtils.d("清单列表: $mvList");
    _videoSourceTabs = VideoSourceFormat.fromJson(mvList);
    // 这句不能省，必须有
    speed = 1.0;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  // 播放器内部切换视频钩子，回调，tabIdx 和 activeIdx
  void onChangeVideo(int curTabIdx, int curActiveIdx) {
    setState(() {
      _curTabIdx = curTabIdx;
      _curActiveIdx = curActiveIdx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: SearchBar(
              urlController: _urlController, targetContent: '⚠️：请不要相信视频中的广告'),
          backgroundColor: Colors.white,
        ),
        body: Container(
            alignment: Alignment.topCenter,
            // 这里 FijkView 开始为自定义 UI 部分
            child: FijkView(
              height: 240,
              color: Colors.black,
              fit: FijkFit.cover,
              player: player,
              panelBuilder: (
                FijkPlayer player,
                FijkData data,
                BuildContext context,
                Size viewSize,
                Rect texturePos,
              ) {
                /// 使用自定义的布局
                return CustomFijkPanel(
                  player: player,
                  // 传递 context 用于左上角返回箭头关闭当前页面，不要传递错误 context，
                  // 如果要点击箭头关闭当前的页面，那必须传递当前组件的根 context
                  pageContent: context,
                  viewSize: viewSize,
                  texturePos: texturePos,
                  // 标题 当前页面顶部的标题部分，可以不传，默认空字符串
                  playerTitle: widget.title,
                  // 当前视频改变钩子，简单模式，单个视频播放，可以不传
                  onChangeVideo: onChangeVideo,
                  // 当前视频源tabIndex
                  curTabIdx: _curTabIdx,
                  // 当前视频源activeIndex
                  curActiveIdx: _curActiveIdx,
                  // 显示的配置
                  showConfig: vCfg,
                  // json格式化后的视频数据
                  videoFormat: _videoSourceTabs,
                );
              },
            )),
      ),
    );
  }
}
