import 'dart:io';

import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/multiplayer/actions/check_add_friends_storage.dart';
import 'package:cash_flow/features/profile/actions/login_via_apple_action.dart';
import 'package:cash_flow/features/profile/actions/login_via_facebook_action.dart';
import 'package:cash_flow/features/profile/actions/login_via_google_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/resources/urls.dart';
import 'package:cash_flow/utils/error_handler.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isAuthorising = useState(false);
    final dispatch = useDispatcher();

    setOrientationPortrait();

    return LoadableView(
      isLoading: isAuthorising.value,
      backgroundColor: Colors.black.withAlpha(150),
      child: CashFlowScaffold(
        title: Strings.loginTitle,
        footerImage: Images.authImage,
        child: Column(
          children: <Widget>[
            const Spacer(flex: 5),
            _buildLoginForm(
              context,
              dispatch,
              isAuthorising,
            ),
            const Spacer(flex: 4),
            // _buildLaterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    Future<void> dispatch(BaseAction action),
    ValueNotifier<bool> isAuthorising,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildSocialMedias(
          icon: Images.icFacebook,
          title: Strings.facebook,
          type: _SocialButtonType.fb,
          context: context,
          dispatch: dispatch,
          isAuthorising: isAuthorising,
        ),
        const SizedBox(height: 16),
        _buildSocialMedias(
          icon: Images.icGoogle,
          title: Strings.google,
          type: _SocialButtonType.google,
          context: context,
          dispatch: dispatch,
          isAuthorising: isAuthorising,
        ),
        const SizedBox(height: 16),
        // TODO(Maxim): Implement authorisation through VK
        //
        // _buildSocialMedias(
        //   icon: Images.icVk,
        //   title: Strings.vk,
        //   type: _SocialButtonType.vk,
        // ),
        // const SizedBox(height: 16),
        if (Platform.isIOS)
          _buildAppleSignInButton(
            context,
            dispatch,
            isAuthorising,
          ),
        const SizedBox(height: 32),
        buildPrivacyPolicy(context),
      ],
    );
  }

  Widget _buildSocialMedias({
    required String icon,
    required String title,
    required _SocialButtonType type,
    required BuildContext context,
    required ValueNotifier<bool> isAuthorising,
    required Future<void> dispatch(BaseAction action),
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          onPressed: () => loginViaSocial(
            type,
            context,
            dispatch,
            isAuthorising,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: 24),
              SvgPicture.asset(icon, width: 24, height: 24),
              const SizedBox(width: 20),
              SizedBox(
                height: 44,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 1),
                    width: 200,
                    child: Text(
                      Strings.getAuthButtonTitle(title),
                      style: Styles.subhead.copyWith(color: ColorRes.mainBlack),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppleSignInButton(
    BuildContext context,
    Future<void> dispatch(BaseAction action),
    ValueNotifier<bool> isAuthorising,
  ) {
    return _buildSocialMedias(
      icon: Images.icApple,
      title: Strings.apple,
      type: _SocialButtonType.apple,
      context: context,
      dispatch: dispatch,
      isAuthorising: isAuthorising,
    );
  }

  Widget buildPrivacyPolicy(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenHeight < 580 ? 14.0 : 15.0;

    final style = Styles.onboardingSubtitle.copyWith(fontSize: fontSize);
    final linkStyle = style.copyWith(decoration: TextDecoration.underline);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(text: Strings.authAndAccept, style: style),
          TextSpan(
            text: Strings.termsOfUse,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchURL(context, Urls.termsOfUseUrl),
          ),
          TextSpan(text: Strings.and, style: style),
          TextSpan(
            text: Strings.privacyPolicy,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchURL(context, Urls.policyUrl),
          ),
        ],
      ),
    );
  }

  Widget buildLaterButton(BuildContext context) {
    return SizedBox(
      height: 46,
      width: 200,
      child: ColorButton(
        text: Strings.skip,
        // TODO(Vadim): Add anonymous auth
        onPressed: () => showNotImplementedDialog(context),
        color: ColorRes.yellow,
      ),
    );
  }

  void loginViaSocial(
    _SocialButtonType type,
    BuildContext context,
    Future<void> dispatch(BaseAction action),
    ValueNotifier<bool> isAuthorising,
  ) {
    switch (type) {
      case _SocialButtonType.fb:
        _onLoginViaFacebookPressed(
          context,
          dispatch,
          isAuthorising,
        );
        break;

      case _SocialButtonType.google:
        _onLoginViaGoogleClicked(
          context,
          dispatch,
          isAuthorising,
        );
        break;

      case _SocialButtonType.apple:
        _onLoginViaAppleClicked(
          context,
          dispatch,
          isAuthorising,
        );
        break;

      case _SocialButtonType.vk:
        // TODO(Vadim): Add vk integration
        showNotImplementedDialog(context);
        break;
    }
  }

  Future<void> _onLoginViaFacebookPressed(
    BuildContext context,
    Future<void> dispatch(BaseAction action),
    ValueNotifier<bool> isAuthorising,
  ) async {
    isAuthorising.value = true;

    final result = await FacebookAuth.instance.login(
      permissions: ['email'],
    ).onError(recordError);

    switch (result.status) {
      case LoginStatus.success:
        _loginViaFacebook(
          context,
          dispatch,
          isAuthorising,
          result.accessToken!.token,
        );
        break;

      case LoginStatus.failed:
        Logger.e('Facebook Auth Error', result.message);
        _onLoginError(context, Exception(result.message), isAuthorising);
        break;

      default:
        isAuthorising.value = false;
        break;
    }
  }

  void _loginViaFacebook(
    BuildContext context,
    Future<void> dispatch(BaseAction action),
    ValueNotifier<bool> isAuthorising,
    String token,
  ) {
    final action = LoginViaFacebookAction(token: token);

    dispatch(action)
        .whenComplete(() => isAuthorising.value = false)
        .then((value) => _onLoginSuccess(dispatch))
        .onError((error, st) => _onLoginError(context, error, isAuthorising));
  }

  void _onLoginError(
    BuildContext context,
    error,
    ValueNotifier<bool> isAuthorising,
  ) {
    Logger.e(error);
    handleError(context: context, exception: error);
    isAuthorising.value = false;

    AnalyticsSender.singInFailed();
  }

  Future<void> _onLoginViaGoogleClicked(
    BuildContext context,
    Future<void> dispatch(BaseAction action),
    ValueNotifier<bool> isAuthorising,
  ) async {
    final account = await GoogleSignIn().signIn().onError((e, st) {
      Logger.e('Google Auth Error', e);
      _onLoginError(context, e, isAuthorising);
      recordError(e);
    });

    if (account == null) {
      // was cancelled by the user
      isAuthorising.value = false;
      return;
    }

    isAuthorising.value = true;

    final authentication = await account.authentication;

    _loginViaGoogle(
      context: context,
      dispatch: dispatch,
      isAuthorising: isAuthorising,
      token: authentication.accessToken!,
      idToken: authentication.idToken!,
    );
  }

  void _loginViaGoogle({
    required BuildContext context,
    required Future<void> dispatch(BaseAction action),
    required ValueNotifier<bool> isAuthorising,
    required String token,
    required String idToken,
  }) {
    final action = LoginViaGoogleAction(
      accessToken: token,
      idToken: idToken,
    );

    dispatch(action)
        .then((value) => _onLoginSuccess(dispatch))
        .onError((error, st) => _onLoginError(context, error, isAuthorising));
  }

  Future<void> _onLoginViaAppleClicked(
    BuildContext context,
    Future<void> dispatch(BaseAction action),
    ValueNotifier<bool> isAuthorising,
  ) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      final accessToken = credential.authorizationCode;
      final firstName = credential.givenName;
      final lastName = credential.familyName;

      isAuthorising.value = true;

      final action = LoginViaAppleAction(
        idToken: identityToken!,
        accessToken: accessToken,
        firstName: firstName,
        lastName: lastName,
      );

      dispatch(action) //
          .then((value) {
        isAuthorising.value = false;
        return _onLoginSuccess(dispatch);
      }).catchError((e) => _onLoginError(context, e, isAuthorising));
    } catch (ex) {
      Logger.e('Apple Auth Error', ex);
      _onLoginError(context, ex, isAuthorising);
    }
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showErrorDialog(
        context: context,
        title: Strings.commonError,
        message: Strings.canNotOpenLink,
      );
    }
  }

  void _onLoginSuccess(
    Future<void> dispatch(BaseAction action),
  ) {
    AnalyticsSender.signIn();
    dispatch(CheckAddFriendsStorage());
    appRouter.startWith(const MainPage());
  }
}

enum _SocialButtonType { fb, google, vk, apple }
