import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/AccountSetting/AccountSettingScreen.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/AccountSetting/NotificationScreen.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/CustomerSupport/CustomerSupportActivity.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/MyAccountActivity/Edit_Account_activity.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/MyAccount_activity.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/Saved_address/saved_address_detailed_screen.dart';
import 'package:velocit/pages/Activity/My_Orders/MyOrders_Activity.dart';
import 'package:velocit/pages/Activity/Order_CheckOut_Activities/OrderReviewScreen.dart';
import 'package:velocit/pages/Activity/Payment_Activities/payments_Activity.dart';
import 'package:velocit/pages/Activity/Product_Activities/ProductDetails_activity.dart';
import 'package:velocit/pages/Activity/Product_Activities/Products_List.dart';
import 'package:velocit/pages/auth/sign_in.dart';
import 'package:velocit/pages/homePage.dart';
import 'package:velocit/pages/screens/cartDetail_Activity.dart';
import 'package:velocit/pages/screens/dashBoard.dart';
import 'package:velocit/services/providers/Home_Provider.dart';
import 'package:velocit/services/providers/cart_Provider.dart';
import 'package:velocit/utils/constants.dart';
import 'package:velocit/utils/routes/routes.dart';
import 'package:velocit/utils/routes/routes_name.dart';
import 'package:velocit/utils/styles.dart';
import 'package:velocit/utils/utils.dart';
import 'Core/ViewModel/auth_view_model.dart';
import 'L10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/localeProvider.dart';
import 'pages/Activity/My_Account_Activities/SaveCardAndWallets/CardList_manage_Payment_Activity.dart';
import 'services/providers/Products_provider.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  StringConstant.isLogIn = false;
  StringConstant.emailOTPVar =
      (await Prefs.instance.getToken(StringConstant.emailOTPPref))!;

  print('The name is ${StringConstant.emailOTPVar}');

  StringConstant.emailvar =
      (await Prefs.instance.getToken(StringConstant.emailPref))!;
  await Prefs.instance.getToken(StringConstant.pinCodePref);

  StringConstant.userAccountName =
      (await Prefs.instance.getToken(StringConstant.userAccountNamePref))!
              .isEmpty
          ? StringConstant.userAccountName
          : StringConstant.userAccountName;
  StringConstant.userAccountEmail =
      (await Prefs.instance.getToken(StringConstant.userAccountEmailPref))!
              .isEmpty
          ? StringConstant.userAccountEmail
          : StringConstant.userAccountEmail;
  StringConstant.userAccountMobile =
      (await Prefs.instance.getToken(StringConstant.userAccountMobilePref))!
              .isEmpty
          ? StringConstant.userAccountMobile
          : StringConstant.userAccountMobile;
  StringConstant.userAccountPass =
      (await Prefs.instance.getToken(StringConstant.userAccountPassPref))!.isEmpty?StringConstant.userAccountPass:StringConstant.userAccountPass;

  StringConstant.placesFromCurrentLocation =
      (await Prefs.instance.getToken(StringConstant.pinCodePref))!.isEmpty?StringConstant.placesFromCurrentLocation:StringConstant.placesFromCurrentLocation;

  StringConstant.addressFromCurrentLocation =
      (await Prefs.instance.getToken(StringConstant.addressPref))!.isEmpty? StringConstant.addressFromCurrentLocation: StringConstant.addressFromCurrentLocation;

  SharedPreferences.setMockInitialValues({});

  await Prefs.instance.getToken(StringConstant.cartListForPreferenceKey);
  await Prefs.instance.getToken('copyCartList');

  //
  // final box = GetStorage();
  // List storageList = [];

  // storageList = box.read('tasks');
  // print("Storage List Length"+storageList.length.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthViewModel(),
          ),

          ChangeNotifierProvider(
            create: (_) => LocaleProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => HomeProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ProductProvider(),
          ),
          // ChangeNotifierProvider(create: (_) => ProductsVM(),),
        ],
        child: Consumer<HomeProvider>(builder: (context, provider, child) {
          provider.loadJson();
          return Consumer<ProductProvider>(builder: (context, value, child) {
            return Consumer<LocaleProvider>(
                builder: (context, localeProvider, snapshot) {
              return MaterialApp(
                locale: localeProvider.locale,
                localizationsDelegates: const [
                  //AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalizations.delegate,
                ],
                supportedLocales: L10n.all,
                theme: ThemeData(
                  primarySwatch: colorCustomForMaterialApp,
                ),
                debugShowCheckedModeBanner: false,
                // initialRoute: StringConstant.isLogIn == true?RoutesName.signInRoute:RoutesName.dashboardRoute,
                initialRoute: RoutesName.splashScreenRoute,
                onGenerateRoute: Routes.generateRoute,
                routes: {
                  // '/': (context) => StringConstant.isLogIn == false
                  //     ? SignIn_Screen()
                  //     : DashboardScreen(),
                  '/': (context) =>SplashScreen(),
                  '/dashBoardScreen': (context) => const DashboardScreen(),
                  '/editAccountActivity': (context) =>
                      const EditAccountActivity(),
                  '/myAccountActivity': (context) => const MyAccountActivity(),
                  '/accountSettingScreen': (context) =>
                      const AccountSettingScreen(),
                  '/myOrdersActivity': (context) => const MyOrdersActivity(),
                  '/cardListManagePayments': (context) =>
                      const CardListManagePayments(),
                  '/savedAddressDetails': (context) =>
                      const SavedAddressDetails(),
                  '/customerSupportActivity': (context) =>
                      const CustomerSupportActivity(),
                  '/productListByCategoryActivity': (context) =>
                      ProductListByCategoryActivity(
                          productList: provider
                              .productList[provider.indexofSubProductList]),
                  '/cartScreen': (context) => CartDetailsActivity(
                      value: value, productList: provider.cartProductList),
                  '/orderReviewSubActivity': (context) =>
                      OrderReviewSubActivity(value: value,cartListFromHome: provider.productList),
                  '/payment_Creditcard_debitcardScreen': (context) =>
                      Payment_Creditcard_debitcardScreen(),
                },
              );
            });
          });
        }));
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeProvider>(context, listen: false).loadJson();
    });
    Timer(
        const Duration(seconds: 3),
        () {
     /* StringConstant.isLogIn == false? Navigator.pushNamed(context, RoutesName.signInRoute) :*/Navigator.pushNamed(context, RoutesName.dashboardRoute);
          });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(100),
        child: Image.asset(
          'assets/images/VelocIT_Icon_512.png',
          scale: 1,
        ),
      ),
    );
  }
}
