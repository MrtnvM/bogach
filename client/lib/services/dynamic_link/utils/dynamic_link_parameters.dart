import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../../../app_configuration.dart';

AndroidParameters getAndroidDynamicLinkParameters(String packageName) {
  return AndroidParameters(
    packageName: packageName,
    minimumVersion: 1,
  );
}

IosParameters getIosDynamicLinkParameters(String packageName) {
  return IosParameters(
    bundleId: packageName,
    customScheme: AppConfiguration.environment!.dynamicLink.customScheme,
    appStoreId: '1531498628',
  );
}
