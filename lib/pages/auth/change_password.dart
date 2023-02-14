import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/pages/screens/dashBoard.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Core/repository/auth_repository.dart';
import '../../utils/StringUtils.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
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
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  final TextEditingController _currentPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool _validateCurrentPassword = false;
  bool _validateNewPassword = false;
  bool _validateConfirmPassword = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getPref();
  }

  var userEmail;
  var userMobile;

  getPref() async {
    final prefs = await SharedPreferences.getInstance();

    userEmail = prefs.getString('userProfileEmailPrefs');
    userMobile = prefs.getString('userProfileMobilePrefs');
    print(userMobile);
    print(userEmail);
  }

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
                    TextFieldUtils().asteriskTextField(
                        StringUtils.currentPassword, context),


                    PasswordTextFormFieldsWidget(
                        errorText: StringUtils.passwordError,
                        textInputType: TextInputType.text,
                        controller: _currentPass,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: StringUtils.currentPassword,
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
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Row(
                      children: [
                        TextFieldUtils().asteriskTextField('New Password', context),
                        SizedBox(
                          width: 5,
                        ),
                        Tooltip(
                          key: tooltipkey,
                          message:
                          'Enter Password that must be\n\u2022 8-16 characters long\n\u2022 Must contain a number\n\u2022 Must contain a capital and small letter\n\u2022 Must contain a special character',
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(
                              top: 30, left: 30, right: 30),
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 2),
                          decoration: BoxDecoration(
                              color: ThemeApp.appColor,
                              borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          child: Icon(Icons.info_outline,color: ThemeApp.appColor),
                        )
                      ],
                    ),
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
                          _currentPass.text.isNotEmpty &&
                          _newPass.text.isNotEmpty &&
                          _confirmPass.text.isNotEmpty) {
                        if (_formKey.currentState!.validate() &&
                            _currentPass.text != _newPass.text &&
                            _confirmPass.text == _newPass.text) {
                          Map emaildata = {
                            "cred": userEmail,
                            "credtype": "email",
                            "newpassword": _newPass.text
                          };
                          Map mobileData = {
                            "cred": userMobile,
                            "credtype": "email",
                            "newpassword": _newPass.text
                          };
                          if (userEmail.toString().isEmpty) {
                            print(mobileData);

                            AuthRepository()
                                .resetPassRequest(mobileData,true, context)
                                .then((value) => setState(() {

                                    }));

                            print("Digit found");
                          } else {
                            print(emaildata);

                            AuthRepository()
                                .resetPassRequest(emaildata,false, context)
                                .then((value) => setState(() {

                                    }));
                          }
                        } else {
                          Utils.errorToast('Please enter valid details');
                        }
                      } else {
                        if (_currentPass.text == _newPass.text) {
                          _validateNewPassword = true;
                        }
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
}
