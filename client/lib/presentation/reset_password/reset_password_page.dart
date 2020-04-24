import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/models/network/errors/invalid_email_exception.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/validators.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:cash_flow/widgets/containers/connected_blocked_loadable.dart';
import 'package:cash_flow/widgets/inputs/border_input_field.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:cash_flow/widgets/inputs/input_field_props.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({this.email});

  final String email;

  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordPageState(email);
  }
}

class _ResetPasswordPageState extends State<ResetPasswordPage> with ReduxState {
  _ResetPasswordPageState(String email)
      : _emailController = TextEditingController(text: email);

  final TextEditingController _emailController;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ConnectedBlockedLoadable(
      converter: (s) => s.login.resetPasswordRequestState.isInProgress,
      child: DropFocus(
        child: Scaffold(
          appBar:
              CashAppBar.withBackButton(title: Strings.recoveryPasswordTitle),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomBar(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            Strings.recoveryPasswordDesc,
            style: Styles.body1.copyWith(color: ColorRes.black),
          ),
          const SizedBox(height: 24),
          BorderInputField(
            props: InputFieldProps(
              label: Strings.labelEmail,
              hint: Strings.hintEmail,
              controller: _emailController,
              focusNode: _focusNode,
              onSubmitted: isFormValid() ? (_) => _onSubmitClicked() : null,
              validatorRules: [ruleNotEmpty, ruleEmail],
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ],
      ),
    );
  }

  bool isFormValid() {
    return !ruleEmail.function(_emailController.text);
  }

  void _onSubmitClicked() {
    dispatchAsyncAction(ResetPasswordAsyncAction(email: _emailController.text))
        .listen((action) => action
          ..onSuccess(_onResetPasswordSuccess)
          ..onError(_onResetPasswordError));
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: ActionButton(
        text: Strings.submit,
        onPressed: isFormValid() ? _onSubmitClicked : null,
        color: ColorRes.grass,
      ),
    );
  }

  void _onResetPasswordSuccess(_) {
    appRouter.goTo(const LoginPage());
  }

  void _onResetPasswordError(error) {
    switch (error.runtimeType) {
      case InvalidEmailException:
        showErrorDialog(context: context, message: Strings.noSuchEmail);
        break;

      default:
        handleError(
          context: context,
          exception: error,
          onRetry: _onSubmitClicked,
        );
        break;
    }
  }
}
