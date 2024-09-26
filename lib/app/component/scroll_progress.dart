import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../util/key_controller.dart';

class ScrollProgressBar extends StatelessWidget implements PreferredSizeWidget {
  const ScrollProgressBar({super.key, required this.height});

  @override
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  Widget build(BuildContext context) {
    final keyController = Get.put(KeyController());

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 4,
        child: ValueListenableBuilder<double>(
          valueListenable: keyController.scrollProgress,
          builder: (context, value, child) {
            return LinearProgressIndicator(
              minHeight: 4,
              value: value,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            );
          },
        ),
      ),
    );
  }
}