import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/recommendations/courses/recommendation_course.dart';
import 'package:cash_flow/services/recommendations_service.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:get_it/get_it.dart';

class GetRecommendationsCoursesAction extends BaseAction {
  @override
  Future<AppState> reduce() async {
    final recommendationsService = GetIt.I.get<RecommendationsService>();

    final courses = await recommendationsService.getCourses();

    return state.rebuild((s) {
      s.recommendations.courses = StoreList<RecommendationCourse>(courses);
    });
  }
}
