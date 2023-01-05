import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  void initState() {
    // TODO: implement initState

  getPrefValue();
  super.initState();
  }

  getPrefValue() async {
    final prefs = await SharedPreferences.getInstance();
    bool check = prefs.containsKey('profileImagePrefs');
    if (check) {
      setState(() {
        print("yes/./././.");
        StringConstant.ProfilePhoto = prefs.getString('profileImagePrefs')!;
      });
      return;
    }

    StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
  }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeApp.appBackgroundColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/myAccountActivity');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: ThemeApp.blackColor,
            ),
          ),
        ),
        title: Text("Edit my account"),
      ),
      body: SafeArea(
        child: Consumer<ProductProvider>(builder: (context, provider, child) {
          return ListView(
            children: [mainUI(provider)],
          );
        }),
      ),
    );
  }

  Widget mainUI(ProductProvider provider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: ThemeApp.whiteColor,
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageFile1 != null
                ? Stack(
                    // alignment: Alignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 130.0,
                          height: 130.0,
                          decoration: new BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade600,
                                  spreadRadius: 1,
                                  blurRadius: 5)
                            ],
                            border: Border.all(
                                color: ThemeApp.whiteColor, width: 4),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: Image.file(
                              imageFile1!,
                              fit: BoxFit.fill,
                              width: 130.0,
                              height: 130.0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: width * .32,
                        // width: 130.0,

                        // height: 40.0,
                        child: InkWell(
                            onTap: () {
                              _getFromCamera();
                            },
                            child: Container(
                              height: height * .06,
                              width: width * .11,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ThemeApp.appColor),
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: SvgPicture.asset(
                                  'assets/appImages/cameraIcon.svg',
                                  color: ThemeApp.whiteColor,
                                  semanticsLabel: 'Acme Logo',

                                  // height: height * .03,
                                ),
                              ),
                            )

                            ),
                      ),
                    ],
                  )
                : Stack(
                    // alignment: Alignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 130.0,
                          height: 130.0,
                          decoration: new BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade600,
                                  spreadRadius: 1,
                                  blurRadius: 15)
                            ],color: ThemeApp.whiteColor,
                            border: Border.all(
                                color: ThemeApp.whiteColor, width: 7),
                            shape: BoxShape.circle,
                          ),
                          child:  ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                            child: Image.file(

                              File(  StringConstant.ProfilePhoto),
                              fit: BoxFit.fill,
                              width: 130.0,
                              height: 130.0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: width * .32,
                        // width: 130.0,

                        // height: 40.0,
                        child: InkWell(
                            onTap: () {
                              _getFromCamera();
                            },
                            child: Container(
                              height: height * .06,
                              width: width * .11,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ThemeApp.appColor),
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: SvgPicture.asset(
                                  'assets/appImages/cameraIcon.svg',
                                  color: ThemeApp.whiteColor,
                                  semanticsLabel: 'Acme Logo',

                                  // height: height * .03,
                                ),
                              ),
                            )
                            /*; Container(
                                        // alignment: Alignment.bottomCenter,
                                        color: ThemeApp.primaryNavyBlackColor,
                                        alignment: const Alignment(-2, -0.1),
                                        child: iconsUtils(
                                            'assets/appImages/editIcon.svg'),
                                      ),*/
                            ),
                      ),
                    ],
                  ),
            /*     imageFile1 != null
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      // height: 50,width:50,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () async {
                          _getFromCamera();
                        },
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          child: Image.file(
                            imageFile1!,
                            fit: BoxFit.fill,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ))
                : Align(
                    alignment: Alignment.center,
                    child: Container(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () async {
                            _getFromCamera();
                          },
                          child: Icon(
                            Icons.account_circle_rounded,
                            size: height * .15,
                            color: ThemeApp.backgroundColor,
                          ),
                        ))),*/
            SizedBox(
              height: height * .03,
            ),
            TextFieldUtils().asteriskTextField(
                StringUtils.fullName,
                context,
              ),
            CharacterTextFormFieldsWidget(
                isEnable: true,
                errorText: StringUtils.enterFullName,
                textInputType: TextInputType.name,
                controller: provider.userNameController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'David Wong',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            SizedBox(
              height: height * .02,
            ),
            TextFieldUtils().asteriskTextField(
                StringUtils.mobileNumber,
                context,
                ),
            MobileNumberTextFormField(
                controller: provider.userMobileController, enable: false),
            SizedBox(
              height: height * .02,
            ),
            TextFieldUtils().asteriskTextField(
                StringUtils.email,
                context,),
            TextFormFieldsWidget(
                errorText: StringUtils.email,
                textInputType: TextInputType.emailAddress,
                controller: provider.userEmailController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'david@gmil.com',
                onChange: (val) {},
                validator: (val) {
                  if (val.isEmpty &&
                      provider.userEmailController.text.isEmpty) {
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
            SizedBox(
              height: height * .03,
            ),
            updateButton(provider),
            SizedBox(
              height: height * .02,
            ),
          ],
        ),
      ),
    );
  }

  File? imageFile1;

  // _getFromCamera() async {
  //
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedImage != null) {
  //     setState(() {
  //       imageFile1 = File(pickedImage.path);
  //       // isEnable = true;
  //
  //     });
  //   }
  // }


  Future _getFromCamera() async {
    var image = await picker.getImage(source: ImageSource.camera);
    final prefs = await SharedPreferences.getInstance();
    // StringConstant.CurrentPinCode = (prefs.getString('CurrentPinCodePref') ?? '');
    String imagePath = image!.path;

    await prefs.setString('profileImagePrefs', imagePath);


    setState(() {
      imageFile1 = File(image!.path);

   // final   file = File(image!.path);
   //    final bytes =
   //    file!.readAsBytesSync();
   //   final img64 = base64Encode(bytes);

    });
    // Navigator.pop(this.context);
  }

  bool isEnable = false;

  Widget fullName(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().dynamicText(
            StringUtils.fullName,
            context,
            TextStyle(fontFamily: 'Roboto',
                color: ThemeApp.blackColor,
                fontSize: height * .02,
                fontWeight: FontWeight.w600)),
        CharacterTextFormFieldsWidget(
            isEnable: true,
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
            TextStyle(fontFamily: 'Roboto',
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
            TextStyle(fontFamily: 'Roboto',
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
    return proceedButton(
        StringUtils.update, ThemeApp.tealButtonColor, context, false, () {
      FocusManager.instance.primaryFocus?.unfocus();

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
