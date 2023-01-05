import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import 'package:velocit/pages/screens/dashBoard.dart';
import '../../Core/ViewModel/auth_view_model.dart';
import '../../utils/constants.dart';
import '../../utils/routes/routes.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/proceedButtons.dart';
import '../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool hasError = false;
  String currentText = "";
  String otpMsg = "";

  late Timer _timer;
  int _start = 120;
  bool isLoading = false;
  TextEditingController controller = TextEditingController(text: "");
  FocusNode focusNode = FocusNode();
  var OTP;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    getOtp();
  }

  getOtp() async {
    OTP = await Prefs.instance.getToken("otpKey");
    print("get OTP from Preference : $OTP");
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: ThemeApp.blackColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )),
        /* AppBar(
    backgroundColor: ThemeApp.whiteColor,
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),
    elevation: 0,
      ),*/
        body: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 40),
            child: ListView(
              children: [
                Container(
                  // group796Z38 (213:207)

                  width: double.infinity,
                  height: 70,
                  child: Image.asset(
                    'assets/appImages/appicon.png',
                    width: double.infinity,
                    height: 70,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                TextFieldUtils().textFieldHeightThree(
                    StringUtils.verification, context),
                const SizedBox(
                  height: 5,
                ),
                TextFieldUtils().subHeadingTextFields(
                    StringUtils.verificationSubHeading,
                    context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                Container(alignment: Alignment.centerLeft,
                  child: TextFieldUtils().dynamicText(
                      '+91 78945612352',
                      context,
                      TextStyle(fontFamily: 'Roboto',
                          color: ThemeApp.primaryNavyBlackColor,
                          fontSize:22,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                PinCodeTextField(
                  autofocus: false,
                  controller: controller,
                  hideCharacter: true,
                  highlight: false,
                  defaultBorderColor: ThemeApp.textFieldBorderColor,
                  hasTextBorderColor: controller.text.length <= 5
                      ? Colors.red
                      : ThemeApp.innertextfieldbordercolor,

                  // highlightPinBoxColor: Colors.orange,
                  maxLength: 6,
                  hasError: hasError,
                  focusNode: focusNode,
                  onTextChanged: (value) {
                    setState(() {
                      if (value.length <= 5) {
                        otpMsg = StringUtils.verificationError;
                      } else {
                        otpMsg = '';
                      }
                      currentText = value;
                    });
                  },
                  onDone: (text) {
                    print("OTP :  $text");
                    print("OTP CONTROLLER ${controller.text}");
                  },
                  pinBoxWidth: 50,
                  pinBoxHeight: 60,
                  hasUnderline: false,
                  wrapAlignment: WrapAlignment.spaceAround,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontFamily: 'Roboto',fontSize: 22.0),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
                  pinBoxRadius: 10,
//                    pinBoxColor: Colors.green[100],
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
//                    highlightAnimation: true,
                  highlightAnimationBeginColor: Colors.black,
                  highlightAnimationEndColor: Colors.white12,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                !currentText.isEmpty
                    ? TextFieldUtils().errorTextFields(otpMsg, context)
                    : Container(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _start != 0
                        ? Center(
                      child: Text(
                    formatHHMMSS(  _start),
                        style: TextStyle(fontFamily: 'Roboto',
                            color: ThemeApp.primaryNavyBlackColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 19),
                      ),
                    )
                        : SizedBox(),
                    SizedBox(width: MediaQuery.of(context).size.width*0.02 ,),
                    Center(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _start = 120;
                              isLoading = true;
                              startTimer();
                            });
                          },
                          child: Text(
                            StringUtils.resendOTP,
                            style: TextStyle(fontFamily: 'Roboto',
                                color: ThemeApp.tealButtonColor,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                MediaQuery.of(context).size.height * .021),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .025,
                ),
                proceedButton(StringUtils.verifyOTP,
                    ThemeApp.tealButtonColor,context, authViewModel.loadingWithPost,() async {
                      StringConstant.isLogIn = true;

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              DashboardScreen(),
                        ),
                      );
                      String? emailId =
                      await Prefs.instance.getToken(StringConstant.emailPref);

                  print("SharePref OTP:" + OTP);

                  print("Intend OTP:${authViewModel.getOTP}");

                  if (controller.text.length >= 6) {
                    // if (authViewModel.getOTP == controller.text) {
                    //   Map data = {'username': 'testuser@test.com'};
                    //   authViewModel.loginApiWithPost(data, context);
                    //   Utils.successToast("OTP is Correct!");
                    //
                    // } else {
                    //   Utils.errorToast("Please enter valid OTP");
                    // }
                      } else {
                    Utils.errorToast("Please enter 6 digit OTP");
                  }
                }),

              ],
            ),
          ),
        ));
  }
  String formatHHMMSS(int seconds) {
    // int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    // String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isLoading = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
