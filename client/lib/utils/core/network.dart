import 'package:connectivity/connectivity.dart';
import 'package:dash_kit_network/dash_kit_network.dart';

Future<void> checkInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    throw NetworkConnectionException(null);
  }
}
