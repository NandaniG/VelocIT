import 'package:flutter/material.dart';
import 'package:velocit/pages/auth/Sign_Up.dart';
import 'package:velocit/pages/auth/sign_in.dart';

import '../../../utils/styles.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';

class AccountVerificationDialog extends StatefulWidget {
  const AccountVerificationDialog({Key? key}) : super(key: key);

  @override
  State<AccountVerificationDialog> createState() =>
      _AccountVerificationDialogState();
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
          maxHeight: 180,
          maxWidth: width,
          minWidth: width,
        ),
        child: Container(
            // padding: EdgeInsets.all(10),
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
                    EdgeInsets.all(20),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFieldUtils().dynamicText(
                            "Log in",
                            context,
                            TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.blackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: ThemeApp.blackColor,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "New User? ",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.blackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.tealButtonColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldUtils().lineHorizontal(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Already a customer? ",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.blackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          InkWell(
                            onTap: ()async {

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SignIn_Screen()));
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.tealButtonColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    )
                    /*     Row(
                      children: [

                        Expanded(
                          flex: 1,
                          child: proceedButton(
                              'Sign In',
                              ThemeApp.tealButtonColor,
                              context, false,() {
                            FocusManager.instance.primaryFocus?.unfocus();

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>  SignIn_Screen(),
                              ),
                            );
                          }),
                        ),
                      ],
                    )*/
                  ],
                ),
              ),
            )),
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
