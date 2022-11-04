import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/AccountSetting/AccountSettingScreen.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/AccountSetting/NotificationScreen.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/CustomerSupport/CustomerSupportActivity.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/Saved_address/saved_address_detailed_screen.dart';
import 'package:velocit/pages/Activity/My_Orders/MyOrders_Activity.dart';
import 'package:velocit/pages/homePage.dart';
import 'package:velocit/services/providers/cart_Provider.dart';
import 'package:velocit/utils/constants.dart';
import 'package:velocit/utils/styles.dart';
import 'package:velocit/utils/utils.dart';
import 'L10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'auth/sign_in.dart';
import 'l10n/localeProvider.dart';
import 'services/providers/Products_provider.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await Prefs().getToken(StringConstant.pinCodePref);

  StringConstant.userAccountName = (await Prefs().getToken(StringConstant.userAccountNamePref))!;
  StringConstant.userAccountEmail = (await Prefs().getToken(StringConstant.userAccountEmailPref))!;
  StringConstant.userAccountMobile = (await Prefs().getToken(StringConstant.userAccountMobilePref))!;
  StringConstant.userAccountPass = (await Prefs().getToken(StringConstant.userAccountPassPref))!;


  StringConstant.placesFromCurrentLocation =
  (await Prefs().getToken(StringConstant.pinCodePref))!;

  StringConstant.addressFromCurrentLocation =
  (await Prefs().getToken(StringConstant.addressPref))!;

  SharedPreferences.setMockInitialValues({});

 await Prefs().getToken(StringConstant.cartListForPreferenceKey);
 await Prefs().getToken('copyCartList');
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
        ChangeNotifierProvider(create: (_) => LocaleProvider(),),
        ChangeNotifierProvider(create: (_) => CartProvider(),),
        ChangeNotifierProvider(create: (_) => ProductProvider(),),
        // ChangeNotifierProvider(create: (_) => ProductsVM(),),

      ],
      child: Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
        return MaterialApp(
          locale: provider.locale,
          localizationsDelegates:const [
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
          // home: SignIn_Screen(),
          home: Home(),
        );
      }),
    );
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
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                Home()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(height: 500,
        color: Colors.white,
        child:Image.asset(
          'assets/images/VelocIT_Icon_512.png',
          height: 120,
        ),
    );
  }
}