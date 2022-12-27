

import 'package:flutter/material.dart';
import 'package:velocit/pages/auth/Sign_Up.dart';
import 'package:velocit/pages/auth/sign_in.dart';

import '../../../utils/styles.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';

class AccountVerificationDialog extends StatefulWidget {
  const AccountVerificationDialog({Key? key}) : super(key: key);

  @override
  State<AccountVerificationDialog> createState() => _AccountVerificationDialogState();
}

class _AccountVerificationDialogState extends State<AccountVerificationDialog> {
  TextEditingController emailOTPController = new TextEditingController();
  TextEditingController mobileOTPController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool _validatePassword = false;
  double height = 0.0;
  double width = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: 300,
          maxWidth: width,
          minWidth: width,
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Center(
            child: Container(
                padding:
                EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TextFieldUtils().dynamicText(
                        "Log in",
                        context,
                        TextStyle(
                            color: ThemeApp.blackColor,
                            fontSize: height * .03,
                            fontWeight: FontWeight.w600)),   SizedBox(
                      height: height * .05,
                    ),
                    TextFieldUtils().dynamicText(
                        "Guest user, please sign in!",
                        context,
                        TextStyle(
                            color: ThemeApp.blackColor,
                            fontSize: height * .025,
                            fontWeight: FontWeight.w500)),

                    SizedBox(
                      height: height * .1,
                    ),
                    Row(
                      children: [

                        Expanded(
                          flex: 1,
                          child: proceedButton(
                              'Sign In',
                              ThemeApp.blackColor,
                              context, false,() {

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>  SignIn_Screen(),
                              ),
                            );
                          }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
          )

        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
