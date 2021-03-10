import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../../../app_configuration.dart';

AndroidParameters getAndroidParameters(String packageName) {
  return AndroidParameters(
    packageName: packageName,
    minimumVersion: 1,
  );
}

IosParameters getIosParameters(String packageName) {
  return IosParameters(
    bundleId: packageName,
    customScheme: AppConfiguration.environment.dynamicLink.customScheme,
    appStoreId: '1531498628',
  );
}
