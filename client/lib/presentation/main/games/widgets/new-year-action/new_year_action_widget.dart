import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewYearActionWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return GestureDetector(
      onTap: () => print('CLICKED'),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size(12), vertical: size(8)),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(Images.newYearActionBackground),
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
              child: Image.asset(Images.newYearBogach, height: size(50)),
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
                      'Привет, дружище!',
                      style: Styles.bodyBold.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: size(4)),
                    Text(
                      'Новый год уже на подходе, а это значит, '
                      'что настала пора празднечных скидок!',
                      style: Styles.body1.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: size(4)),
                    Text(
                      'Квесты и 25 мультиплеерных игр по супер-цене!',
                      style: Styles.bodyBold.copyWith(
                        fontSize: 10,
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
    );
  }
}
