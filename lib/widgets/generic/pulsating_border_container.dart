import 'package:flutter/material.dart';

class PulsatingBorderContainer extends StatefulWidget {
  final bool isPulsating;
  final Widget child;

  const PulsatingBorderContainer({
    Key? key,
    required this.isPulsating,
    required this.child,
  }) : super(key: key);

  @override
  _PulsatingBorderContainerState createState() =>
      _PulsatingBorderContainerState();
}

class _PulsatingBorderContainerState extends State<PulsatingBorderContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  )
    ..addListener(() {
      setState(() {});
      if (_controller.isCompleted) _controller.reverse();
      if (_controller.isDismissed) _controller.forward();
    })
    ..forward();

  late final Animation<Color?> _pulseAnimation = ColorTween(
    begin: Colors.transparent,
    end: Theme.of(context).primaryColor,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCirc,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: widget.isPulsating
              ? (_pulseAnimation.value ?? Colors.transparent)
              : Colors.transparent,
        ),
      ),
      child: widget.child,
    );
  }
}
