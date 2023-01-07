import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/pages/auth/sign_in.dart';
import 'package:velocit/utils/utils.dart';

import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../widgets/global/proceedButtons.dart';
import '../../widgets/global/textFormFields.dart';
import 'package:velocit/utils/StringUtils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController registerEmail = TextEditingController();
  bool _validateEmail = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController mobileController = TextEditingController();

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
                  padding: const EdgeInsets.fromLTRB(122, 3, 121, 36),
                  child: SvgPicture.asset(
                    'assets/appImages/new_app_icon.svg',
                    // color: ThemeApp.primaryNavyBlackColor,
                    semanticsLabel: 'Acme Logo',

                    height: 40, width: 132,
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
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      color: ThemeApp.primaryNavyBlackColor),
                ),

                SizedBox(
                  height:81,
                ),
        /*        TextFieldUtils().asteriskTextField("Email ID", context),
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
                        return StringUtils.emailError;
                      } else if (!StringConstant().isEmail(value)) {
                        _validateEmail = true;
                        return StringUtils.emailError;
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
                TextFieldUtils().asteriskTextField(
                    StringUtils.registeredEmailAddress, context),
                TextFormFieldsWidget(
                    errorText: StringUtils.emailError,
                    textInputType: TextInputType.emailAddress,
                    controller: registerEmail,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: StringUtils.email,
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
                        return StringUtils.validateRegisteredEmail;
                      } else if (!StringConstant().isEmail(value) &&
                          !StringConstant().isPhone(value)) {
                        _validateEmail = true;
                        return StringUtils.validateRegisteredEmail;
                      } else {
                        _validateEmail = false;
                      }
                      return null;
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                ),
                proceedButton(StringUtils.resetPassword,
                    ThemeApp.tealButtonColor, context, false, () {
                  if (_formKey.currentState!.validate() &&
                      registerEmail.text.isNotEmpty) {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => SignIn_Screen(),
                    //   ),
                    // );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ForgotSuccessDialog(text: registerEmail.text);
                        });
                  } else {
                    Utils.errorToast('Please enter valid Details.');
                  }
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => OTPScreen(),
                  //   ),
                  // );
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
                    Text('Password Reset Successfully',
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
