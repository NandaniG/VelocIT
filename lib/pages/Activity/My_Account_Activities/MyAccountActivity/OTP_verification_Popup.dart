import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/MyAccount_activity.dart';
import '../../../../services/models/JsonModelForApp/HomeModel.dart';
import '../../../../services/models/userAccountDetailModel.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';
import 'package:velocit/utils/StringUtils.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreference();
  }


  getPreference() async {

    setState(() {

    });
    StringConstant.userAccountImagePicker = (await Prefs.instance.getToken(StringConstant.userAccountImagePickerPref))!.isEmpty?StringConstant.userAccountImagePicker:(await Prefs.instance.getToken(StringConstant.userAccountImagePickerPref))!;
    StringConstant.userAccountName = (await Prefs.instance.getToken(StringConstant.userAccountNamePref))!.isEmpty?StringConstant.userAccountName:(await Prefs.instance.getToken(StringConstant.userAccountNamePref))!;
    StringConstant.userAccountEmail = (await Prefs.instance.getToken(StringConstant.userAccountEmailPref))!.isEmpty?StringConstant.userAccountEmail:(await Prefs.instance.getToken(StringConstant.userAccountEmailPref))!;
    StringConstant.userAccountMobile = (await Prefs.instance.getToken(StringConstant.userAccountMobilePref))!.isEmpty?StringConstant.userAccountMobile:(await Prefs.instance.getToken(StringConstant.userAccountMobilePref))!;
    StringConstant.userAccountPass = (await Prefs.instance.getToken(StringConstant.userAccountPassPref))!.isEmpty?StringConstant.userAccountPass:(await Prefs.instance.getToken(StringConstant.userAccountPassPref))!;
    print(StringConstant.userAccountName);

  }
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
          child: Consumer<ProductProvider>(builder: (context, value, child) {
            return Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: TextFieldUtils().dynamicText(
                            "OTP Verification",
                            context,
                            TextStyle(
                                color: ThemeApp.primaryNavyBlackColor,
                                fontSize: height * .025,
                                fontWeight: FontWeight.w700)),
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
                  SizedBox(
                    height: height * .02,
                  ),
                  TextFieldUtils().dynamicText(
                      "${StringUtils.otpSentTo} david@gmail.com",
                      context,
                      TextStyle(
                          color: ThemeApp.primaryNavyBlackColor,
                          fontSize: height * .019,
                          fontWeight: FontWeight.w400)),
                  TextFormFieldsWidget(
                      errorText: StringUtils.otpSentTo,
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
                                  color: ThemeApp.tealButtonColor,
                                  fontSize: height * .018,
                                  fontWeight: FontWeight.w400)),
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
                      "${StringUtils.otpSentTo} +91 5252634825",
                      context,
                      TextStyle(
                          color: ThemeApp.primaryNavyBlackColor,
                          fontSize: height * .019,
                          fontWeight: FontWeight.w400)),
                  TextFormFieldsWidget(
                      errorText: StringUtils.otpSentTo,
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
                                  color: ThemeApp.tealButtonColor,
                                  fontSize: height * .018,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                      onChange: (val) {},
                      validator: (value) {
                        return null;
                      }),
                  SizedBox(
                    height: height * .01,
                  ),
                  TextFieldUtils().asteriskTextField(
                      "${StringUtils.password}",
                      context,
                     ),
                  PasswordTextFormFieldsWidget(
                      errorText: StringUtils.passwordError,
                      textInputType: TextInputType.text,
                      controller: passwordController,
                      autoValidation: AutovalidateMode.onUserInteraction,
                      hintText: StringUtils.password,
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
                          return StringUtils.passwordError;
                        } else if (!StringConstant().isPass(value)) {
                          _validatePassword = true;
                          return StringUtils
                              .validPasswordError;
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
                            StringUtils.cancel, context, () {
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
                        child: proceedButton(
                            StringUtils.update,
                            ThemeApp.blackColor,
                            context, false,() {
                          setState(() {
                            value.userAccountDetailList.add(UserAccountList(
                                userId: 1,userImage: value.images.toString(),
                                userName: value.userNameController.text,
                                userEmail: value.userEmailController.text,
                                userMobile: value.userMobileController.text,
                                userPassword: passwordController.text));


                            Prefs.instance.setToken(StringConstant.userAccountPassPref,
                                passwordController.text);
                            getPreference();                          });
                          print("value.creditCardList__________" +
                              value.userNameController.text.toString());
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MyAccountActivity(),
                            ),
                          );
                        }),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
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
