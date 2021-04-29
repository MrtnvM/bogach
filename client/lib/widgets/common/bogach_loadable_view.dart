import 'package:cash_flow/resources/colors.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';

class BogachLoadableView extends StatelessWidget {
  const BogachLoadableView({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  final bool? isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LoadableView(
      isLoading: isLoading!,
      backgroundColor: ColorRes.black.withAlpha(120),
      indicatorColor: const AlwaysStoppedAnimation(ColorRes.mainGreen),
      child: child,
    );
  }
}
