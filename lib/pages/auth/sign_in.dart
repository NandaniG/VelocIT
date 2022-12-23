import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/Core/ViewModel/auth_view_model.dart';
import 'package:velocit/pages/auth/OTP_Screen.dart';
import 'package:velocit/pages/auth/Sign_Up.dart';
import 'package:velocit/pages/screens/dashBoard.dart';

import '../../Core/repository/auth_repository.dart';
import '../../services/providers/Home_Provider.dart';
import '../../utils/StringUtils.dart';
import '../../utils/constants.dart';
import '../../utils/routes/routes.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/proceedButtons.dart';
import '../../widgets/global/textFormFields.dart';
import 'forgot_password.dart';

class SignIn_Screen extends StatefulWidget {
  @override
  State<SignIn_Screen> createState() => _SignIn_ScreenState();
}

class _SignIn_ScreenState extends State<SignIn_Screen> {
  TextEditingController email = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _usingPassVisible = false;
  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _validateEmail = false;
  bool _validateMobile = false;
  bool _validatePassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usingPassVisible = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeProvider>(context, listen: false).loadJson();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    email.dispose();
    mobileController.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      TextFieldUtils()
                          .textFieldHeightThree(StringUtils.signin, context),
                      const SizedBox(
                        height: 5,
                      ),
                      // Text(StringUtils!.helloWorld);

                      TextFieldUtils().subHeadingTextFields(
                          StringUtils.signinSubTitle, context),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .04,
                      ),
                      Row(
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
                                child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 15.0, 0, 15.0),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      color: _usingPassVisible
                                          ? ThemeApp.whiteColor
                                          : ThemeApp.appColor,
                                    ),
                                    child: TextFieldUtils().usingPassTextFields(
                                        StringUtils.usingPass,
                                        _usingPassVisible
                                            ? ThemeApp.blackColor
                                            : ThemeApp.whiteColor,
                                        context))),
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
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 15.0, 0, 15.0),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      color: _usingPassVisible
                                          ? ThemeApp.appColor
                                          : ThemeApp.whiteColor,
                                    ),
                                    child: TextFieldUtils().usingPassTextFields(
                                        StringUtils.usingOTP,
                                        _usingPassVisible
                                            ? ThemeApp.whiteColor
                                            : ThemeApp.blackColor,
                                        context))),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .04,
                      ),
                      !_usingPassVisible
                          ? TextFieldUtils().asteriskTextField(
                              StringUtils.emailAddress, context)
                          : TextFieldUtils().asteriskTextField(
                              StringUtils.mobileNumber, context),

                      !_usingPassVisible
                          ? TextFormFieldsWidget(
                              errorText: StringUtils.emailError,
                              textInputType: TextInputType.emailAddress,
                              controller: email,
                              autoValidation:
                                  AutovalidateMode.onUserInteraction,
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
                                  return StringUtils.emailError;
                                } else if (!StringConstant().isEmail(value)) {
                                  _validateEmail = true;
                                  return StringUtils.emailError;
                                } else {
                                  _validateEmail = false;
                                }
                                return null;
                              })
                          : const SizedBox(
                              height: 0,
                            ),
                      !_usingPassVisible
                          ? const SizedBox(
                              height: 0,
                            )
                          : TextFormFieldsWidget(
                              errorText: StringUtils.emailError,
                              textInputType: TextInputType.phone,
                              controller: mobileController,
                              autoValidation:
                                  AutovalidateMode.onUserInteraction,
                              hintText: StringUtils.mobileNumber,
                              onChange: (val) {
                                setState(() {
                                  if (val.isEmpty &&
                                      mobileController.text.isEmpty) {
                                    _validateMobile = true;
                                  } else if (!StringConstant().isPhone(val)) {
                                    _validateMobile = true;
                                  } else {
                                    _validateMobile = false;
                                  }
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty &&
                                    mobileController.text.isEmpty) {
                                  _validateMobile = true;
                                  return StringUtils.mobileError;
                                } else if (!StringConstant().isPhone(value)) {
                                  _validateMobile = true;
                                  return StringUtils
                                      .mobileError;
                                } else {
                                  _validateMobile = false;
                                }
                                return null;
                              }),
                      !_usingPassVisible
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * .02,
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      !_usingPassVisible
                          ? TextFieldUtils().asteriskTextField(
                          StringUtils.password, context)
                          : const SizedBox(
                              height: 0,
                            ),
                      !_usingPassVisible
                          ? PasswordTextFormFieldsWidget(
                              errorText:
                              StringUtils.passwordError,
                              textInputType: TextInputType.text,
                              controller: password,
                              autoValidation:
                                  AutovalidateMode.onUserInteraction,
                              hintText:StringUtils.password,
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
                                  return StringUtils
                                      .passwordError;
                                } else if (!StringConstant().isPass(value)) {
                                  _validatePassword = true;
                                  return StringUtils
                                      .validPasswordError;
                                } else {
                                  _validatePassword = false;
                                }
                                return null;
                              })
                          : const SizedBox(
                              height: 0,
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .008,
                      ),
                      !_usingPassVisible
                          ? Container(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPassword()),
                                  );
                                },
                                child: TextFieldUtils().hyperLinkTextFields(
                                    StringUtils.forgotPassword,
                                    context),
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      !_usingPassVisible
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * .02,
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      proceedButton(
                          !_usingPassVisible
                              ? StringUtils.signin
                              : StringUtils.sendOtp,
                          ThemeApp.tealButtonColor,
                          context,
                          authViewModel.loadingWithGet, () async {
                        setState(() {
                          Prefs.instance
                              .setToken(StringConstant.emailPref, email.text);
                          if (!_usingPassVisible) {
                            if (_formKey.currentState!.validate() &&
                                email.text.isNotEmpty &&
                                password.text.isNotEmpty) {
                              Prefs.instance.setToken(
                                  StringConstant.emailOTPPref,
                                  mobileController.text);

                              // Map data = {
                              //   'email': email.text,
                              //   'password': password.text
                              // };
                              Map data = {
                                'email': email.text,
                                'password': password.text
                              };
                              Map mobileData = {
                                'mobile': email.text,
                                'password': password.text
                              };

                              if (StringConstant().isNumeric(email.text)) {
                                print("Digit found");
                              } else {
                                AuthRepository()
                                    .postApiUsingEmailRequest(data, context);


                                print("Digit not found");
                              }
                            } else {
                              Utils.errorToast("Please enter Details.");
                            }
                          } else {
                            if (mobileController.text.isNotEmpty) {
                              authViewModel.loginApiWithGet(context);

                              Prefs.instance.setToken(
                                  StringConstant.emailOTPPref,
                                  mobileController.text);
                              Map mobileData = {
                                'mobile': mobileController.text,
                                'password': password.text
                              };

                              // AuthRepository().postApiUsingMobileRequest(
                              //     mobileData, context);
                              /*   if (StringConstant().isNumeric(email.text)) {
                                AuthRepository().postApiUsingMobileRequest(
                                    mobileData, context);
                                print("Digit found");
                              } else {

                                print("Digit not found");
                              }*/
                            } else {
                              Utils.errorToast("Please enter valid Details.");
                            }
                            print(mobileController.text);
                          }
                        });
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 190, bottom: 10),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                            color: ThemeApp.primaryNavyBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUp()));
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: ThemeApp.primaryNavyBlackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
