import 'package:flutter/material.dart';
import 'package:velocit/pages/screens/dashBoard.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      backgroundColor: ThemeApp.backgroundColor,
      appBar: PreferredSize(
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
                TextFieldUtils().appBarTextField(AppLocalizations
                    .of(context)
                    .changePassword, context),
              ],
            ),
          )),
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
                        .titleTextFields(AppLocalizations
                        .of(context)
                        .changePassword, context),
                    PasswordTextFormFieldsWidget(
                        errorText: AppLocalizations
                            .of(context)
                            .passwordError,
                        textInputType: TextInputType.text,
                        controller: _currentPass,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: AppLocalizations
                            .of(context)
                            .password,
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
                        onChange: (val) {
                          setState(() {
                            if (val.isNotEmpty && _newPass.text.isNotEmpty) {
                              if (val == _currentPass.text) {
                                _validateNewPassword = true;
                              } else {
                                _validateNewPassword = false;
                              }
                            } else {
                              _validateNewPassword = true;
                            }
                          });
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
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .02,
                    ),
                    TextFieldUtils()
                        .titleTextFields('Confirm Password *', context),
                    PasswordTextFormFieldsWidget(
                        errorText: 'please enter password',
                        textInputType: TextInputType.text,
                        controller: _confirmPass,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: 'Password',
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
                    proceedButton('Change Password',ThemeApp.blackColor, context, false,() async{
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
