import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/models/domain/user/online/online_profile.dart';
import 'package:cash_flow/utils/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MultiplayerService {
  MultiplayerService({
    @required this.apiClient,
    @required this.firestore,
  })  : assert(apiClient != null),
        assert(firestore != null);

  final CashFlowApiClient apiClient;
  final FirebaseFirestore firestore;

  Future<List<OnlineProfile>> setUserOnline(OnlineProfile user) {
    return apiClient
        .setOnlineStatus(user)
        .then((value) => apiClient.getOnlineProfiles(user.userId))
        .catchError(recordError);
  }
}
