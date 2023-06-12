import 'package:flutter/material.dart';
import 'package:platform_vip_analysis/utils/icon_badge.dart';
// import 'package:icon_badge/icon_badge.dart';

class IconWithBadge extends StatelessWidget {
  final IconData icon;
  final bool hasBadge;

  const IconWithBadge({
    Key? key,
    required this.icon,
    this.hasBadge = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconBadge(
      itemCount: 0,
      itemColor: Colors.transparent,
      hideZero: hasBadge,
      badgeColor: Colors.redAccent,
      icon: Icon(icon, size: 28, color: Colors.grey,),
      top: 5.0, // 调整小红点距离顶部的距离
      right: 10.0, // 调整小红点距离右侧的距离
    );
  }
}
