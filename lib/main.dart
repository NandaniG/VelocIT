import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:geolocator/geolocator.dart';

// import 'package:geocode/geocode.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/services/providers/Home_Provider.dart';
import 'package:velocit/utils/constants.dart';
import 'package:velocit/utils/routes/routes.dart';
import 'package:velocit/utils/routes/routes_name.dart';
import 'package:velocit/utils/styles.dart';
import 'package:velocit/utils/utils.dart';
import 'Core/ViewModel/OrderBasket_viewmodel.dart';
import 'Core/ViewModel/cart_view_model.dart';
import 'Core/ViewModel/dashboard_view_model.dart';
import 'Core/ViewModel/product_listing_view_model.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/localeProvider.dart';
import 'notificationservices/local_notification_service.dart';
import 'services/providers/Products_provider.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print('FirebaseMessaging : ' + message.data.toString());
  print('FirebaseMessaging : ' + message.notification!.title.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  runApp(MyApp());
// getpref();
}

getpref() async {
  Prefs.instance;
  StringConstant.isLogIn = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
//user login id final
  StringConstant.loginUserName = (prefs.getString('usernameLogin')) ?? '';
  StringConstant.loginUserEmail = (prefs.getString('emailLogin')) ?? '';
  //

  var testId = await prefs.getString(StringConstant.testId);
  print("on loging testId : " + testId.toString());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => DashboardViewModel(),
          ),
          ChangeNotifierProvider(
            create:(_) => ProductSpecificListViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => LocaleProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => HomeProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ProductProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => OrderBasketViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => CartViewModel(),
          ),

          // ChangeNotifierProvider(create: (_) => ProductsVM(),),
        ],
        child: Consumer<HomeProvider>(builder: (context, provider, child) {
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
                unselectedWidgetColor: ThemeApp.appColor,
                textTheme: GoogleFonts.robotoTextTheme(
                  Theme.of(context).textTheme,
                ),
                primarySwatch: colorCustomForMaterialApp,
              ),
              color: ThemeApp.appColor,
              debugShowCheckedModeBanner: false,
              // home: ForgotPassword(),
              // initialRoute: StringConstant.isLogIn != true?RoutesName.signInRoute:RoutesName.dashboardRoute,
              initialRoute: RoutesName.splashScreenRoute,
              onGenerateRoute: Routes.generateRoute,
            );
            // });
          });
        }));
  }
}
