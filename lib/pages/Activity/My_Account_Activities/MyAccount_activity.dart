import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/AccountSetting/NotificationScreen.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/CustomerSupport/CustomerSupportActivity.dart';

import '../../../services/providers/Products_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';
import '../../../widgets/features/scannerWithGallery.dart';
import '../../auth/change_password.dart';
import '../../homePage.dart';
import '../../screens/dashBoard.dart';
import '../../screens/offers_Activity.dart';
import '../../tabs/tabs.dart';
import '../My_Orders/MyOrders_Activity.dart';
import 'AccountSetting/AccountSettingScreen.dart';
import 'SaveCardAndWallets/CardList_manage_Payment_Activity.dart';
import 'MyAccountActivity/Edit_Account_activity.dart';
import 'Saved_address/saved_address_detailed_screen.dart';

class MyAccountActivity extends StatefulWidget {
  const MyAccountActivity({Key? key}) : super(key: key);

  @override
  State<MyAccountActivity> createState() => _MyAccountActivityState();
}

class _MyAccountActivityState extends State<MyAccountActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreference();
  }

  getPreference() async {
    setState(() {});
    StringConstant.userAccountName =
        (await Prefs.instance.getToken(StringConstant.userAccountNamePref))!;
    StringConstant.userAccountEmail =
        (await Prefs.instance.getToken(StringConstant.userAccountEmailPref))!;
    StringConstant.userAccountMobile =
        (await Prefs.instance.getToken(StringConstant.userAccountMobilePref))!;
    StringConstant.userAccountPass =
        (await Prefs.instance.getToken(StringConstant.userAccountPassPref))!;
    print(StringConstant.userAccountName);

    StringConstant.userAccountImagePicker =
        (await Prefs.instance.getToken(StringConstant.userAccountImagePickerPref))!;



    print("StringConstant.userAccountImagePicker");
    print(StringConstant.userAccountImagePicker);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/dashBoardScreen');

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .09),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: ThemeApp.appBackgroundColor,

            child: AppBar(
              centerTitle: false,
              elevation: 0,
              backgroundColor: ThemeApp.appBackgroundColor,
              flexibleSpace: Container(
                height: height * .11,
                width: width,
                decoration: const BoxDecoration(
                  color: ThemeApp.appBackgroundColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              ),
              titleSpacing: 0,
              leading:IconButton(
                  icon: const Icon(Icons.arrow_back, color:ThemeApp.blackColor),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/dashBoardScreen');

                  }),

              // leadingWidth: width * .06,
              title: Text("My Account"),
              // Row
            ),
          ),
        ),
        bottomNavigationBar: bottomNavigationBarWidget(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: Consumer<ProductProvider>(builder: (context, value, child) {
            return Container(
              color: ThemeApp.appBackgroundColor,
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20,top: 20),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // height: height * 0.12,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: ThemeApp.whiteColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    width: 60.0,
                                    height: 60.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              'assets/images/laptopImage.jpg',
                                            )))
                         /*       child: Image.memory(
                                  Base64Decoder().convert(StringConstant.userAccountImagePicker
                                      .replaceAll(
                                      RegExp(
                                          r'^data:image\/[a-z]+;base64,'),
                                      '')),fit: BoxFit.fill,
                                  width: 100,
                                  height: 100,
                                ),*/),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextFieldUtils().dynamicText(
                                          // StringConstant.userAccountName,
                                          'Dawid John',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: height * .022,
                                          )),
                                      SizedBox(
                                        height: height * .01,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          // StringConstant.userAccountEmail,
                                          'dawid@gmail.com',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.darkGreyTab,
                                            fontSize: height * .018,
                                          )),
                                      SizedBox(
                                        height: height * .01,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          // StringConstant.userAccountMobile,
                                          '+91 8787965428',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.darkGreyTab,
                                            fontSize: height * .018,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EditAccountActivity(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.edit, size: height * .02),
                                          SizedBox(
                                            width: width * .01,
                                          ),
                                          TextFieldUtils().dynamicText(
                                              'Edit',
                                              context,
                                              TextStyle(
                                                color: ThemeApp.darkGreyTab,
                                                fontSize: height * .018,
                                              )),
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: height * .01,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          // height: height * 0.12,
                          alignment: Alignment.center,
                          // padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: ThemeApp.whiteColor,
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MyOrdersActivity(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    'assets/images/laptopImage.jpg',
                                                  )))),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          'My Orders',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: height * .02,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                         /*     Container(
                                width: width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: ThemeApp.appBackgroundColor, width: 1),
                                    // bottom: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CardListManagePayments(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    'assets/images/laptopImage.jpg',
                                                  )))),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          'Saved Cards and Wallets',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: height * .02,
                                          )),
                                    ],
                                  ),
                                ),
                              ),*/
                              Container(
                                width: width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: ThemeApp.appBackgroundColor, width: 1),
                                    // bottom: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SavedAddressDetails(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    'assets/images/laptopImage.jpg',
                                                  )))),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          'Saved Addresses',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: height * .02,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: ThemeApp.appBackgroundColor, width: 1),
                                    // bottom: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomerSupportActivity(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    'assets/images/laptopImage.jpg',
                                                  )))),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          'Customer Support',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: height * .02,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: ThemeApp.appBackgroundColor, width: 1),
                                    // bottom: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                              InkWell(
                             /*   onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AccountSettingScreen(),
                                    ),
                                  );
                                },*/
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const EditAccountActivity(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    'assets/images/laptopImage.jpg',
                                                  )))),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          'Account Settings',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: height * .02,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: ThemeApp.appBackgroundColor, width: 1),
                                    // bottom: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationScreen(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    'assets/images/laptopImage.jpg',
                                                  )))),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          'Notifications',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: height * .02,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: ThemeApp.appBackgroundColor, width: 1),
                                    // bottom: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const ChangePassword(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    'assets/images/laptopImage.jpg',
                                                  )))),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          'Change Password',
                                          context,
                                          TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: height * .02,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: ThemeApp.appBackgroundColor, width: 1),
                                    // bottom: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new AssetImage(
                                                  'assets/images/laptopImage.jpg',
                                                )))),
                                    SizedBox(
                                      width: width * .03,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        'Sign Out',
                                        context,
                                        TextStyle(
                                          color: ThemeApp.blackColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: height * .02,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
