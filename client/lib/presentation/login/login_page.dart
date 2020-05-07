import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/models/errors/unknown_error.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with ReduxState {
  @override
  void initState() {
    super.initState();
    setOrientationPortrait();
  }

  @override
  Widget build(BuildContext context) {
    return DropFocus(
      child: Scaffold(
        backgroundColor: ColorRes.darkBlue,
        body: _buildBody(),
      ),
    );
  }

  void _onLoggedIn(_) {
    appRouter.startWith(const MainPage());
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 24),
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
        _buildAppleSignInButton(),
        const SafeArea(top: false, child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildSocialMedias({
    @required String icon,
    @required String title,
    @required _SocialButtonType type,
  }) {
    return OutlineButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(icon, width: 24, height: 24),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              height: 44,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AutoSizeText(
                    title.toUpperCase(),
                    style: Styles.body1.copyWith(color: ColorRes.white),
                    maxFontSize: Styles.body1.fontSize,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      color: ColorRes.grass,
      onPressed: () => loginViaSocial(type),
      borderSide: const BorderSide(color: ColorRes.grass),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      highlightedBorderColor: ColorRes.grass,
    );
  }

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: _buildLoginForm(),
          ),
        );
      }),
    );
  }

  void loginViaSocial(_SocialButtonType type) {
    switch (type) {
      case _SocialButtonType.fb:
        _onLoginViaFacebookPressed();
        break;
      case _SocialButtonType.google:
        _onLoginViaGoogleClicked();
        break;
    }
  }

  Future<void> _onLoginViaFacebookPressed() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _loginViaFacebook(result.accessToken.token);
        break;
      case FacebookLoginStatus.error:
        handleError(context: context, exception: UnknownErrorException());
        break;
      default:
        break;
    }
  }

  void _loginViaFacebook(String token) {
    dispatchAsyncAction(LoginViaFacebookAsyncAction(token: token))
        .listen((action) => action
          ..onSuccess(_onLoggedIn)
          ..onError(_onLoginViaFacebookError));
  }

  void _onLoginViaFacebookError(error) {
    handleError(context: context, exception: error);
  }

  Future<void> _onLoginViaGoogleClicked() async {
    final account = await GoogleSignIn()
        .signIn()
        .catchError((e) => showErrorDialog(context: context));

    if (account == null) {
      //was cancelled by the user
      return;
    }

    final authentication = await account.authentication;

    _loginViaGoogle(
      token: authentication.accessToken,
      idToken: authentication.idToken,
    );
  }

  void _loginViaGoogle({String token, String idToken}) {
    dispatchAsyncAction(LoginViaGoogleAsyncAction(
      accessToken: token,
      idToken: idToken,
    )).listen((action) => action
      ..onSuccess(_onLoggedIn)
      ..onError(_onLoginViaFacebookError));
  }

  Future<void> _onLoginViaAppleClicked() async {
    final result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final identityToken =
            String.fromCharCodes(result.credential.identityToken);
        final accessToken =
            String.fromCharCodes(result.credential.authorizationCode);
        final firstName = result.credential.fullName.givenName;
        final lastName = result.credential.fullName.givenName;

        dispatchAsyncAction(LoginViaAppleAsyncAction(
          idToken: identityToken,
          accessToken: accessToken,
          firstName: firstName,
          lastName: lastName,
        )).listen((action) => action
          ..onSuccess(_onLoggedIn)
          ..onError(_onLoginViaAppleError));
        break;
      case AuthorizationStatus.error:
        handleError(context: context, exception: UnknownErrorException());
        break;

      case AuthorizationStatus.cancelled:
        break;
    }
  }

  Widget _buildAppleSignInButton() {
    return FutureBuilder(
        future: AppleSignIn.isAvailable(),
        builder: (context, snapShoot) =>
            snapShoot.hasData && snapShoot.data == true
                ? AppleSignInButton(onPressed: _onLoginViaAppleClicked)
                : Container());
  }

  void _onLoginViaAppleError(error) {
    handleError(context: context, exception: error);
  }
}

enum _SocialButtonType { fb, google }
