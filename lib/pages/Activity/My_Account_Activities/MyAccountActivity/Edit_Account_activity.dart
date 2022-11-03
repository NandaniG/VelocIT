import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';
import 'OTP_verification_Popup.dart';

class EditAccountActivity extends StatefulWidget {
  const EditAccountActivity({Key? key}) : super(key: key);

  @override
  State<EditAccountActivity> createState() => _EditAccountActivityState();
}

class _EditAccountActivityState extends State<EditAccountActivity> {
  double height = 0.0;
  double width = 0.0;

  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  TextEditingController fullNameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  bool _validateFullName = false;
  bool _validateMobile = false;
  bool _validateEmail = false;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

     return Scaffold(
      backgroundColor: ThemeApp.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeApp.blackColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: ThemeApp.whiteColor,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 0),
        color: ThemeApp.backgroundColor,
        height: height*.6,
        child: Stack(
          children: [
            Container(
              height: height * .12,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ThemeApp.blackColor,
                  border: Border.all(
                    color: ThemeApp.blackColor,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
              child: Align(
                alignment: Alignment(0.0, .2),
                child: Container(
                  // height: height *.9,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: ThemeApp.whiteColor,
                  ),
                  // height: profile_side,
                  width: width,
                  child: Form(
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Full Name
                        TextFieldUtils().dynamicText(
                            AppLocalizations.of(context).fullName,
                            context,
                            TextStyle(
                                color: ThemeApp.blackColor,
                                fontSize: height * .02,
                                fontWeight: FontWeight.w600)),
                        TextFormFieldsWidget(
                            errorText: AppLocalizations.of(context).enterFullName,
                            textInputType: TextInputType.text,
                            controller: fullNameController,
                            autoValidation: AutovalidateMode.onUserInteraction,
                            hintText: 'David Wong',
                            onChange: (val) {

                            },
                            validator: (value) {

                              return null;
                            }),
                        //Mobile Number
                        TextFieldUtils().dynamicText(
                            AppLocalizations.of(context).mobileNumber,
                            context,
                            TextStyle(
                                color: ThemeApp.blackColor,
                                fontSize: height * .02,
                                fontWeight: FontWeight.w600)),
                        MobileNumberTextFormField(controller : mobileController),

                    /*    TextFormFieldsWidget(
                            errorText: AppLocalizations.of(context).mobileNumber,
                            textInputType: TextInputType.number,
                            controller: mobileController,maxLength: 10,
                            autoValidation: AutovalidateMode.onUserInteraction,
                            hintText: 'Ex: 8582968541',
                            onChange: (val) {

                            },
                            validator: (value) {
                              if (value.isEmpty && mobileController.text.isEmpty) {
                                _validateMobile = true;
                                return AppLocalizations.of(context).enterMobileNumber;
                              } else if (
                              mobileController.text.length <=9) {
                                _validateMobile = true;
                                return AppLocalizations.of(context).enterMobileNumber;
                              } else {
                                _validateMobile = false;
                              }
                              return null;
                            }),*/
                        //Mobile Number
                        TextFieldUtils().dynamicText(
                            AppLocalizations.of(context).email,
                            context,
                            TextStyle(
                                color: ThemeApp.blackColor,
                                fontSize: height * .02,
                                fontWeight: FontWeight.w600)),
                        TextFormFieldsWidget(
                            errorText: AppLocalizations.of(context).email,
                            textInputType: TextInputType.emailAddress,
                            controller: emailController,
                            autoValidation: AutovalidateMode.onUserInteraction,
                            hintText: 'david@gmil.com',
                            onChange: (val) {

                            },
                            validator: (value) {
                              if (value.isEmpty && emailController.text.isEmpty) {
                                _validateEmail = true;
                                return AppLocalizations.of(context).emailError;
                              } else if (
                              !StringConstant().isEmail(value)) {
                                _validateEmail = true;
                                return AppLocalizations.of(context).emailError;
                              } else {
                                _validateEmail = false;
                              }
                              return null;
                            }),
                        SizedBox(
                          height:height * .02,
                        ),
                        proceedButton(AppLocalizations.of(context).update,ThemeApp.blackColor, context, () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return OTPVerificationDialog(
                                   );
                              });
                        })
                      ],),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment(0, -1),
                child: Container(
                    alignment: Alignment(0, -1),
                    child: Icon(
                      Icons.circle,
                      size: height * .15,
                      color: ThemeApp.lightGreyTab,
                    )
                )),
            Align(
                alignment: Alignment(0, -1),
                child: Container(
                    alignment: Alignment(0, -1),
                    child: Icon(
                      Icons.account_circle_rounded,
                      size: height * .15,
                      color: ThemeApp.darkGreyTab,
                    )
                )),
          ],
        ),
      ),
    );
  }
}
