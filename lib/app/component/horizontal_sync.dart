import 'package:flutter/material.dart';

class HorizontalScrollSync extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollController verticalScrollController;

  HorizontalScrollSync({
    required this.itemCount,
    required this.itemBuilder,
    required this.verticalScrollController,
  });

  @override
  _HorizontalScrollSyncState createState() => _HorizontalScrollSyncState();
}

class _HorizontalScrollSyncState extends State<HorizontalScrollSync> {
  late ScrollController _horizontalScrollController;
  int? _hoveredIndex;
  int? _tappedIndex;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    widget.verticalScrollController.addListener(() {
      if (_horizontalScrollController.hasClients) {
        _horizontalScrollController.jumpTo(widget.verticalScrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _onHover(int index, bool isHovered) {
    setState(() {
      _hoveredIndex = isHovered ? index : null;
    });
  }

  void _onTapDown(int index) {
    setState(() {
      _tappedIndex = index;
    });
  }

  void _onTapUp() {
    setState(() {
      _tappedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      child: ListView.builder(
        controller: _horizontalScrollController,
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(), // Отключаем возможность прокрутки
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          double scale = 1.0;

          // Эффект увеличения при наведении
          if (_hoveredIndex != null) {
            int distance = (_hoveredIndex! - index).abs();
            if (distance == 0) {
              scale = 1.45;
            } else if (distance == 1) {
              scale = 1.3;
            } else if (distance == 2) {
              scale = 1.25;
            } else if (distance == 3) {
              scale = 1.1;
            } else if (distance == 4) {
              scale = 1.05;
            }
          }

          // Эффект уменьшения при нажатии
          if (_tappedIndex != null) {
            int distance = (_tappedIndex! - index).abs();
            if (distance == 0) {
              scale = 0.8; // Центральный элемент — максимальное уменьшение
            } else if (distance == 1) {
              scale = 0.9;
            } else if (distance == 2) {
              scale = 0.95;
            } else if (distance == 3) {
              scale = 1.0;
            } else if (distance == 4) {
              scale = 1.0; // Возвращение к исходному масштабу
            }
          }

          return GestureDetector(
            onTapDown: (_) => _onTapDown(index),
            onTapUp: (_) => _onTapUp(),
            onTapCancel: _onTapUp,
            child: MouseRegion(
              onEnter: (_) => _onHover(index, true),
              onExit: (_) => _onHover(index, false),
              child: AnimatedScale(
                scale: scale,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: widget.itemBuilder(context, index),
              ),
            ),
          );
        },
      ),
    );
  }
}