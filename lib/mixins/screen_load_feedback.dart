import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/feedback_provider.dart';

class FeedbackRouteArgs {
  const FeedbackRouteArgs({
    this.feedbackMessage,
    this.feedbackType,
    this.showFeedback,
  });

  final bool? showFeedback;
  final FeedbackType? feedbackType;
  final String? feedbackMessage;
}

mixin ScreenLoadFeedback {
  void checkAndShowFeedback(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as FeedbackRouteArgs?;
      final feedbackProvider =
          Provider.of<FeedbackProvider>(context, listen: false);

      if (args == null) {
        return;
      }

      if (args.showFeedback ?? false) {
        switch (args.feedbackType) {
          case FeedbackType.SUCCESS:
            feedbackProvider.showSuccessFeedback(
              context,
              args.feedbackMessage ?? "Successo!",
            );
            break;
          case FeedbackType.INFO:
            feedbackProvider.showInfoFeedback(
              context,
              args.feedbackMessage ?? "Info",
            );
            break;
          case FeedbackType.FAIL:
            feedbackProvider.showFailFeedback(
              context,
              args.feedbackMessage ?? "Errore!",
            );
            break;
          case null:
            break;
        }
      }
    });
  }
}
