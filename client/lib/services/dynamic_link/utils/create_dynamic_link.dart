import 'package:cash_flow/app_configuration.dart';
import 'package:cash_flow/services/dynamic_link/utils/dynamic_link_parameters.dart';
import 'package:cash_flow/utils/core/network.dart';
import 'package:cash_flow/utils/core/platform/package_info_utils.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> createDynamicLink({
  Map<String, dynamic> queryParameters,
  SocialMetaTagParameters socialTagParameters,
  GoogleAnalyticsParameters analyticsParameters,
}) async {
  await checkInternetConnection();

  final packageName = await getPackageName();

  final baseUrl = AppConfiguration.environment.dynamicLink.baseUrl;
  final query = queryParameters.entries
      .map((parameter) => '${parameter.key}=${parameter.value}')
      .join();

  final deepLink = '$baseUrl?$query';
  final link = Uri.parse(deepLink);

  final parameters = DynamicLinkParameters(
    uriPrefix: baseUrl,
    link: link,
    androidParameters: getAndroidDynamicLinkParameters(packageName),
    iosParameters: getIosDynamicLinkParameters(packageName),
    googleAnalyticsParameters: analyticsParameters,
    itunesConnectAnalyticsParameters: null,
    socialMetaTagParameters: socialTagParameters,
  );

  final shortLink = await parameters.buildShortLink();
  return shortLink.shortUrl.toString();
}
