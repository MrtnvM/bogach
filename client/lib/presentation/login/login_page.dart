import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_flow/configuration/system_ui.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/models/network/errors/invalid_credentials_exception.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/presentation/registration/registration_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/validators.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:cash_flow/widgets/buttons/border_button.dart';
import 'package:cash_flow/widgets/containers/connected_blocked_loadable.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:cash_flow/widgets/inputs/input_field.dart';
import 'package:cash_flow/widgets/inputs/input_field_props.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with ReduxState {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    setOrientationPortrait();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectedBlockedLoadable(
      converter: (state) => state.login.loginRequestState.isInProgress,
      child: DropFocus(
        child: Scaffold(
          backgroundColor: ColorRes.darkBlue,
          body: _buildBody(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  void _onLoginClicked() {
    if (_formKey.currentState.validate()) {
      dispatchAsyncAction(LoginAsyncAction(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )).listen((action) => action
        ..onSuccess((_) => _onLoggedIn())
        ..onError(_onLoginError));
    }
  }

  void _onSignUpClicked() {
     appRouter.goTo(const RegistrationPage());
  }

  void _onLoggedIn() {
    appRouter.startWith(const MainPage());
  }

  void _onLoginError(dynamic error) {
    switch (error.runtimeType) {
      case InvalidCredentialsException:
        showErrorDialog(context: context, message: Strings.invalidCredentials);
        break;

      default:
        handleError(
          context: context,
          exception: error,
          onRetry: _onLoginClicked,
        );
        break;
    }
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 24),
          InputField(
            props: InputFieldProps(
              hint: Strings.email,
              controller: _emailController,
              validatorRules: [ruleNotEmpty],
              textInputAction: TextInputAction.next,
              focusNode: _emailFocusNode,
              nextFocusNode: _passwordFocusNode,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 16),
          InputField(
            props: InputFieldProps(
              hint: Strings.password,
              controller: _passwordController,
              validatorRules: [ruleNotEmpty],
              focusNode: _passwordFocusNode,
              onSubmitted: (_) => _onLoginClicked(),
              obscureText: true,
            ),
          ),
          _buildLoginButton(),
          const SizedBox(height: 24),
          _buildSocialMedias(),
          const SizedBox(height: 16),
          _buildSignUpWidget(),
          const SafeArea(top: false, child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildSocialMedias() {
    return OutlineButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(Images.icFacebook, width: 24, height: 24),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              height: 44,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AutoSizeText(
                    Strings.facebook.toUpperCase(),
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
      onPressed: _onContinueWithFacebookPressed,
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

  void _onContinueWithFacebookPressed() {}

  Widget _buildLoginButton() {
    return ActionButton(
      text: Strings.loginTitle,
      onPressed: _onLoginClicked,
      color: ColorRes.grass,
    );
  }

  Widget _buildSignUpWidget() {
    return BorderButton(
      text: Strings.signUpTitle,
      onPressed: _onSignUpClicked,
      color: ColorRes.grass,
      textColor: ColorRes.white,
    );
  }
}
