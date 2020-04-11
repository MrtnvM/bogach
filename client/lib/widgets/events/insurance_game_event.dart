import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/containers/info_table.dart';
import 'package:cash_flow/widgets/events/game_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InsuranceGameEvent extends StatefulWidget {
  const InsuranceGameEvent(this.viewModel) : assert(viewModel != null);

  final InsuranceViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return InsuranceGameEventState();
  }
}

class InsuranceGameEventState extends State<InsuranceGameEvent> {
  @override
  Widget build(BuildContext context) {
    return GameEvent(
      icon: Icons.beach_access,
      name: Strings.insuranceTitle,
      buttonsState: ButtonsState.skip,
      buttonsProperties: widget.viewModel.buttonsProperties,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitle(),
            const SizedBox(height: 8),
            _buildDescription(),
            const SizedBox(height: 8),
            _buildPrice(),
            const SizedBox(height: 8),
            _buildInfo(widget.viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(InsuranceViewModel viewModel) {
    final map = {
      Strings.coverage: viewModel.coverage.toPrice(),
    };

    return InfoTable(map);
  }

  Widget _buildTitle() {
    return const Text(
      Strings.insuranceDesc,
      style: Styles.body2,
    );
  }

  Widget _buildDescription() {
    return Text(
      Strings.insurance,
      style: Styles.body1,
    );
  }

  Widget _buildPrice() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: Strings.price, style: Styles.body1),
          const WidgetSpan(
              child: SizedBox(
            width: 4,
          )),
          TextSpan(
              text: widget.viewModel.price.toPrice(),
              style: Styles.body2.copyWith(color: ColorRes.blue)),
        ],
      ),
    );
  }
}

class InsuranceViewModel {
  const InsuranceViewModel({
    this.coverage,
    this.price,
    this.buttonsProperties,
  });

  final int coverage;
  final int price;
  final ButtonsProperties buttonsProperties;
}
