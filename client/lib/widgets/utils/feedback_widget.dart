import 'package:cash_flow/core/hooks/feedback_hooks.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FeedbackWidget extends HookWidget {
  const FeedbackWidget({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final feedbackSender = useFeedbackSender();

    return BetterFeedback(
      drawColors: const [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.yellow,
      ],
      translation: Strings.ruFeedbackTranslations,
      onFeedback: feedbackSender.sendFeedback,
      child: child,
    );
  }
}
