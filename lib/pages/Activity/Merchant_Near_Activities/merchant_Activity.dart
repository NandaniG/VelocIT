import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:velocit/pages/Activity/Merchant_Near_Activities/Merchant_List_Screen.dart';
import 'package:velocit/services/providers/Home_Provider.dart';

import '../../../Core/Model/MerchantModel/MerchantListModel.dart';
import '../../../Core/ViewModel/Merchant_viewModel.dart';
import '../../../Core/data/responses/status.dart';
import '../../../utils/ProgressIndicatorLoader.dart';
import '../../../utils/StringUtils.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../widgets/global/ConfirmationDialog.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'FilterScreen_Merchant.dart';

class MerchantActvity extends StatefulWidget {
  dynamic merchantList;

  MerchantActvity({Key? key, this.merchantList}) : super(key: key);

  @override
  State<MerchantActvity> createState() => _MerchantActvityState();
}

class _MerchantActvityState extends State<MerchantActvity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  bool isGridView = false;

  late GoogleMapController mapController; //contrller for Google map
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  Set<Marker> markersList = new Set();

  var data;

  final Set<Marker> markers = new Set(); //markers for google map
  LatLng showLocation = const LatLng(
      26.26774119270947, 73.03210171571942); //location to show in map
  MerchantViewModel merchantViewModel = MerchantViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = Provider.of<HomeProvider>(context, listen: false).loadJson();
    // getmarkers();
    // _request_permission(context);
    askPermissions(Permission.location);
  }



/*
  getGPSInfo() async {
    bool servicestatus = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    setState(() {});
    if (servicestatus) {
      print("GPS service is enabled");
    } else {
      await Permission.locationAlways.request();
      print("GPS service is disabled.");
    }
    permission = await Geolocator.checkPermission();
    print("permission :  " + permission.toString());

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Permission.locationAlways.request();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Permission.locationAlways.request();
        print('Location permissions are denied');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          AppSettings.openLocationSettings();

          getGPSInfo();
          Utils.errorToast(
              'You need to enable location for merchants near you');

          print("'Location permissions are permanently denied");
        } else {
          print("GPS Location service is granted");
          getLocation();
        }
      } else {
        print("GPS Location service is granted");
        getLocation();
      }
    } else {
      getLocation();
      print("GPS Location permission granted.");
    }

    //
  }
*/

  Future<void> askPermissions(Permission requestedPermission,
     ) async {
    // Check permission status
    PermissionStatus status = await requestedPermission.status;
    // Request permission
    if (status != PermissionStatus.granted &&
        status != PermissionStatus.permanentlyDenied) {
      status = await requestedPermission.request();
      print("PermissionStatus.denied.....");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              heading: "Alert message",
              subTitle: 'To use this feature, go to app setting and allow permission for Microphone.',
              button1: 'Cancel',
              button2: 'Go to Setting',
              onTap1: () async {
                Navigator.pop(context);
              },
              onTap2: () async {
                AppSettings.openLocationSettings();

              },
            );
          });
    } else if (status == PermissionStatus.denied) {


      print("PermissionStatus.denied");

      // openAppSettings();
      askPermissions(requestedPermission);
    } else if (status == PermissionStatus.permanentlyDenied) {
      print("PermissionStatus.denied.....");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              heading: "Alert message",
              subTitle: 'To use this feature, go to app setting and allow permission for Microphone.',
              button1: 'Cancel',
              button2: 'Go to Setting',
              onTap1: () async {
                Navigator.pop(context);
              },
              onTap2: () async {
                AppSettings.openLocationSettings();

              },
            );
          });
      print("PermissionStatus.restricted");
      // openAppSettings();
      // askPermissions(requestedPermission);
    } else {
      getLocation();
    }
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("long" + position.longitude.toString()); //Output: 80.24599079
    print("current lat" + position.latitude.toString()); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();
    Map data = {};
    if (double.parse(long) < 0) {
      data = {
        "base_latitude": 26.26774119270947,
        "base_longitude": 73.03210171571942,
        "distance_in_hundred_mtrs": 100
      };
    } else {
      setState(() {
        // showLocation = LatLng(26.26774119270947, 73.03210171571942);
        // showLocation = LatLng(position.latitude, position.longitude);
      });
      /* data = {
        "base_latitude": lat,
        "base_longitude": long,
        "distance_in_hundred_mtrs": 100
      };*/
      data = {
        "base_latitude": 26.26774119270947,
        "base_longitude": 73.03210171571942,
        "distance_in_hundred_mtrs": 100
      };
    }
    var responce = await merchantViewModel.getPostMerchantNearMe(context, data);
    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }

