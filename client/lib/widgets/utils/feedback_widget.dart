import 'package:cash_flow/resources/colors.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FeedbackWidget extends HookWidget {
  const FeedbackWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO(Artem): fix it
    // final feedbackSender = useFeedbackSender();

    return BetterFeedback(
      theme: FeedbackThemeData(
        drawColors: const [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
        ],
        background: ColorRes.scaffoldBackground,
      ),

      localeOverride: const Locale('ru'),
      child: child,
    );
  }
}
