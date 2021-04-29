import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GameboardTimer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final remainingSeconds = _useTimerRemainingSeconds();
    final minutes = (remainingSeconds ~/ 60).toString();
    final seconds = '${remainingSeconds % 60}'.padLeft(2, '0');
    const timerSize = 16.0;

    return Container(
      width: 44,
      height: timerSize,
      decoration: BoxDecoration(
        color: ColorRes.mainGreen,
        border: Border.all(color: ColorRes.white64, width: 1),
        borderRadius: BorderRadius.circular(timerSize / 2),
        boxShadow: [
          BoxShadow(blurRadius: 2, color: Colors.black.withAlpha(100)),
        ],
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          '$minutes:$seconds',
          style: Styles.body1.copyWith(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

int _useTimerRemainingSeconds() {
  final moveStartDate = useCurrentGame((s) => s.state.moveStartDateInUTC);
  final remainingSeconds = useState(_getRemainingSeconds(moveStartDate));

  useEffect(() {
    if (moveStartDate == null) {
      return null;
    }

    final subscription = Stream.periodic(const Duration(seconds: 1))
        .map((_) => _getRemainingSeconds(moveStartDate))
        .takeWhile((seconds) => seconds >= 0)
        .listen((seconds) => remainingSeconds.value = seconds);

    return subscription.cancel;
  }, [moveStartDate]);

  final remainingSecondsValue =
      remainingSeconds.value < 0 || remainingSeconds.value > 60
          ? 0
          : remainingSeconds.value;

  return remainingSecondsValue;
}

int _getRemainingSeconds(DateTime moveStartDate) {
  if (moveStartDate == null) {
    return 0;
  }

  final now = DateTime.now().toUtc();

  final moveEndTime = moveStartDate.add(const Duration(seconds: 60));
  final remainingTimeInMs =
      moveEndTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
  final remainingSeconds = remainingTimeInMs / 1000;

  return remainingSeconds.toInt();
}
