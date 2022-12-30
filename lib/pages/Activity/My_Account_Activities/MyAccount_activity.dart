import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/AccountSetting/NotificationScreen.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/CustomerSupport/CustomerSupportActivity.dart';

import '../../../Core/Model/CartModels/SendCartForPaymentModel.dart';
import '../../../Core/ViewModel/cart_view_model.dart';
import '../../../Core/data/responses/status.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes/routes.dart';
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
  CartViewModel cartListView = CartViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartId();
    getPreference();
  }

  getCartId() async {
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

    cartListView.sendCartForPaymentWithGet(
        this.context, StringConstant.UserCartID);
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

    StringConstant.userAccountImagePicker = (await Prefs.instance
        .getToken(StringConstant.userAccountImagePickerPref))!;

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
          preferredSize: Size.fromHeight(height * .07),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: ThemeApp.appBackgroundColor,
            alignment: Alignment.center,
            child: AppBar(
              centerTitle: false,
              elevation: 0,
              backgroundColor: ThemeApp.appBackgroundColor,
              flexibleSpace: Container(
                height: height * .07,
                width: width,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ThemeApp.appBackgroundColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              ),
              titleSpacing: 0,
              leading: IconButton(
                  icon:
                      const Icon(Icons.arrow_back, color: ThemeApp.blackColor),
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
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: height * 0.3,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: ThemeApp.whiteColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
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
                                          ],
                                          border: Border.all(
                                              color: ThemeApp.whiteColor,
                                              width: 7),
                                          shape: BoxShape.circle,
                                       /*   image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new AssetImage(
                                                'assets/images/laptopImage.jpg',
                                              ))*/),
                                    child:   ClipRRect(
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(100)),
                                      child: Image.file(

                                      File(  StringConstant.ProfilePhoto ??""),
                                      fit: BoxFit.fill,
                                      width: 130.0,
                                      height: 130.0,
                                  ),
                                    ),),
                                ),
                                Positioned(
                                  bottom: 0, right: width * .32,
                                  // width: 130.0,

                                  // height: 40.0,
                                  child: InkWell(  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const EditAccountActivity(),
                                      ),
                                    );
                                  },
                                    child:Container(
                                      height: height * .06,
                                      width: width * .11,

                                      decoration: BoxDecoration(

                                          borderRadius: BorderRadius.circular(30),
                                          color: ThemeApp.appColor),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: SvgPicture.asset(
                                          'assets/appImages/editIcon.svg',
                                          color: ThemeApp.whiteColor,
                                          semanticsLabel: 'Acme Logo',

                                          // height: height * .03,
                                        ),
                                      ),
                                    )/*; Container(
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
                            SizedBox(
                              height: height * .01,
                            ),
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
                            /*          SizedBox(
                              height: height * .01,
                            ),
                            TextFieldUtils().dynamicText(
                              // StringConstant.userAccountMobile,
                                '+91 8787965428',
                                context,
                                TextStyle(
                                  color: ThemeApp.darkGreyTab,
                                  fontSize: height * .018,
                                )),*/
                            /* Expanded(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.edit,
                                            size: height * .02),
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
                            ),*/
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      Container(
                        // height: height * 0.12,
                        // alignment: Alignment.center,
                        // // padding: const EdgeInsets.all(10),
                        // decoration: const BoxDecoration(
                        //   borderRadius: BorderRadius.all(
                        //     Radius.circular(8),
                        //   ),
                        //   color: ThemeApp.appBackgroundColor,
                        // ),
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
                                    iconsUtils(
                                        'assets/appImages/myOrderIcon.svg'),
                                    SizedBox(
                                      width: width * .05,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        'My Orders',
                                        context,
                                        TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: height * .022,
                                            letterSpacing: -0.25)),
                                  ],
                                ),
                              ),
                            ),
                InkWell(
                  onTap: () {
                    ChangeNotifierProvider<CartViewModel>.value(
                      value: cartListView,
                      child: Consumer<CartViewModel>(
                          builder: (context, cartProvider, child) {
                            switch (
                            cartProvider.sendCartForPayment.status) {
                              case Status.LOADING:
                                print("Api load");

                                return TextFieldUtils()
                                    .circularBar(context);
                              case Status.ERROR:
                                print("Api error");

                                return Text(cartProvider
                                    .sendCartForPayment.message
                                    .toString());
                              case Status.COMPLETED:
                                print("Api calll");
                                CartForPaymentPayload
                                cartForPaymentPayload = cartProvider
                                    .sendCartForPayment.data!.payload!;

                                List<CartOrdersForPurchase>
                                cartOrderPurchase = cartProvider
                                    .sendCartForPayment
                                    .data!
                                    .payload!
                                    .cart!
                                    .ordersForPurchase!;
                                return    SavedAddressDetails(
                                    cartForPaymentPayload:
                                    cartProvider
                                        .sendCartForPayment
                                        .data!
                                        .payload!);
                            }
                            return SizedBox();
                          }),
                    );

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        iconsUtils(
                            'assets/appImages/savedAddressIcon.svg'),
                        SizedBox(
                          width: width * .05,
                        ),
                        TextFieldUtils().dynamicText(
                            'Saved Addresses',
                            context,
                            TextStyle(
                                color: ThemeApp.blackColor,
                                fontWeight: FontWeight.w700,
                                fontSize: height * .022,
                                letterSpacing: -0.25)),
                      ],
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
                                    iconsUtils(
                                        'assets/appImages/headPhoneIcon.svg'),
                                    SizedBox(
                                      width: width * .05,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        'Customer Support',
                                        context,
                                        TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: height * .022,
                                            letterSpacing: -0.25)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AccountSettingScreen(),
                                  ),
                                );
                              },
                              /*     onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const EditAccountActivity(),
                                  ),
                                );
                              },*/
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    iconsUtils(
                                        'assets/appImages/settingIcon.svg'),
                                    SizedBox(
                                      width: width * .05,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        'Account Settings',
                                        context,
                                        TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: height * .022,
                                            letterSpacing: -0.25)),
                                  ],
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
                                    iconsUtils(
                                        'assets/appImages/settingIcon.svg'),
                                    SizedBox(
                                      width: width * .05,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        'Notifications',
                                        context,
                                        TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: height * .022,
                                            letterSpacing: -0.25)),
                                  ],
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
                                    iconsUtils(
                                        'assets/appImages/settingIcon.svg'),
                                    SizedBox(
                                      width: width * .05,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        'Change Password',
                                        context,
                                        TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: height * .022,
                                            letterSpacing: -0.25)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt('isUserLoggedIn', 0);

                                Navigator.pushReplacementNamed(
                                    context, RoutesName.dashboardRoute);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    iconsUtils(
                                        'assets/appImages/signOutIcon.svg'),
                                    SizedBox(
                                      width: width * .05,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        'Sign Out',
                                        context,
                                        TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: height * .022,
                                            letterSpacing: -0.25)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget iconsUtils(String svgIcon) {
    return Container(
      height: height * .05,
      width: width * .1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: ThemeApp.appColor),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SvgPicture.asset(
          svgIcon,
          color: ThemeApp.whiteColor,
          semanticsLabel: 'Acme Logo',

          // height: height * .03,
        ),
      ),
    );
  }
}
