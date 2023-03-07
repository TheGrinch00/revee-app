import 'package:flutter/material.dart';

class AnimatedSlideOpacity extends StatefulWidget {
  final Widget child;
  final int millisDelay;
  final int milllisDuration;
  const AnimatedSlideOpacity({
    Key? key,
    this.millisDelay = 0,
    this.milllisDuration = 500,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedSlideOpacity> createState() => _AnimatedSlideOpacityState();
}

class _AnimatedSlideOpacityState extends State<AnimatedSlideOpacity>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.milllisDuration),
    vsync: this,
  );

  // The Tween is an object that tells how the values should change
  // according to the controller value
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-1.5, 0.0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ),
  );

  // The opacity goes from 0.0 to 1.0
  late final Animation<double> _fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCirc,
    ),
  );

  @override
  void initState() {
    // Start animation after some delay
    Future.delayed(
      Duration(milliseconds: widget.millisDelay),
      () {
        if (mounted) {
          return _controller.forward();
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}
