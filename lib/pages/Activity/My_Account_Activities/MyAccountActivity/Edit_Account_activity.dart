import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocit/services/models/userAccountDetailModel.dart';

import '../../../../services/models/FilterModel.dart';
import '../../../../services/models/JsonModelForApp/HomeModel.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';
import 'OTP_verification_Popup.dart';
import 'package:velocit/utils/StringUtils.dart';

class EditAccountActivity extends StatefulWidget {
  const EditAccountActivity({Key? key}) : super(key: key);

  @override
  State<EditAccountActivity> createState() => _EditAccountActivityState();
}

class _EditAccountActivityState extends State<EditAccountActivity> {
  double height = 0.0;
  double width = 0.0;
  final picker = ImagePicker();
  late File _profileImage;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  //
  // TextEditingController fullNameController = new TextEditingController();
  // TextEditingController mobileController = new TextEditingController();
  // TextEditingController emailController = new TextEditingController();

  bool _validateFullName = false;
  bool _validateMobile = false;
  bool _validateEmail = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeApp.blackColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/myAccountActivity');
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
      body: Consumer<ProductProvider>(builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.only(top: 0),
          color: ThemeApp.appBackgroundColor,
          height: height * .6,
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
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Align(
                  alignment: Alignment(0.0, .2),
                  child: Container(
                    // height: height *.9,
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.only(top: 50, left: 20, right: 20),
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
                          fullName(provider),
                          mobileNumber(provider),
                          emailId(provider),
                          SizedBox(
                            height: height * .02,
                          ),
                          updateButton(provider)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Stack(alignment: Alignment.topCenter,
                children: [

                  Align(
                      alignment: Alignment(0, -1),
                      child: Container(
                          alignment: Alignment(0, -1),
                          child: Icon(
                            Icons.circle,
                            size: height * .15,
                            color: ThemeApp.whiteColor,
                          ))),
                  imageFile1 != null
                      ? Align(
                      alignment: Alignment(0, -1),
                      child: Container(
                        // height: 50,width:50,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment(0, -1),
                        child: InkWell(
                          onTap: () async {
                            _getFromCamera();
                          },
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                            child:   Image.file(
                              imageFile1!,

                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                      ))
                      : Align(
                      alignment: Alignment(0, -1),
                      child: Container(
                          alignment: Alignment(0, -1),
                          child: InkWell(
                            onTap: () async {
                              _getFromCamera();

                            },
                            child: Icon(
                              Icons.account_circle_rounded,
                              size: height * .15,
                              color: ThemeApp.backgroundColor,
                            ),
                          ))),
                  // Align(
                  //   alignment: Alignment(0.09, -1),
                  //   child: Container(
                  //       height: 100,
                  //       width: 50,
                  //       alignment: Alignment.bottomRight,
                  //           child: Icon(
                  //             Icons.camera_alt,
                  //             size: height * .03,
                  //             color: ThemeApp.blackColor,
                  //           )),
                  // ),
                ],
              ),

            ],
          ),
        );
      }),
    );
  }
  File? imageFile1;

  _getFromCamera() async {

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedImage != null) {
      setState(() {
        imageFile1 = File(pickedImage.path);
        isEnable = true;
      });
    }
  }

  bool isEnable =false;

  Widget fullName(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().dynamicText(
            StringUtils.fullName,
            context,
            TextStyle(
                color: ThemeApp.blackColor,
                fontSize: height * .02,
                fontWeight: FontWeight.w600)),
        CharacterTextFormFieldsWidget(
          isEnable: isEnable,
            errorText: StringUtils.enterFullName,
            textInputType: TextInputType.name,

            controller: provider.userNameController,
            autoValidation: AutovalidateMode.onUserInteraction,
            hintText: 'David Wong',


            onChange: (val) {},
            validator: (value) {
              return null;
            }),
      ],
    );
  }

  Widget mobileNumber(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().dynamicText(
            StringUtils.mobileNumber,
            context,
            TextStyle(
                color: ThemeApp.blackColor,
                fontSize: height * .02,
                fontWeight: FontWeight.w600)),
        MobileNumberTextFormField(
            controller: provider.userMobileController, enable: false),
      ],
    );
  }

  Widget emailId(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().dynamicText(
            StringUtils.email,
            context,
            TextStyle(
                color: ThemeApp.blackColor,
                fontSize: height * .02,
                fontWeight: FontWeight.w600)),
        TextFormFieldsWidget(
            errorText: StringUtils.email,
            textInputType: TextInputType.emailAddress,
            controller: provider.userEmailController,
            autoValidation: AutovalidateMode.onUserInteraction,
            hintText: 'david@gmil.com',
            onChange: (val) {},
            validator: (val) {
              if (val.isEmpty && provider.userEmailController.text.isEmpty) {
                _validateEmail = true;
                return StringUtils.emailError;
              } else if (!StringConstant().isEmail(val)) {
                _validateEmail = true;
                return StringUtils.emailError;
              } else {
                _validateEmail = false;
              }
              return null;
            }),
      ],
    );
  }

  Widget updateButton(ProductProvider provider) {
    return proceedButton(StringUtils.update,
        ThemeApp.tealButtonColor, context, false, () {
      print("provider.creditCardList__________" +
          provider.userAccountDetailList.length.toString());
      initializeFilter(provider);

      setState(() {

        Prefs.instance.setToken(StringConstant.userAccountNamePref,
            provider.userNameController.text);
        Prefs.instance.setToken(StringConstant.userAccountEmailPref,
            provider.userEmailController.text);
        Prefs.instance.setToken(StringConstant.userAccountMobilePref,
            provider.userMobileController.text);
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return OTPVerificationDialog();
          });
    });
  }

  void initializeFilter(ProductProvider provider) {
    provider.userAccountDetailList = <UserAccountList>[];

    provider.userAccountDetailList.add(UserAccountList(
        userId: 1,
        userImage: provider.images.toString(),
        userName: provider.userNameController.text,
        userEmail: provider.userEmailController.text,
        userMobile: provider.userMobileController.text,
        userPassword: 'userPassword'));

  }
  // String images='';
  Future<String> getBase64Image(PickedFile img) async {
    List<int> imageBytes = File(img.path).readAsBytesSync();
    String img64 = base64Encode(imageBytes);
    // print(img.path);
    // print(img64);
    return img64;
  }
}
