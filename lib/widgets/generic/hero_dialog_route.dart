import 'package:flutter/material.dart';

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required WidgetBuilder builder,
    bool isDismissable = false,
    RouteSettings? settings,
    bool fullScreenDialog = false,
  })  : _builder = builder,
        _isDismissable = isDismissable,
        super(settings: settings, fullscreenDialog: fullScreenDialog);

  final WidgetBuilder _builder;
  final bool _isDismissable;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => "Popup aperto";

  @override
  bool get barrierDismissible => _isDismissable;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Disable animations, it will be handled by Hero widget
    return child;
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
