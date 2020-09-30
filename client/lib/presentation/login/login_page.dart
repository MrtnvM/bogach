import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/features/profile/actions/login_via_apple_action.dart';
import 'package:cash_flow/features/profile/actions/login_via_facebook_action.dart';
import 'package:cash_flow/features/profile/actions/login_via_google_action.dart';
import 'package:cash_flow/models/errors/unknown_error.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/resources/urls.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool _isAuthorising = false;

  @override
  void initState() {
    super.initState();
    setOrientationPortrait();
  }

  @override
  Widget build(BuildContext context) {
    return LoadableView(
      isLoading: _isAuthorising,
      backgroundColor: Colors.black.withAlpha(150),
      child: CashFlowScaffold(
        title: Strings.loginTitle,
        footerImage: Images.authImage,
        child: Column(
          children: <Widget>[
            _buildLoginForm(),
            // _buildLaterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildSocialMedias(
          icon: Images.icFacebook,
          title: Strings.facebook,
          type: _SocialButtonType.fb,
        ),
        const SizedBox(height: 16),
        _buildSocialMedias(
          icon: Images.icGoogle,
          title: Strings.google,
          type: _SocialButtonType.google,
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
        _buildAppleSignInButton(),
        const SizedBox(height: 32),
        buildPrivacyPolicy(),
      ],
    );
  }

  Widget _buildSocialMedias({
    @required String icon,
    @required String title,
    @required _SocialButtonType type,
  }) {
    return FlatButton(
      color: Colors.white,
      onPressed: () => loginViaSocial(type),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset(icon, width: 24, height: 24),
          const SizedBox(width: 12),
          Flexible(
            child: SizedBox(
              height: 44,
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: Text(
                    Strings.getAuthButtonTitle(title),
                    style: Styles.subhead.copyWith(color: ColorRes.mainBlack),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppleSignInButton() {
    return FutureBuilder(
      future: AppleSignIn.isAvailable(),
      builder: (context, snapShoot) =>
          snapShoot.hasData && snapShoot.data == true
              ? _buildSocialMedias(
                  icon: Images.icApple,
                  title: Strings.apple,
                  type: _SocialButtonType.apple,
                )
              : Container(),
    );
  }

  Widget buildPrivacyPolicy() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: Strings.authAndAccept,
            style: Styles.onboardingSubtitle,
          ),
          TextSpan(
            text: Strings.termsOfUse,
            style: Styles.onboardingSubtitle.copyWith(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchURL(Urls.termsOfUseUrl);
              },
          ),
          TextSpan(
            text: Strings.and,
            style: Styles.onboardingSubtitle,
          ),
          TextSpan(
            text: Strings.privacyPolicy,
            style: Styles.onboardingSubtitle.copyWith(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchURL(Urls.policyUrl);
              },
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

  void _onLoggedIn() {
    setState(() => _isAuthorising = false);
    appRouter.startWith(const MainPage());
  }

  void loginViaSocial(_SocialButtonType type) {
    switch (type) {
      case _SocialButtonType.fb:
        _onLoginViaFacebookPressed();
        break;

      case _SocialButtonType.google:
        _onLoginViaGoogleClicked();
        break;

      case _SocialButtonType.apple:
        _onLoginViaAppleClicked();
        break;

      case _SocialButtonType.vk:
        // TODO(Vadim): Add vk integration
        showNotImplementedDialog(context);
        break;
    }
  }

  Future<void> _onLoginViaFacebookPressed() async {
    setState(() => _isAuthorising = true);

    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _loginViaFacebook(result.accessToken.token);
        break;

      case FacebookLoginStatus.error:
        setState(() => _isAuthorising = false);
        handleError(context: context, exception: UnknownErrorException());
        break;

      default:
        setState(() => _isAuthorising = false);
        break;
    }
  }

  void _loginViaFacebook(String token) {
    final action = LoginViaFacebookAction(token: token);

    context
        .dispatch(action)
        .then((_) => _onLoggedIn())
        .catchError(_onLoginError);
  }

  void _onLoginError(error) {
    setState(() => _isAuthorising = false);
    handleError(context: context, exception: error);
  }

  Future<void> _onLoginViaGoogleClicked() async {
    final account = await GoogleSignIn().signIn().catchError((e) {
      setState(() => _isAuthorising = false);
      showErrorDialog(context: context);
    });

    if (account == null) {
      // was cancelled by the user
      setState(() => _isAuthorising = false);
      return;
    }

    setState(() => _isAuthorising = true);

    final authentication = await account.authentication;

    _loginViaGoogle(
      token: authentication.accessToken,
      idToken: authentication.idToken,
    );
  }

  void _loginViaGoogle({String token, String idToken}) {
    context
        .dispatch(LoginViaGoogleAction(
          accessToken: token,
          idToken: idToken,
        ))
        .then((_) => _onLoggedIn())
        .catchError(_onLoginError);
  }

  Future<void> _onLoginViaAppleClicked() async {
    final result = await AppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final identityToken =
            String.fromCharCodes(result.credential.identityToken);
        final accessToken =
            String.fromCharCodes(result.credential.authorizationCode);
        final firstName = result.credential.fullName.givenName;
        final lastName = result.credential.fullName.familyName;

        setState(() => _isAuthorising = true);

        context
            .dispatch(LoginViaAppleAction(
              idToken: identityToken,
              accessToken: accessToken,
              firstName: firstName,
              lastName: lastName,
            ))
            .then((_) => _onLoggedIn())
            .catchError(_onLoginViaAppleError);

        break;

      case AuthorizationStatus.error:
        setState(() => _isAuthorising = false);
        handleError(context: context, exception: UnknownErrorException());
        break;

      case AuthorizationStatus.cancelled:
        setState(() => _isAuthorising = false);
        break;
    }
  }

  void _onLoginViaAppleError(error) {
    setState(() => _isAuthorising = false);
    handleError(context: context, exception: error);
  }

  Future<void> _launchURL(String url) async {
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
}

enum _SocialButtonType { fb, google, vk, apple }
