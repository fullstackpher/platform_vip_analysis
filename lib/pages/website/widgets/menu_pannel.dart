import 'package:flutter/material.dart';

class MenuPanel extends StatefulWidget {
  final List<Widget> children;
  final ValueChanged<int> onItemSelected;
  final int currentIndex;

  const MenuPanel({
    required this.children,
    required this.onItemSelected,
    required this.currentIndex,
  });

  @override
  _MenuPanelState createState() => _MenuPanelState();
}

class _MenuPanelState extends State<MenuPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0, // 设置导航栏的高度
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 设置内边距
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.children.length,
              (index) => Expanded(
            child: GestureDetector(
              onTap: () => widget.onItemSelected(index),
              child: widget.children[index],
            ),
          ),
        ),
      ),
    );
  }
}
