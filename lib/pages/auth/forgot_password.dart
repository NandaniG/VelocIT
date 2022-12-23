import 'package:flutter/material.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/pages/auth/sign_in.dart';

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
  TextEditingController email = TextEditingController();
  bool _validateEmail = false;
  final _formKey = GlobalKey<FormState>();

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
                    .textFieldHeightThree(StringUtils.forgotPassword, context),
                const SizedBox(
                  height: 5,
                ),
                TextFieldUtils().subHeadingTextFields(
                    StringUtils.forgotPasswordSubHeading, context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                TextFieldUtils().asteriskTextField(
                    StringUtils.registeredEmailAddress, context),
                TextFormFieldsWidget(
                    errorText: StringUtils.emailError,
                    textInputType: TextInputType.emailAddress,
                    controller: email,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: StringUtils.email,
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
                      email.text.isNotEmpty) {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => SignIn_Screen(),
                    //   ),
                    // );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ForgotSuccessDialog(text:  email.text);
                        });
                  } else {
                    final snackBar = SnackBar(
                      content: Text('Please enter valid Details.'),
                      clipBehavior: Clip.antiAlias,
                      backgroundColor: ThemeApp.greenappcolor,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
  ForgotSuccessDialog({required this.text });

  @override
  State<ForgotSuccessDialog> createState() => _ForgotSuccessDialogState();
}

class _ForgotSuccessDialogState extends State<ForgotSuccessDialog> {
  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: 420.0,
          maxWidth: MediaQuery.of(context).size.width,
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
                      // group796Z38 (213:207)

                      width: double.infinity,
                      // height: 70,
                      child: Image.asset(
                        'assets/appImages/passwordResetIcon.png',
                        width: double.infinity,
                        height: 100,
                      ),
                    ),
                    TextFieldUtils().dynamicText(
                        'Password Reset Successfully',
                        context,
                        TextStyle(
                          color: ThemeApp.primaryNavyBlackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.height * .028,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),

                    Center(
                      child: Text(
                          'We have sent a temporary password to your registered email address "${widget.text}"',
                          style: TextStyle(
                            color: ThemeApp.blackColor,
                            // fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.height * .022,
                          ),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .07,
                    ),
                    proceedButton(
                        'Sign In Now', ThemeApp.blackColor, context, false, () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                          SignIn_Screen()
                        ),
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
