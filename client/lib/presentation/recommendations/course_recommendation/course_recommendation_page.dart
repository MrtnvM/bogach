import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CourseRecommendationPage extends HookWidget {
  const CourseRecommendationPage(this.courseId);

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final course = useGlobalState(
      (s) => s.recommendations.courses.itemsMap[courseId],
    )!;

    return Scaffold(
      appBar: AppBar(
        title: Text(course.profession),
      ),
      body: WebView(
        initialUrl: course.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
