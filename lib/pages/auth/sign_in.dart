import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/pages/auth/Sign_Up.dart';
import 'package:velocit/pages/screens/dashBoard.dart';

import '../../Core/repository/auth_repository.dart';
import '../../utils/StringUtils.dart';
import '../../utils/constants.dart';
import '../../utils/routes/routes.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/proceedButtons.dart';
import '../../widgets/global/textFormFields.dart';
import 'forgot_password.dart';

class SignIn_Screen extends StatefulWidget {
  const SignIn_Screen({Key? key}) : super(key: key);

  @override
  State<SignIn_Screen> createState() => _SignIn_ScreenState();
}

class _SignIn_ScreenState extends State<SignIn_Screen> {
  TextEditingController email = new TextEditingController();

  // TextEditingController emailUsingOtpController = TextEditingController();
  TextEditingController password = new TextEditingController();
  bool _usingPassVisible = false;

  // int? _radioIndex = 2;
  // String _radioVal = "";
  bool isOtp = false;
  bool isSwitch = false;

  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _validateEmail = false;
  bool _validateMobile = false;
  bool _validatePassword = false;
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  /// otp fields
  TextEditingController otpController = TextEditingController(text: "");
  var OTP;
  bool hasError = false;
  String currentText = "";
  String otpMsg = "";

