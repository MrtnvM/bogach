/// This code will be removed after upgrafing project to Flutter 2.0
/// This library go ahead from release for Flutter 1.x

// ignore: implementation_imports
import 'package:feedback/src/feedback_controller.dart';
// ignore: implementation_imports
import 'package:feedback/src/feedback_functions.dart';
// ignore: implementation_imports
import 'package:feedback/src/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'better_feedback_widget.dart';

/// This widget should be at the top of your widget tree.
class BetterFeedback extends StatefulWidget {
  const BetterFeedback({
    Key key,
    this.child,
    @required this.onFeedback,
    this.backgroundColor,
    this.drawColors,
    this.translation,
  })  : assert(onFeedback != null),
        super(key: key);

  /// Gets called when the user submits his feedback.
  final OnFeedbackCallback onFeedback;

  /// The application to wrap, typically a [MaterialApp].
  final Widget child;

  /// The background of the feedback view.
  final Color backgroundColor;

  /// Colors which can be used to draw on [child].
  final List<Color> drawColors;

  /// Optional translation for the feedback view, defaults to english.
  final FeedbackTranslation translation;

  /// Call `BetterFeedback.of(context)` to get an instance of
  /// [FeedbackData] on which you can call `.show()` or `.hide()`
  /// to enable or disable the feedback view.
  static FeedbackData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FeedbackData>();

  @override
  _BetterFeedbackState createState() => _BetterFeedbackState();
}

class _BetterFeedbackState extends State<BetterFeedback> {
  FeedbackController controller = FeedbackController();

  @override
  void initState() {
    super.initState();
    controller.addListener(onUpdateOfController);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(onUpdateOfController);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FeedbackData(
        controller: controller,
        child: BetterFeedbackWidget(
          isFeedbackVisible: controller.isVisible,
          feedback: widget.onFeedback,
          backgroundColor: widget.backgroundColor,
          drawColors: widget.drawColors,
          translation: widget.translation ?? EnTranslation(),
          child: widget.child,
        ),
      ),
    );
  }

  void onUpdateOfController() {
    setState(() {});
  }
}

class FeedbackData extends InheritedWidget {
  const FeedbackData({
    Key key,
    @required Widget child,
    @required this.controller,
  })  : assert(child != null),
        assert(controller != null),
        super(key: key, child: child);

  final FeedbackController controller;

  @override
  bool updateShouldNotify(FeedbackData oldWidget) {
    return oldWidget.controller != controller;
  }

  /// Shows the feedback view
  void show() => controller.show();

  /// Hides the feedback view
  void hide() => controller.hide();

  bool get isVisible => controller.isVisible;
}
