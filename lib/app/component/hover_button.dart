import 'package:flutter/material.dart';

class HoverEffectButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double expanded;
  final double shrink;
  final int milsec;

  const HoverEffectButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.expanded,
    required this.milsec,
    required this.shrink,
  }) : super(key: key);

  @override
  _HoverEffectButtonState createState() => _HoverEffectButtonState();
}

class _HoverEffectButtonState extends State<HoverEffectButton> {
  bool _isHovered = false;
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTap(true), // Поймать событие нажатия
      onTapUp: (_) => _onTap(false), // Поймать событие отпускания
      onTapCancel: () => _onTap(false), // Если тап был отменен
      onTap: widget.onPressed, // Обработчик нажатия
      child: MouseRegion(
        onEnter: (_) => _onHover(true), // Наведение мыши
        onExit: (_) => _onHover(false), // Уход мыши
        child: AnimatedScale(
          scale: _isTapped
              ? widget.shrink // Уменьшение при нажатии
              : (_isHovered
              ? widget.expanded // Увеличение при наведении
              : 1.0), // Обычный размер
          duration: Duration(milliseconds: widget.milsec),
          curve: Curves.easeInOut, // Плавность анимации
          child: widget.child,
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  void _onTap(bool isTapped) {
    setState(() {
      _isTapped = isTapped;
    });
  }
}