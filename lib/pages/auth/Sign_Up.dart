import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/pages/auth/sign_in.dart';
import 'package:velocit/services/models/JsonModelForApp/SignIn.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../Core/AppConstant/apiMapping.dart';
import '../../Core/Model/SignUpModel.dart';
import '../../Core/ViewModel/auth_view_model.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/textFormFields.dart';
import 'forgot_password.dart';

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
  bool _validateEmailOtp = false;
  bool _validatePassword = false;
  bool _validateConfirmPassword = false;
  double height = 0.0;
  double width = 0.0;
  bool isTermSelected = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final authViewModel = Provider.of<AuthViewModel>(context);

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
                        padding: const EdgeInsets.fromLTRB(122, 50, 121, 46),
                        child: SvgPicture.asset(
                          'assets/appImages/new_app_icon.svg',
                          // color: ThemeApp.primaryNavyBlackColor,
                          semanticsLabel: 'Acme Logo',

                          height: 40, width: 132,
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
                        height: 8,
                      ),
                      // Text(StringUtils!.helloWorld);
            Text(
              'Signup to continue',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w400,
                  color: ThemeApp.primaryNavyBlackColor),),
                      SizedBox(
                        height: 33,
                      ),
                      fullName(),
                      SizedBox(
                        height: 20,
                      ),
                      mobileNumber(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      TextFieldUtils()
                          .asteriskTextField(StringUtils.emailAddress, context),

                      TextFormFieldsWidget(
                          errorText: StringUtils.emailError,
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

                      const SizedBox(
                        height: 0,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
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
                                'Enter Password that must be\n(i) 8-16 characters long\n(ii) Must contain a number\n(iii) Must contain a capital and small letter\n(iv)Must contain a special character',
                            padding: const EdgeInsets.all(30),
                            margin: const EdgeInsets.only(
                                top: 30, left: 30, right: 30),
                            triggerMode: TooltipTriggerMode.tap,
                            showDuration: const Duration(seconds: 2),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(22)),
                            textStyle: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                letterSpacing: 1.2,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
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
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      TextFieldUtils().asteriskTextField(
                          StringUtils.confirmPassword, context),

                      PasswordTextFormFieldsWidget(
                          errorText: StringUtils.passwordError,
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
                              return StringUtils.passwordError;
                            } else if (confirmPassword.text != password.text) {
                              _validateConfirmPassword = true;
                              return StringUtils.validPasswordError;
                            } else {
                              _validateConfirmPassword = false;
                            }
                            return null;
                          }),

                      SizedBox(
                        height: 53,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: proceedButton(
                            'Create an Account',
                            ThemeApp.tealButtonColor,
                            context,
                            authViewModel.loadingWithAuthUSerPost, () {
                          FocusManager.instance.primaryFocus?.unfocus();

                          if (_formKey.currentState!.validate()&&isTermSelected==true) {
                            Map data = {
                              "username": businessNameController.text,
                              "password": password.text.trim(),
                              "email": email.text,
                              "mobile": mobileNumberController.text,
                            };
                            apiRequest(data);
                            // authViewModel.authSignUpUsingPost(data, context);
                          }else{
                            Utils.errorToast("Please enter all details");
                          }
                        }),
                      ),
                      SizedBox(
                        height: 14,
                      ),
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
                          TextFieldUtils().dynamicText(
                              'I agree with Terms and Conditions',
                              context,
                              TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.blackColor,
                                  fontSize: height * .018,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Container(
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
                                Navigator.of(context).push(MaterialPageRoute(
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
                      )
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
            hintText: 'David Wong',
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
                return StringUtils.fullName;
              } else if (businessNameController.text.length < 4) {
                _validateName = true;
                return StringUtils.fullName;
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
          controller: mobileNumberController,
          enable: true,
        ),
      ],
    );
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
    Utils.successToast(rawJson.toString());

    Map<String, dynamic> map = jsonDecode(rawJson);
    String name = map['message'];
    Utils.successToast(name.toString());
    if (response.statusCode == 200) {
      Utils.successToast(name.toString());
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SignIn_Screen()));
      print(reply.toString());
    } else {
      Utils.errorToast("System is busy, Please try after sometime.");
    }

    httpClient.close();
    return reply;
  }
}
