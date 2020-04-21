import 'package:flutter_platform_network/flutter_platform_network.dart';

class ResponseModel {
  const ResponseModel();

  Map<String, dynamic> toJson() => <String, dynamic>{};
}

class VoidResponseModel extends ResponseModel {}

class ResponseErrorModel extends ResponseModel {
  const ResponseErrorModel(this.response);

  final Response response;
}
