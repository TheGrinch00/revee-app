import 'package:flutter/material.dart';

class MuiAccordion extends StatefulWidget {
  const MuiAccordion({
    Key? key,
    required this.title,
    required this.index,
    required this.totalElements,
    this.children = const [],
  }) : super(key: key);

  final Widget title;
  final int index;
  final int totalElements;
  final List<Widget> children;

  @override
  _MuiAccordionState createState() => _MuiAccordionState();
}

class _MuiAccordionState extends State<MuiAccordion> {
  static const defaultMargin = 8.0;
  static const defaultRadius = 5.0;

  bool _isExpanded = false;

  EdgeInsetsGeometry accordionExternalPadding() {
    if (!_isExpanded) {
      return EdgeInsets.zero;
    }

    if (widget.index == 0) {
      return const EdgeInsets.only(bottom: defaultMargin);
    }

    if (widget.index == widget.totalElements - 1) {
      return const EdgeInsets.only(top: defaultMargin);
    }

    return const EdgeInsets.symmetric(vertical: defaultMargin);
  }

  BorderRadiusGeometry accordionRadius() {
    final index = widget.index;
    final totalElements = widget.totalElements;

    if (index == 0 && index == totalElements - 1) {
      return BorderRadius.circular(defaultRadius);
    }

    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(defaultRadius),
        topRight: Radius.circular(defaultRadius),
      );
    }

    if (index == totalElements - 1) {
      return const BorderRadius.only(
        bottomLeft: Radius.circular(defaultRadius),
        bottomRight: Radius.circular(defaultRadius),
      );
    }

    return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        borderRadius: accordionRadius(),
        border: Border.all(
          color: Theme.of(context).secondaryHeaderColor,
        ),
      ),
      margin: accordionExternalPadding(),
      child: ExpansionTile(
        title: widget.title,
        onExpansionChanged: (isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: widget.children,
      ),
    );
  }
}