/*  Set<Marker> getmarkers() {
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
  }*/

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * .135),
        child: AppBarWidget(
          context: context,
          titleWidget: searchBarWidget(),
          location: const AddressWidgets(),
        ),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context, 3),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView(
              children: [
                Container(
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
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: height * .02,
                                )),
                            Transform.scale(
                              scale: 1.1,
                              child: Switch(
                                // This bool value toggles the switch.
                                value: isGridView,
                                activeColor: ThemeApp.appLightColor,
                                inactiveTrackColor: ThemeApp.appLightColor,

                                inactiveThumbColor: ThemeApp.whiteColor,
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.
                                  setState(() {
                                    isGridView = value;
                                  });
                                },
                              ),
                            ),
                            TextFieldUtils().dynamicText(
                                StringUtils.mapView,
                                context,
                                TextStyle(
                                  fontFamily: 'Roboto',
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
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Merchant_FilterScreen(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 2, 10, 2),
                                    child: SvgPicture.asset(
                                      'assets/appImages/filterIcon.svg',
                                      color: ThemeApp.primaryNavyBlackColor,
                                      semanticsLabel: 'Acme Logo',
                                      theme: SvgTheme(
                                        currentColor:
                                            ThemeApp.primaryNavyBlackColor,
                                      ),
                                      height: height * .03,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                !isGridView ? merchantList() : mapView(),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
      ),
    );
  }

  Widget merchantList() {
    var orientation =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: ChangeNotifierProvider<MerchantViewModel>.value(
            value: merchantViewModel,
            child: Consumer<MerchantViewModel>(
                builder: (context, merchantList, child) {
              switch (merchantList.merchantResponse.status) {
                case Status.LOADING:
                  if (kDebugMode) {
                    print("Api load");
                  }
                  return ProgressIndicatorLoader(true);

                case Status.ERROR:
                  if (kDebugMode) {
                    print("Api error : " +
                        merchantList.merchantResponse.message.toString());
                  }
                  return Text(merchantList.merchantResponse.message.toString());

                case Status.COMPLETED:
                  if (kDebugMode) {
                    print("Api calll");
                  }

                  print("merchantList...." +
                      merchantList.merchantResponse.data.toString());
                  if (merchantList.merchantResponse.data?.status == "OK") {
                    if ((merchantList.merchantResponse.data?.payload ?? [])
                            .length >
                        0) {
                      List<MerchantPayload> payload =
                          merchantList.merchantResponse.data!.payload!;
                      // Set<Marker> markers = [] as Set<Marker>;
                      // setState(() {
                      for (var i = 0; i < payload.length; i++) {
                        String name = '${payload[i].name ?? ""}';
                        markersList.add(Marker(
                          markerId: MarkerId(payload[i].id.toString()),
                          position: LatLng(payload[i].latitude ?? 0,
                              payload[i].longitude ?? 0),
                          //position of marker
                          infoWindow: InfoWindow(
                            //popup info
                            onTap: (() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MerchantListByIdActivity(
                                        merchant: merchantList
                                            .merchantResponse.data?.payload![i],
                                      )));
                            }),
                            title: name,
                            // snippet: ,
                          ),
                          icon:
                              BitmapDescriptor.defaultMarker, //Icon for Marker
                        ));
                      }
                      // });
                    }
                  }
                  List<MerchantPayload> merchantLists =
                      merchantList.merchantResponse.data!.payload!;

                  return markersList.isEmpty
                      ? Container(
                          height: height,
                          alignment: Alignment.center,
                          child: Text("No merchant available near you"))
                      : Container(
                          height: MediaQuery.of(context).size.height,
                          // padding: EdgeInsets.all(12.0),
                          child: GridView.builder(
                            itemCount: merchantList
                                .merchantResponse.data?.payload!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            // gridDelegate:
                            //     SliverGridDelegateWithFixedCrossAxisCount(
                            //         // childAspectRatio: 3 / 3.1,
                            //         childAspectRatio: orientation
                            //             ? width * 3.2 / height * 0.5
                            //             : width * 2 / height * 1,
                            //         crossAxisCount: 2,
                            //         crossAxisSpacing: 10,
                            //         mainAxisSpacing: 10),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 30,
                              // childAspectRatio: 1.0,
                              childAspectRatio:
                                  MediaQuery.of(context).size.height / 900,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              print(merchantList.merchantResponse.data!
                                  .payload![index].merchantStoreImage
                                  .toString());
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MerchantListByIdActivity(
                                            merchant: merchantList
                                                .merchantResponse
                                                .data
                                                ?.payload![index],
                                          )));
                                },
                                child: Container(
                                    // height: orientation
                                    //     ? height * 36
                                    //     : height * .30,
                                    // // MediaQuery.of(context).size.height * .26,
                                    // width:
                                    //     MediaQuery.of(context).size.width * .45,
                                    // decoration: const BoxDecoration(
                                    //   color: ThemeApp.tealButtonColor,
                                    //
                                    //   /*borderRadius: BorderRadius.all(
                                    //         Radius.circular(10))*/
                                    // ),
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*Expanded(
                                          flex: 2,
                                          child:*/
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          height: 143,
                                          width: 191,
                                          decoration: BoxDecoration(
                                              color: ThemeApp.whiteColor,
                                              border: Border.all(
                                                  color: ThemeApp
                                                      .tealButtonColor)),
                                          child: ClipRRect(
                                            child: merchantList
                                                    .merchantResponse
                                                    .data!
                                                    .payload![index]
                                                    .merchantStoreImage
                                                    .toString()
                                                    .isNotEmpty
                                                ? Image.network(
                                                    merchantList
                                                        .merchantResponse
                                                        .data!
                                                        .payload![index]
                                                        .merchantStoreImage
                                                        .toString(),
                                                    // fit: BoxFit.fill,
                                                    height: (MediaQuery.of(
                                                                    context)
                                                                .orientation ==
                                                            Orientation
                                                                .landscape)
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .26
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .1,
                                                  )
                                                : SizedBox(
                                                    // height: height * .28,
                                                    width: width,
                                                    child: Icon(
                                                      Icons.image_outlined,
                                                      size: 50,
                                                    )),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 7, right: 7),
                                          child: kmAwayOnMerchantImage(
                                            double.parse(merchantList
                                                            .merchantResponse
                                                            .data!
                                                            .payload![index]
                                                            .distanceInKm
                                                            .toString())
                                                        .toString() +
                                                    ' KM Away' ??
                                                "",
                                            context,
                                          ),
                                        )
                                      ],
                                      // ),
                                    ),
                                    Container(
                                      color: ThemeApp.tealButtonColor,
                                      width: 191,
                                      height: 66,
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextFieldUtils()
                                              .listNameHeadingTextField(
                                                  merchantList
                                                          .merchantResponse
                                                          .data!
                                                          .payload![index]
                                                          .name
                                                          .toString() ??
                                                      "",
                                                  context),
                                        ],
                                      ),
                                    ),
                                    // Padding(
                                    //     padding: const EdgeInsets.fromLTRB(
                                    //         18, 11, 18, 11),
                                    //     child: Text(
                                    //       merchantList.merchantResponse.data
                                    //               ?.payload![index].name
                                    //               .toString() ??
                                    //           "",
                                    //       style: TextStyle(
                                    //         fontFamily: 'Roboto',
                                    //         fontSize: 12,
                                    //         color: ThemeApp.whiteColor,
                                    //         fontWeight: FontWeight.w700,
                                    //         overflow: TextOverflow.ellipsis,
                                    //       ),
                                    //     )),
                                  ],
                                )),
                              );
                            },
                          ));
                default:
                  return Text("No Data found!");
              }
              return Text("No Data found!");
            })),
      ),
    );
  }

  Widget mapView() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: markersList.isEmpty
              ? Container(
                  height: height,
                  alignment: Alignment.center,
                  child: Center(
                      child: Text(
                    "No merchant available near you",
                    style: TextStyle(fontSize: 20),
                  )))
              : GestureDetector(
                  onVerticalDragStart: (start) {},
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    myLocationEnabled: true,
                    gestureRecognizers: Set()
                      ..add(Factory<OneSequenceGestureRecognizer>(
                          () => new EagerGestureRecognizer()))
                      ..add(Factory<PanGestureRecognizer>(
                          () => PanGestureRecognizer()))
                      ..add(Factory<ScaleGestureRecognizer>(
                          () => ScaleGestureRecognizer()))
                      ..add(Factory<TapGestureRecognizer>(
                          () => TapGestureRecognizer()))
                      ..add(Factory<VerticalDragGestureRecognizer>(
                          () => VerticalDragGestureRecognizer())),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    markers: markersList,
                    initialCameraPosition: CameraPosition(
                      target: showLocation,
                      zoom: 12.0,
                    ),
                    // GoogleMap(
                    //   zoomGesturesEnabled: true,
                    //   //enable Zoom in, out on map
                    //   initialCameraPosition: const CameraPosition(
                    //     //innital position in map
                    //     target: showLocation, //initial position
                    //     zoom: 15.0, //initial zoom level
                    //   ),
                    //   markers: getmarkers(),
                    //   //markers to show on map
                    //   mapType: MapType.normal,
                    //   //map type
                    //   onMapCreated: (controller) {
                    //     //method called when map is created
                    //     setState(() {
                    //       mapController = controller;
                    //     });
                    //   },
                    // ),
                  ),
                ),
        ));
  }
}
