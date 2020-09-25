import 'package:cloud_firestore/cloud_firestore.dart';

Future configureFirestoreLocalEnvironment() async {
  FirebaseFirestore.instance.settings = const Settings(
    host: 'localhost:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );
}
