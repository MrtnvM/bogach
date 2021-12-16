// import 'package:cash_flow/features/profile/actions/logout_action.dart';
// import 'package:cash_flow/features/profile/actions/start_listening_profile_updates_action.dart';
// import 'package:cash_flow/navigation/app_router.dart';
// import 'package:cash_flow/presentation/login/login_page.dart';
// import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
// import 'package:dash_kit_core/dash_kit_core.dart';
// import 'package:flutter/material.dart';

// class LogoutSetting extends StatefulWidget implements ControlPanelSetting {
//   const LogoutSetting();

//   @override
//   _LogoutSettingState createState() => _LogoutSettingState();

//   @override
//   Setting get setting => Setting(
//         id: runtimeType.toString(),
//         title: 'Log Out',
//       );
// }

// class _LogoutSettingState extends State<LogoutSetting> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           primary: Colors.green.withAlpha(240),
//         ),
//         onPressed: _logout,
//         child: FittedBox(
//           child: Text(
//             'Log Out',
//             style: TextStyle(
//               color: Colors.white.withAlpha(240),
//               letterSpacing: 0.4,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _logout() {
//     context
//         .dispatch(StopListeningProfileUpdatesAction())
//         .then((value) => context.dispatch(LogoutAction()))
//         .then((_) => _onLogoutFinished())
//         .onError((_, st) => _onLogoutFinished());
//   }

//   void _onLogoutFinished() {
//     appRouter.startWith(LoginPage());
//   }
// }
