import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocit/main.dart';
import 'package:velocit/pages/auth/OTP_Screen.dart';
import 'package:velocit/pages/screens/dashBoard.dart';
import 'package:velocit/utils/routes/routes.dart';

import '../../pages/auth/Sign_Up.dart';
import '../../pages/auth/sign_in.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreenRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());
        case RoutesName.signUpRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignUp());
      case RoutesName.signInRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignIn_Screen());
      case RoutesName.dashboardRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => DashboardScreen());

      case RoutesName.otpRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => OTPScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("No routes are there.")),
          );
        });
    }
  }
}
