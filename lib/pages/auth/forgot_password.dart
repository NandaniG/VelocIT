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
      backgroundColor: ThemeApp.whiteColor,
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
            TextFieldUtils().textFieldHeightThree(AppLocalizations.of(context).forgotPassword, context),
            const SizedBox(
              height: 5,
            ),
            TextFieldUtils().subHeadingTextFields(
                AppLocalizations.of(context).forgotPasswordSubHeading, context),
            SizedBox(
              height: MediaQuery.of(context).size.height * .04,
            ),
            TextFieldUtils()
                .titleTextFields(AppLocalizations.of(context).registeredEmailAddress, context),
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
              height: MediaQuery.of(context).size.height * .025,
            ),
            proceedButton(AppLocalizations.of(context).resetPassword, ThemeApp.blackColor,context, () {
              if (_formKey.currentState!.validate() &&
                  email.text.isNotEmpty) {
                if (email.text == 'codeelan@gmail.com' ) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignIn_Screen(),
                    ),
                  );
                } else {
                  final snackBar = SnackBar(
                    content: Text('Please enter valid Details.....'),
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: ThemeApp.greenappcolor,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }


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
