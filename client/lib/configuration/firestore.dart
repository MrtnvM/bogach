import 'package:cloud_firestore/cloud_firestore.dart';

Future configureFirestoreLocalEnvironment() async {
  await Firestore.instance.settings(
    host: 'localhost:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );
}
