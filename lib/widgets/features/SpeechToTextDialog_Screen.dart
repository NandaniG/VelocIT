import 'dart:async';

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;
import 'package:velocit/services/providers/Home_Provider.dart';

import '../../pages/Activity/DashBoard_DetailScreens_Activities/Categories_Activity.dart';
import '../../pages/Activity/Product_Activities/Products_List.dart';
import '../../utils/constants.dart';
import '../global/okPopUp.dart';

class SpeechToTextDialog extends StatefulWidget {
  SpeechToTextDialog({super.key});

  @override
  _SpeechToTextDialogState createState() => _SpeechToTextDialogState();
}

class _SpeechToTextDialogState extends State<SpeechToTextDialog> {
  speechToText.SpeechToText? speech;
  String textString = "Speak now...";
  bool isListen = false;
  double confidence = 1.0;

  late Timer _timer;
  int _start = 3;

  final Map<String, HighlightedWord> highlightWords = {
    "flutter": HighlightedWord(
        textStyle:
            TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
    "developer": HighlightedWord(
        textStyle:
            TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
  };

  void startTimer(HomeProvider homeProvider) {
    const oneSec = Duration(seconds:3);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 1) {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>  ProductListByCategoryActivity(productList: homeProvider
                  .jsonData["shopByCategoryList"][1]["subShopByCategoryList"][1]),
            ),
          );

          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return OkDialog(
          //           text: StringConstant.controllerSpeechToText.text);
          //     });
        }
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void listen(HomeProvider homeProvider) async {
    if (!isListen) {
      bool avail = await speech!.initialize();
      if (avail) {
        setState(() {
          isListen = true;
        });
        speech!.listen(onResult: (value) {

          setState(() {
            textString = value.recognizedWords;
            if (value.hasConfidenceRating && value.confidence > 0) {
              confidence = value.confidence;
              StringConstant.controllerSpeechToText.text = textString;
            }
          });
          startTimer(homeProvider);

        });
      }
    } else {
      setState(() {
        isListen = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // startTimer();
    speech = speechToText.SpeechToText();
    isListen = false;
  }

  @override
  void dispose() {
    _timer.cancel();
    speech!.cancel();
    super.dispose();
  }

  dialogContent(BuildContext context, HomeProvider homeProvider) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: 300.0,
          maxWidth: 100.0,
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Container(
            //  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                // Container(
                //   child: Text(
                //     "Confidence: ${(confidence * 100.0).toStringAsFixed(1)}%",
                //     style: TextStyle(
                //         fontSize: 20.0,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.red),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextHighlight(
                    text: textString,
                    words: highlightWords,
                    textStyle: TextStyle(
                        fontSize: 25.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                AvatarGlow(
                  animate: isListen,
                  glowColor: Colors.red,
                  endRadius: 65.0,
                  duration: Duration(milliseconds: 2000),
                  repeatPauseDuration: Duration(milliseconds: 100),
                  repeat: true,
                  child: Container(
                    height: 70,
                    width: 70,
                    child: FloatingActionButton(
                      child: Icon(isListen ? Icons.mic : Icons.mic_none,
                          color: isListen ? Colors.redAccent : Colors.black,
                          size: 50),
                      onPressed: () {
                        listen(homeProvider);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context,homeProvider),
    );
  }
}

// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class LocationMap extends StatefulWidget {
//   const LocationMap({Key? key}) : super(key: key);
//
//   @override
//   State<LocationMap> createState() => _LocationMapState();
// }
//
// class _LocationMapState extends State<LocationMap> {
//   late GoogleMapController mapController; //contrller for Google map
//   final Set<Marker> markers = new Set(); //markers for google map
//   static const LatLng showLocation = const LatLng(27.7089427, 85.3086209); //location to show in map
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getmarkers();
//   }
//
//
//   Set<Marker> getmarkers() { //markers to place on map
//     setState(() {
//       markers.add(Marker( //add first marker
//         markerId: MarkerId(showLocation.toString()),
//         position: showLocation, //position of marker
//         infoWindow: InfoWindow( //popup info
//           title: 'Marker Title First ',
//           snippet: 'My Custom Subtitle',
//         ),
//         icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//       ));
//
//       markers.add(Marker( //add second marker
//         markerId: MarkerId(showLocation.toString()),
//         position: LatLng(27.7099116, 85.3132343), //position of marker
//         infoWindow: InfoWindow( //popup info
//           title: 'Marker Title Second ',
//           snippet: 'My Custom Subtitle',
//         ),
//         icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//       ));
//
//       markers.add(Marker( //add third marker
//         markerId: MarkerId(showLocation.toString()),
//         position: LatLng(27.7137735, 85.315626), //position of marker
//         infoWindow: InfoWindow( //popup info
//           title: 'Marker Title Third ',
//           snippet: 'My Custom Subtitle',
//         ),
//         icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//       ));
//
//       //add more markers here
//     });
//
//     return markers;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Maps Sample App'),
//         backgroundColor: Colors.green[700],
//       ),
//       body: GoogleMap( //Map widget from google_maps_flutter package
//         zoomGesturesEnabled: true, //enable Zoom in, out on map
//         initialCameraPosition: CameraPosition( //innital position in map
//           target: showLocation, //initial position
//           zoom: 15.0, //initial zoom level
//         ),
//         markers: getmarkers(), //markers to show on map
//         mapType: MapType.normal, //map type
//         onMapCreated: (controller) { //method called when map is created
//           setState(() {
//             mapController = controller;
//           });
//         },
//       ),
//     );
//   }
// }
