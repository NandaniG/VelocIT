import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Core/Enum/viewState.dart';
import '../../Core/Service/authenticateWithUID_Service.dart';
import '../../Core/ViewModel/authenticateWithUID_Provider.dart';
import '../../services/providers/Home_Provider.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/proceedButtons.dart';
import '../../widgets/global/textFormFields.dart';
import '../../widgets/global/toastMessage.dart';
import 'OTP_Screen.dart';
import 'forgot_password.dart';

class SignIn_Screen extends StatefulWidget {
  @override
  State<SignIn_Screen> createState() => _SignIn_ScreenState();
}

class _SignIn_ScreenState extends State<SignIn_Screen> {
  TextEditingController email = TextEditingController();
  TextEditingController emailOtp = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _usingPassVisible = false;
  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _validateEmail = false;
  bool _validateEmailOtp = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeApp.whiteColor,
        body: Container(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 40),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFieldUtils().textFieldHeightThree(
                    AppLocalizations.of(context).signin, context),
                const SizedBox(
                  height: 5,
                ),
                // Text(AppLocalizations.of(context)!.helloWorld);

                TextFieldUtils().subHeadingTextFields(
                    AppLocalizations.of(context).signinSubTitle, context),
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
                              // email.clear();
                              // _usingPassVisible==true ? _validateEmail = true:_validateEmail=false;
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                color: _usingPassVisible
                                    ? ThemeApp.lightGreyTab
                                    : ThemeApp.darkGreyTab,
                              ),
                              child: TextFieldUtils().usingPassTextFields(
                                  AppLocalizations.of(context).usingPass,
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

                              // email.clear();
                              // _usingPassVisible==true ? _validateEmail = true:_validateEmail=false;
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: _usingPassVisible
                                    ? ThemeApp.darkGreyTab
                                    : ThemeApp.lightGreyTab,
                              ),
                              child: TextFieldUtils().usingPassTextFields(
                                  AppLocalizations.of(context).usingOTP,
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
                TextFieldUtils().titleTextFields(
                    AppLocalizations.of(context).emailORMobile, context),

                !_usingPassVisible
                    ? TextFormFieldsWidget(
                        errorText: AppLocalizations.of(context).emailError,
                        textInputType: TextInputType.emailAddress,
                        controller: email,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: AppLocalizations.of(context).emailORMobile,
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
                            return AppLocalizations.of(context).validEmailError;
                          } else if (!StringConstant().isEmail(value) &&
                              !StringConstant().isPhone(value)) {
                            _validateEmail = true;
                            return AppLocalizations.of(context).validEmailError;
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
                        errorText: AppLocalizations.of(context).emailError,
                        textInputType: TextInputType.emailAddress,
                        controller: emailOtp,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: AppLocalizations.of(context).emailORMobile,
                        onChange: (val) {
                          setState(() {
                            if (val.isEmpty && emailOtp.text.isEmpty) {
                              _validateEmailOtp = true;
                            } else if (!StringConstant().isEmail(val) &&
                                !StringConstant().isPhone(val)) {
                              _validateEmail = true;
                            } else {
                              _validateEmailOtp = false;
                            }
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty && emailOtp.text.isEmpty) {
                            _validateEmailOtp = true;
                            return AppLocalizations.of(context).validEmailError;
                          } else if (!StringConstant().isEmail(value) &&
                              !StringConstant().isPhone(value)) {
                            _validateEmail = true;
                            return AppLocalizations.of(context).validEmailError;
                          } else {
                            _validateEmailOtp = false;
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
                    ? TextFieldUtils().titleTextFields(
                        AppLocalizations.of(context).password, context)
                    : const SizedBox(
                        height: 0,
                      ),
                !_usingPassVisible
                    ? PasswordTextFormFieldsWidget(
                        errorText: AppLocalizations.of(context).passwordError,
                        textInputType: TextInputType.text,
                        controller: password,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: AppLocalizations.of(context).password,
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
                            return AppLocalizations.of(context).passwordError;
                          } else if (!StringConstant().isPass(value)) {
                            _validatePassword = true;
                            return AppLocalizations.of(context)
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
                  height: MediaQuery.of(context).size.height * .02,
                ),
                !_usingPassVisible
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()),
                          );
                        },
                        child: TextFieldUtils().hyperLinkTextFields(
                            AppLocalizations.of(context).forgotPassword,
                            context),
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
                Consumer<AuthenticateWithUIDProvider>(
                    builder: (context, provider, child) {
                  // provider.isLoading=false;
                  return provider.isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ThemeApp.blackColor,
                          ),
                        )
                      : proceedButton(
                          !_usingPassVisible
                              ? AppLocalizations.of(context).signin
                              : AppLocalizations.of(context).sendOtp,
                          ThemeApp.blackColor,
                          context, () async {
                          setState(() {
                            provider.isLoading = true;
                          });
                          setState(() {
                            Prefs()
                                .setToken(StringConstant.emailPref, email.text);
                            // successToast(provider.service.Otp.toString());

                            if (!_usingPassVisible) {
                              if (_formKey.currentState!.validate() &&
                                  email.text.isNotEmpty &&
                                  password.text.isNotEmpty) {
                                if ((email.text == 'codeelan@gmail.com' ||
                                        email.text == '7990916638') &&
                                    password.text == "CodeElan@123") {
                                  provider.getAuthenticateWithUID();


                                  Timer(const Duration(seconds: 3), () {
                                    setState(() {
                                      provider.isLoading = false;
                                    });
                                    successToast(provider.service.Otp);

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => OTPScreen(
                                            Otp: provider.service.Otp
                                                .toString(),
                                          service: provider.service,
                                        ),
                                      ),
                                    );
                                  });

                                  print(email.text);
                                } else {
                                  final snackBar = const SnackBar(
                                    content: Text('Please enter valid Details'),
                                    clipBehavior: Clip.antiAlias,
                                    backgroundColor: ThemeApp.greenappcolor,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              } else {
                                errorToast("Please enter valid Details.");
                              }
                            } else {
                              if (emailOtp.text.isNotEmpty &&
                                  (emailOtp.text == 'codeelan@gmail.com' ||
                                      emailOtp.text == '7990916638')) {
                                Prefs().setToken(
                                    StringConstant.emailOTPPref, emailOtp.text);

                                provider.getAuthenticateWithUID();
                                provider.getUserList();
                                provider.postUserData();

                                print(provider.service);
                                print(provider.isLoading);
                                Timer(const Duration(seconds: 3), () {

                                  setState(() {
                                    provider.isLoading = false;
                                  });
                                  successToast(provider.service.Otp);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => OTPScreen(
                                          Otp: provider.service.Otp.toString(),
                                           service: provider.service,

                                      ),
                                    ),
                                  );
                                });
                              } else {
                                errorToast("Please enter valid Details.");
                              }
                              print(emailOtp.text);
                            }
                          });
                        });
                }),
              ],
            ),
          ),
        ));
  }
}
