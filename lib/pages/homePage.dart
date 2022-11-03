import 'dart:io';

import 'package:barcode_finder/barcode_finder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:velocit/pages/Activity/Product_Activities/Products_List.dart';
import 'package:velocit/pages/screens/cartDetail_Activity.dart';
import 'package:velocit/pages/screens/dashBoard.dart';
import 'package:velocit/pages/screens/offers_Activity.dart';
import 'package:velocit/pages/tabs/tabs.dart';
import 'package:velocit/pages/screens/dashBoard.dart';

import '../services/models/ProductDetailModel.dart';
import '../services/providers/Products_provider.dart';
import '../utils/constants.dart';
import '../utils/styles.dart';
import '../utils/utils.dart';
import '../widgets/global/okPopUp.dart';
import '../widgets/global/proceedButtons.dart';
import '../widgets/global/textFormFields.dart';
import '../widgets/scannerWithGallery.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  var userName = '';
  var getResult = 'QR Code Result';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final List _tabIcons = List.unmodifiable([
    {'icon': 'assets/icons/home.png'},
    {'icon': 'assets/icons/percentage.png'},
    {'icon': 'assets/icons/percentage.png'},
    {'icon': 'assets/icons/shop.png'},
    {'icon': 'assets/icons/shopping-cart.png'},
  ]);
 late ProductDetailsModel model;
 late ProductProvider value;
  final List<Widget> _tabs = List.unmodifiable([
    // SearchList(),
    DashboardScreen(),
    OfferActivity(),
    Container(),
    Container(),
    MobileListActivity(),
  ]);

  void onTabChanged(int index) {
    setState(() => currentIndex = index);
  }

  final controller = BarcodeFinderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeApp.backgroundColor,
      body: _tabs[currentIndex],
      /*     bottomNavigationBar: Tabs(
        tabIcons: _tabIcons,
        activeIndex: currentIndex,
        onTabChanged: onTabChanged,
      ), */
      bottomNavigationBar: Stack(
        alignment: FractionalOffset(.5, 1.0),
        children: [
          Tabs(
            tabIcons: _tabIcons,
            activeIndex: currentIndex,
            onTabChanged: onTabChanged,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                backgroundColor: ThemeApp.darkGreyTab,
                onPressed: () {
                  // scanQRCode();
                  // scanFile();
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => StepperScreen(),
                  //   ),
                  // );
                  showModalBottomSheet(
                      isDismissible: true,
                      context: context,
                      builder: (context) {
                        return ScannerWidget(state: controller.state);
                      });
                },
                child: Icon(Icons.document_scanner_outlined,
                    color: ThemeApp.whiteColor),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _scannerWidget(BarcodeFinderState state) {
    return Container(
      height: MediaQuery.of(context).size.height * .3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // if (state is BarcodeFinderLoading)
          //   _loading()
          // else if (state is BarcodeFinderError)
          //   _text(
          //     '${state.message}',
          //   )
          // else if (state is BarcodeFinderSuccess)
          //   _text(
          //     '${state.code}',
          //   ),
          proceedButton("Scan with Camera", ThemeApp.darkGreyColor, context,
              () {
            scanQRCode();
          }),
          proceedButton("Scan with Gallery", ThemeApp.darkGreyColor, context,
              () {
            _startScanFileButton(state);
          }),
          // _startScanFileButton(state),
        ],
      ),
    );
  }

  Widget _startScanFileButton(BarcodeFinderState state) {
    return ElevatedButton(
      onPressed: state is! BarcodeFinderLoading
          ? () async {
              FilePickerResult? pickedFile =
                  await FilePicker.platform.pickFiles();
              if (pickedFile != null) {
                String? filePath = pickedFile.files.single.path;
                if (filePath != null) {
                  final file = File(filePath);
                  controller.scanFile(file);
                }
              }
            }
          : null,
      child: Text('Scan PDF or image file'),
    );
  }

  Widget _loading() => Center(child: CircularProgressIndicator());

  Text _text(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }

  void scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff8866', 'Cancel', true, ScanMode.DEFAULT);

      final qrCodeDecode = await FlutterBarcodeScanner.getBarcodeStreamReceiver(
          '#ff8866', 'Cancel', true, ScanMode.DEFAULT);

      if (!mounted) return;

      setState(() {
        // if()
        if (qrCode.isNotEmpty) {
          getResult = qrCode;
        } else {
          getResult = qrCodeDecode as String;
        }
      });
      print("QRCode_Result:--");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return OkDialog(text: "Value:\n${qrCode.toString()}");
          });
      print("Scanned values $qrCode");
    } on PlatformException {
      getResult = 'Failed to scan QR Code.';
    }
  }

  Future<String?> scanFile() async {
    // Used to pick a file from device storage
    final pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      final filePath = pickedFile.files.single.path;
      if (filePath != null) {
        return await BarcodeFinder.scanFile(path: filePath);
      }
    }
  }
}

class ScannerWidget extends StatefulWidget {
  BarcodeFinderState state;

  ScannerWidget({Key? key, required this.state}) : super(key: key);

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  var getResult = 'QR Code Result';
  final controller = BarcodeFinderController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _scanBarcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .25,
      color: Colors.cyan,
      margin: EdgeInsets.all(10.0),
      child: Scaffold(
          key: _scaffoldKey,
          body: Center(
            child: Wrap(
              children: [
                AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) {
                    final state = controller.state;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        proceedButton(
                            "Scan with Camera", ThemeApp.darkGreyColor, context,
                            () {
                          // Navigator.of(context).pop();

                          scanQR();
                        }),
                        SizedBox(height: MediaQuery.of(context).size.height*.01 ,),
                        _startScanFileButton(state),
                        Text(
                          'Code:',
                          textAlign: TextAlign.center,
                        ),
                        if (state is BarcodeFinderLoading)
                          _loading()
                        else if (state is BarcodeFinderError)
                          _text(
                            '${state.message}',
                          )
                        else if (state is BarcodeFinderSuccess)
                          _text(
                            '${state.code}',
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget _loading() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: CircularProgressIndicator(
          color: ThemeApp.darkGreyColor,
        )),
      );

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      _scanBarcode = barcodeScanRes;
      print('_scanBarcode : ' + barcodeScanRes);
      print('_scanBarcode : ' + _scanBarcode);
      if (!mounted) return;
      Navigator.of(context).pop();

      final snackBar = SnackBar(
        content: Text(_scanBarcode),
        backgroundColor: ThemeApp.greenappcolor,
        clipBehavior: Clip.antiAlias,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
//barcode scanner flutter ant
  }

  Widget _startScanFileButton(BarcodeFinderState state) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: ThemeApp.darkGreyColor,
      ),
      child: InkWell(
          onTap: state is! BarcodeFinderLoading
              ? () async {
                  FilePickerResult? pickedFile =
                      await FilePicker.platform.pickFiles();
                  if (pickedFile != null) {
                    String? filePath = pickedFile.files.single.path;
                    if (filePath != null) {
                      final file = File(filePath);
                      controller.scanFile(file);
                    }
                  }
                  final snackBar = SnackBar(
                    content: Text(_scanBarcode),
                    backgroundColor: ThemeApp.greenappcolor,
                    clipBehavior: Clip.antiAlias,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              : null,
          child: TextFieldUtils().usingPassTextFields(
              "Open Gallery", ThemeApp.whiteColor, context)),
    );
  }

  Future<String?> scanFile() async {
    // Used to pick a file from device storage
    final pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      final filePath = pickedFile.files.single.path;
      if (filePath != null) {
        return await BarcodeFinder.scanFile(path: filePath);
      }
    }
  }

  Text _text(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }
}
