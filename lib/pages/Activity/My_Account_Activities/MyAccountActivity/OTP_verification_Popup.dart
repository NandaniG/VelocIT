import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';

class OTPVerificationDialog extends StatefulWidget {
  const OTPVerificationDialog({Key? key}) : super(key: key);

  @override
  State<OTPVerificationDialog> createState() => _OTPVerificationDialogState();
}

class _OTPVerificationDialogState extends State<OTPVerificationDialog> {
  TextEditingController emailOTPController = new TextEditingController();
  TextEditingController mobileOTPController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool _validatePassword = false;
  double height = 0.0;
  double width = 0.0;

  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: height * .55,
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
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: TextFieldUtils().dynamicText(
                      "OTP Verification",
                      context,
                      TextStyle(
                          color: ThemeApp.blackColor,
                          fontSize: height * .025,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: height * .02,
                ),
                TextFieldUtils().dynamicText(
                    "${AppLocalizations.of(context).otpSentTo} david@gmail.com",
                    context,
                    TextStyle(
                        color: ThemeApp.blackColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w600)),
                TextFormFieldsWidget(
                    errorText: AppLocalizations.of(context).otpSentTo,
                    textInputType: TextInputType.text,
                    controller: emailOTPController,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: 'Enter OTP',
                    suffixText: InkWell(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: width * .1,
                        padding: EdgeInsets.only(right: 10),
                        child: Text("Resend",
                            style: TextStyle(
                                color: ThemeApp.blackColor,
                                fontSize: height * .016,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    onChange: (val) {},
                    validator: (value) {
                      return null;
                    }),
                SizedBox(
                  height: height * .01,
                ),
                TextFieldUtils().dynamicText(
                    "${AppLocalizations.of(context).otpSentTo} +91 5252634825",
                    context,
                    TextStyle(
                        color: ThemeApp.blackColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w600)),
                TextFormFieldsWidget(
                    errorText: AppLocalizations.of(context).otpSentTo,
                    textInputType: TextInputType.text,
                    controller: mobileOTPController,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: 'Enter OTP',
                    suffixText: InkWell(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: width * .1,
                        padding: EdgeInsets.only(right: 10),
                        child: Text("Resend",
                            style: TextStyle(
                                color: ThemeApp.blackColor,
                                fontSize: height * .016,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    onChange: (val) {},
                    validator: (value) {
                      return null;
                    }),
                SizedBox(
                  height: height * .01,
                ),
                TextFieldUtils().dynamicText(
                    "${AppLocalizations.of(context).password} *",
                    context,
                    TextStyle(
                        color: ThemeApp.blackColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w600)),
                PasswordTextFormFieldsWidget(
                    errorText: AppLocalizations.of(context).passwordError,
                    textInputType: TextInputType.text,
                    controller: passwordController,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: AppLocalizations.of(context).password,
                    onChange: (val) {
                      setState(() {
                        if (val.isEmpty && passwordController.text.isEmpty) {
                          _validatePassword = true;
                        } else if (!StringConstant().isPass(val)) {
                          _validatePassword = true;
                        } else {
                          _validatePassword = false;
                        }
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty && passwordController.text.isEmpty) {
                        _validatePassword = true;
                        return AppLocalizations.of(context).passwordError;
                      } else if (!StringConstant().isPass(value)) {
                        _validatePassword = true;
                        return AppLocalizations.of(context).validPasswordError;
                      } else {
                        _validatePassword = false;
                      }
                      return null;
                    }),
                SizedBox(
                  height: height * .02,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: whiteProceedButton(
                          AppLocalizations.of(context).cancel, context, () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => AddNewCardActivity(),
                        //   ),
                        // );
                        Navigator.pop(context);

                      }),
                    ),
                    SizedBox(
                      width: width * .02,
                    ),
                    Expanded(
                      flex: 1,
                      child: proceedButton(AppLocalizations.of(context).update,
                          ThemeApp.blackColor, context, () {
                        Navigator.pop(context);
                      }),
                    ),
                  ],
                )
              ],
            ),
          ),
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
