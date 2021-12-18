import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PriceInfoWidget extends HookWidget {
  const PriceInfoWidget({
    this.itemImageUrl,
    required this.countInPortfolio,
    required this.previousPrice,
    required this.currentPrice,
    this.monthlyIncome,
  });

  final String? itemImageUrl;
  final int countInPortfolio;
  final double previousPrice;
  final double currentPrice;
  final double? monthlyIncome;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    final infoBlocks = [
      _InPortfolioBlock(
        itemImageUrl: itemImageUrl,
        currentPrice: currentPrice,
        previousPrice: previousPrice,
        countInPortfolio: countInPortfolio,
      ),
      if (countInPortfolio > 0) ...[
        const _Divider(),
        _PortfolioValueBlock(
          currentPrice: currentPrice,
          previousPrice: previousPrice,
          countInPortfolio: countInPortfolio,
        ),
      ],
      if (monthlyIncome != null && monthlyIncome!.round() != 0) ...[
        const _Divider(),
        _MonthlyIncomeBlock(monthlyIncome: monthlyIncome!),
      ],
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size(16),
        vertical: size(12),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size(6)),
        color: ColorRes.primaryWhiteColor,
        border: Border.all(color: const Color(0x99DBDBDB), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: infoBlocks,
      ),
    );
  }
}

class _Divider extends HookWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: size(10)),
      child: const Divider(height: 0.5, color: ColorRes.divider),
    );
  }
}

class _InPortfolioBlock extends HookWidget {
  const _InPortfolioBlock({
    this.itemImageUrl,
    required this.countInPortfolio,
    required this.previousPrice,
    required this.currentPrice,
  });

  final String? itemImageUrl;
  final int countInPortfolio;
  final double previousPrice;
  final double currentPrice;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final itemImageSize = size(28);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Strings.inPortfolio, style: Styles.infoBlockTitle),
              SizedBox(height: size(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    countInPortfolio.toString(),
                    style: Styles.infoBlockValue,
                  ),
                  Text(
                    ' ${Strings.countShort}',
                    style: Styles.infoBlockDescription.copyWith(fontSize: 14),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size(10)),
                    height: size(14),
                    width: 1,
                    color: ColorRes.infoBlockDescription,
                  ),
                  if (countInPortfolio > 0) ...[
                    Text(
                      previousPrice.toPrice(),
                      style: Styles.infoBlockDescription,
                    ),
                    SizedBox(width: size(4)),
                    Image.asset(Images.infoBlockArrowRight, width: size(12)),
                  ],
                  SizedBox(width: size(4)),
                  Text(
                    currentPrice.toPrice(),
                    style: Styles.infoBlockDescription,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (itemImageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(itemImageSize / 2),
            child: CachedNetworkImage(
              imageUrl: itemImageUrl!,
              width: itemImageSize,
              height: itemImageSize,
            ),
          )
      ],
    );
  }
}

class _PortfolioValueBlock extends HookWidget {
  const _PortfolioValueBlock({
    required this.countInPortfolio,
    required this.previousPrice,
    required this.currentPrice,
  });

  final int countInPortfolio;
  final double previousPrice;
  final double currentPrice;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    final portfolioValue = currentPrice * countInPortfolio;
    final previousPortfolioValue = previousPrice * countInPortfolio;

    final income = portfolioValue - previousPortfolioValue;
    final priceChange = ((currentPrice - previousPrice) / previousPrice) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(Strings.portfolioValue, style: Styles.infoBlockTitle),
        SizedBox(height: size(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              portfolioValue.toPriceWithoutSymbol(),
              style: Styles.infoBlockValue,
            ),
            Text(
              ' ${Strings.rubleSymbol}',
              style: Styles.infoBlockDescription.copyWith(fontSize: 16),
            ),
            SizedBox(width: size(12)),
            Image.asset(
              income >= 0 ? Images.infoBlockArrowUp : Images.infoBlockArrowDown,
              width: size(12),
            ),
            SizedBox(width: size(4)),
            Text(
              '${income.toPrice()} (${priceChange.toPercent()})',
              style: Styles.infoBlockDescription.copyWith(
                color: income >= 0 ? ColorRes.increase : ColorRes.decrease,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MonthlyIncomeBlock extends HookWidget {
  const _MonthlyIncomeBlock({required this.monthlyIncome});

  final double monthlyIncome;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final sign = monthlyIncome >= 0 ? '+' : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.incomePerMonth.replaceAll(':', ''),
          style: Styles.infoBlockTitle,
        ),
        SizedBox(height: size(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$sign${monthlyIncome.round()}',
              style: Styles.infoBlockValue,
            ),
            Text(
              ' ${Strings.rubleSymbol}/${Strings.monthShort}',
              style: Styles.infoBlockDescription.copyWith(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
