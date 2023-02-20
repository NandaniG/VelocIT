import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/utils/constants.dart';
import 'package:velocit/utils/routes/routes.dart';
import 'package:velocit/utils/utils.dart';

import '../../notificationservices/local_notification_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String deviceTokenToSendPushNotification = '';

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
    startTime();
    // _getCurrentPosition();
  }

  // Step 1.  Get the device token

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    print("Token Value $deviceTokenToSendPushNotification");
  }

  //splash to home timer

  startTime() async {
    final prefs = await SharedPreferences.getInstance();

    var loginId = await Prefs.instance.getToken(StringConstant.userId);
    StringConstant.BadgeCounterValue =
        (prefs.getString('setBadgeCountPrefs')) ?? '';
    print("Splash LoginId : " + loginId.toString());

    var _duration = const Duration(seconds: 2);
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
          print('ISNOT logged in..' +
              StringConstant.RandomUserLoginId.toString());
          rnd = Random();
          var r = min + rnd.nextInt(max - min);

          print("$r is in the range of $min and $max");
          ID = r;
          print("cartId empty UserID" + ID.toString());
        } else {
          print('Existing USER.....' +
              StringConstant.RandomUserLoginId.toString());
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

  Future<Future<void>> _getCurrentPosition() async {
    LocationPermission permission;

    bool serviceEnabled;
    // LocationPermission permission;

// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // startTime();

      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Utils.errorToast('Location Permission Denied');
        startTime();

        // permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          startTime();
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getLocation(_currentPosition!);
    }).catchError((e) {
      startTime();
      print(e.toString());
    });
  }

  _getLocation(Position position) async {
    final coordinates = Coordinates(position.latitude, position.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("address.streetAddress" + first.postalCode.toString());
    print("${first.featureName} : ${first.addressLine}");
    final prefs = await SharedPreferences.getInstance();

    var splitag = first.addressLine.split(",");
    // var houseBuilding = splitag[0]+', '+splitag[1];
    // var areaColony = splitag[2];
    // var state = splitag[3];
    // var city = splitag[4];
    var pincode = first.postalCode;

    setState(() {
      prefs
          .setString('CurrentPinCodePrefs', first.postalCode.toString())
          .then((value) {
        startTime();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getDeviceTokenToSendNotification();
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