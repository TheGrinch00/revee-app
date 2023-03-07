import 'package:flutter/material.dart';

enum FeedbackType {
  SUCCESS,
  FAIL,
  INFO,
}

class FeedbackProvider with ChangeNotifier {
  void showSuccessFeedback(
    BuildContext context,
    String message,
  ) =>
      _showFeedback(
        context,
        message,
        FeedbackType.SUCCESS,
      );

  void showFailFeedback(
    BuildContext context,
    String message,
  ) =>
      _showFeedback(
        context,
        message,
        FeedbackType.FAIL,
      );

  void showInfoFeedback(
    BuildContext context,
    String message,
  ) =>
      _showFeedback(
        context,
        message,
        FeedbackType.INFO,
      );

  void _showFeedback(
    BuildContext context,
    String message,
    FeedbackType type,
  ) {
    late final Color bgColor;

    switch (type) {
      case FeedbackType.SUCCESS:
        bgColor = Colors.green;
        break;
      case FeedbackType.FAIL:
        bgColor = Colors.red;
        break;
      case FeedbackType.INFO:
        bgColor = Colors.blue;
        break;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        content: Text(
          message,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  static void showCustomFeedback(BuildContext context, SnackBar snackbar) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
