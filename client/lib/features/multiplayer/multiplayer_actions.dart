import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/core/search_query_result.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class QueryUserProfilesAsyncAction
    extends AsyncAction<SearchQueryResult<UserProfile>> {
  QueryUserProfilesAsyncAction([this.query]);
  final String query;
}
