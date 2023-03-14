import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocit/Core/Model/ProductListingModel.dart';
import 'package:velocit/main.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/MyAccount_activity.dart';
import 'package:velocit/pages/Activity/My_Orders/MyOrders_Activity.dart';
import 'package:velocit/pages/auth/OTP_Screen.dart';
import 'package:velocit/pages/auth/change_password.dart';
import 'package:velocit/pages/screens/cartDetail_Activity.dart';
import 'package:velocit/pages/screens/dashBoard.dart';
import 'package:velocit/pages/screens/offers_Activity.dart';
import 'package:velocit/utils/routes/routes.dart';

import '../../pages/Activity/My_Account_Activities/Saved_address/saved_address_detailed_screen.dart';
import '../../pages/Activity/Product_Activities/Products_List.dart';
import '../../pages/auth/Sign_Up.dart';
import '../../pages/auth/forgot_password.dart';
import '../../pages/auth/sign_in.dart';
import '../../pages/screens/launch_Screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreenRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());
      case RoutesName.signUpRoute:
        return MaterialPageRoute(builder: (BuildContext context) => SignUp());
      case RoutesName.signInRoute:
        return MaterialPageRoute(
          builder: (BuildContext context) => SignIn_Screen(),
        );
      case RoutesName.dashboardRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => DashboardScreen());
         case RoutesName.orderRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => MyOrdersActivity());
      case RoutesName.myAccountRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => MyAccountActivity());
      case RoutesName.saveAddressRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => SavedAddressDetails());

      case RoutesName.productListingRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductListByCategoryActivity());


        case RoutesName.cartScreenRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => CartDetailsActivity());        case RoutesName.offerScreenRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => OfferActivity());


      // case RoutesName.otpRoute:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => OTPScreen(mobileNumber: ''));
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("No routes are there.")),
          );
        });
    }
  }
}
