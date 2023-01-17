import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
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
import 'package:velocit/pages/screens/launch_Screen.dart';
import 'package:velocit/services/providers/Home_Provider.dart';
import 'package:velocit/services/providers/cart_Provider.dart';
import 'package:velocit/utils/constants.dart';
import 'package:velocit/utils/routes/routes.dart';
import 'package:velocit/utils/routes/routes_name.dart';
import 'package:velocit/utils/styles.dart';
import 'package:velocit/utils/utils.dart';
import 'package:velocit/widgets/global/textFormFields.dart';
import 'Core/ViewModel/OrderBasket_viewmodel.dart';
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
//user login id final
  StringConstant.loginUserName = (prefs.getString('usernameLogin')) ?? '';
  StringConstant.loginUserEmail = (prefs.getString('emailLogin')) ?? '';
  //

  var testId = await prefs.getString(StringConstant.testId);
  print("on loging testId : " + testId.toString());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

/*  ProductSpecificListViewModel productViewModel =
      ProductSpecificListViewModel();
  Map data = {
    "category_code": "EOLP",
    "recommended_for_you": "1",
    "Merchants Near You": "1",
    "best_deal": "",
    'budget_buys': ""
  };*/

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // productViewModel.productSpecificListWithGet(context, data);
    return MultiProvider(
        providers: [
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
            create: (_) => ProductProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => OrderBasketViewModel(),
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
              routes: {
                // '/': (context) => StringConstant.isLogIn != true
                //     ? SignIn_Screen()
                //     : DashboardScreen(),
                '/': (context) => SplashScreen(),
                // '/': (context) => SignIn_Screen(),
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
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<HomeProvider>(context, listen: false).loadJson();
    // });
    // startTime();
    getCurrentLocation();
  }

  startTime() async {
    final prefs = await SharedPreferences.getInstance();

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

  late Random rnd;
  var min = 100000000;
  int max = 1000000000;
  var ID;
  String finalId = '';

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      StringConstant.isUserLoggedIn = (prefs.getInt('isUserLoggedIn')) ?? 0;
      StringConstant.FINALPINCODE =
          (prefs.getString('CurrentPinCodePref')) ?? '';
      print("IS USER LOGGEDIN ..............." +
          StringConstant.isUserLoggedIn.toString());

      StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
      StringConstant.RandomUserLoginId =
          (prefs.getString('RandomUserId')) ?? '';
      print("USER LOGIN ID..............." +
          StringConstant.UserLoginId.toString());

      if (StringConstant.UserLoginId == '') {
        if ((StringConstant.RandomUserLoginId == '' ||
            StringConstant.RandomUserLoginId == null)) {
          print('login user is GUEST');
          rnd = new Random();
          var r = min + rnd.nextInt(max - min);

          print("$r is in the range of $min and $max");
          ID = r;
          print("cartId empty" + ID.toString());
        } else {
          print('login user is GUEST'); // ID = StringConstant.UserLoginId;
          ID = StringConstant.UserLoginId.toString();
        }
      } else {
        print('login user is not GUEST');
        print("RandomUserLoginId empty");
        // ID = StringConstant.UserLoginId;
        ID = StringConstant.UserLoginId.toString();
      }
      // 715223688
      finalId = ID.toString();
      prefs.setString('RandomUserId', finalId.toString());

      print('finalId  RandomUserLoginId' + finalId);

      if (StringConstant.isUserLoggedIn != 0) {
        Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute)
            .then((value) {
          StringConstant.FINALPINCODE;
        });
      } else {
        Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute)
            .then((value) {
          StringConstant.FINALPINCODE;
        });
        // StringConstant.FINALPINCODE =
        //     (prefs.getString('CurrentPinCodePref')) ?? '';
        print("Not Logged in");
        // Navigator.pushReplacementNamed(context, RoutesName.signInRoute);
      }
    });
  }

  var locationMessage = "";
  String addressPincode = "";

  Future getCurrentLocation() async {
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

    var lastPosition = await Geolocator.getLastKnownPosition();
    print("lastPosition" + lastPosition.toString());
    startTime();

    setState(() {
      locationMessage = "${position.latitude}, ${position.longitude}";
      // getAddressFromLatLong(
      //     position.latitude, position.longitude);
    });

    _getAddress(position.latitude, position.longitude);
  }

  Future<String> _getAddress(double? lat, double? lang) async {
    print("address.streetAddress");
    if (lat == null || lang == null) return "";
    GeoCode geoCode = GeoCode();
    Address address =
        await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    addressPincode = address.postal.toString();
    print("address.streetAddress" + address.streetAddress.toString());
    print("address.streetAddress" + address.region.toString());
    print("address.streetAddress" + address.toString());
    print("address.streetAddress" + address.toString());

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('CurrentPinCodePref', addressPincode.toString());

    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              // end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xff95EAF1),
                Color(0xff75E4ED),
                Color(0xff02D3E3),
                Color(0xff00A7BF),
                Color(0xff007896),
                // Color(0xff3AA17E),
                // Color(0xff3AA17E),
              ],
              // Gradient from https://learnui.design/tools/gradient-generator.html
              tileMode: TileMode.mirror,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/appImages/splashScreen.png',
                  alignment: Alignment.center,
                  height: 173,
                  width: 253,
                  // height: 300,
                ),
              ),
            ],
          ),
        ),
      ),
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
      print('res' + res.toString());
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
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: status != 'No records found'
                  ? ListView.builder(
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
                    )
                  : Text(""),
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

  Location(this.name, this.district, this.taluka, this.region, this.state);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(json['Name'], json['District'], json['Taluk'],
        json['Region'], json['State']);
  }
}
