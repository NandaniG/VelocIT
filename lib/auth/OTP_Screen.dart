import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:velocit/pages/screens/dashBoard.dart';

import '../pages/homePage.dart';
import '../utils/constants.dart';
import '../utils/styles.dart';
import '../utils/utils.dart';
import '../widgets/global/okPopUp.dart';
import '../widgets/global/proceedButtons.dart';
import '../widgets/global/textFormFields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'change_password.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool hasError = false;
  String currentText = "";
  String otpMsg = "";

  late Timer _timer;
  int _start = 30;
  bool isLoading = false;
  TextEditingController controller = TextEditingController(text: "");
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeApp.whiteColor,
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
    padding: const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 40),
    child: ListView(
        children: [
          TextFieldUtils().textFieldHeightThree(AppLocalizations.of(context).verification, context),
          const SizedBox(
            height: 5,
          ),
          TextFieldUtils().subHeadingTextFields(
              AppLocalizations.of(context).verificationSubHeading, context),
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
              print(value);
              setState(() {
                if (value.length <= 5) {
                  otpMsg = AppLocalizations.of(context).verificationError;
                } else {
                  otpMsg = '';
                }
                currentText = value;
              });
            },
            onDone: (text) {
              print("DONE $text");
              print("DONE CONTROLLER ${controller.text}");
            },
            pinBoxWidth: 48,
            pinBoxHeight: 50,
            hasUnderline: false,
            wrapAlignment: WrapAlignment.spaceAround,
            pinBoxDecoration:
                ProvidedPinBoxDecoration.defaultPinBoxDecoration,
            pinTextStyle: TextStyle(fontSize: 22.0),
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
            height: MediaQuery.of(context).size.height * .025,
          ),
          proceedButton(AppLocalizations.of(context).verifyOTP,ThemeApp.blackColor, context, () async {
            String? emailId =await Prefs().getToken(StringConstant.emailPref);

            print("Email pref...${emailId.toString()}");
           if(controller.text.length >= 6){
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen(),), (route) => false);

           }else{
             showDialog(
                 context: context,
                 builder: (BuildContext context) {
                   return  OkDialog(text: "Please enter 6 digit OTP");
                 });
           }

          }),
          SizedBox(
            height: MediaQuery.of(context).size.height * .025,
          ),
          _start != 0
              ? Center(
                  child: Text(
                    _start.toString(),
                    style: TextStyle(
                        color: ThemeApp.darkGreyTab,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                )
              : Center(
                  child: InkWell(
                  onTap: () {
                    setState(() {
                      _start = 30;
                      isLoading = true;
                      startTimer();
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context).resendOTP,
                    style: TextStyle(
                        color: ThemeApp.darkGreyTab,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * .021),
                  ),
                )),
        ],
    ),
        ),
      ),
    );
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
