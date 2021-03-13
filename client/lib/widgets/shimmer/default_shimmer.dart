import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DefaultShimmer extends StatelessWidget {
  const DefaultShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorRes.shimmerBaseColor,
      highlightColor: ColorRes.shimmerHightlightColor,
      child: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.grey,
      ),
    );
  }
}