  late Timer _timer;
  int _start = 90;
  bool isLoading = false;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _radioIndex = 1;
    isOtp = false;
    _usingPassVisible = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    email.dispose();
    // emailUsingOtpController.dispose();
    password.dispose();
  }

  var isOtpValues;
  var userId, userName;

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isOtpValues = (prefs.getString(StringConstant.setOtp)) ?? '';
    userId = (prefs.getString('userIdFromOtp')) ?? '';
    userName = (prefs.getString('userNameFromOtp')) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 10),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   // group796Z38 (213:207)
                    //
                    //   width: double.infinity,
                    //   height: 70,
                    //   child: Image.asset(
                    //     'assets/appImages/appicon.png',
                    //     width: double.infinity,
                    //     height: 70,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(110, 50.74, 110, 46),
                      child: SvgPicture.asset(
                        'assets/appImages/new_app_icon.svg',
                        // color: ThemeApp.primaryNavyBlackColor,
                        semanticsLabel: 'Acme Logo',

                        height: 47.67, width: 155,
                      ),
                    ),

                    Text(
                      'Sign In',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          color: ThemeApp.primaryNavyBlackColor),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // Text(StringUtils!.helloWorld);
                    Text(
                      'Provide below details to continue your shopping',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          color: ThemeApp.primaryNavyBlackColor),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    /*                 Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 25,
                          child: Radio(
                            value: 1,
                            groupValue: _radioIndex,
                            activeColor: ThemeApp.appColor,
                            onChanged: (value) {
                              setState(() {
                                _radioIndex = value as int;
                                _radioVal = 'Email';
                                mobileController.clear();
                                print(_radioVal);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        const Text("Email",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            )),
                        SizedBox(
                          width: 14,
                        ),
                        SizedBox(
                          width: 25,
                          child: Radio(
                            value: 2,
                            groupValue: _radioIndex,
                            activeColor: ThemeApp.appColor,
                            onChanged: (value) {
                              setState(() {
                                _usingPassVisible = true;
                                _usingPassVisible = !_usingPassVisible;
                                email.clear();
                                password.clear();
                                _radioIndex = value as int;
                                _radioVal = 'Phone';
                                print(_radioVal);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        const Text("Phone Number",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),*/
                    /*    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _usingPassVisible = true;
                                _usingPassVisible = !_usingPassVisible;
                                email.clear();
                                password.clear();
                                // _usingPassVisible==true ? _validateEmail = true:_validateEmail=false;
                              });
                            },
                            child:
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: _usingPassVisible
                                      ? Colors.white
                                      : ThemeApp.appColor,
                                ),
                                child: Center(
                                  child: Text(StringUtils.usingPass,
                                      style: TextStyle(fontFamily: 'Roboto',
                                          fontSize: 13,
                                          color: _usingPassVisible
                                              ? ThemeApp.blackColor
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.08)),
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  _usingPassVisible = true;
                                  mobileController.clear();
                                });
                              },
                              child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: _usingPassVisible
                                        ? ThemeApp.appColor
                                        : ThemeApp.whiteColor,
                                  ),
                                  child: Center(
                                    child: Text(StringUtils.usingOTP,
                                        style: TextStyle(fontFamily: 'Roboto',
                                            fontSize: 13,
                                            color: _usingPassVisible
                                                ? ThemeApp.whiteColor
                                                : ThemeApp.blackColor,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -0.08)),
                                  ))),
                        ),
                      ],
                    ),*/
                    SizedBox(
                      height: 30,
                    ),
                    /* isOtp == false
                       ? TextFieldUtils().asteriskTextField(
                            StringUtils.emailAddress, context)
                        :*/
                    TextFieldUtils()
                        .asteriskTextField(StringUtils.emailORMobile, context),
                    /*TextFieldUtils().asteriskTextField(
                            StringUtils.mobileNumber, context),*/
                    /*     isOtp == false?
                    TextFormFieldsWidget(
                        errorText:StringUtils.validemailORMobileError,
                        textInputType: TextInputType.emailAddress,
                        controller: email,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: StringUtils.emailORMobileHint,
                        preffixText: Padding(
                          padding: const EdgeInsets.fromLTRB(11.73,12.73,6.36,12.73),
                          child: SvgPicture.asset(
                            'assets/appImages/Username.svg',
                            width: 16.56,
                            height: 16.56,
                          ),
                        ),
                        suffixText:(!StringConstant().isEmail(email.text) &&
                            !StringConstant().isPhone(email.text))?SizedBox(): Padding(
                          padding:
                          const EdgeInsets.fromLTRB(11.73, 12.73, 11.73, 12.73),
                          child: SvgPicture.asset(
                            'assets/appImages/emailValidateIcon.svg',
                            width: 15.54,
                            height: 15.54,
                          ),
                        ),
                        onChange: (val) {
                          setState(() {
                            if (val.isEmpty && email.text.isEmpty) {
                              _validateEmail = true;
                            } else if (!StringConstant().isEmail(val) &&
                                !StringConstant().isPhone(val)) {
                              _validateEmail = true;
                            } else {
                              _validateEmail = false;
                            }
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty && email.text.isEmpty) {
                            _validateEmail = true;
                            return StringUtils.validEmailError;
                          } else if (!StringConstant().isEmail(value) &&
                              !StringConstant().isPhone(value)) {
                            _validateEmail = true;
                            return StringUtils.validEmailError;
                          } else {
                            _validateEmail = false;
                          }
                          return null;
                        }): */
                    TextFormFieldsWidget(
                        maxLength:
                            StringConstant().isPhone(email.text) ? 10 : null,
                        errorText: StringUtils.validemailORMobileError,
                        textInputType: TextInputType.emailAddress,
                        controller: email,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: StringUtils.emailORMobileHint,
                        preffixText: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              11.73, 12.73, 6.36, 12.73),
                          child: SvgPicture.asset(
                            'assets/appImages/Username.svg',
                            width: 16.56,
                            height: 16.56,
                          ),
                        ),
                        suffixText: (!StringConstant().isEmail(email.text) &&
                                !StringConstant().isPhone(email.text))
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    11.73, 12.73, 11.73, 12.73),
                                child: SvgPicture.asset(
                                  'assets/appImages/emailValidateIcon.svg',
                                  width: 15.54,
                                  height: 15.54,
                                ),
                              ),
                        onChange: (val) {
                          setState(() {
                            if (val.isEmpty && email.text.isEmpty) {
                              _validateEmail = true;
                            } else if (!StringConstant().isEmail(val) &&
                                !StringConstant().isPhone(val)) {
                              _validateEmail = true;
                            } else {
                              _validateEmail = false;
                            }
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty && email.text.isEmpty) {
                            _validateEmail = true;
                            return StringUtils.validemailORMobileError;
                          } else if (!StringConstant().isEmail(value) &&
                              !StringConstant().isPhone(value)) {
                            _validateEmail = true;
                            return StringUtils.validemailORMobileError;
                          } else {
                            _validateEmail = false;
                          }
                          return null;
                        }),
                    /* TextFormFieldsWidget(
                        errorText:StringUtils.validemailORMobileError,
                        textInputType: TextInputType.emailAddress,
                        controller: emailUsingOtpController,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: StringUtils.emailORMobileHint,
                        preffixText: Padding(
                          padding: const EdgeInsets.fromLTRB(11.73,12.73,6.36,12.73),
                          child: SvgPicture.asset(
                            'assets/appImages/Username.svg',
                            width: 16.56,
                            height: 16.56,
                          ),
                        ),
                        suffixText:(!StringConstant().isEmail(emailUsingOtpController.text) &&
                            !StringConstant().isPhone(emailUsingOtpController.text))?SizedBox(): Padding(
                          padding:
                          const EdgeInsets.fromLTRB(11.73, 12.73, 11.73, 12.73),
                          child: SvgPicture.asset(
                            'assets/appImages/emailValidateIcon.svg',
                            width: 15.54,
                            height: 15.54,
                          ),
                        ),
                        onChange: (val) {
                          setState(() {
                            if (val.isEmpty && emailUsingOtpController.text.isEmpty) {
                              _validateEmail = true;
                            } else if (!StringConstant().isEmail(val) &&
                                !StringConstant().isPhone(val)) {
                              _validateEmail = true;
                            } else {
                              _validateEmail = false;
                            }
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty && emailUsingOtpController.text.isEmpty) {
                            _validateEmail = true;
                            return StringUtils.validEmailError;
                          } else if (!StringConstant().isEmail(value) &&
                              !StringConstant().isPhone(value)) {
                            _validateEmail = true;
                            return StringUtils.validEmailError;
                          } else {
                            _validateEmail = false;
                          }
                          return null;
                        }),*/

                    isOtp == false
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    isOtp == false
                        ? Row(
                            children: [
                              TextFieldUtils().asteriskTextField(
                                  StringUtils.password, context),
                              SizedBox(
                                width: 5,
                              ),
                              Tooltip(
                                key: tooltipkey,
                                message:
                                    'Enter Password that must be\no 8-16 characters long\no Must contain a number\no Must contain a capital and small letter\no Must contain a special character',
                                padding: const EdgeInsets.all(30),
                                margin: const EdgeInsets.only(
                                    top: 30, left: 30, right: 30),
                                triggerMode: TooltipTriggerMode.tap,
                                showDuration: const Duration(minutes: 3),
                                decoration: BoxDecoration(
                                    color: ThemeApp.appColor,
                                    borderRadius: BorderRadius.circular(22)),
                                textStyle: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                                child: Icon(
                                  Icons.info_outline,
                                  color: ThemeApp.appColor,
                                ),
                              )
                            ],
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    isOtp == false
                        ? PasswordTextFormFieldsWidget(
                            errorText: StringUtils.passwordError,
                            textInputType: TextInputType.text,
                            controller: password,
                            autoValidation: AutovalidateMode.onUserInteraction,
                            hintText: StringUtils.password,
                            // prefixIcon: Padding(
                            //   padding: const EdgeInsets.fromLTRB(11.73,12.73,6.36,12.73),
                            //   child: SvgPicture.asset(
                            //     'assets/appImages/Password.svg',
                            //     width: 16.56,
                            //     height: 16.56,
                            //   ),
                            // ),
                            onChange: (val) {
                              setState(() {
                                if (val.isEmpty && password.text.isEmpty) {
                                  _validatePassword = true;
                                } else if (!StringConstant().isPass(val)) {
                                  _validatePassword = true;
                                } else {
                                  _validatePassword = false;
                                }
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty && password.text.isEmpty) {
                                _validatePassword = true;
                                return StringUtils.passwordError;
                              } else if (!StringConstant().isPass(value)) {
                                _validatePassword = true;
                                return StringUtils.validPasswordError;
                              } else {
                                _validatePassword = false;
                              }
                              return null;
                            })
                        : const SizedBox(
                            height: 0,
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),

                    isOtp == true
                        ? TextFieldUtils()
                            .asteriskTextField(StringUtils.otp, context)
                        : SizedBox(),
                    isOtp == true
                        ? SizedBox(
                            height: 10,
                          )
                        : SizedBox(),
                    isOtp == true
                        ? FittedBox(
                            fit: BoxFit.fitWidth,
                            child: PinCodeTextField(
                              autofocus: false,
                              controller: otpController,
                              hideCharacter: true,
                              highlight: false,
                              defaultBorderColor: ThemeApp.whiteColor,
                              hasTextBorderColor: otpController.text.length <= 5
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
                                print("OTP CONTROLLER ${otpController.text}");
                              },
                              // pinBoxWidth: 40,
                              // pinBoxHeight: 60,
                              hasUnderline: false,
                              wrapAlignment: WrapAlignment.spaceBetween,
                              pinBoxDecoration: ProvidedPinBoxDecoration
                                  .defaultPinBoxDecoration,
                              pinTextStyle: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 22.0),
                              pinTextAnimatedSwitcherTransition:
                                  ProvidedPinBoxTextAnimation.scalingTransition,
                              pinBoxRadius: 10,
//                    pinBoxColor: Colors.green[100],
                              pinTextAnimatedSwitcherDuration:
                                  Duration(milliseconds: 300),
//                    highlightAnimation: true,
                              highlightAnimationBeginColor: Colors.black,
                              highlightAnimationEndColor: Colors.white,
                              keyboardType: TextInputType.number,
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    !currentText.isEmpty
                        ? TextFieldUtils().errorTextFields(otpMsg, context)
                        : Container(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    isOtp == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _start != 0
                                  ? Center(
                                      child: Text(
                                        formatHHMMSS(_start),
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color:
                                                ThemeApp.primaryNavyBlackColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          Map emaildata = {
                                            'email': email.text,
                                          };
                                          Map mobileData = {
                                            'mobile': email.text,
                                          };
                                          if (StringConstant()
                                              .isNumeric(email.text)) {
                                            print(mobileData);

                                            AuthRepository()
                                                .postApiForMobileOTPRequest(
                                                    mobileData, false, context)
                                                .then((value) {
                                              _start = 90;
                                              isLoading = true;

                                              otpController.clear();
                                              startTimer();
                                            });

                                            print("Digit found");
                                          } else {
                                            print(emaildata);

                                            AuthRepository()
                                                .postApiForEmailOTPRequest(
                                                    emaildata, false, context)
                                                .then((value) {
                                              _start = 90;
                                              isLoading = true;

                                              otpController.clear();
                                              startTimer();
                                            });
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(builder: (context) => OTPScreen(mobileNumber:    mobileController.text))).then((value) => setState((){}));

                                            print("Digit not found");
                                            // email.clear();
                                            // mobileController.clear();
                                            // password.clear();
                                          }
                                        });
                                      },
                                      child: Text(
                                        StringUtils.resendOTP,
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: ThemeApp.tealButtonColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              /*      _start == 0? Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _start = 120;
                                isLoading = true;
                                startTimer();
                              });
                            },
                            child: Text(
                              'Re-generate OTP',
                              style: TextStyle(fontFamily: 'Roboto',
                                  color: ThemeApp.tealButtonColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                  MediaQuery.of(context).size.height * .021),
                            ),
                          )): */

                              /*     Center(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            _start = 120;
                            isLoading = true;
                            startTimer();

                            Map emaildata = {
                              'email': widget.mobileNumber,
                            };
                            Map mobileData = {
                              'mobile': widget.mobileNumber,
                            };
                            if (StringConstant()
                                .isNumeric(widget.mobileNumber)) {
                              print(mobileData);

                              AuthRepository()
                                  .postApiForMobileOTPRequest(
                                      mobileData, context)
                                  .then((value) => setState(() {}));

                              print("Digit found");
                            } else {
                              print(emaildata);

                              AuthRepository()
                                  .postApiForEmailOTPRequest(emaildata, context)
                                  .then((value) => setState(() {}));
                              // Navigator.of(context).push(
                              //     MaterialPageRoute(builder: (context) => OTPScreen(mobileNumber:    mobileController.text))).then((value) => setState((){}));

                              print("Digit not found");
                              // email.clear();
                              // mobileController.clear();
                              // password.clear();
                            }
                          });
                        },
                        child: Text(
                          StringUtils.resendOTP,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.tealButtonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      )),*/
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Request Password",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            )),
                        SizedBox(
                          width: 7,
                        ),
                        Transform.scale(
                          scale: 1.1,
                          child: Switch(
                            // This bool value toggles the switch.
                            value: isOtp,
                            activeColor: ThemeApp.whiteColor,
                            activeTrackColor: ThemeApp.appLightColor,
                            inactiveTrackColor: ThemeApp.appLightColor,
                            inactiveThumbColor: ThemeApp.whiteColor,
                            onChanged: (bool val) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                print("Switch value " + isOtp.toString());
                                if (isOtp == false) {
                                  if (email.text.isNotEmpty) {
                                    isOtp = val;
                                    print(email.text);
                                    sendOTPCallback();
                                    startTimer();

                                  } else {
                                    Utils.errorToast(
                                        "Please enter email or mobile");
                                  }
                                } else {
                                  isOtp = val;
                                  setState(() {
                                   _start=90;

                                  });
                                }

                                // if (isOtp == true) {
                                //   print("isOtp == true " + isOtp.toString());
                                // }
                              });

                              /*  if (isOtp == true) {
                                // isOtp = !isOtp;
                                print("isOtp == true" + isOtp.toString());
                              } else {
                                print(
                                    "Switch value in else" + isOtp.toString());

                                setState(() {
                                  isOtp = val;
                                });
                                // Utils.errorToast(
                                //     "Please enter email or mobile");
                              }

                              if (email.text.isNotEmpty) {
                                isOtp = true;
                                print(email.text);
                                // sendOTPCallback();
                              }*/
                            },
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text("Request OTP",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ))
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()),
                          );
                        },
                        child: TextFieldUtils().hyperLinkTextFields(
                            StringUtils.forgotPassword, context),
                      ),
                    ),

                    /* isOtp == false
                        ? Container(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()),
                                );
                              },
                              child: TextFieldUtils().hyperLinkTextFields(
                                  StringUtils.forgotPassword, context),
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                          ),*/
                    isOtp == false
                        ? SizedBox(
                            height: 50,
                          )
                        : const SizedBox(
                            height: 50,
                          ),

                    isOtp == false
                        ? proceedButton(StringUtils.signin,
                            ThemeApp.tealButtonColor, context, false, () {
                            if (_formKey.currentState!.validate() &&
                                email.text.isNotEmpty &&
                                password.text.isNotEmpty) {
                              Map emaildata = {
                                'email': email.text,
                                'password': password.text.trim()
                              };
                              Map mobileData = {
                                'mobile': email.text,
                                'password': password.text
                              };
                              print(emaildata);
                              if (StringConstant().isNumeric(email.text)) {
                                AuthRepository()
                                    .postApiUsingEmailPasswordRequest(
                                        mobileData, context)
                                    .then((value) => setState(() {}));
                                print("Digit found");
                              } else {
                                AuthRepository()
                                    .postApiUsingEmailPasswordRequest(
                                        emaildata, context)
                                    .then((value) => setState(() {}));

                                print("Digit not found");
                                // email.clear();
                                // mobileController.clear();
                                // password.clear();
                              }
                            } else {
                              Utils.errorToast(
                                  "Please enter valid username or password");
                            }
                          })
                        : proceedButton(StringUtils.verifyOTP,
                            ThemeApp.tealButtonColor, context, false, () async {
                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         DashboardScreen(),
                            //   ),
                            // );
                            if (otpController.text.length >= 6) {
                              StringConstant.isLogIn = true;

                              Map passOtpData = {
                                'username': userName,
                                'otp': otpController.text,
                                'user_id': userId,
                              };
                              AuthRepository().postApiForValidateOTP(
                                  passOtpData, false, context);
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
                    /*     proceedButton(StringUtils.sendOtp,
                            ThemeApp.tealButtonColor, context, false, () {
                            if (_formKey.currentState!.validate() &&
                                email.text.isNotEmpty) {
                              Map emaildata = {
                                'email': email.text,
                              };
                              Map mobileData = {
                                'mobile': email.text,
                              };
                              if (StringConstant().isNumeric(email.text)) {
                                print(mobileData);

                                AuthRepository()
                                    .postApiForMobileOTPRequest(
                                        mobileData, false, context)
                                    .then((value) => setState(() {}));

                                print("Digit found");
                              } else {
                                print(emaildata);

                                AuthRepository()
                                    .postApiForEmailOTPRequest(
                                        emaildata, false, context)
                                    .then((value) => setState(() {}));
                                // Navigator.of(context).push(
                                //     MaterialPageRoute(builder: (context) => OTPScreen(mobileNumber:    mobileController.text))).then((value) => setState((){}));

                                print("Digit not found");
                                // email.clear();
                                // mobileController.clear();
                                // password.clear();
                              }
                            } else {
                              Utils.errorToast(
                                  "Please enter valid mobile number");
                            }
                          }),*/
/////////////////////
                    /*   proceedButton(
                        _radioIndex == 1
                            ? StringUtils.signin
                            : StringUtils.sendOtp,
                        ThemeApp.tealButtonColor,
                        context,
                        authViewModel.loadingWithGet, () async {
                      FocusManager.instance.primaryFocus?.unfocus();

                      setState(() {
                        Prefs.instance
                            .setToken(StringConstant.emailPref, email.text);
                        if (  !_usingPassVisible) {
                        if (_formKey.currentState!.validate() &&
                            email.text.isNotEmpty &&
                            password.text.isNotEmpty) {
                          Prefs.instance.setToken(StringConstant.emailOTPPref,
                              mobileController.text);

                          Map data = {
                            'email': email.text,
                            'password': password.text.trim()
                          };
                          Map mobileData = {
                            'mobile': email.text,
                            'password': password.text
                          };
                          print(data);
                          if (StringConstant().isNumeric(email.text)) {
                            print("Digit found");
                          } else {
                            AuthRepository()
                                .postApiUsingEmailRequest(data, context);

                            print("Digit not found");
                            // email.clear();
                            // mobileController.clear();
                            // password.clear();
                          }
                        }*/ /* else {
                          _radioIndex == 1?   Utils.errorToast("Incorrect username or password"):Utils.errorToast("Incorrect mobile number");
                        }*/ /*
                        } else {
                          if (mobileController.text.isNotEmpty&&mobileController.text.length==10) {
                            authViewModel.loginApiWithGet(context);

                            Prefs.instance.setToken(StringConstant.emailOTPPref,
                                mobileController.text);
                            Map mobileData = {
                              'mobile': mobileController.text,
                              'password': password.text
                            };

                            // AuthRepository().postApiUsingMobileRequest(
                            //     mobileData, context);
                            */ /*   if (StringConstant().isNumeric(email.text)) {
                                  AuthRepository().postApiUsingMobileRequest(
                                      mobileData, context);
                                  print("Digit found");
                                } else {

                                  print("Digit not found");
                                }*/ /*
                          } else {
                            Utils.errorToast("Please enter valid Details.");
                          }
                          print(mobileController.text);
                        }
                      });
                    }),*/
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.primaryNavyBlackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        InkWell(
                          onTap: () {
                            email.clear();
                            password.clear();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.tealButtonColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "or",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.primaryNavyBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Continue as ",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.primaryNavyBlackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil(
                                    RoutesName.dashboardRoute, (route) => false)
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: Text(
                            "Guest",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.tealButtonColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  toggle() {}

  sendOTPCallback() {
    print("Insight API CALL");
    Map emaildata = {
      'email': email.text,
    };
    Map mobileData = {
      'mobile': email.text,
    };
    if (StringConstant().isNumeric(email.text)) {
      print(mobileData);

      AuthRepository()
          .postApiForMobileOTPRequest(mobileData, false, context)
          .then((value) => setState(() {
                getPref();
              }));

      print("Digit found");
    } else {
      print(emaildata);

      AuthRepository()
          .postApiForEmailOTPRequest(emaildata, false, context)
          .then((value) => setState(() {
                getPref();
              }));
      // Navigator.of(context).push(
      //     MaterialPageRoute(builder: (context) => OTPScreen(mobileNumber:    mobileController.text))).then((value) => setState((){}));

      print("Digit not found");
      // email.clear();
      // mobileController.clear();
      // password.clear();
    }
  }
}
