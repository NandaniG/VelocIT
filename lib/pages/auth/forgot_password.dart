import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/pages/auth/sign_in.dart';
import 'package:velocit/utils/utils.dart';

import '../../Core/repository/auth_repository.dart';
import '../../utils/constants.dart';
import '../../utils/routes/routes.dart';
import '../../utils/styles.dart';
import '../../widgets/global/proceedButtons.dart';
import '../../widgets/global/textFormFields.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../screens/dashBoard.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController registerEmail = TextEditingController();
  bool _validateEmail = false;
  final _formKey = GlobalKey<FormState>();

  // TextEditingController email = TextEditingController();
  // TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 40),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                /*   Container(
                  // group796Z38 (213:207)

                  width: double.infinity,
                  height: 70,
                  child: Image.asset(
                    'assets/appImages/appicon.png',
                    width: double.infinity,
                    height: 70,
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(110, 4, 110, 46),
                  child: SvgPicture.asset(
                    'assets/appImages/new_app_icon.svg',
                    // color: ThemeApp.primaryNavyBlackColor,
                    semanticsLabel: 'Acme Logo',

                    height: 47.67, width: 155,
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * .04,
                // ),

                Text(
                  StringUtils.forgotPassword,
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
                  StringUtils.forgotPasswordSubHeading,
                  maxLines: 4,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      color: ThemeApp.primaryNavyBlackColor),
                ),

                SizedBox(
                  height: 81,
                ),
                /*        TextFieldUtils().asteriskTextField("Email ID", context),
                TextFormFieldsWidget(
                    errorText: StringUtils.validEmailError,
                    textInputType: TextInputType.emailAddress,
                    controller: email,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: StringUtils.emailAddress,
                    onChange: (val) {
                      setState(() {
                        if (val.isEmpty && email.text.isEmpty) {
                          _validateEmail = true;
                        } else if (!StringConstant().isEmail(val)) {
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
                      } else if (!StringConstant().isEmail(value)) {
                        _validateEmail = true;
                        return StringUtils.validEmailError;
                      } else {
                        _validateEmail = false;
                      }
                      return null;
                    }),*/
                /* TextFieldUtils()
                    .asteriskTextField(StringUtils.mobileNumber, context),
                MobileNumberTextFormField(
                  controller: mobileController,
                  enable: true,
                ),*/
                TextFieldUtils()
                    .asteriskTextField(StringUtils.emailORMobile, context),
                TextFormFieldsWidget(
                    maxLength: StringConstant().isPhone(registerEmail.text)
                        ? 10
                        : null,
                    errorText: StringUtils.validemailORMobileError,
                    textInputType: TextInputType.emailAddress,
                    controller: registerEmail,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: StringUtils.emailORMobileHint,
                    preffixText: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(11.73, 12.73, 6.36, 12.73),
                      child: SvgPicture.asset(
                        'assets/appImages/Username.svg',
                        width: 16.56,
                        height: 16.56,
                      ),
                    ),
                    suffixText:
                        (!StringConstant().isEmail(registerEmail.text) &&
                                !StringConstant().isPhone(registerEmail.text))
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
                        if (val.isEmpty && registerEmail.text.isEmpty) {
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
                      if (value.isEmpty && registerEmail.text.isEmpty) {
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
                // TextFieldUtils().asteriskTextField(
                //     StringUtils.registeredEmailAddress, context),
                // EmailTextFormFieldsWidget(
                //     errorText: StringUtils.validEmailError,
                //     textInputType: TextInputType.emailAddress,
                //     controller: registerEmail,
                //     autoValidation: AutovalidateMode.onUserInteraction,
                //     hintText: StringUtils.emailAddress,
                //     onChange: (val) {
                //       setState(() {
                //         if (val.isEmpty && registerEmail.text.isEmpty) {
                //           _validateEmail = true;
                //         } else if (!StringConstant().isEmail(val) &&
                //             !StringConstant().isPhone(val)) {
                //           _validateEmail = true;
                //         } else {
                //           _validateEmail = false;
                //         }
                //       });
                //     },
                //     validator: (value) {
                //       if (value.isEmpty && registerEmail.text.isEmpty) {
                //         _validateEmail = true;
                //         return StringUtils.validateRegisteredEmail;
                //       } else if (!StringConstant().isEmail(value) &&
                //           !StringConstant().isPhone(value)) {
                //         _validateEmail = true;
                //         return StringUtils.validateRegisteredEmail;
                //       } else {
                //         _validateEmail = false;
                //       }
                //       return null;
                //     }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                ),
                proceedButton(StringUtils.resetPassword,
                    ThemeApp.tealButtonColor, context, false, () {
                  if (_formKey.currentState!.validate() &&
                      registerEmail.text.isNotEmpty) {
                    Map emaildata = {
                      "cred": registerEmail.text,
                      "credtype": "email"
                    };
                    Map mobileData = {
                      "cred": registerEmail.text,
                      "credtype": "mobile"
                    };
                    if (StringConstant().isNumeric(registerEmail.text)) {
                      print(mobileData);

                      AuthRepository()
                          .forgotPassRequest(mobileData, context)
                          .then((value) => setState(() {}));

                      print("Digit found");
                    } else {
                      print(emaildata);

                      AuthRepository()
                          .forgotPassRequest(emaildata, context)
                          .then((value) => setState(() {}));
                    }
                  } else {
                    Utils.errorToast('Please enter valid Details.');
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotSuccessDialog extends StatefulWidget {
  final String text;

  ForgotSuccessDialog({required this.text});

  @override
  State<ForgotSuccessDialog> createState() => _ForgotSuccessDialogState();
}

class _ForgotSuccessDialogState extends State<ForgotSuccessDialog> {
  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 300.0,
          maxHeight: 350.0,
          maxWidth: 330,
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                //  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(height: MediaQuery.of(context).size.height * .025,),
                    Container(
                      width: 97,
                      // height: 70,
                      child: Image.asset(
                        'assets/appImages/passwordResetIcon.png',
                        width: double.infinity,
                        height: 97,
                      ),
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    Text('Password sent successfully',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.primaryNavyBlackColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Text(
                          'We have sent a temporary password to your registered email address "${widget.text}"',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: ThemeApp.primaryNavyBlackColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    proceedButton(
                        'Sign In Now', ThemeApp.tealButtonColor, context, false,
                        () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SignIn_Screen()),
                      );
                    })
                  ],
                ),
              ),
              Positioned(
                  right: 0,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                      )))
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

class ChangeForgotPassword extends StatefulWidget {
  final String cred;
   ChangeForgotPassword({Key? key, required this.cred}) : super(key: key);

  @override
  State<ChangeForgotPassword> createState() => _ChangeForgotPasswordState();
}

class _ChangeForgotPasswordState extends State<ChangeForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  // final TextEditingController _currentPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  // bool _validateCurrentPassword = false;
  bool _validateNewPassword = false;
  bool _validateConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * .07),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: ThemeApp.appBackgroundColor,
          alignment: Alignment.center,
          child: AppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: ThemeApp.appBackgroundColor,
            flexibleSpace: Container(
              height: MediaQuery.of(context).size.height * .07,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: ThemeApp.appBackgroundColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
            ),
            titleSpacing: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) =>
                //     const DashboardScreen(),
                //   ),
                // );
              },
              child: Transform.scale(
                scale: 0.7,
                child: Image.asset(
                  'assets/appImages/backArrow.png',
                  color: ThemeApp.primaryNavyBlackColor,
                  // height: height*.001,
                ),
              ),
            ),

            // leadingWidth: width * .06,
            title: TextFieldUtils().dynamicText(
                'Change password',
                context,
                TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    // fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.height * .022,
                    fontWeight: FontWeight.w500)),
            // Row
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: MediaQuery.of(context).size.height * .7,
            decoration: BoxDecoration(
              color: ThemeApp.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 30, bottom: 30),
                child: ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    TextFieldUtils().asteriskTextField('New Password', context),
                    PasswordTextFormFieldsWidget(
                        errorText: 'please enter new password',
                        textInputType: TextInputType.text,
                        controller: _newPass,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: 'New Password',
                        onChange: (val) {
                          setState(() {
                            _checkPassword(val);
                          });
                          // setState(() {
                          //   if (val.isNotEmpty && _newPass.text.isNotEmpty) {
                          //     if (val == _currentPass.text) {
                          //       _validateNewPassword = true;
                          //     } else {
                          //       _validateNewPassword = false;
                          //     }
                          //   } else {
                          //     _validateNewPassword = true;
                          //   }
                          // });
                        },
                        validator: (value) {
                          if (value.isEmpty && _newPass.text.isEmpty) {
                            _validateNewPassword = true;
                            return 'please enter new password';
                          } else {
                            _validateNewPassword = false;
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    // The strength indicator bar
                    _newPass.text.length > 0
                        ? LinearProgressIndicator(
                            value: _strength,
                            backgroundColor: Colors.grey[300],
                            color: _strength <= 1 / 4
                                ? Colors.red
                                : _strength == 2 / 4
                                    ? Colors.yellow
                                    : _strength == 3 / 4
                                        ? Colors.blue
                                        : Colors.green,
                            minHeight: 5,
                          )
                        : SizedBox(),
                    SizedBox(height: 20),
                    TextFieldUtils()
                        .asteriskTextField('Confirm Password', context),
                    PasswordTextFormFieldsWidget(
                        errorText: 'please enter password',
                        textInputType: TextInputType.text,
                        controller: _confirmPass,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: 'Confirm Password',
                        onChange: (val) {
                          setState(() {
                            if (val.isNotEmpty &&
                                _confirmPass.text.isNotEmpty) {
                              if (val == _newPass.text) {
                                _validateConfirmPassword = false;
                              } else {
                                _validateConfirmPassword = true;
                              }
                            } else {
                              _validateConfirmPassword = true;
                            }
                          });
                        },
                        validator: (value) {
                          if (value.isNotEmpty &&
                              _confirmPass.text.isNotEmpty) {
                            if (value == _newPass.text) {
                              _validateConfirmPassword = false;
                            } else {
                              _validateConfirmPassword = true;
                              return 'New password and confirm \n password are mismatch';
                            }
                          } else {
                            _validateConfirmPassword = true;
                            return 'please enter confirmed new password';
                          }
                          return null;
                        }),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .1,
                    ),
                    proceedButton('Change Password', ThemeApp.tealButtonColor,
                        context, false, () async {
                      FocusManager.instance.primaryFocus?.unfocus();

                      if (_formKey.currentState!.validate() &&
                          _newPass.text.isNotEmpty &&
                          _confirmPass.text.isNotEmpty) {
                        if (_formKey.currentState!.validate() &&
                            _confirmPass.text == _newPass.text) {
                          Map emaildata = {
                            "cred": widget.cred,
                            "credtype": "email",
                            "newpassword":_newPass.text
                          };
                          Map mobileData = {
                            "cred": widget.cred,
                            "credtype": "email",
                            "newpassword":_newPass.text
                          };
                          if (StringConstant().isNumeric(widget.cred)) {
                            print(mobileData);

                            AuthRepository()
                                .resetPassRequest(mobileData, true,context)
                                .then((value) => setState(() { }));

                            print("Digit found");
                          } else {
                            print(emaildata);

                            AuthRepository()
                                .resetPassRequest(emaildata,true, context)
                                .then((value) => setState(() {  }));
                          }
                        } else {
                          Utils.errorToast('Please enter valid details');
                        }
                      } else {
                        if (_confirmPass.text != _newPass.text) {
                          _validateConfirmPassword = true;
                        }
                        Utils.errorToast('Please enter valid details');
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  late String _password;
  double _strength = 0;

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String _displayText = 'Please enter a password';

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty && _newPass.text.isEmpty) {
      print("strength 1");
    } else if (!StringConstant().isPass(_password)) {
      //if password not match with regex show red bar
      print("strength 2");
      setState(() {
        _strength = 1 / 4;
        _displayText = 'Your password is too short';
      });
    }
    /* else if (StringConstant().isPass(_password)) {
      print("strength 3");

      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    }  */
    else if (_password.length > 7 && _password.length < 12) {
      // password match with regex and greater than 7 to 12 then show yellow bar
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    } else if (_password.length > 11) {
      if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          _strength = 3 / 4;
          _displayText = 'Your password is strong';
        });
      } else {
        //password match and greater than 11 , show green bar
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          _strength = 1;
          _displayText = 'Your password is great';
        });
      }
    }
  }

