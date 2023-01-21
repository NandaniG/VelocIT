// import 'dart:io';
//
// import 'package:barcode_finder/barcode_finder.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:provider/provider.dart';
// import 'package:velocit/pages/Activity/Product_Activities/Products_List.dart';
// import 'package:velocit/pages/screens/cartDetail_Activity.dart';
// import 'package:velocit/pages/screens/dashBoard.dart';
// import 'package:velocit/pages/screens/offers_Activity.dart';
// import 'package:velocit/pages/tabs/tabs.dart';
// import 'package:velocit/pages/screens/dashBoard.dart';
// import 'package:velocit/services/providers/Home_Provider.dart';
//
// import '../services/models/ProductDetailModel.dart';
// import '../services/providers/Products_provider.dart';
// import '../utils/constants.dart';
// import '../utils/styles.dart';
// import '../utils/utils.dart';
// import '../widgets/features/scannerWithGallery.dart';
// import '../widgets/global/okPopUp.dart';
// import '../widgets/global/proceedButtons.dart';
// import '../widgets/global/textFormFields.dart';
//
// class Home extends StatefulWidget {
//
//   const Home({super.key});
//
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   int currentIndex = 0;
//   var userName = '';
//   var getResult = 'QR Code Result';
//   Future<void> fetch() async {
//     await Provider.of<HomeProvider>(context, listen: false);
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//
//     fetch();
//     print("Fetch____________");
//   }
//
//   final List _tabIcons = List.unmodifiable([
//     {'icon': 'assets/icons/home.png'},
//     {'icon': 'assets/icons/percentage.png'},
//     {'icon': 'assets/icons/percentage.png'},
//     {'icon': 'assets/icons/shop.png'},
//     {'icon': 'assets/icons/shopping-cart.png'},
//   ]);
//
//
//   final List<Widget> _tabs = List.unmodifiable([
//     // SearchList(),
//     DashboardScreen(),
//     OfferActivity(id: 0,),
//     Container(),
//     Container(),
//     Container(),
//   ]);
//
//
//   Widget cartDetails(){
//     return Container();
//   }
//   void onTabChanged(int index) {
//     setState(() => currentIndex = index);
//   }
//
//   final controller = BarcodeFinderController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ThemeApp.appBackgroundColor,
//       body: _tabs[currentIndex] ,
//       /*     bottomNavigationBar: Tabs(
//         tabIcons: _tabIcons,
//         activeIndex: currentIndex,
//         onTabChanged: onTabChanged,
//       ), */
//       bottomNavigationBar: Stack(
//         alignment: FractionalOffset(.5, 1.0),
//         children: [
//           // Tabs(
//           //   tabIcons: _tabIcons,
//           //   activeIndex: currentIndex,
//           //   onTabChanged: onTabChanged,
//           // ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: Container(
//               height: 70,
//               width: 70,
//               child: FloatingActionButton(
//                 backgroundColor: ThemeApp.darkGreyTab,
//                 onPressed: () {
//                   scanQRCode();
//                   // scanFile();
//                   // Navigator.of(context).push(
//                   //   MaterialPageRoute(
//                   //     builder: (context) => StepperScreen(),
//                   //   ),
//                   // );
//                 /*  showModalBottomSheet(
//                       isDismissible: true,
//                       context: context,
//                       builder: (context) {
//                         return ScannerWidget(state: controller.state);
//                       });*/
//                 },
//                 child: Icon(Icons.document_scanner_outlined,
//                     color: ThemeApp.whiteColor),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
//
//   Widget _scannerWidget(BarcodeFinderState state) {
//     return Container(
//       height: MediaQuery.of(context).size.height * .3,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // if (state is BarcodeFinderLoading)
//           //   _loading()
//           // else if (state is BarcodeFinderError)
//           //   _text(
//           //     '${state.message}',
//           //   )
//           // else if (state is BarcodeFinderSuccess)
//           //   _text(
//           //     '${state.code}',
//           //   ),
//           proceedButton("Scan with Camera", ThemeApp.tealButtonColor, context,false,
//               () {
//             scanQRCode();
//           }),
//           proceedButton("Scan with Gallery", ThemeApp.tealButtonColor, context,false,
//               () {
//             _startScanFileButton(state);
//           }),
//           // _startScanFileButton(state),
//         ],
//       ),
//     );
//   }
//
//   Widget _startScanFileButton(BarcodeFinderState state) {
//     return ElevatedButton(
//       onPressed: state is! BarcodeFinderLoading
//           ? () async {
//               FilePickerResult? pickedFile =
//                   await FilePicker.platform.pickFiles();
//               if (pickedFile != null) {
//                 String? filePath = pickedFile.files.single.path;
//                 if (filePath != null) {
//                   final file = File(filePath);
//                   controller.scanFile(file);
//                 }
//               }
//             }
//           : null,
//       child: Text('Scan PDF or image file'),
//     );
//   }
//
//   Widget _loading() => Center(child: CircularProgressIndicator());
//
//   Text _text(String text) {
//     return Text(
//       text,
//       textAlign: TextAlign.center,
//     );
//   }
//
//   void scanQRCode() async {
//     try {
//       final qrCode = await FlutterBarcodeScanner.scanBarcode(
//           '#ff8866', 'Cancel', true, ScanMode.DEFAULT);
//
//       final qrCodeDecode = await FlutterBarcodeScanner.getBarcodeStreamReceiver(
//           '#ff8866', 'Cancel', true, ScanMode.DEFAULT);
//
//       if (!mounted) return;
//
//       setState(() {
//         // if()
//         if (qrCode.isNotEmpty) {
//           getResult = qrCode;
//         } else {
//           getResult = qrCodeDecode as String;
//         }
//       });
//       print("QRCode_Result:--");
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return OkDialog(text: "Value:\n${qrCode.toString()}");
//           });
//       print("Scanned values $qrCode");
//     } on PlatformException {
//       getResult = 'Failed to scan QR Code.';
//     }
//   }
//
//   Future<String?> scanFile() async {
//     // Used to pick a file from device storage
//     final pickedFile = await FilePicker.platform.pickFiles();
//     if (pickedFile != null) {
//       final filePath = pickedFile.files.single.path;
//       if (filePath != null) {
//         return await BarcodeFinder.scanFile(path: filePath);
//       }
//     }
//   }
// }
//
