import 'package:flutter/material.dart';

class TestAddtocart extends StatefulWidget {
  const TestAddtocart({Key? key}) : super(key: key);

  @override
  State<TestAddtocart> createState() => _TestAddtocartState();
}

class _TestAddtocartState extends State<TestAddtocart> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:pocket_mart/utils/constants.dart';
//
// class GetLocationPage extends StatefulWidget {
//   @override
//   _GetLocationPageState createState() => _GetLocationPageState();
// }
//
// class _GetLocationPageState extends State<GetLocationPage> {
//   late var placesFromCurrentLocation;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // _getLocation();
//     getAddressFromLatLng();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
// child: Text(StringConstant.placesFromCurrentLocation),
//       ),
//     );
//   }
// /*
//   late LatLng currentPostion;
//
//   void _getUserLocation() async {
//     var position = await GeolocatorPlatform.instance
//         .getCurrentPosition(locationSettings:LocationSettings(accuracy:LocationAccuracy.high ) );
//
//     setState(() {
//       currentPostion = LatLng(position.latitude, position.longitude);
//     });
//   }
//
//   Future _getLocation() async {
//
//     List<Placemark> placemarks = await placemarkFromCoordinates(currentPostion.latitude, currentPostion.longitude);
//
//     String palcename = placemarks.first.administrativeArea.toString() + ", " +  placemarks.first.postalCode.toString();
//
//     print("Postal code: ${palcename} : ");
//   }
// */
//   //////////
//
//   // static Future<Position> getCurrentPosition() async {
//   //   final Position position;
//   //   Position newPosition = await _determinePosition();
//   //   // Position newPosition = await Geolocator.getCurrentPosition(
//   //   //     desiredAccuracy: LocationAccuracy.high,forceAndroidLocationManager: true);
//   //   position = newPosition;
//   //
//   //   return position;
//   // }
//
//   static Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       await Geolocator.openLocationSettings();
//       // return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     // StreamSubscription<Position> streamSubscription = Geolocator.getPositionStream()
//     //                 .listen((Position position) {
//     //      position.latitude;
//     //      position.longitude;
//     // });
//   }
//
//    Future<String> getAddressFromLatLng() async {
//     String _currentPlace='';
//     try {
//       final newPosition = await _determinePosition();
//
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           newPosition.latitude, newPosition.longitude);
//
//       Placemark place = placemarks[0];
//       placesFromCurrentLocation = place.postalCode;
//       //J5GF+W62, Dholewadi, Maharashtra, 422608, India
//       _currentPlace = "${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";//here you can used place.country and other things also
//
//       print("_currentPlace--$place");
//       print("placesFromCurrentLocation--$placesFromCurrentLocation");
//     } catch (e) {
//       print(e);
//     }
//     return _currentPlace;
//   }
// }
//
//
// class LocationApi {
//   // late final Position?;
//
//   static Future<Position> getCurrentPosition() async {
//     final Position position;
//     Position newPosition = await _determinePosition();
//     // Position newPosition = await Geolocator.getCurrentPosition(
//     //     desiredAccuracy: LocationAccuracy.high,forceAndroidLocationManager: true);
//     position = newPosition;
//
//     return position;
//   }
//
//   static Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       await Geolocator.openLocationSettings();
//       // return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     // StreamSubscription<Position> streamSubscription = Geolocator.getPositionStream()
//     //                 .listen((Position position) {
//     //      position.latitude;
//     //      position.longitude;
//     // });
//   }
//
//   static Future<String> getAddressFromLatLng() async {
//     String _currentPlace='';
//     try {
//       final newPosition = await _determinePosition();
//
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           newPosition.latitude, newPosition.longitude);
//
//       Placemark place = placemarks[0];
//       //J5GF+W62, Dholewadi, Maharashtra, 422608, India
//       _currentPlace = "${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";//here you can used place.country and other things also
//       print("_currentPlace--$place");
//     } catch (e) {
//       print(e);
//     }
//     return _currentPlace;
//   }
// }