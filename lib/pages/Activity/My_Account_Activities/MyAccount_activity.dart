import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Model/userModel.dart';
import 'package:velocit/Core/repository/auth_repository.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/AccountSetting/NotificationScreen.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/CustomerSupport/CustomerSupportActivity.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/Saved_address/ProfileImageDialog.dart';
import 'package:velocit/services/providers/Home_Provider.dart';

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
  var data;
  File? imageFile1;
  bool isNotification = false;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartId();
  }

  getCartId() async {
    final prefs = await SharedPreferences.getInstance();
    StringConstant.ProfilePhoto =
       ( prefs.getString('userProfileImagePrefs'))?? "";
    StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {


        Navigator.of(context)
            .pushNamedAndRemoveUntil(
                RoutesName.dashboardRoute, (route) => false)
            .then((value) {
          setState(() {});
        });
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
              leading: InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //     const DashboardScreen(),
                  //   ),
                  // );

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          RoutesName.dashboardRoute, (route) => false)
                      .then((value) {
                    setState(() {});
                  });
                  // Navigator.pushReplacementNamed(
                  //         context, RoutesName.dashboardRoute)
                  //     .then((value) => setState(() {}));
                  Provider.of<ProductProvider>(context, listen: false);
                },
                child: Transform.scale(
                  scale: 0.7,
                  child: Image.asset(
                    'assets/appImages/backArrow.png',
                    color: ThemeApp.primaryNavyBlackColor,
                    // height: height*.001,
                  ),
                ),
              ),

              // leadingWidth: width * .06,
              title: TextFieldUtils().dynamicText(
                  'My Account',
                  context,
                  TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      // fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.height * .022,
                      fontWeight: FontWeight.w500)),
              // Row
            ),
          ),
        ),
        bottomNavigationBar: bottomNavigationBarWidget(context, 0),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: Consumer<HomeProvider>(builder: (context, value, child) {
            return FutureBuilder<UserModel>(
                future: AuthRepository()
                    .getUserDetailsById(StringConstant.UserLoginId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? Container(
                          color: ThemeApp.appBackgroundColor,
                          width: width,
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 227,
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 25, 0, 25),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      color: ThemeApp.whiteColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // imageFile1 != null
                                        snapshot.data!.payload!.imageUrl
                                                    .toString() !=
                                                null
                                            ? Stack(
                                                // alignment: Alignment.center,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      width: 110.0,
                                                      height: 110.0,
                                                      decoration:
                                                          new BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: ThemeApp
                                                                  .appLightColor,
                                                              spreadRadius: 1,
                                                              blurRadius: 5)
                                                        ],
                                                        border: Border.all(
                                                            color: ThemeApp
                                                                .whiteColor,
                                                            width: 4),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    100)),
                                                        child: Image.network(
                                                          // imageFile1!,
                                                          snapshot
                                                                  .data!
                                                                  .payload!
                                                                  .imageUrl ??
                                                              "",
                                                          fit: BoxFit.fitWidth,
                                                          width: 90.0,
                                                          height: 90.0,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Icon(
                                                              Icons.image,
                                                              color: ThemeApp
                                                                  .whiteColor,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: width / 2.5,
                                                    // width: 130.0,

                                                    // height: 40.0,
                                                    child: InkWell(
                                                        onTap: () {
                                                          // _getFromCamera();


                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return ProfileImageDialog(
                                                                    isEditAccount: false);
                                                              });
                                                        },
                                                        child: Container(
                                                          height: 32,
                                                          width: 32,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              color: ThemeApp
                                                                  .appColor),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(7),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/appImages/cameraIcon.svg',
                                                              color: ThemeApp
                                                                  .whiteColor,
                                                              semanticsLabel:
                                                                  'Acme Logo',

                                                              // height: height * .03,
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              )
                                            : Stack(
                                                // alignment: Alignment.center,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      width: 110.0,
                                                      height: 110.0,
                                                      decoration:
                                                          new BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: ThemeApp
                                                                  .appBackgroundColor,
                                                              spreadRadius: 1,
                                                              blurRadius: 15)
                                                        ],
                                                        color: ThemeApp
                                                            .appBackgroundColor,
                                                        border: Border.all(
                                                            color: ThemeApp
                                                                .whiteColor,
                                                            width: 7),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    100)),
                                                        child: Image.file(
                                                          File(''),
                                                          fit: BoxFit.fitWidth,
                                                          width: 130.0,
                                                          height: 130.0,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Icon(
                                                              Icons.image,
                                                              color: ThemeApp
                                                                  .whiteColor,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: width / 2.5,
                                                    // width: 130.0,

                                                    // height: 40.0,
                                                    child: InkWell(
                                                        onTap: () {
                                                          // _getFromCamera();

                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return ProfileImageDialog(
                                                                    isEditAccount: false);
                                                              });
                                                        },
                                                        child: Container(
                                                          height: 32,
                                                          width: 32,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              color: ThemeApp
                                                                  .appColor),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(7),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/appImages/cameraIcon.svg',
                                                              color: ThemeApp
                                                                  .whiteColor,
                                                              semanticsLabel:
                                                                  'Acme Logo',

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
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFieldUtils().dynamicText(
                                            snapshot.data!.payload!.username
                                                .toString(),
                                            // StringConstant.loginUserName,
                                            context,
                                            TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ThemeApp.blackColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                letterSpacing: -0.25)),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        TextFieldUtils().dynamicText(
                                            snapshot.data!.payload!.email
                                                .toString(),
                                            // StringConstant.loginUserEmail,
                                            context,
                                            TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ThemeApp.lightFontColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.5)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        //push notifications
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    iconsUtils(
                                                        'assets/appImages/notificationIcon.svg',
                                                        17,
                                                        15.41),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    accountTextList(
                                                        'Notifications'),
                                                  ],
                                                ),
                                                Transform.scale(
                                                  scale: 1.1,
                                                  child: Switch(
                                                    // This bool value toggles the switch.
                                                    value: isNotification,
                                                    activeColor:
                                                        ThemeApp.appLightColor,
                                                    inactiveTrackColor:
                                                        ThemeApp.appLightColor,
                                                    inactiveThumbColor:
                                                        ThemeApp.whiteColor,
                                                    onChanged: (bool val) {
                                                      // This is called when the user toggles the switch.
                                                      setState(() {
                                                        isNotification = val;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //my orders
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
                                                    'assets/appImages/myOrderIcon.svg',
                                                    18.65,
                                                    18),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList('My Orders'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        /*  ChangeNotifierProvider<CartViewModel>.value(
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
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SavedAddressDetails(
                                                        cartForPaymentPayload:
                                                            cartForPaymentPayload),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                iconsUtils(
                                                    'assets/appImages/savedAddressIcon.svg'),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList('Saved Addresses'),
                                              ],
                                            ),
                                          ),
                                        );
                                    }
                                    return SizedBox();
                                  }),
                                ),*/
//address

                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SavedAddressDetails(),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                iconsUtils(
                                                    'assets/appImages/savedAddressIcon.svg',
                                                    20,
                                                    15.26),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList(
                                                    'Saved Addresses'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //edit profile
                                        InkWell(
                                          onTap: () async {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditAccountActivity(
                                                        // payload:
                                                        //     snapshot.data!.payload,
                                                        ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                iconsUtils(
                                                    'assets/appImages/settingIcon.svg',
                                                    20,
                                                    18),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList('Edit profile'),
                                              ],
                                            ),
                                          ),
                                        ), //change password
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
                                                    'assets/appImages/changePassIcon.svg',
                                                    21.59,
                                                    19),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList(
                                                    'Change Password'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //customer support
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
                                                    'assets/appImages/headPhoneIcon.svg',
                                                    18,
                                                    18),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList(
                                                    'Customer Support'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        /*    //account settings
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountSettingScreen(),
                                      ),
                                    );
                                  },
                                  */
                                        /*     onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const EditAccountActivity(),
                                      ),
                                    );
                                  },*/ /*
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        iconsUtils(
                                            'assets/appImages/settingIcon.svg'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        accountTextList('Account Settings'),
                                      ],
                                    ),
                                  ),
                                ),*/

                                        //sign out
                                        InkWell(
                                          onTap: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setInt('isUserLoggedIn', 0);
                                            prefs.setString('RandomUserId', '');
                                            StringConstant.UserLoginId = '';
                                            StringConstant.RandomUserLoginId =
                                                '';
                                            StringConstant.UserCartID = '';
                                            StringConstant.BadgeCounterValue =
                                                '';
                                            StringConstant.ScannedProductId =
                                                '';
                                            final pref = await SharedPreferences
                                                .getInstance();

                                            await pref.clear();
                                            late Random rnd;
                                            var min = 100000000;
                                            int max = 1000000000;

                                            var ID;
                                            String finalId = '';
                                            rnd = new Random();
                                            var r =
                                                min + rnd.nextInt(max - min);

                                            print(
                                                "$r is in the range of $min and $max");
                                            ID = r;
                                            print("cartId empty UserID" +
                                                ID.toString());
                                            // 715223688
                                            finalId = ID.toString();
                                            prefs.setString('RandomUserId',
                                                finalId.toString());
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    RoutesName.dashboardRoute,
                                                    (route) => false)
                                                .then((value) {
                                              setState(() {});
                                            });
                                            Utils.successToast(
                                                'You are signed out');
                                            // _getCurrentPosition().then((value) {
                                            //   setState(() {
                                            //     StringConstant.CurrentPinCode =
                                            //         (prefs.getString(
                                            //                 'CurrentPinCodePrefs')) ??
                                            //             '';
                                            //   });
                                            // });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                iconsUtils(
                                                    'assets/appImages/signOutIcon.svg',
                                                    18,
                                                    18),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList('Sign Out'),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        )
                      : Container(
                          color: ThemeApp.appBackgroundColor,
                          width: width,
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 227,
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 25, 0, 25),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      color: ThemeApp.whiteColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // imageFile1 != null
                                        Stack(
                                          // alignment: Alignment.center,
                                          children: [
                                            Center(
                                              child: Container(
                                                width: 110.0,
                                                height: 110.0,
                                                decoration: new BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: ThemeApp
                                                            .appBackgroundColor,
                                                        spreadRadius: 1,
                                                        blurRadius: 15)
                                                  ],
                                                  color: ThemeApp
                                                      .appBackgroundColor,
                                                  border: Border.all(
                                                      color:
                                                          ThemeApp.whiteColor,
                                                      width: 7),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(100)),
                                                  child: Image.file(
                                                    File(''),
                                                    fit: BoxFit.fitWidth,
                                                    width: 130.0,
                                                    height: 130.0,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Icon(
                                                        Icons.image,
                                                        color:
                                                            ThemeApp.whiteColor,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: width / 2.5,
                                              // width: 130.0,

                                              // height: 40.0,
                                              child: InkWell(
                                                  onTap: () {
                                                    // _getFromCamera();
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return ProfileImageDialog(
                                                              isEditAccount: false);
                                                        });
                                                  },
                                                  child: Container(
                                                    height: 32,
                                                    width: 32,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color:
                                                            ThemeApp.appColor),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              7),
                                                      child: SvgPicture.asset(
                                                        'assets/appImages/cameraIcon.svg',
                                                        color:
                                                            ThemeApp.whiteColor,
                                                        semanticsLabel:
                                                            'Acme Logo',

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
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFieldUtils().dynamicText(
                                            "",
                                            // StringConstant.loginUserName,
                                            context,
                                            TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ThemeApp.blackColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                letterSpacing: -0.25)),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        TextFieldUtils().dynamicText(
                                            "",
                                            // StringConstant.loginUserEmail,
                                            context,
                                            TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ThemeApp.lightFontColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.5)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        //push notifications
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    iconsUtils(
                                                        'assets/appImages/notificationIcon.svg',
                                                        17,
                                                        15.41),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    accountTextList(
                                                        'Notifications'),
                                                  ],
                                                ),
                                                Transform.scale(
                                                  scale: 1.1,
                                                  child: Switch(
                                                    // This bool value toggles the switch.
                                                    value: isNotification,
                                                    activeColor:
                                                        ThemeApp.appLightColor,
                                                    inactiveTrackColor:
                                                        ThemeApp.appLightColor,
                                                    inactiveThumbColor:
                                                        ThemeApp.whiteColor,
                                                    onChanged: (bool val) {
                                                      // This is called when the user toggles the switch.
                                                      setState(() {
                                                        isNotification = val;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //my orders
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
                                                    'assets/appImages/myOrderIcon.svg',
                                                    18.65,
                                                    18),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList('My Orders'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        /*  ChangeNotifierProvider<CartViewModel>.value(
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
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SavedAddressDetails(
                                                        cartForPaymentPayload:
                                                            cartForPaymentPayload),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                iconsUtils(
                                                    'assets/appImages/savedAddressIcon.svg'),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList('Saved Addresses'),
                                              ],
                                            ),
                                          ),
                                        );
                                    }
                                    return SizedBox();
                                  }),
                                ),*/
//address

                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SavedAddressDetails(),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                iconsUtils(
                                                    'assets/appImages/savedAddressIcon.svg',
                                                    20,
                                                    15.26),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList(
                                                    'Saved Addresses'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //edit profile
                                        InkWell(
                                          onTap: () async {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditAccountActivity(
                                                        // payload:
                                                        //     snapshot.data!.payload,
                                                        ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                iconsUtils(
                                                    'assets/appImages/settingIcon.svg',
                                                    20,
                                                    18),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList('Edit profile'),
                                              ],
                                            ),
                                          ),
                                        ), //change password
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
                                                    'assets/appImages/changePassIcon.svg',
                                                    21.59,
                                                    19),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList(
                                                    'Change Password'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //customer support
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
                                                    'assets/appImages/headPhoneIcon.svg',
                                                    18,
                                                    18),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList(
                                                    'Customer Support'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        /*    //account settings
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountSettingScreen(),
                                      ),
                                    );
                                  },
                                  */
                                        /*     onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const EditAccountActivity(),
                                      ),
                                    );
                                  },*/ /*
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        iconsUtils(
                                            'assets/appImages/settingIcon.svg'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        accountTextList('Account Settings'),
                                      ],
                                    ),
                                  ),
                                ),*/

                                        //sign out
                                        InkWell(
                                          onTap: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setInt('isUserLoggedIn', 0);
                                            prefs.setString('RandomUserId', '');
                                            StringConstant.UserLoginId = '';
                                            StringConstant.RandomUserLoginId =
                                                '';
                                            StringConstant.UserCartID = '';
                                            StringConstant.BadgeCounterValue =
                                                '';
                                            StringConstant.ScannedProductId =
                                                '';
                                            final pref = await SharedPreferences
                                                .getInstance();

                                            await pref.clear();
                                            late Random rnd;
                                            var min = 100000000;
                                            int max = 1000000000;

                                            var ID;
                                            String finalId = '';
                                            rnd = new Random();
                                            var r =
                                                min + rnd.nextInt(max - min);

                                            print(
                                                "$r is in the range of $min and $max");
                                            ID = r;
                                            print("cartId empty UserID" +
                                                ID.toString());
                                            // 715223688
                                            finalId = ID.toString();
                                            prefs.setString('RandomUserId',
                                                finalId.toString());
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    RoutesName.dashboardRoute,
                                                    (route) => false)
                                                .then((value) {
                                              setState(() {});
                                            });
                                            Utils.successToast(
                                                'You are signed out');
                                            // _getCurrentPosition().then((value) {
                                            //   setState(() {
                                            //     StringConstant.CurrentPinCode =
                                            //         (prefs.getString(
                                            //                 'CurrentPinCodePrefs')) ??
                                            //             '';
                                            //   });
                                            // });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                iconsUtils(
                                                    'assets/appImages/signOutIcon.svg',
                                                    18,
                                                    18),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                accountTextList('Sign Out'),
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
                });
          }),
        ),
      ),
    );
  }

  Position? _currentPosition;

  Future<Future<void>> _getCurrentPosition() async {
    LocationPermission permission;

    bool serviceEnabled;
    // LocationPermission permission;

// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // startTime();

      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Utils.errorToast('Location Permission Denied');

        // permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getLocation(_currentPosition!);
    }).catchError((e) {
      print(e.toString());
    });
  }

  _getLocation(Position position) async {
    final coordinates = Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("address.streetAddress" + first.postalCode.toString());
    print("${first.featureName} : ${first.addressLine}");
    final prefs = await SharedPreferences.getInstance();

    var splitag = first.addressLine?.split(",");
    // var houseBuilding = splitag[0]+', '+splitag[1];
    // var areaColony = splitag[2];
    // var state = splitag[3];
    // var city = splitag[4];
    var pincode = first.postalCode;

    setState(() {
      prefs
          .setString('CurrentPinCodePrefs', first.postalCode.toString())
          .then((value) {
        Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute);
        Utils.successToast('You are signed out');
      });
    });
  }

  Widget iconsUtils(String svgIcon, double height, double width) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: ThemeApp.appColor),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: SvgPicture.asset(
          svgIcon,
          color: ThemeApp.whiteColor,
          semanticsLabel: 'Acme Logo',
          height: height,
          width: width,
          // height: height * .03,
        ),
      ),
    );
  }

  Widget accountTextList(String text) {
    return TextFieldUtils().dynamicText(
        text,
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: -0.25));
  }

  // Widget bottomSheetForImagePicker() {
  //   return SingleChildScrollView(
  //     child: Container(
  //       padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
  //       decoration: const BoxDecoration(
  //           color: ThemeApp.whiteColor,
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20.0),
  //               topRight: Radius.circular(20.0))),
  //       // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           accountTextList('Change Profile Photo'),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Row(
  //             children: [
  //               InkWell(
  //                 onTap: () async {
  //                   // final prefs = await SharedPreferences.getInstance();
  //                   //
  //                   // FilePickerResult? pickedFile =
  //                   // await FilePicker.platform.pickFiles();
  //                   // if (pickedFile != null) {
  //                   //   String? filePath = pickedFile.files.single.path;
  //                   //   if (filePath != null) {
  //                   //     final file = File(filePath);
  //                   //     await prefs.setString('profileImagePrefs', filePath);
  //                   //
  //                   //     imageFile1 = file;
  //                   //     Navigator.of(context).pushReplacement(
  //                   //       MaterialPageRoute(
  //                   //         builder: (context) =>  EditAccountActivity(),
  //                   //       ),
  //                   //     );
  //                   //   }
  //                   // }
  //
  //                   final prefs = await SharedPreferences.getInstance();
  //
  //                   final pickedFile = await picker.getImage(
  //                     source: ImageSource.gallery,);
  //                   print(pickedFile!.path.toString());
  //                   if (pickedFile != null) {
  //                     await prefs.setString(
  //                         'userProfileImagePrefs', pickedFile.path);
  //                     await prefs.setString(
  //                         'profileImagePrefs', pickedFile.path);
  //                     StringConstant.UserLoginId =
  //                         (prefs.getString('isUserId')) ?? '';
  //
  //
  //                     AuthRepository().updateProfileImageApi(
  //                         File(pickedFile.path), StringConstant.UserLoginId, context);
  //
  //                     Navigator.of(context).pushReplacement(
  //                       MaterialPageRoute(
  //                         builder: (context) =>  EditAccountActivity(),
  //                       ),
  //                     );
  //                   }
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: ThemeApp.lightBorderColor,
  //                     borderRadius: BorderRadius.all(Radius.circular(8)),
  //                     // border: Border.all(color: ThemeApp.lightBorderColor)
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20),
  //                     child: SvgPicture.asset(
  //                       'assets/appImages/imageIcon.svg',
  //                       color: ThemeApp.subIconColor,
  //                       semanticsLabel: 'Acme Logo',
  //                       height: 37,
  //                       // height: height * .03,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               InkWell(
  //                 onTap: () async {
  //                   // var image =
  //                   // await picker.getImage(source: ImageSource.camera);
  //                   // final prefs = await SharedPreferences.getInstance();
  //                   // // StringConstant.CurrentPinCode = (prefs.getString('CurrentPinCodePref') ?? '');
  //                   // String imagePath = image!.path;
  //                   //
  //                   // await prefs.setString('profileImagePrefs', imagePath);
  //                   // Map data = {
  //                   //   "imgUrl": image.path,
  //                   // };
  //                   //
  //                   // setState(() {
  //                   //   imageFile1 = File(image.path);
  //                   //   Navigator.of(context).pushReplacement(
  //                   //     MaterialPageRoute(
  //                   //       builder: (context) =>  EditAccountActivity(),
  //                   //     ),
  //                   //   );
  //                   // });
  //
  //
  //                   var image = await picker.getImage(source: ImageSource.camera);
  //                   final prefs = await SharedPreferences.getInstance();
  //                   String imagePath = image!.path;
  //                   await prefs.setString('profileImagePrefs', imagePath);
  //                   StringConstant.UserLoginId =
  //                       (prefs.getString('isUserId')) ?? '';
  //                   await  prefs.setString('userProfileImagePrefs',imagePath) ;
  //
  //                   AuthRepository().updateProfileImageApi(
  //                       File(image.path), StringConstant.UserLoginId,context);
  //
  //                   Navigator.of(context).pushReplacement(
  //                     MaterialPageRoute(
  //                       builder: (context) => EditAccountActivity(),
  //                     ),
  //                   );
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: ThemeApp.lightBorderColor,
  //                     borderRadius: BorderRadius.all(Radius.circular(8)),
  //                     // border: Border.all(color: ThemeApp.lightBorderColor)
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20),
  //                     child: SvgPicture.asset(
  //                       'assets/appImages/cameraIconGrey.svg',
  //                       color: ThemeApp.subIconColor,
  //                       semanticsLabel: 'Acme Logo',
  //                       height: 37,
  //                       // height: height * .03,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

}
