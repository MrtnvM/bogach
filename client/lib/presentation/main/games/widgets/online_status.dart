import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OnlineStatus extends HookWidget {
  const OnlineStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onlineStatus = useOnlineStatus();
    final size = useAdaptiveSize();

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.93,
      upperBound: 1,
    );

    useEffect(() {
      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });

      /// Turn off animation on development machine.
      /// Simulators can consume energy when drawing animations
      if (!kDebugMode) {
        animationController.forward();
      }

      return null;
    }, []);

    return SizedBox(
      height: size(40),
      width: size(40),
      child: Center(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) => Container(
            height: size(30) * animationController.value,
            width: size(30) * animationController.value,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.25 * animationController.value,
                colors: [
                  onlineStatus.color,
                  onlineStatus.color.withAlpha(200),
                  onlineStatus.color.withAlpha(120),
                  Colors.white
                ],
              ),
              border: Border.all(
                color: onlineStatus.color.withAlpha(
                  (50 * animationController.value).toInt(),
                ),
              ),
              borderRadius: BorderRadius.circular(size(15)),
            ),
          ),
        ),
      ),
    );
  }
}
