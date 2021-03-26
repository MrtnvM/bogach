import 'package:dash_kit_network/dash_kit_network.dart';

class ResponseModel {
  const ResponseModel();

  Map<String, dynamic> toJson() => <String, dynamic>{};
}

class VoidResponseModel extends ResponseModel {}

class ResponseErrorModel extends ResponseModel {
  const ResponseErrorModel(this.response);

  final Response response;

  @override
  String toString() {
    return 'ResponseErrorModel:\n'
        'Status code: ${response.statusCode} ${response.statusMessage}'
        'Data: ${response.data}';
  }
}
