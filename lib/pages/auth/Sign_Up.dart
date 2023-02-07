import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/pages/auth/sign_in.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../Core/AppConstant/apiMapping.dart';
import '../../utils/constants.dart';
import '../../utils/routes/routes.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/textFormFields.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/dashBoard.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = new TextEditingController();
  TextEditingController businessNameController = new TextEditingController();
  TextEditingController mobileNumberController = new TextEditingController();
  TextEditingController emailOtp = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _validateName = false;
  bool _validateEmail = false;
  bool _validateMobile = false;
  bool _validateEmailOtp = false;
  bool _validatePassword = false;
  bool _validateConfirmPassword = false;
  double height = 0.0;
  double width = 0.0;
  bool isTermSelected = false;
  var isTermError = '';

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // group796Z38 (213:207)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(110, 50.74, 110, 46),
                        child: SvgPicture.asset(
                          'assets/appImages/new_app_icon.svg',
                          // color: ThemeApp.primaryNavyBlackColor,
                          semanticsLabel: 'Acme Logo',

                          height: 47.67, width: 155,
                        ),
                      ),
                      /*         width: double.infinity,
                        height: 70,
                        child: Image.asset(
                          'assets/appImages/appicon.png',
                          width: double.infinity,
                          height: 70,
                        ),
                      ),*/
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * .04,
                      // ),

                      Text(
                        'Create an Account',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            color: ThemeApp.primaryNavyBlackColor),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      // Text(StringUtils!.helloWorld);
                      Text(
                        'Signup to continue',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            color: ThemeApp.primaryNavyBlackColor),
                      ),
                      SizedBox(
                        height: 33,
                      ),
                      fullName(),
                      SizedBox(
                        height: 20,
                      ),

                      TextFieldUtils()
                          .asteriskTextField(StringUtils.emailAddress, context),

                      EmailTextFormFieldsWidget(
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
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      mobileNumber(),
                      SizedBox(
                        height: 20,
                      ),

                      Row(
                        children: [
                          TextFieldUtils()
                              .asteriskTextField(StringUtils.password, context),
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
                            child: Icon(Icons.info_outline),
                          )
                        ],
                      ),
                      PasswordTextFormFieldsWidget(
                          errorText: StringUtils.passwordError,
                          textInputType: TextInputType.text,
                          controller: password,
                          autoValidation: AutovalidateMode.onUserInteraction,
                          hintText: StringUtils.password,
                          onChange: (val) {
                            _checkPassword(val);

                            // setState(() {
                            //     if (val.isEmpty && password.text.isEmpty) {
                            //       _validatePassword = true;
                            //     } else if (!StringConstant().isPass(val)) {
                            //       _validatePassword = true;
                            //     } else {
                            //       _validatePassword = false;
                            //     }
                            //   });
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
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      // The strength indicator bar
                      password.text.length > 0
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
                  /*    SizedBox(height: 20),
                      Text(
                        _displayText,
                        style: const TextStyle(fontSize: 18),
                      ),*/
                      SizedBox(height: 20),
                      TextFieldUtils().asteriskTextField(
                          StringUtils.confirmPassword, context),

                      PasswordTextFormFieldsWidget(
                          errorText: StringUtils.confirmPasswordError,
                          textInputType: TextInputType.text,
                          controller: confirmPassword,
                          autoValidation: AutovalidateMode.onUserInteraction,
                          hintText: StringUtils.confirmPassword,
                          onChange: (val) {
                            setState(() {
                              if (confirmPassword.text != password.text) {
                                _validateConfirmPassword = true;
                              } else if (!StringConstant().isPass(val)) {
                                _validateConfirmPassword = true;
                              } else {
                                _validateConfirmPassword = false;
                              }
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty && password.text.isEmpty) {
                              _validateConfirmPassword = true;
                              return StringUtils.confirmPasswordError;
                            } else if (confirmPassword.text != password.text) {
                              _validateConfirmPassword = true;
                              return StringUtils.validConfirmPasswordError;
                            } else {
                              _validateConfirmPassword = false;
                            }
                            return null;
                          }),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: isTermSelected,
                            onChanged: (values) {
                              setState(() {
                                isTermSelected = values!;
                              });
                            },
                          ),
                          Row(
                            children: [
                              TextFieldUtils().dynamicText(
                                  'I agree with ',
                                  context,
                                  TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.blackColor,
                                    fontSize: height * .018,
                                    fontWeight: FontWeight.w500,
                                  )),
                              InkWell(
                                onTap: () {
                                  _launchURL();
                                },
                                child: TextFieldUtils().dynamicText(
                                    'Terms and Conditions',
                                    context,
                                    TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.tealButtonColor,
                                      fontSize: height * .018,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 3,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      isTermSelected == false
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                isTermError,
                                style: TextStyle(color: ThemeApp.redColor),
                              ),
                            )
                          : Text(''),
                      SizedBox(
                        height: 45,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: proceedButton(
                            'Create an Account',
                            ThemeApp.tealButtonColor,
                            context,
                         false, () {
                          FocusManager.instance.primaryFocus?.unfocus();

                          if (isTermSelected == false) {
                            setState(() {
                              isTermError =
                                  'Please accept the terms and conditions.';
                            });
                          } else {
                            setState(() {
                              isTermError = '';
                            });
                          }
                          if (_formKey.currentState!.validate() &&
                              isTermSelected == true) {
                            Map data = {
                              "username": businessNameController.text,
                              "password": password.text.trim(),
                              "email": email.text,
                              "mobile": mobileNumberController.text,
                            };
                            apiRequest(data);

                            // authViewModel.authSignUpUsingPost(data, context);
                          } else {
                            Utils.errorToast("Please enter valid details");
                          }

                        }),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      /*     Row(
                        children: [
                          Checkbox(
                            value: isTermSelected,
                            onChanged: (values) {
                              setState(() {
                                isTermSelected = values!;
                                isTermError = 'Please select';
                              });
                            },
                          ),
                          Row(
                            children: [
                              TextFieldUtils().dynamicText(
                                  'I agree with ',
                                  context,
                                  TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.blackColor,
                                    fontSize: height * .018,
                                    fontWeight: FontWeight.w500,
                                  )),
                              InkWell(
                                onTap: () {
                                  _launchURL();
                                },
                                child: TextFieldUtils().dynamicText(
                                    'Terms and Conditions',
                                    context,
                                    TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.tealButtonColor,
                                      fontSize: height * .018,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 3,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),*/
                      /*       CheckboxListTile(
                value: isTermSelected,
                onChanged: (val) {
                  setState(() => isTermSelected = val!
                  );},
                subtitle: !isTermSelected
                    ? Text(
                  isTermError,
                  style: TextStyle(color: Colors.red),
                )
                    : null,
                title: new Text(
                  'I agree.',
                  style: TextStyle(fontSize: 14.0),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.green,
              ),*/
                    /*  Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.primaryNavyBlackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            InkWell(
                              onTap: () {
                                businessNameController.clear();
                                mobileNumberController.clear();
                                emailOtp.clear();
                                password.clear();
                                confirmPassword.clear();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => SignIn_Screen()));
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.primaryNavyBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
*/

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
                                  "Already have an account? ",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.primaryNavyBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                InkWell(
                                  onTap: () {
                                    businessNameController.clear();
                                    mobileNumberController.clear();
                                    emailOtp.clear();
                                    password.clear();
                                    confirmPassword.clear();
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (context) => SignIn_Screen())).then((value) => setState((){}));
                                  },
                                  child: Text(
                                    "Sign In",
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
                                  onTap: (){
                                    Navigator.of(context).pushNamedAndRemoveUntil(RoutesName.dashboardRoute, (route) => false).then((value) {
                                      setState(() {

                                      });
                                    });   },
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

                // const Positioned(
                //     bottom: 0.0,
                //     right: 0.0,
                //     left: 0.0,
                //     child: Center(
                //       child: Text(
                //         "Don't have an account? Create Account",
                //         style: TextStyle(fontFamily: 'Roboto',
                //             color: Color(0xffF6C37F),
                //             fontSize: 18,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     )),
              ],
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

    if (_password.isEmpty && password.text.isEmpty) {
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

/*  void _checkPassword(String value) {
    _password = value.trim();

    if (value.isEmpty && password.text.isEmpty) {
      setState(() {
        _validatePassword = true;
        _strength = 0;
        _displayText = 'Please enter you password';
      });
    } else if (!StringConstant().isPass(value)) {
      setState(() {
        _validatePassword = true;
        _strength = 1 / 16;
        _displayText = 'Your password is not acceptable';
      });
    } else if (StringConstant().isPass(value)) {
      setState(() {
        _strength = 8 / 16;
        _displayText = 'Your password is acceptable but not strong';

        _validatePassword = false;
      });
    } else {
      // if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
      if (_strength>9) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          _strength = 8/ 16;
          _displayText = 'Your password is strong';
        });
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          _strength = 1;
          _displayText = 'Your password is great';
        });
      }
    }

    */ /* if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = 'Please enter you password';
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    } else if (_password.length < 9) {
      setState(() {
        if (value.isEmpty && password.text.isEmpty) {
          _validatePassword = true;
          _strength = 2 / 4;
          _displayText = 'Your password is acceptable but not strong';
        } else if (!StringConstant().isPass(value)) {
          _validatePassword = true;
          _strength = 2 / 4;
          _displayText = 'Your password is acceptable but not strong';
        } else {
          _validatePassword = false;
        }
        // _strength = 2 / 4;
        // _displayText = 'Your password is acceptable but not strong';
      });
    } else {
      if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          if (value.isEmpty && password.text.isEmpty) {
            _validatePassword = true;
          } else if (!StringConstant().isPass(value)) {
            _validatePassword = true;
          } else {
            _strength = 3 / 4;
            _displayText = 'Your password is strong';

            _validatePassword = false;
          }
        });
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          _strength = 1;
          _displayText = 'Your password is great';
        });
      }
    }*/ /*
  }*/

  Widget fullName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().asteriskTextField(StringUtils.fullName, context),
        CharacterTextFormFieldsWidget(
            errorText: 'Please enter Name',
            textInputType: TextInputType.name,
            controller: businessNameController,
            autoValidation: AutovalidateMode.onUserInteraction,
            hintText: 'Type your name',
            onChange: (val) {
              setState(() {
                if (val.isEmpty && businessNameController.text.isEmpty) {
                  _validateName = true;
                } else if (businessNameController.text.length < 4) {
                  _validateName = true;
                } else {
                  _validateName = false;
                }
              });
            },
            validator: (value) {
              if (value.isEmpty && businessNameController.text.isEmpty) {
                _validateName = true;
                return StringUtils.enterFullName;
              } else if (businessNameController.text.length < 4) {
                _validateName = true;
                return StringUtils.enterFullName;
              } else {
                _validateName = false;
              }
              return null;
            }),
      ],
    );
  }

  Widget mobileNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().asteriskTextField(StringUtils.mobileNumber, context),
        MobileNumberTextFormField(
            errorText: StringUtils.enterMobileNumber,
            controller: mobileNumberController,
            enable: true,
            onChanged: (phone) {
              print('phone.completeNumber');
              print(phone.completeNumber);
        if (phone.countryCode == "IN") {
          print("india selected");
          print(phone.completeNumber);
        } else {
          print("india not selected");
        }     if (phone==''  && mobileNumberController.text.isEmpty) {
              _validateMobile = true;
              return StringUtils.enterMobileNumber;
              } else if (mobileNumberController.text.length < 10) {
              _validateMobile = true;
              return StringUtils.enterMobileNumber;
              } else {
              _validateMobile = false;
              }
        },
            validator: (value) {
              if (value.number.isEmpty && mobileNumberController.text.isEmpty) {
                _validateMobile = true;
                return StringUtils.enterMobileNumber;
              } else if (mobileNumberController.text.length < 10) {
                _validateMobile = true;
                return StringUtils.enterMobileNumber;
              } else {
                _validateMobile = false;
              }
              return null;
            }),
      ],
    );
  }

  _launchURL() async {
    const url = 'https://codeelan.com';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future apiRequest(Map jsonMap) async {
    var url = ApiMapping.getURI(apiEndPoint.auth_signUp_using_post);
    print("SignUp URL " + url.toString());
    print("SignUp Data " + jsonMap.toString());

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    dynamic reply = await response.transform(utf8.decoder).join();
    String rawJson = reply.toString();
    print(reply);


 Map<String, dynamic> map = jsonDecode(rawJson);
    if (response.statusCode == 200) {
      String name = map['message'];
      Utils.successToast(name.toString());
      print("SignUp response " + name.toString());

      // Utils.successToast(name.toString());
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => SignIn_Screen()));
      businessNameController.clear();

      mobileNumberController.clear();
      email.clear();
      password.clear();
      confirmPassword.clear();
      print(reply.toString());
    } else {
      // Utils.errorToast(name.toString());
      Utils.errorToast(map['error'].toString());
      }

    httpClient.close();
    return reply;
  }
}
