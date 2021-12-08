import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/recommendations/recommendation_book.dart';
import 'package:cash_flow/services/recommendations_service.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:get_it/get_it.dart';

class GetRecommendationsBooksAction extends BaseAction {
  @override
  Future<AppState> reduce() async {
    final recommendationsService = GetIt.I.get<RecommendationsService>();

    final books = await recommendationsService.getBooks();

    return state.rebuild((s) {
      s.recommendations.books = StoreList<RecommendationBook>(books);
    });
  }
}
