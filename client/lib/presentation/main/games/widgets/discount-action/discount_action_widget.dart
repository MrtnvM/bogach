import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/config/actions/increase_discount_action_seen_count_action.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/purchase/actions/buy_with_new_year_action.dart';
import 'package:cash_flow/models/errors/purchase_errors.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/ui/dialogs.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DiscountActionWidget extends HookWidget {
  const DiscountActionWidget({
    Key? key,
    required this.onDissmised,
  }) : super(key: key);

  static bool _isPurchaseSeen = false;

  final VoidCallback onDissmised;

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser()!;
    final size = useAdaptiveSize();
    final dispatch = useDispatcher();
    final discountActionSeen = useConfig((c) => c.discountActionSeenCount);
    final isVisible = useState(discountActionSeen < 3);
    final isQuestsAvailable = user.purchaseProfile?.isQuestsAvailable == true;
    final isDiscountActionAvailable = isVisible.value && !isQuestsAvailable;

    useEffect(() {
      if (isDiscountActionAvailable && !_isPurchaseSeen) {
        AnalyticsSender.discountActionPurchaseSeen();
        dispatch(IncreaseDiscountActionSeenCountAction());
        _isPurchaseSeen = true;
      }
    }, []);

    if (!isDiscountActionAvailable) {
      return const SizedBox();
    }

    late VoidCallback buyWithDiscountAction;
    buyWithDiscountAction = () async {
      try {
        AnalyticsSender.discountActionPurchaseStarted();
        await dispatch(BuyWithDiscountActionAction());
        AnalyticsSender.discountActionPurchasePurchased();

        showAlert(
          context: context,
          title: Strings.discountActionBoughtAlertTitle,
          message: Strings.discountActionBoughtAlertMessage,
          submitButtonText: Strings.ok,
          needCancelButton: false,
        );
      } on PurchaseCanceledException catch (error) {
        AnalyticsSender.discountActionPurchaseCanceled();
        Fimber.i('Purchase canceled: ${error.productId}');
      } catch (error) {
        AnalyticsSender.discountActionPurchaseFailed();

        handleError(
          context: context,
          exception: error,
          onRetry: buyWithDiscountAction,
        );
      }
    };

    return Dismissible(
      key: ValueKey(user.id),
      onDismissed: (_) {
        isVisible.value = false;
        AnalyticsSender.discountActionPurchaseDismissed();
        onDissmised();
      },
      child: GestureDetector(
        onTap: buyWithDiscountAction,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size(12), vertical: size(8)),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(Images.actionBackground),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                spreadRadius: 4,
                color: Colors.black.withOpacity(0.25),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(size(8)),
                child: Image.asset(Images.discountBogach, height: size(50)),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size(12),
                    bottom: size(12),
                    right: size(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${user.fullName}, привет!',
                        style: Styles.bodyBold.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: size(4)),
                      Text(
                        'Успей получить скидку!',
                        style: Styles.body1.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: size(4)),
                      Text(
                        'Квесты и 25 мультиплеерных игр по супер-цене!',
                        style: Styles.bodyBold.copyWith(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF38D3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: size(6),
                      vertical: size(4),
                    ),
                    margin: EdgeInsets.only(top: size(14)),
                    child: Text(
                      '-50%',
                      style: Styles.bodyBold.copyWith(fontSize: 9),
                    ),
                  ),
                  SizedBox(height: size(4)),
                  Text('179 ₽', style: Styles.bodyBold.copyWith(fontSize: 20)),
                  SizedBox(height: size(2)),
                  Text(
                    '358 ₽',
                    style: Styles.bodyBold.copyWith(
                      fontSize: 13,
                      decoration: TextDecoration.lineThrough,
                      color: const Color(0xFF434343),
                    ),
                  ),
                  SizedBox(height: size(10)),
                ],
              ),
              SizedBox(width: size(12)),
            ],
          ),
        ),
      ),
    );
  }
}
