import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useDynamicLinkSubscription(
  void handler(PendingDynamicLinkData? link), {
  void errorHandler(dynamic error)?,
}) {
  useEffect(() {
    FirebaseDynamicLinks.instance.getInitialLink().then((dynamicLink) {
      if (dynamicLink?.link != null) {
        handler(dynamicLink);
      }
    }).onError((error, st) {
      errorHandler!(error);
    });

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (dynamicLink) async {
        if (dynamicLink?.link != null) {
          handler(dynamicLink);
        }
      },
      onError: (error) async {
        errorHandler!(error);
      },
    );

    return null;
  }, []);
}