/*static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // StreamSubscription<Position> streamSubscription = Geolocator.getPositionStream()
    //                 .listen((Position position) {
    //      position.latitude;
    //      position.longitude;
    // });
  }

  Future<String> getAddressFromLatLng() async {
    String _currentPlace = '';
    try {
      final newPosition = await determinePosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
          newPosition.latitude, newPosition.longitude);

      Placemark place = placemarks[0];
      setState(() async {
        //J5GF+W62, Dholewadi, Maharashtra, 422608, India
        _currentPlace =
        "${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}"; //here you can used place.country and other things also

        print("_currentPlace--$place");
        StringConstant.placesFromCurrentLocation = place.postalCode.toString();

        print("placesFromCurrentLocation--" +
            StringConstant.placesFromCurrentLocation);
        Prefs.instance.setToken(StringConstant.pinCodePref,
            place.postalCode.toString());
         });
    } catch (e) {
      print(e);
    }
    return _currentPlace;
  }*/

}

class ForgotPassOTP extends StatefulWidget {
  String mobileNumber = '';
  String OTP = '';

  ForgotPassOTP({
    Key? key,
    required this.mobileNumber,
    required this.OTP,
  }) : super(key: key);

  @override
  State<ForgotPassOTP> createState() => _ForgotPassOTPState();
}

