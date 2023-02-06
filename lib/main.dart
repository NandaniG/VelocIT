import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart';

// import 'package:geocode/geocode.dart';
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
import 'Core/ViewModel/cart_view_model.dart';
import 'Core/ViewModel/dashboard_view_model.dart';
import 'Core/ViewModel/product_listing_view_model.dart';
import 'L10n/l10n.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/localeProvider.dart';
import 'notificationservices/local_notification_service.dart';
import 'pages/Activity/My_Account_Activities/SaveCardAndWallets/CardList_manage_Payment_Activity.dart';
import 'services/providers/Products_provider.dart';


Future<void> backgroundHandler(RemoteMessage message) async {
  print('FirebaseMessaging : '+message.data.toString());
  print('FirebaseMessaging : ' +message.notification!.title.toString());
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
       /*       routes: {
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
              },*/
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

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);

        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );



    _getCurrentPosition();
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

      StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
      StringConstant.RandomUserLoginId =
          (prefs.getString('RandomUserId')) ?? '';
      print("USER LOGIN ID..............." +
          StringConstant.UserLoginId.toString());


      print("USER RandomUserLoginId ID..............." +
          StringConstant.RandomUserLoginId.toString());

      if (StringConstant.isUserLoggedIn == 0) {
        if ((StringConstant.RandomUserLoginId == '')) {
          print('login user is GUEST ');
          print('ISNOT logged in..'+ StringConstant.RandomUserLoginId.toString());
          rnd = new Random();
          var r = min + rnd.nextInt(max - min);

          print("$r is in the range of $min and $max");
          ID = r;
          print("cartId empty UserID" + ID.toString());
        } else {
          print('Existing USER.....'+ StringConstant.RandomUserLoginId.toString());
          ID = StringConstant.RandomUserLoginId.toString();
        }
      } else {
        print('login user is not GUEST');
        print("RandomUserLoginId empty");
        // ID = StringConstant.UserLoginId;
        ID = StringConstant.UserLoginId.toString();
      }
      // 715223688
      finalId = ID.toString();
      prefs.setString('RandomUserId', finalId);

      print('finalId  RandomUserLoginId' + finalId);

      if (StringConstant.isUserLoggedIn != 0) {
        Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute)
            .then((value) {
          setState(() {});
        });
      } else {
        Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute)
            .then((value) {
          setState(() {});
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
/*  Future getCurrentLocation() async {
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
    prefs.setString('CurrentPinCodePrefs', addressPincode.toString());

    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
  }*/
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }
/*    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }*/
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      _getCurrentPosition();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {  _getCurrentPosition();
        return Future.error('Location permission are denied');
      }
    }

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high) .then((Position position) {
      setState(() => _currentPosition = position);
      _getLocation(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });



  }

  _getLocation(Position position) async {
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("address.streetAddress" + first.postalCode.toString());
    print("${first.featureName} : ${first.addressLine}");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('CurrentPinCodePrefs', first.postalCode.toString());

    var splitag = first.addressLine.split(",");
    // var houseBuilding = splitag[0]+', '+splitag[1];
    // var areaColony = splitag[2];
    // var state = splitag[3];
    // var city = splitag[4];
    var pincode = first.postalCode;

    setState(() {
      startTime();

    prefs.setString('CurrentPinCodePrefs', first.postalCode.toString());
    });
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

/*class MyHomePage extends StatefulWidget {
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
}*/
