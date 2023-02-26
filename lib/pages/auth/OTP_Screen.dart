// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pin_code_text_field/pin_code_text_field.dart';
// import 'package:provider/provider.dart';
// import 'package:velocit/pages/screens/dashBoard.dart';
// import '../../Core/repository/auth_repository.dart';
// import '../../utils/constants.dart';
// import '../../utils/routes/routes.dart';
// import '../../utils/styles.dart';
// import '../../utils/utils.dart';
// import '../../widgets/global/proceedButtons.dart';
// import '../../widgets/global/textFormFields.dart';
//
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:velocit/utils/StringUtils.dart';
//
// class OTPScreen extends StatefulWidget {
//    String UID='';
//    String mobileNumber='';
//    String OTP='';
//    String Uname='';
//    bool isForgotPass;
//
//   OTPScreen(
//       {Key? key,
//       required this.UID,
//       required this.mobileNumber,
//       required this.OTP,
//       required this.Uname,
//       required this.isForgotPass})
//       : super(key: key);
//
//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }
//
// class _OTPScreenState extends State<OTPScreen> {
//   bool hasError = false;
//   String currentText = "";
//   String otpMsg = "";
//
//   late Timer _timer;
//   int _start = 90;
//   bool isLoading = false;
//   TextEditingController controller = TextEditingController(text: "");
//   FocusNode focusNode = FocusNode();
//   var OTP;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     startTimer();
//     print(widget.OTP);
//     print(widget.UID);
//     print(widget.mobileNumber);
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         if (_start != 0) {
//           return Future.value(false);
//         } else {
//           Navigator.of(context).pushNamed(RoutesName.signInRoute).then((value) {
//             setState(() {
//
//             });
//           });
//           return Future.value(true);
//         }
//       },
//       child: Scaffold(
//           backgroundColor: ThemeApp.appBackgroundColor,
//           appBar: PreferredSize(
//             preferredSize:
//                 Size.fromHeight(MediaQuery.of(context).size.height * .07),
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               color: ThemeApp.appBackgroundColor,
//               alignment: Alignment.center,
//               child: AppBar(
//                 automaticallyImplyLeading: _start != 0 ? true : false,
//                 centerTitle: false,
//                 elevation: 0,
//                 backgroundColor: ThemeApp.appBackgroundColor,
//                 flexibleSpace: Container(
//                   height: MediaQuery.of(context).size.height * .07,
//                   width: MediaQuery.of(context).size.width,
//                   alignment: Alignment.center,
//                   decoration: const BoxDecoration(
//                     color: ThemeApp.appBackgroundColor,
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(15),
//                         bottomRight: Radius.circular(15)),
//                   ),
//                 ),
//                 titleSpacing: 0,
//                 leading: _start != 0
//                     ? SizedBox()
//                     : InkWell(
//                         onTap: () {
//                           Navigator.of(context).pushNamed(RoutesName.signInRoute).then((value) {
//                             setState(() {
//
//                             });
//                           });
//                         },
//                         child: Transform.scale(
//                           scale: 0.7,
//                           child: Image.asset(
//                             'assets/appImages/backArrow.png',
//                             color: ThemeApp.primaryNavyBlackColor,
//                             // height: height*.001,
//                           ),
//                         ),
//                       ),
//
//                 // leadingWidth: width * .06,
//
//                 // Row
//               ),
//             ),
//           ),
//           /* AppBar(
//       backgroundColor: ThemeApp.whiteColor,
//       iconTheme: IconThemeData(
//         color: Colors.black, //change your color here
//       ),
//       elevation: 0,
//         ),*/
//           body: SafeArea(
//             child: Container(
//               padding: const EdgeInsets.only(
//                   left: 30, right: 30, top: 0, bottom: 40),
//               child: ListView(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(110, 50.74, 110, 46),
//                     child: SvgPicture.asset(
//                       'assets/appImages/new_app_icon.svg',
//                       // color: ThemeApp.primaryNavyBlackColor,
//                       semanticsLabel: 'Acme Logo',
//
//                       height: 47.67, width: 155,
//                     ),
//                   ),
//                   /*     Container(
//                     // group796Z38 (213:207)
//
//                     width: double.infinity,
//                     height: 70,
//                     child: Image.asset(
//                       'assets/appImages/appicon.png',
//                       width: double.infinity,
//                       height: 70,
//                     ),
//                   ),*/
//                   Text(
//                     StringUtils.verification,
//                     style: TextStyle(
//                         fontFamily: 'Roboto',
//                         fontSize: 20,
//                         overflow: TextOverflow.ellipsis,
//                         fontWeight: FontWeight.w400,
//                         color: ThemeApp.primaryNavyBlackColor),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   // Text(StringUtils!.helloWorld);
//                   Text(
//                     StringUtils.verificationSubHeading,
//                     maxLines: 2,
//                     style: TextStyle(
//                         fontFamily: 'Roboto',
//                         fontSize: 14,
//                         overflow: TextOverflow.ellipsis,
//                         fontWeight: FontWeight.w400,
//                         color: ThemeApp.primaryNavyBlackColor),
//                   ),
//                   // TextFieldUtils().textFieldHeightThree(
//                   //     StringUtils.verification, context),
//                   // const SizedBox(
//                   //   height: 5,
//                   // ),
//                   // TextFieldUtils().subHeadingTextFields(
//                   //     StringUtils.verificationSubHeading,
//                   //     context),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * .04,
//                   ),
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     child: TextFieldUtils().dynamicText(
//                         widget.mobileNumber.toString(),
//                         context,
//                         TextStyle(
//                             fontFamily: 'Roboto',
//                             color: ThemeApp.primaryNavyBlackColor,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w400)),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * .04,
//                   ),
//                   FittedBox(
//                     fit: BoxFit.fitWidth,
//                     child: PinCodeTextField(
//                       autofocus: false,
//                       controller: controller,
//                       hideCharacter: true,
//                       highlight: false,
//                       defaultBorderColor: ThemeApp.whiteColor,
//                       hasTextBorderColor: controller.text.length <= 5
//                           ? Colors.red
//                           : ThemeApp.innertextfieldbordercolor,
//
//                       // highlightPinBoxColor: Colors.orange,
//                       maxLength: 6,
//                       hasError: hasError,
//                       focusNode: focusNode,
//                       onTextChanged: (value) {
//                         setState(() {
//                           if (value.length <= 5) {
//                             otpMsg = StringUtils.verificationError;
//                           } else {
//                             otpMsg = '';
//                           }
//                           currentText = value;
//                         });
//                       },
//                       onDone: (text) {
//                         print("OTP :  $text");
//                         print("OTP CONTROLLER ${controller.text}");
//                       },
//                       // pinBoxWidth: 40,
//                       // pinBoxHeight: 60,
//                       hasUnderline: false,
//                       wrapAlignment: WrapAlignment.spaceBetween,
//                       pinBoxDecoration:
//                           ProvidedPinBoxDecoration.defaultPinBoxDecoration,
//                       pinTextStyle:
//                           TextStyle(fontFamily: 'Roboto', fontSize: 22.0),
//                       pinTextAnimatedSwitcherTransition:
//                           ProvidedPinBoxTextAnimation.scalingTransition,
//                       pinBoxRadius: 10,
// //                    pinBoxColor: Colors.green[100],
//                       pinTextAnimatedSwitcherDuration:
//                           Duration(milliseconds: 300),
// //                    highlightAnimation: true,
//                       highlightAnimationBeginColor: Colors.black,
//                       highlightAnimationEndColor: Colors.white,
//                       keyboardType: TextInputType.number,
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * .01,
//                   ),
//                   !currentText.isEmpty
//                       ? TextFieldUtils().errorTextFields(otpMsg, context)
//                       : Container(),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * .01,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       _start != 0
//                           ? Center(
//                               child: Text(
//                                 formatHHMMSS(_start),
//                                 style: TextStyle(
//                                     fontFamily: 'Roboto',
//                                     color: ThemeApp.primaryNavyBlackColor,
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 14),
//                               ),
//                             )
//                           : InkWell(
//                               onTap: () {
//                                 setState(() {
//
//                                   Map emaildata = {
//                                     'email': widget.mobileNumber,
//                                   };
//                                   Map mobileData = {
//                                     'mobile': widget.mobileNumber,
//                                   };
//                                   if (StringConstant()
//                                       .isNumeric(widget.mobileNumber)) {
//                                     print(mobileData);
//
//                                     AuthRepository()
//                                         .postApiForMobileOTPRequest(
//                                             mobileData,widget.isForgotPass, context)
//                                         .then((value) {
//                                       _start = 90;
//                                       isLoading = true;
//
//                                       controller.clear();
//                                       startTimer();
//                                     });
//
//                                     print("Digit found");
//                                   } else {
//                                     print(emaildata);
//
//                                     AuthRepository()
//                                         .postApiForEmailOTPRequest(
//                                             emaildata,widget.isForgotPass, context)
//                                         .then((value) {
//                                       _start = 90;
//                                       isLoading = true;
//
//                                       controller.clear();
//                                       startTimer();
//                                     });
//                                     // Navigator.of(context).push(
//                                     //     MaterialPageRoute(builder: (context) => OTPScreen(mobileNumber:    mobileController.text))).then((value) => setState((){}));
//
//                                     print("Digit not found");
//                                     // email.clear();
//                                     // mobileController.clear();
//                                     // password.clear();
//                                   }
//                                 });
//                               },
//                               child: Text(
//                                 StringUtils.resendOTP,
//                                 style: TextStyle(
//                                     fontFamily: 'Roboto',
//                                     color: ThemeApp.tealButtonColor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14),
//                               ),
//                             ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.02,
//                       ),
//                       /*      _start == 0? Center(
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 _start = 120;
//                                 isLoading = true;
//                                 startTimer();
//                               });
//                             },
//                             child: Text(
//                               'Re-generate OTP',
//                               style: TextStyle(fontFamily: 'Roboto',
//                                   color: ThemeApp.tealButtonColor,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize:
//                                   MediaQuery.of(context).size.height * .021),
//                             ),
//                           )): */
//
//                       /*     Center(
//                           child: InkWell(
//                         onTap: () {
//                           setState(() {
//                             _start = 120;
//                             isLoading = true;
//                             startTimer();
//
//                             Map emaildata = {
//                               'email': widget.mobileNumber,
//                             };
//                             Map mobileData = {
//                               'mobile': widget.mobileNumber,
//                             };
//                             if (StringConstant()
//                                 .isNumeric(widget.mobileNumber)) {
//                               print(mobileData);
//
//                               AuthRepository()
//                                   .postApiForMobileOTPRequest(
//                                       mobileData, context)
//                                   .then((value) => setState(() {}));
//
//                               print("Digit found");
//                             } else {
//                               print(emaildata);
//
//                               AuthRepository()
//                                   .postApiForEmailOTPRequest(emaildata, context)
//                                   .then((value) => setState(() {}));
//                               // Navigator.of(context).push(
//                               //     MaterialPageRoute(builder: (context) => OTPScreen(mobileNumber:    mobileController.text))).then((value) => setState((){}));
//
//                               print("Digit not found");
//                               // email.clear();
//                               // mobileController.clear();
//                               // password.clear();
//                             }
//                           });
//                         },
//                         child: Text(
//                           StringUtils.resendOTP,
//                           style: TextStyle(
//                               fontFamily: 'Roboto',
//                               color: ThemeApp.tealButtonColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14),
//                         ),
//                       )),*/
//                     ],
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * .025,
//                   ),
//                   proceedButton(StringUtils.verifyOTP, ThemeApp.tealButtonColor,
//                       context, false, () async {
//                     // Navigator.of(context).pushReplacement(
//                     //   MaterialPageRoute(
//                     //     builder: (context) =>
//                     //         DashboardScreen(),
//                     //   ),
//                     // );
//                     if (controller.text.length >= 6) {
//                       StringConstant.isLogIn = true;
//
//                       Map passOtpData = {
//                         'username': widget.Uname,
//                         'otp': controller.text,
//                         'user_id': widget.UID,
//                       };
//                       AuthRepository()
//                           .postApiForValidateOTP(passOtpData,widget.isForgotPass, context);
//                       // if (authViewModel.getOTP == controller.text) {
//                       //   Map data = {'username': 'testuser@test.com'};
//                       //   authViewModel.loginApiWithPost(data, context);
//                       //   Utils.successToast("OTP is Correct!");
//                       //
//                       // } else {
//                       //   Utils.errorToast("Please enter valid OTP");
//                       // }
//                     } else {
//                       Utils.errorToast("Please enter 6 digit OTP");
//                     }
//                   }),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
//
//   String formatHHMMSS(int seconds) {
//     // int hours = (seconds / 3600).truncate();
//     seconds = (seconds % 3600).truncate();
//     int minutes = (seconds / 60).truncate();
//
//     // String hoursStr = (hours).toString().padLeft(2, '0');
//     String minutesStr = (minutes).toString().padLeft(2, '0');
//     String secondsStr = (seconds % 60).toString().padLeft(2, '0');
//
//     return "$minutesStr:$secondsStr";
//   }
//
//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (_start == 0) {
//           setState(() {
//             timer.cancel();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             _start--;
//           });
//         }
//       },
//     );
//   }
// }
