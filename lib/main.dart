import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/AccountSetting/AccountSettingScreen.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/CustomerSupport/CustomerSupportActivity.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/MyAccountActivity/Edit_Account_activity.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/MyAccount_activity.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/Saved_address/saved_address_detailed_screen.dart';
import 'package:velocit/pages/Activity/My_Orders/MyOrders_Activity.dart';
import 'package:velocit/pages/Activity/Order_CheckOut_Activities/OrderReviewScreen.dart';
import 'package:velocit/pages/Activity/Payment_Activities/payments_Activity.dart';
import 'package:velocit/pages/Activity/Product_Activities/Products_List.dart';
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
import 'Core/ViewModel/dashboard_view_model.dart';
import 'Core/ViewModel/product_listing_view_model.dart';
import 'L10n/l10n.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/localeProvider.dart';
import 'pages/Activity/My_Account_Activities/SaveCardAndWallets/CardList_manage_Payment_Activity.dart';
import 'services/providers/Products_provider.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
  StringConstant.isLogIn = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // var loginId=await  prefs.getString(StringConstant.userId);
  var testId=await  prefs.getString(StringConstant.testId);
  print("on loging testId : "+testId.toString());

  // StringConstant.isLogIn = true;
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
      (await Prefs.instance.getToken(StringConstant.userAccountPassPref))!
              .isEmpty
          ? StringConstant.userAccountPass
          : StringConstant.userAccountPass;

  StringConstant.placesFromCurrentLocation =
      (await Prefs.instance.getToken(StringConstant.pinCodePref))!.isEmpty
          ? StringConstant.placesFromCurrentLocation
          : StringConstant.placesFromCurrentLocation;

  StringConstant.addressFromCurrentLocation =
      (await Prefs.instance.getToken(StringConstant.addressPref))!.isEmpty
          ? StringConstant.addressFromCurrentLocation
          : StringConstant.addressFromCurrentLocation;

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
   MyApp({super.key});
   ProductSpecificListViewModel productViewModel =
   ProductSpecificListViewModel();    Map data = {"category_code":"EOLP","recommended_for_you":"1","Merchants Near You":"1","best_deal":"",'budget_buys':""};

   // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    productViewModel.productSpecificListWithGet(context,data);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => DashboardViewModel(),
          ),  ChangeNotifierProvider(
            create: (_) => ProductSpecificListViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => LocaleProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => HomeProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => CartManageProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ProductProvider(),
          ),
          // ChangeNotifierProvider(create: (_) => ProductsVM(),),
        ],
        child: Consumer<HomeProvider>(builder: (context, provider, child) {
        var data =   provider.loadJson();

        return Consumer<ProductProvider>(builder: (context, value, child) {
            // return Consumer<LocaleProvider>(
            //     builder: (context, localeProvider, snapshot) {
              return MaterialApp(
              /*  locale: localeProvider.locale,
                localizationsDelegates: const [
                  //AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalizations.delegate,
                ],
                supportedLocales: L10n.all,*/
                theme: ThemeData(
                  primarySwatch: colorCustomForMaterialApp,
                ),
                debugShowCheckedModeBanner: false,
                // home: ForgotPassword(),
                // initialRoute: StringConstant.isLogIn == true?RoutesName.signInRoute:RoutesName.dashboardRoute,
                initialRoute: RoutesName.splashScreenRoute,
                onGenerateRoute: Routes.generateRoute,
                routes: {
                  // '/': (context) => StringConstant.isLogIn == true
                  //     ? SignIn_Screen()
                  //     : DashboardScreen(),
                  '/': (context) => SplashScreen(),
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
                  // '/productDetailsActivity': (context) => ProductDetailsActivity(model: productsList[0], value: value),
                  '/cartScreen': (context) => CartDetailsActivity(
                      value: value, productList: provider.cartProductList),
                  '/orderReviewSubActivity': (context) =>
                      OrderReviewSubActivity(
                          value: value, cartListFromHome: provider.productList),
                  '/payment_Creditcard_debitcardScreen': (context) =>
                      const Payment_Creditcard_debitcardScreen(),
                },
              );
            // });
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
    startTime();
  }

  startTime() async {
    var loginId=await  Prefs.instance.getToken(StringConstant.userId);
    print("Splash LoginId : "+loginId.toString());

    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(height: MediaQuery.of(context).size.height,
        color: ThemeApp.appBackgroundColor,

        child: const Center(
          child: CircularProgressIndicator(
            color: ThemeApp.darkGreyColor,
          ),
        ),
      ),
    );
  }
}
