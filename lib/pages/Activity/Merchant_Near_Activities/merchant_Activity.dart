import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/StringUtils.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'FilterScreen_Merchant.dart';

class MerchantActvity extends StatefulWidget {
  final dynamic merchantList;

  const MerchantActvity({Key? key, this.merchantList}) : super(key: key);

  @override
  State<MerchantActvity> createState() => _MerchantActvityState();
}

class _MerchantActvityState extends State<MerchantActvity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  bool isGridView = false;

  late GoogleMapController mapController; //contrller for Google map

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  final Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation =
      const LatLng(27.7089427, 85.3086209); //location to show in map

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmarkers();
  }


  getGPSInfo() async {
    bool servicestatus = await Geolocator.isLocationServiceEnabled();

    if(servicestatus){
      print("GPS service is enabled");
    }else{
      print("GPS service is disabled.");
    }
    //
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }else if(permission == LocationPermission.deniedForever){
        print("'Location permissions are permanently denied");
      }else{
        print("GPS Location service is granted");
        getLocation();
      }
    }else{    getLocation();
      print("GPS Location permission granted.");
    }
  }



  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }

  Set<Marker> getmarkers() {

    getGPSInfo();
    //markers to place on map
    setState(() {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Marker Title First ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: const LatLng(27.7099116, 85.3132343), //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Marker Title Second ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: const LatLng(27.7137735, 85.315626), //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Marker Title Third ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      //add more markers here
    });

    return markers;
  }



  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
    preferredSize: Size.fromHeight(height * .12),
    child: appBarWidget(context, searchBar(context), addressWidget(context,StringConstant.placesFromCurrentLocation),
        setState(() {})),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: SafeArea(
        child: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [    Container(
            color: ThemeApp.whiteColor,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Row(
                    children: [
                      TextFieldUtils().dynamicText(
                          StringUtils.gridView,
                          context,
                          TextStyle(fontFamily: 'Roboto',
                            color: ThemeApp.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: height * .02,
                          )),
                      Transform.scale(
                        scale: 1.1,
                        child: Switch(
                          // This bool value toggles the switch.
                          value: isGridView, activeColor: ThemeApp.appLightColor,
                          inactiveTrackColor: ThemeApp.appLightColor,

                          inactiveThumbColor: ThemeApp.whiteColor,
                          onChanged: (bool value) {
                            // This is called when the user toggles the switch.
                            setState(() {
                              isGridView = value;
                            });
                          },
                        ),
                      ),   TextFieldUtils().dynamicText(
                          StringUtils.mapView,
                          context,
                          TextStyle(fontFamily: 'Roboto',
                            color: ThemeApp.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: height * .02,
                          )),

                    ],
                  ),
                ),
                Container(
                  height: height * .07,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const VerticalDivider(
                          color: ThemeApp.textFieldBorderColor,
                          thickness: 1,
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Merchant_FilterScreen(),
                                ),
                              );

                            },
                            child:  Padding(
                              padding: const EdgeInsets.fromLTRB(10,2,10,2),
                              child: SvgPicture.asset(
                                'assets/appImages/filterIcon.svg',
                                color: ThemeApp.primaryNavyBlackColor,
                                semanticsLabel: 'Acme Logo',
                                theme: SvgTheme(
                                  currentColor: ThemeApp.primaryNavyBlackColor,
                                ),
                                height: height * .03,
                              ),))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
            !isGridView ? budgetBuyList() : mapView(),            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
          ],
        )),
      ),
    );
  }

  Widget budgetBuyList() {
    var orientation =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    return SingleChildScrollView(
      child: Container(        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Text(servicestatus? "GPS is Enabled": "GPS is disabled."),
            // Text(haspermission? "GPS is Enabled": "GPS is disabled."),
            //
            // Text("Longitude: $long", style:TextStyle(fontFamily: 'Roboto',fontSize: 20)),
            // Text("Latitude: $lat", style: TextStyle(fontFamily: 'Roboto',fontSize: 20),),
            TextFieldUtils().dynamicText(
                StringUtils.merchantNearYou,
                context,
                TextStyle(fontFamily: 'Roboto',
                  color: ThemeApp.blackColor,
                  fontWeight: FontWeight.w400,
                  fontSize: height * .025,
                )),

            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),

                  Container(
                          height: MediaQuery.of(context).size.height,
                          // padding: EdgeInsets.all(12.0),
                          child: GridView.builder(
                            itemCount: widget.merchantList["subMerchantList"].length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    // childAspectRatio: 3 / 3.1,
                                    childAspectRatio: orientation
                                        ? width * 3.2 / height * 0.5
                                        : width * 2 / height * 1,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  height:
                                      orientation ? height * 26 : height * .17,
                                  // MediaQuery.of(context).size.height * .26,
                                  width: MediaQuery.of(context).size.width * .45,
                                  decoration: const BoxDecoration(
                                      color: ThemeApp.tealButtonColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            height: orientation
                                                ? height * .25
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .17,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            decoration: const BoxDecoration(
                                                color: ThemeApp.whiteColor,
                                                borderRadius:
                                                    BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                )),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                              child: Image.asset(
                                                // width: double.infinity,
                                                widget.merchantList["subMerchantList"][index]["subMerchantNearYouImage"],
                                                // fit: BoxFit.fill,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .07,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 7, right: 7),
                                            child: kmAwayOnMerchantImage(
                                              widget.merchantList["subMerchantList"][index]["subMerchantNearYoukmAWAY"],
                                              context,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: TextFieldUtils()
                                            .homePageTitlesTextFieldsWHITE(
                                            widget.merchantList["subMerchantList"][index]["subMerchantNearYouName"],
                                                context),
                                      ),
                                    ],
                                  ));
                            },
                          ))

          ],
        ),
      ),
    );
  }

  Widget mapView() {
    return Container(height: height*.9,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GoogleMap(
          zoomGesturesEnabled: true,
          //enable Zoom in, out on map
          initialCameraPosition: const CameraPosition(
            //innital position in map
            target: showLocation, //initial position
            zoom: 15.0, //initial zoom level
          ),
          markers: getmarkers(),
          //markers to show on map
          mapType: MapType.normal,
          //map type
          onMapCreated: (controller) {
            //method called when map is created
            setState(() {
              mapController = controller;
            });
          },
        ),
      ),
    );
  }
}
