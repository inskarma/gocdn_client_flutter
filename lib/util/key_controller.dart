import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeyController extends GetxController {
  final GlobalKey section1Key = GlobalKey();
  final GlobalKey section2Key = GlobalKey();
  final GlobalKey section3Key = GlobalKey();
  final GlobalKey section4Key = GlobalKey();
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<double> scrollProgress = ValueNotifier(0.0);
  final ValueNotifier<int> currentSection = ValueNotifier(0);

  KeyController() {
    scrollController.addListener(_updateScrollProgress);
    scrollController.addListener(_updateCurrentSection);
  }

  void scrollToSection(GlobalKey key,int duration ) {
    print(key);
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(seconds: duration),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  void _updateScrollProgress() {
    final maxScrollExtent = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    scrollProgress.value = (currentScroll / maxScrollExtent).clamp(0.0, 1.0);
  }

  void _updateCurrentSection() {
    if (_isInSection(section1Key)) {
      currentSection.value = 0;
    } else if (_isInSection(section2Key)) {
      currentSection.value = 1;
    } else if (_isInSection(section3Key)) {
      currentSection.value = 2;
    } else if (_isInSection(section4Key)) {
      currentSection.value = 3;
    }
  }

  bool _isInSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = box.localToGlobal(Offset.zero);
        final screenHeight = Get.context!.size!.height;
        return position.dy >= 0 && position.dy < screenHeight;
      }
    }
    return false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
