// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// import '../../utils/constants.dart';
// import '../../utils/styles.dart';
// import '../global/textFormFields.dart';
//
// class AddressScreen extends StatefulWidget {
//   const AddressScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AddressScreen> createState() => _AddressScreenState();
// }
//
// class _AddressScreenState extends State<AddressScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             color: ThemeApp.whiteColor,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 50),
//                     child: IconButton(
//                       icon:
//                           Icon(Icons.arrow_back, color: ThemeApp.blackColor),
//                       onPressed: () => Navigator.of(context).pop(),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                       padding: const EdgeInsets.only(top: 50),
//                       child: TextFieldUtils()
//                           .homePageheadingTextField("Address", context)),
//                 ),
//
//               ],
//             ),
//           )),
//       body: Stack(
//         children: [
//           Column(
//             children: <Widget>[
//               SizedBox(
//                 child: TextFieldUtils().subHeadingTextFields(
//                     "Deliver to - ${StringConstant.placesFromCurrentLocation}", context),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
