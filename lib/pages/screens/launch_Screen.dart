//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:geocode/geocode.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:velocit/pages/screens/dashBoard.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     startTime();    getCurrentLocation();
//
//     super.initState();
//   }
//
//   startTime() async {
//     var _duration = new Duration(seconds: 2);
//     return new Timer(_duration, navigationPage);
//   }
//
//   void navigationPage() {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => DashboardScreen()));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 begin: FractionalOffset.topCenter,
//                 end: FractionalOffset.bottomCenter,
//               // end: Alignment(0.8, 1),
//               colors: <Color>[
//                 Color(0xff95EAF1),
//                 Color(0xff75E4ED),
//                 Color(0xff02D3E3),
//                 Color(0xff00A7BF),
//                 Color(0xff007896),
//                 // Color(0xff3AA17E),
//                 // Color(0xff3AA17E),
//               ], // Gradient from https://learnui.design/tools/gradient-generator.html
//               tileMode: TileMode.mirror,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Center(
//                 child: Image.asset(
//                   'assets/appImages/splash_image.png',
//                   alignment: Alignment.center,
//                   height: 162,
//                   width: 268,
//                   // height: 300,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   var locationMessage = "";
//   String addressPincode = "";
//
//
//   Future getCurrentLocation() async{
//
//     LocationPermission? permission;
//
//     permission = await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permission are denied');
//       }
//     }
//
//     var position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     var lastPosition =  await Geolocator.getLastKnownPosition();
//     print("lastPosition"+lastPosition.toString());
//     startTime();
//
//     setState(() {
//       locationMessage = "${position.latitude}, ${position.longitude}";
//       // getAddressFromLatLong(
//       //     position.latitude, position.longitude);
//     });
//
//     _getAddress(
//         position.latitude, position.longitude);
//
//   }
//   Future<String> _getAddress(double? lat, double? lang) async {
//     print("address.streetAddress");
//     if (lat == null || lang == null) return "";
//     GeoCode geoCode = GeoCode();
//     Address address =
//     await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
//     addressPincode = address.postal.toString();
//     print("address.addressPincode"+addressPincode.toString());
//     print("address.streetAddress"+address.region.toString());
//     print("address.streetAddress"+address.toString());
//
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('CurrentPinCodePref', addressPincode.toString());
//
//     return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
//   }
//
// }
