import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/fullscreen_popup_container.dart';
import 'package:flutter/material.dart';

class QuestsAccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final imageSize = screenWidth * 0.75;

    return FullscreenPopupContainer(
      backgroundColor: ColorRes.questAccessPageBackgound,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: imageSize,
            width: imageSize,
            child: Image.asset(Images.questsAccess),
          ),
          const SizedBox(height: 16),
          const _QuestsAccessDescription(),
          const SizedBox(height: 32),
          const _AdvantagesWidget(),
          const SizedBox(height: 48),
          const _BuyButton(),
        ],
      ),
    );
  }
}

class _QuestsAccessDescription extends StatelessWidget {
  const _QuestsAccessDescription({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: Strings.quests,
            style: Styles.body2.copyWith(
              letterSpacing: 0.4,
              fontSize: 15,
            ),
          ),
          TextSpan(
            text: Strings.questsAccessDescription,
            style: Styles.body1.copyWith(
              letterSpacing: 0.4,
              fontSize: 15,
            ),
          ),
        ]),
      ),
    );
  }
}

class _AdvantagesWidget extends StatelessWidget {
  const _AdvantagesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildAdvantage(Strings.questsAccessAdvantage1),
        _buildAdvantage(Strings.questsAccessAdvantage2),
        _buildAdvantage(Strings.questsAccessAdvantage3),
      ],
    );
  }

  Widget _buildAdvantage(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Styles.body1,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyButton extends StatelessWidget {
  const _BuyButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: ColorRes.green,
      onPressed: () => print('Pressed!'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.check, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            Strings.buyQuestsAccess,
            style: Styles.body1.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
