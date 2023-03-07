import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:revee/utils/theme.dart';

class ReveeBouncingLoader extends StatefulWidget {
  @override
  _ReveeBouncingLoaderState createState() => _ReveeBouncingLoaderState();
}

class _ReveeBouncingLoaderState extends State<ReveeBouncingLoader>
    with SingleTickerProviderStateMixin {
  // Create animation controller, adding listener and starting
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )
    ..addListener(_animationListener)
    ..forward();

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
    return CustomPaint(
      size: const Size(60, 30),
      painter: LoaderPainter(_controller.value),
    );
  }
}

class LoaderPainter extends CustomPainter {
  final double progress;

  LoaderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final myPaint = Paint();
    final radius = size.height / 3;

    const twoPi = math.pi * 2;

    double angle;
    double yOff;

    // First circle - phase 0°
    myPaint.color = CustomColors.revee.withOpacity(0.33);
    angle = twoPi * (progress + 0 / 3);
    yOff = size.height / 2 + math.cos(angle) * size.height / 3;

    canvas.drawCircle(Offset(0, yOff), radius, myPaint);

    // Second circle - phase 120°
    myPaint.color = CustomColors.revee.withOpacity(0.67);
    angle = twoPi * (progress + 1 / 3);
    yOff = size.height / 2 + math.cos(angle) * size.height / 3;

    canvas.drawCircle(Offset(size.width / 2, yOff), radius, myPaint);

    // Third circle - phase 240°
    myPaint.color = CustomColors.revee;
    angle = twoPi * (progress + 2 / 3);
    yOff = size.height / 2 + math.cos(angle) * size.height / 3;

    canvas.drawCircle(Offset(size.width, yOff), radius, myPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
