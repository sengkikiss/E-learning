import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'ai_assistant_sheet.dart';

class EcTouchFloatingWidget extends StatefulWidget {
  const EcTouchFloatingWidget({super.key});

  @override
  State<EcTouchFloatingWidget> createState() => _EcTouchFloatingWidgetState();
}

class _EcTouchFloatingWidgetState extends State<EcTouchFloatingWidget>
    with SingleTickerProviderStateMixin {
  Offset? _position;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isDragging = false;

  static const double _buttonSize = 56.0;
  static const double _edgePadding = 12.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_position == null) {
      final size = MediaQuery.of(context).size;
      final padding = MediaQuery.of(context).padding;
      // Default initial position: bottom right, above bottom nav bar
      _position = Offset(
        size.width - _buttonSize - _edgePadding,
        size.height - padding.bottom - 160,
      );
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _isDragging = true;
      final size = MediaQuery.of(context).size;
      final padding = MediaQuery.of(context).padding;

      double newX = (_position?.dx ?? 0) + details.delta.dx;
      double newY = (_position?.dy ?? 0) + details.delta.dy;

      // Clamping within safe area bounds
      final minX = _edgePadding;
      final maxX = size.width - _buttonSize - _edgePadding;
      final minY = padding.top + _edgePadding;
      final maxY = size.height - padding.bottom - _buttonSize - 80;

      newX = newX.clamp(minX, maxX);
      newY = newY.clamp(minY, maxY);

      _position = Offset(newX, newY);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
      final size = MediaQuery.of(context).size;
      final currentX = _position?.dx ?? 0;
      final currentY = _position?.dy ?? 0;

      // Snap to nearest horizontal edge (AssistiveTouch behavior)
      final middle = size.width / 2;
      final targetX = currentX < middle
          ? _edgePadding
          : size.width - _buttonSize - _edgePadding;

      _position = Offset(targetX, currentY);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pos = _position ?? Offset(size.width - _buttonSize - _edgePadding, 300);

    return Stack(
      children: [
        AnimatedPositioned(
          duration: _isDragging ? Duration.zero : const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          left: pos.dx,
          top: pos.dy,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            onTap: () {
              AiAssistantSheet.show(context);
            },
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: SizedBox(
                width: _buttonSize,
                height: _buttonSize,
                child: Center(
                  child: Lottie.asset(
                    'assets/animetions/Ai.json',
                    width: _buttonSize,
                    height: _buttonSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
