import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/inputs/border_input_field.dart';
import 'package:cash_flow/widgets/inputs/input_field_props.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

class PriceInputField extends HookWidget {
  const PriceInputField({
    Key key,
    @required this.currentPrice,
    this.onCountChanged,
    this.initialCount = 1,
  })  : assert(currentPrice != null),
        assert(initialCount != null),
        super(key: key);

  final int initialCount;
  final double currentPrice;
  final void Function(int) onCountChanged;

  @override
  Widget build(BuildContext context) {
    final count = useState(initialCount);
    final countController = useTextEditingController(text: '$initialCount');

    useEffect(() {
      countController.addListener(() {
        count.value = int.tryParse(countController.text) ?? 0;
        onCountChanged?.call(count.value);
      });

      return null;
    });

    return Container(
      color: ColorRes.grey2,
      child: Row(
        children: <Widget>[
          const Text(Strings.inputCount, style: Styles.body1),
          const SizedBox(width: 12),
          Expanded(
            child: BorderInputField(
              props: InputFieldProps(
                controller: countController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: ' = ', style: Styles.body1),
                TextSpan(
                  text: (currentPrice * count.value.toDouble()).toPrice(),
                  style: Styles.body2.copyWith(color: ColorRes.orange),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
