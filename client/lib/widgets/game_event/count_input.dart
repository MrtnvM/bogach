import 'dart:math';

import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CountInput extends HookWidget {
  const CountInput({
    required this.selectedAction,
    required this.availableCount,
    required this.onCountChanged,
  });

  final BuySellAction selectedAction;
  final int availableCount;
  final void Function(int count, bool hasValue) onCountChanged;

  @override
  Widget build(BuildContext context) {
    final count = useState(1);
    final size = useAdaptiveSize();
    final countController = useTextEditingController();
    final countFocusNode = useFocusNode();

    useEffect(() {
      count.value = 1;
    }, [selectedAction]);

    useEffect(() {
      countController.text = count.value.toString();
      countController.selection = TextSelection.fromPosition(
        TextPosition(offset: countController.text.length),
      );

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final value = max(count.value, 1);
        onCountChanged(value, count.value != 0);
      });
    }, [count.value]);

    useEffect(() {
      final listener = () {
        final text = countController.text;

        if (text.isEmpty) {
          count.value = 0;
          countController.text = count.value.toString();
          countController.selection = TextSelection.fromPosition(
            TextPosition(offset: countController.text.length),
          );
        } else {
          final value = int.tryParse(text);
          final isValueChanged = value != count.value;
          final isIncorrectZeroValue = value == 0 && text.length > 1;

          if (value != null && (isValueChanged || isIncorrectZeroValue)) {
            count.value = min(value, availableCount);
            countController.text = count.value.toString();
            countController.selection = TextSelection.fromPosition(
              TextPosition(offset: countController.text.length),
            );
          }
        }
      };

      countController.addListener(listener);
      return () => countController.removeListener(listener);
    }, [availableCount]);

    useEffect(() {
      final listener = () {
        if (!countFocusNode.hasFocus) {
          final newValue = max(count.value, 1);
          count.value = newValue;
          countController.text = newValue.toString();
        }
      };

      countFocusNode.addListener(listener);
      return () => countFocusNode.removeListener(listener);
    }, []);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.count,
          style: Styles.infoBlockTitle.copyWith(fontSize: 12),
        ),
        SizedBox(height: size(8)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: SizedBox(
                height: size(32),
                child: Stack(
                  children: [
                    TextField(
                      focusNode: countFocusNode,
                      controller: countController,
                      style: Styles.infoBlockValue,
                      keyboardType: TextInputType.number,
                      scrollPadding: EdgeInsets.only(bottom: size(140)),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                    IgnorePointer(
                      child: Padding(
                        padding: EdgeInsets.only(top: size(9)),
                        child: Row(
                          children: [
                            Text(
                              count.value.toString(),
                              style: Styles.infoBlockValue.copyWith(
                                color: Colors.transparent,
                              ),
                            ),
                            Text(
                              ' ${Strings.countShort}',
                              style: Styles.infoBlockValue.copyWith(
                                color: ColorRes.infoBlockDescription,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: size(24)),
            _buildChangeButton(Images.removeButton, () {
              if (count.value >= 2) {
                count.value = count.value - 1;
              }
            }),
            SizedBox(width: size(16)),
            _buildChangeButton(Images.addButton, () {
              if (count.value < availableCount) {
                count.value = count.value + 1;
              }
            }),
          ],
        ),
        SizedBox(height: size(8)),
        const Divider(color: ColorRes.divider, height: 0.5),
        SizedBox(height: size(6)),
        Text(
          '${Strings.available} $availableCount',
          style: Styles.infoBlockDescription.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildChangeButton(String image, VoidCallback callback) {
    return GestureDetector(
      onTap: () {
        DropFocus.drop();
        callback();
      },
      child: Image.asset(image, width: 32, height: 32),
    );
  }
}
