import 'package:flutter/material.dart';
import 'package:velocit/pages/screens/dashBoard.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/StringUtils.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../widgets/global/okPopUp.dart';
import '../../widgets/global/proceedButtons.dart';
import '../../widgets/global/textFormFields.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool _validateCurrentPassword = false;
  bool _validateNewPassword = false;
  bool _validateConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
/*      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: ThemeApp.whiteColor,
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon:
                    Icon(Icons.arrow_back, color: ThemeApp.blackColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                TextFieldUtils().appBarTextField(StringUtils
                    .changePassword, context),
              ],
            ),
          )),*/
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * .07),
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
                TextStyle(fontFamily: 'Roboto',
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
            height: MediaQuery
                .of(context)
                .size
                .height * .6,
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
                    TextFieldUtils()
                        .titleTextFields(StringUtils
                        .currentPassword, context),
                    PasswordTextFormFieldsWidget(
                        errorText: StringUtils
                            .passwordError,
                        textInputType: TextInputType.text,
                        controller: _currentPass,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: StringUtils
                            .currentPassword,
                        onChange: (val) {
                          setState(() {
                            if (val.isEmpty && _currentPass.text.isEmpty) {
                              _validateCurrentPassword = true;
                            } else {
                              _validateCurrentPassword = false;
                            }
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty && _currentPass.text.isEmpty) {
                            _validateCurrentPassword = true;
                            return 'please enter password';
                          } else {
                            _validateCurrentPassword = false;
                          }
                          return null;
                        }),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .02,
                    ),
                    TextFieldUtils().titleTextFields('New Password *', context),
                    PasswordTextFormFieldsWidget(
                        errorText: 'please enter new password',
                        textInputType: TextInputType.text,
                        controller: _newPass,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: 'New Password',
                        onChange: (val) {setState(() {
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
                          if (value.isNotEmpty && _newPass.text.isNotEmpty) {
                            if (value != _currentPass.text) {
                              _validateNewPassword = false;
                            } else {
                              _validateNewPassword = true;
                              return 'This looks like same as \n current password';
                            }
                          } else {
                            _validateNewPassword = true;
                            return 'please enter new password';
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
                        .titleTextFields('Confirm Password *', context),
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
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .025,
                    ),
                    proceedButton('Change Password',ThemeApp.tealButtonColor, context, false,() async{                        FocusManager.instance.primaryFocus?.unfocus();

                    if (_formKey.currentState!.validate() &&
                          _currentPass.text.isNotEmpty &&
                          _newPass.text.isNotEmpty &&
                          _confirmPass.text.isNotEmpty) {
                        if (_formKey.currentState!.validate() &&
                            _currentPass.text != _newPass.text &&
                            _confirmPass.text == _newPass.text) {


                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen(),), (route) => false);

                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return OkDialog(
                                    text: "Please enter correct data");
                              });
                        }
                      } else {
                        if (_currentPass.text == _newPass.text) {
                          _validateNewPassword = true;
                        }
                        if (_confirmPass.text != _newPass.text) {
                          _validateConfirmPassword = true;
                        }
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return OkDialog(
                                  text: "Please enter all details Sign In");
                            });
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
    }/* else if (StringConstant().isPass(_password)) {
      print("strength 3");

      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    }  */else if (_password.length > 7&& _password.length<12) {
      // password match with regex and greater than 7 to 12 then show yellow bar
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    }else if(_password.length>11){

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
