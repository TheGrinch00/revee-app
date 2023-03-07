import 'package:flutter/material.dart';

class PulsatingBadge extends StatefulWidget {
  const PulsatingBadge({Key? key, this.color = Colors.blue}) : super(key: key);

  final Color color;

  @override
  _PulsatingBadgeState createState() => _PulsatingBadgeState();
}

class _PulsatingBadgeState extends State<PulsatingBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )
    ..addListener(_animationListener)
    ..forward();

  late final Animation<double> _animation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    ),
  );

  // Function to re-render the widget everytime the controller's value changes
  void _animationListener() {
    setState(() {});
    if (_controller.isCompleted) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_animationListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CustomPaint(
        painter: PulsatingBadgePainter(
          color: widget.color,
          progress: _animation.value,
        ),
      ),
    );
  }
}

class PulsatingBadgePainter extends CustomPainter {
  PulsatingBadgePainter({required this.color, required this.progress});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Color circleColor =
        progress < 0.5 ? color : color.withOpacity(1 - 0.75 * (progress - 0.5));

    final double outerRadius = (size.width / 2 - size.width / 5) * progress * 2;
    final double innerRadius =
        progress < 0.6 ? 0 : (progress - 0.6) * 2.5 * (size.width / 1.5);

    final paint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      outerRadius,
      paint,
    );

    paint.color = Colors.white;

    canvas.drawCircle(
      center,
      innerRadius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