class _ForgotPassOTPState extends State<ForgotPassOTP> {
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
    print(widget.OTP);
    print(widget.mobileNumber);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_start != 0) {
          return Future.value(false);
        } else {
          Navigator.of(context).pushNamed(RoutesName.signInRoute).then((value) {
            setState(() {});
          });
          return Future.value(true);
        }
      },
      child: Scaffold(
          backgroundColor: ThemeApp.appBackgroundColor,
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * .07),
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: ThemeApp.appBackgroundColor,
              alignment: Alignment.center,
              child: AppBar(
                automaticallyImplyLeading: _start != 0 ? true : false,
                centerTitle: false,
                elevation: 0,
                backgroundColor: ThemeApp.appBackgroundColor,
                flexibleSpace: Container(
                  height: MediaQuery.of(context).size.height * .07,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ThemeApp.appBackgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                ),
                titleSpacing: 0,
                leading: _start != 0
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RoutesName.signInRoute)
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: Transform.scale(
                          scale: 0.7,
                          child: Image.asset(
                            'assets/appImages/backArrow.png',
                            color: ThemeApp.primaryNavyBlackColor,
                            // height: height*.001,
                          ),
                        ),
                      ),

                // leadingWidth: width * .06,

                // Row
              ),
            ),
          ),
          /* AppBar(
      backgroundColor: ThemeApp.whiteColor,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      elevation: 0,
        ),*/
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 0, bottom: 40),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(110, 50.74, 110, 46),
                    child: SvgPicture.asset(
                      'assets/appImages/new_app_icon.svg',
                      // color: ThemeApp.primaryNavyBlackColor,
                      semanticsLabel: 'Acme Logo',

                      height: 47.67, width: 155,
                    ),
                  ),
                  /*     Container(
                    // group796Z38 (213:207)

                    width: double.infinity,
                    height: 70,
                    child: Image.asset(
                      'assets/appImages/appicon.png',
                      width: double.infinity,
                      height: 70,
                    ),
                  ),*/
                  Text(
                    StringUtils.verification,
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
                    StringUtils.verificationSubHeading,
                    maxLines: 2,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                        color: ThemeApp.primaryNavyBlackColor),
                  ),
                  // TextFieldUtils().textFieldHeightThree(
                  //     StringUtils.verification, context),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // TextFieldUtils().subHeadingTextFields(
                  //     StringUtils.verificationSubHeading,
                  //     context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextFieldUtils().dynamicText(
                        widget.mobileNumber.toString(),
                        context,
                        TextStyle(
                            fontFamily: 'Roboto',
                            color: ThemeApp.primaryNavyBlackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: PinCodeTextField(
                      autofocus: false,
                      controller: controller,
                      hideCharacter: true,
                      highlight: false,
                      defaultBorderColor: ThemeApp.whiteColor,
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
                      // pinBoxWidth: 40,
                      // pinBoxHeight: 60,
                      hasUnderline: false,
                      wrapAlignment: WrapAlignment.spaceBetween,
                      pinBoxDecoration:
                          ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                      pinTextStyle:
                          TextStyle(fontFamily: 'Roboto', fontSize: 22.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _start != 0
                          ? Center(
                              child: Text(
                                formatHHMMSS(_start),
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.primaryNavyBlackColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  _start = 120;
                                  isLoading = true;

                                  Map emaildata = {
                                    "cred": widget.mobileNumber,
                                    "credtype": "email"
                                  };
                                  Map mobileData = {
                                    "cred": widget.mobileNumber,
                                    "credtype": "mobile"
                                  };
                                  if (StringConstant()
                                      .isNumeric(widget.mobileNumber)) {
                                    print(mobileData);

                                    AuthRepository()
                                        .forgotPassRequest(mobileData, context)
                                        .then((value) => setState(() {

                                            }));

                                    print("Digit found");
                                  } else {
                                    print(emaildata);

                                    AuthRepository()
                                        .forgotPassRequest(emaildata, context)
                                        .then((value) => setState(() {}));
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
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .025,
                  ),
                  proceedButton(StringUtils.verifyOTP, ThemeApp.tealButtonColor,
                      context, false, () async {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         DashboardScreen(),
                    //   ),
                    // );
                    if (controller.text.length >= 6) {
                      print(widget.OTP);
                      print(controller.text);
                      if (controller.text==widget.OTP) {

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => ChangeForgotPassword(cred: widget.mobileNumber)));
                      } else {
                        Utils.errorToast("Please enter valid details.");
                      }
                    } else {
                      Utils.errorToast("Please enter 6 digit OTP");
                    }
                  }),
                ],
              ),
            ),
          )),
    );
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
