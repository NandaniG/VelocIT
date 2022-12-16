import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/pages/auth/sign_in.dart';

import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../widgets/global/proceedButtons.dart';
import '../../widgets/global/textFormFields.dart';

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
      backgroundColor: ThemeApp.appBackgrounColor,
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
    padding: const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 40),
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
            TextFieldUtils().textFieldHeightThree(AppLocalizations.of(context).forgotPassword, context),
            const SizedBox(
              height: 5,
            ),
            TextFieldUtils().subHeadingTextFields(
                AppLocalizations.of(context).forgotPasswordSubHeading, context),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            TextFieldUtils().asteriskTextField(
                AppLocalizations.of(context).registeredEmailAddress,context),
            TextFormFieldsWidget(
                errorText: AppLocalizations.of(context).emailError,
                textInputType: TextInputType.emailAddress,
                controller: email,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: AppLocalizations.of(context).email,
                onChange: (val) {
                  setState(() {
                    if (val.isEmpty && email.text.isEmpty) {
                      _validateEmail = true;
                    } else if (!StringConstant().isEmail(val) && !StringConstant().isPhone(val)) {
                      _validateEmail = true;
                    } else {
                      _validateEmail = false;
                    }
                  });
                },
                validator: (value) {
                  if (value.isEmpty && email.text.isEmpty) {
                    _validateEmail = true;
                    return AppLocalizations.of(context).validateRegisteredEmail;
                  } else if (!StringConstant().isEmail(value) && !StringConstant().isPhone(value)) {
                    _validateEmail = true;
                    return AppLocalizations.of(context).validateRegisteredEmail;
                  } else {
                    _validateEmail = false;
                  }
                  return null;
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height * .08,
            ),
            proceedButton(AppLocalizations.of(context).resetPassword, ThemeApp.tealButtonColor,context, false,() {
              if (_formKey.currentState!.validate() &&
                  email.text.isNotEmpty) {


                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => SignIn_Screen(),
                //   ),
                // );
                showDialog(
                    context: context,
                    builder: (BuildContext
                    context) {
                      return ForgotSuccessDialog(
                      );
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

  ForgotSuccessDialog();

  @override
  State<ForgotSuccessDialog> createState() => _ForgotSuccessDialogState();
}

class _ForgotSuccessDialogState extends State<ForgotSuccessDialog> {
  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: 300.0,
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
          child: Container(
            //  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                      color: ThemeApp.blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.height * .025,
                    )),
                proceedButton('Ok', ThemeApp.blackColor,context, false,() {
                  Navigator.pop(context);
                })
              ],
            ),
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