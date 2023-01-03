import 'dart:async';
import 'dart:convert';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:velocit/pages/auth/sign_in.dart';
import 'package:velocit/pages/screens/cartDetail_Activity.dart';
import 'package:velocit/pages/screens/dashBoard.dart';
import 'package:velocit/services/providers/Home_Provider.dart';
import 'package:velocit/services/providers/cart_Provider.dart';
import 'package:velocit/utils/constants.dart';
import 'package:velocit/utils/routes/routes.dart';
import 'package:velocit/utils/routes/routes_name.dart';
import 'package:velocit/utils/styles.dart';
import 'package:velocit/utils/utils.dart';
import 'package:velocit/widgets/global/textFormFields.dart';
import 'Core/ViewModel/OrderBasket_viewmodel.dart';
import 'Core/ViewModel/auth_view_model.dart';
import 'Core/ViewModel/dashboard_view_model.dart';
import 'Core/ViewModel/product_listing_view_model.dart';
import 'L10n/l10n.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/localeProvider.dart';
import 'pages/Activity/My_Account_Activities/SaveCardAndWallets/CardList_manage_Payment_Activity.dart';
import 'services/providers/Products_provider.dart';

late SharedPreferences sp;

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
// getpref();
}

getpref() async {
  Prefs.instance;
  StringConstant.isLogIn = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // var loginId=await  prefs.getString(StringConstant.userId);
  var testId = await prefs.getString(StringConstant.testId);
  print("on loging testId : " + testId.toString());

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
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ProductSpecificListViewModel productViewModel =
      ProductSpecificListViewModel();
  Map data = {
    "category_code": "EOLP",
    "recommended_for_you": "1",
    "Merchants Near You": "1",
    "best_deal": "",
    'budget_buys': ""
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // productViewModel.productSpecificListWithGet(context, data);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => DashboardViewModel(),
          ),
          ChangeNotifierProvider(
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
          ),ChangeNotifierProvider(
            create: (_) => OrderBasketViewModel(),
          ),

          // ChangeNotifierProvider(create: (_) => ProductsVM(),),
        ],
        child: Consumer<HomeProvider>(builder: (context, provider, child) {
          var data = provider.loadJson();
          var dataa = provider.loadJsonss();

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
              ),color: ThemeApp.appColor,
              debugShowCheckedModeBanner: false,
              // home: ForgotPassword(),
              // initialRoute: StringConstant.isLogIn != true?RoutesName.signInRoute:RoutesName.dashboardRoute,
              initialRoute: RoutesName.splashScreenRoute,
              onGenerateRoute: Routes.generateRoute,
              routes: {

                // '/': (context) => StringConstant.isLogIn != true
                //     ? SignIn_Screen()
                //     : DashboardScreen(),
                '/': (context) => SplashScreen(),
                // '/': (context) => MyHomePage(title: ""),
                '/dashBoardScreen': (context) => const DashboardScreen(),
                '/editAccountActivity': (context) =>
                    const EditAccountActivity(),
                '/myAccountActivity': (context) => const MyAccountActivity(),
                '/accountSettingScreen': (context) =>
                    const AccountSettingScreen(),
                '/myOrdersActivity': (context) => const MyOrdersActivity(),
                '/cardListManagePayments': (context) =>
                    const CardListManagePayments(),
                // '/savedAddressDetails': (context) =>
                //     const SavedAddressDetails(),
                '/customerSupportActivity': (context) =>
                    const CustomerSupportActivity(),
                '/productListByCategoryActivity': (context) =>
                    ProductListByCategoryActivity(
                        productList: provider
                            .productList[provider.indexofSubProductList]),
                // '/productDetailsActivity': (context) => ProductDetailsActivity(model: productsList[0], value: value),
                '/cartScreen': (context) => CartDetailsActivity(),
                // '/orderReviewSubActivity': (context) => OrderReviewSubActivity(
                //     cartPayLoad: value, cartListFromHome: provider.productList),

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
    // startTime();
    getCurrentLocation();
  }

  startTime() async {    final prefs = await SharedPreferences.getInstance();

  var loginId = await Prefs.instance.getToken(StringConstant.userId);
    StringConstant.BadgeCounterValue =
        (prefs.getString('setBadgeCountPrefs')) ?? '';
    print("Splash LoginId : " + loginId.toString());

    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    _loadCounter();
    // Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute);
  }

  Future<void> _loadCounter() async {

    final prefs = await SharedPreferences.getInstance();
    setState(() {

      StringConstant.isUserLoggedIn = (prefs.getInt('isUserLoggedIn')) ?? 0;
      print("IS USER LOGGEDIN ..............." +
          StringConstant.isUserLoggedIn.toString());

      StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';

      print("USER LOGIN ID..............." +
          StringConstant.UserLoginId.toString());

      if (StringConstant.isUserLoggedIn != 0) {
        Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute);
      } else {
        Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute);

      print("Not Logged in");
        // Navigator.pushReplacementNamed(context, RoutesName.signInRoute);
      }
    });
  }

  var locationMessage = "";
  String addressPincode = "";


  Future getCurrentLocation() async{

    LocationPermission? permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lastPosition =  await Geolocator.getLastKnownPosition();
    print("lastPosition"+lastPosition.toString());
    startTime();

    setState(() {
      locationMessage = "${position.latitude}, ${position.longitude}";
      // getAddressFromLatLong(
      //     position.latitude, position.longitude);
    });

    _getAddress(
        position.latitude, position.longitude);

  }
  Future<String> _getAddress(double? lat, double? lang) async {
    print("address.streetAddress");
    if (lat == null || lang == null) return "";
    GeoCode geoCode = GeoCode();
    Address address =
    await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    addressPincode = address.postal.toString();
    print("address.streetAddress"+address.streetAddress.toString());
    print("address.streetAddress"+address.region.toString());
    print("address.streetAddress"+address.toString());

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('CurrentPinCodePref', addressPincode.toString());

    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          color: ThemeApp.appBackgroundColor,
          child: TextFieldUtils().circularBar(context)),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Location> locations = [];
  String status = '';

  _getLocations(pincode) {
    setState(() {
      status = 'Please wait...';
    });
    final JsonDecoder _decoder = const JsonDecoder();
    http
        .get(Uri.parse("http://www.postalpincode.in/api/pincode/$pincode"))
        .then((http.Response response) {
      final String res = response.body;
      print('res'+res.toString());
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }

      setState(() {
        var json = _decoder.convert(res);
        var tmp = json['PostOffice'] as List;
        var tmpasa = json['Message'] as List;
        status = json['Message'];
        locations =
            tmp.map<Location>((json) => Location.fromJson(json)).toList();
        status = 'All Locations at Pincode ' + pincode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              key: GlobalKey<FormState>(),
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                labelText: "Pincode",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              onFieldSubmitted: (val) => _getLocations(val),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(status,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: status!='No records found' ?ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: locations.length,
                itemBuilder: (BuildContext context, int index) {
                  final Location location = locations.elementAt(index);

                  return Card(
                    child: ListTile(
                      title: Text(location.name),
                      subtitle: Text('District: ' +
                          location.district +
                          '\nTaluk: ' +
                          location.taluka +
                          '\nState: ' +
                          location.state),
                    ),
                  );
                },
              ):Text(""),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class Location {
  String name;
  String district;
  String taluka;
  String region;
  String state;

  Location(this.name, this.district,this.taluka, this.region, this.state);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        json['Name'], json['District'],json['Taluk'], json['Region'], json['State']);
  }
}