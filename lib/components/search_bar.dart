import 'package:flutter/material.dart';
import 'package:platform_vip_analysis/utils/log_utils.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required TextEditingController urlController,
    required String targetContent,
  })  : _urlController = urlController,
        _targetContent = targetContent,
        super(key: key);

  final TextEditingController _urlController;
  final String _targetContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: TextFormField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: InputDecoration(
                hintText: _targetContent,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(10),
              ),
              enabled: false,
              textAlign: TextAlign.left,
              onTap: () => LogUtils.d('拷贝当前内容'),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.close, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
