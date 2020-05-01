import 'package:cash_flow/models/network/responses/response_model.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';

VoidResponseModel voidResponse(Response response) {
  if ([200, 201, 204].contains(response.statusCode)) {
    return VoidResponseModel();
  }

  throw ResponseErrorModel(response);
}
