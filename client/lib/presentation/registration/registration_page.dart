import 'package:cash_flow/features/registration/registration_actions.dart';
import 'package:cash_flow/models/network/errors/email_has_been_taken_exception.dart';
import 'package:cash_flow/models/network/request/register_request_model.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/resources/urls.dart';
import 'package:cash_flow/utils/validators.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:cash_flow/widgets/containers/connected_blocked_loadable.dart';
import 'package:cash_flow/widgets/inputs/border_input_field.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:cash_flow/widgets/inputs/input_field_props.dart';
import 'package:cash_flow/widgets/selectors/checkbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage();

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> with ReduxState {
  final _nickController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _emailController = TextEditingController();

  List<InputFieldProps> _fields;
  bool _agreementAccepted = false;

  @override
  void initState() {
    super.initState();

    _fields = _getAllProps();
    for (var field in _fields) {
      field.controller.addListener(() => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectedBlockedLoadable(
      converter: (state) => state.registration.requestState.isInProgress,
      child: DropFocus(
        child: Scaffold(
          backgroundColor: ColorRes.gallery,
          appBar: CashAppBar.withBackButton(title: Strings.registrationTitle),
          body: _buildContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final prop in _fields) {
      prop.focusNode.dispose();
    }
    super.dispose();
  }

  List<InputFieldProps> _getAllProps() {
    final props = <InputFieldProps>[];

    props
      ..insert(
        0,
        InputFieldProps(
            label: Strings.labelRepeatPassword,
            hint: Strings.hintRepeatPassword,
            controller: _repeatPasswordController,
            focusNode: FocusNode(),
            validatorRules: [
              ruleNotEmpty,
              rulePasswordsShouldMatch(
                (value) => value != _passwordController.text,
              ),
            ],
            obscureText: true),
      )
      ..insert(
        0,
        InputFieldProps(
            label: Strings.labelPassword,
            hint: Strings.hintPassword,
            controller: _passwordController,
            focusNode: FocusNode(),
            nextFocusNode: props[0].focusNode,
            validatorRules: [ruleNotEmpty, rulePassword],
            obscureText: true),
      )
      ..insert(
        0,
        InputFieldProps(
          label: Strings.labelEmail,
          hint: Strings.hintEmail,
          controller: _emailController,
          focusNode: FocusNode(),
          nextFocusNode: props[0].focusNode,
          validatorRules: [ruleNotEmpty, ruleEmail],
          keyboardType: TextInputType.emailAddress,
        ),
      )
      ..insert(
        0,
        InputFieldProps(
          label: Strings.labelNickName,
          hint: Strings.hintNickName,
          controller: _nickController,
          focusNode: FocusNode(),
          nextFocusNode: props[0].focusNode,
          validatorRules: [ruleNotEmpty],
          textCapitalization: TextCapitalization.words,
        ),
      );

    return props;
  }

  void _onAgreementCheckBoxClicked(bool value) {
    setState(() => _agreementAccepted = !_agreementAccepted);
  }

  void _onRegisterClicked() {
    FocusScope.of(context).requestFocus(FocusNode());

    final requestModel = RegisterRequestModel((b) => b
      ..nickName = _nickController.text.trim()
      ..email = _emailController.text.trim()
      ..password = _passwordController.text.trim()
      ..repeatPassword = _repeatPasswordController.text.trim());

    dispatchAsyncAction(RegisterAsyncAction(model: requestModel))
        .listen((action) => action
          ..onSuccess(_onRegistrationSuccess)
          ..onError(_onRegistrationError));
  }

  bool isFormValid() {
    final allFieldsValid = _fields.every((field) =>
        field.validatorRules == null ||
        validate(field.controller.text, field.validatorRules) == null);

    return allFieldsValid && _agreementAccepted;
  }

  void _onRegistrationSuccess(_) {
    appRouter.startWith(const MainPage());
  }

  void _onRegistrationError(dynamic error) {
    switch (error.runtimeType) {
      case EmailHasBeenTakenException:
        showErrorDialog(context: context, message: Strings.emailHasBeenTaken);
        break;

      default:
        handleError(
          context: context,
          exception: error,
          onRetry: _onRegisterClicked,
        );
        break;
    }
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: <Widget>[
              for (var value in _fields)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: BorderInputField(props: value),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildAgreementCheckBox(),
        const SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 26),
          child: SafeArea(
            top: false,
            child: ActionButton(
              text: Strings.signUpTitle,
              color: ColorRes.grass,
              onPressed: isFormValid() ? _onRegisterClicked : null,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildAgreementCheckBox() {
    return Container(
      margin: const EdgeInsets.only(left: 14),
      child: CashCheckbox.widget(
        isChecked: _agreementAccepted,
        onChanged: _onAgreementCheckBoxClicked,
        widget: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: Strings.regAgreementStart),
              TextSpan(
                  text: Strings.regAgreementTermsOfUse,
                  style: Styles.caption.copyWith(
                      color: ColorRes.black,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _launchTermsOfUseUrl),
              TextSpan(text: Strings.regAgreementAnd),
              TextSpan(
                  text: Strings.regAgreementPrivacyPolicy,
                  style: Styles.caption.copyWith(
                      color: ColorRes.black,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _launchPrivacyPolicyUrl),
            ],
          ),
          textAlign: TextAlign.left,
          maxLines: 2,
          style: Styles.body1.copyWith(color: ColorRes.black),
        ),
      ),
    );
  }

  Future<void> _launchPrivacyPolicyUrl() async {
    final url = Urls.policyUrl;

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> _launchTermsOfUseUrl() async {
    final url = Urls.termsOfUseUrl;

    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
