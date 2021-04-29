import 'package:launch_review/launch_review.dart';

void launchMarket() {
  LaunchReview.launch(
    writeReview: false,
    androidAppId: 'io.mobile.bogach',
    iOSAppId: '1531498628',
  );
}
