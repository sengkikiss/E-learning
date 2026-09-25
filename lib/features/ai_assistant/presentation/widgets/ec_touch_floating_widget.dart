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
      const minX = _edgePadding;
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
              child: Container( 
                width: _buttonSize,
                height: _buttonSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6366F1), // Indigo
                      Color(0xFF8B5CF6), // Purple
                      Color(0xFF06B6D4), // Cyan
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.55),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withOpacity(0.35),
                      blurRadius: 24,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glassmorphism ring
                    Container(
                      width: _buttonSize - 4,
                      height: _buttonSize - 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.35),
                          width: 1.5,
                        ),
                      ),
                    ),

                    // AI Icon
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 26,
                    ),

                    // "AI" mini pill badge on top-right
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 0.5),
                        ),
                        child: const Text(
                          'AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
