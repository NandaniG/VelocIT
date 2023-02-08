import 'dart:async';
import 'dart:io';

import 'package:barcode_finder/barcode_finder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Model/ProductCategoryModel.dart';
import 'package:velocit/pages/Activity/DashBoard_DetailScreens_Activities/service_ui/Service_Categories_Activity.dart';
import 'package:velocit/pages/screens/cartDetail_Activity.dart';
import 'package:velocit/utils/utils.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';
import 'package:velocit/widgets/global/textFormFields.dart';

import '../../Core/ViewModel/cart_view_model.dart';
import '../../Core/ViewModel/dashboard_view_model.dart';
import '../../Core/ViewModel/product_listing_view_model.dart';
import '../../Core/data/responses/status.dart';
import '../../Core/repository/cart_repository.dart';
import '../../pages/Activity/Merchant_Near_Activities/merchant_Activity.dart';
import '../../pages/Activity/My_Account_Activities/AccountSetting/NotificationScreen.dart';
import '../../pages/Activity/My_Account_Activities/SaveCardAndWallets/CardList_manage_Payment_Activity.dart';
import '../../pages/Activity/My_Account_Activities/MyAccount_activity.dart';
import '../../pages/Activity/My_Account_Activities/is_My_account_login_dialog.dart';
import '../../pages/Activity/Product_Activities/ProductDetails_activity.dart';
import '../../pages/Activity/Product_Activities/Products_List.dart';
import '../../pages/SearchContent/searchProductListScreen.dart';
import '../../pages/homePage.dart';
import '../../pages/screens/dashBoard.dart';
import '../../pages/screens/offers_Activity.dart';
import '../../pages/tabs/tabs.dart';
import '../../services/providers/Home_Provider.dart';
import '../../services/providers/Products_provider.dart';
import '../../utils/constants.dart';
import '../../utils/routes/routes.dart';
import '../../utils/styles.dart';
import '../features/SpeechToTextDialog_Screen.dart';
import '../features/addressScreen.dart';
import '../features/switchLanguages.dart';
import '../features/scannerWithGallery.dart';
import 'autoSearchLocation_popup.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;

import 'okPopUp.dart';

speechToText.SpeechToText? speech;

class AppBarWidget extends StatefulWidget {
  final BuildContext context;
  final Widget titleWidget;
  final Widget location;

  AppBarWidget(
      {Key? key,
      required this.context,
      required this.titleWidget,
      required this.location})
      : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  getPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      StringConstant.ProfilePhoto =
          (prefs.getString('profileImagePrefs')) ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return appBarWidget(context, widget.titleWidget);
  }

  Widget appBarWidget(
    BuildContext context,
    Widget titleWidget,
  ) {
    double height = 0.0;
    double width = 0.0;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: ThemeApp.appBackgroundColor,
            child: AppBar(
              centerTitle: true,
              titleSpacing: 5,

              // elevation: 1,
              backgroundColor: ThemeApp.appBackgroundColor,
              flexibleSpace: Container(
                height: height * .08,
                width: width,
                decoration: const BoxDecoration(
                  color: ThemeApp.appBackgroundColor,
                ),
              ),
              automaticallyImplyLeading: false,
              leadingWidth: Navigator.canPop(context) ? width * .1 : 0,

              leading: Navigator.canPop(context)
                  ? InkWell(
                      onTap: () {
                        (() {});
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
                      child: Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Center(
                          child: Transform.scale(
                            scale: 1.5,
                            child: Image.asset(
                              'assets/appImages/backArrow.png',
                              color: ThemeApp.primaryNavyBlackColor,
                              // height: height*.001,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),

              title: titleWidget,
              // Row
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: Container(
                      // height: 25,
                      // width: 25,
                      child: SvgPicture.asset(
                        'assets/appImages/notificationIcon.svg',
                        color: ThemeApp.primaryNavyBlackColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(
                          currentColor: ThemeApp.primaryNavyBlackColor,
                        ),
                        height: 28,
                        width: 28,
                      ),
                    ),
                  ),
                ),
                Consumer<HomeProvider>(builder: (context, provider, child) {
                  return Consumer<ProductProvider>(
                      builder: (context, product, child) {
                    return /*StringConstant.isLogIn == false
                        ? const SizedBox(
                            width: 0,
                          )
                        : */
                        InkWell(
                      onTap: () async {
                        /// locale languages
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //       builder: (context) => FlutterLocalizationDemo()),
                        // );

                        if (kDebugMode) {
                          print("provider.cartProductList");
                          // print(provider.cartProductList);
                        }
                        product.badgeFinalCount;

                        provider.isBottomAppCart = true;
                        provider.isHome = true;

                        final prefs = await SharedPreferences.getInstance();
                        StringConstant.loginUserName =
                            (prefs.getString('usernameLogin')) ?? '';
                        StringConstant.loginUserEmail =
                            (prefs.getString('emailLogin')) ?? '';

                        StringConstant.isUserLoggedIn =
                            (prefs.getInt('isUserLoggedIn')) ?? 0;
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => CartDetailsActivity(
                        //             value: product, productList: provider.cartProductList)),
                        //         (route) => false);
                        if (StringConstant.isUserLoggedIn != 0) {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MyAccountActivity(),
                                ),
                              )
                              .then((value) => setState(() {}));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AccountVerificationDialog();
                              });
                        }
                      },
                      child: StringConstant.ProfilePhoto == ''
                          ? Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SvgPicture.asset(
                                'assets/appImages/profileIcon.svg',
                                color: ThemeApp.primaryNavyBlackColor,
                                semanticsLabel: 'Acme Logo',
                                theme: SvgTheme(
                                  currentColor: ThemeApp.primaryNavyBlackColor,
                                ),
                                height: 28,
                                width: 28,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                height: 28,
                                width: 28,
                                child: CircleAvatar(
                                  backgroundColor: ThemeApp.whiteColor,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100)),
                                    child: Image.file(
                                      File(StringConstant.ProfilePhoto),
                                      fit: BoxFit.fill,
                                      height: 25,
                                      width: 25,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.image,
                                          color: ThemeApp.whiteColor,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       top: 13, bottom: 13, right: 15),
                      //   child: Image.asset(
                      //     'assets/appImages/userIcon.png',
                      //     // width: double.infinity,
                      //     height: height * .1,
                      //     color: ThemeApp.primaryNavyBlackColor,
                      //     fit: BoxFit.fill,
                      //   ),
                      // ),
                    );
                  });
                }),
              ],
            ),
          ),
          widget.location
        ],
      ),
    );
  }
}

class AppBar_BackWidget extends StatefulWidget {
  final BuildContext context;
  final Widget titleWidget;
  final Widget location;

  AppBar_BackWidget(
      {Key? key,
      required this.context,
      required this.titleWidget,
      required this.location})
      : super(key: key);

  @override
  State<AppBar_BackWidget> createState() => _AppBar_BackWidgetState();
}

class _AppBar_BackWidgetState extends State<AppBar_BackWidget> {
  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: ThemeApp.darkGreyTab,
          child: AppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: ThemeApp.appBackgroundColor,
            flexibleSpace: Container(
              height: height * .08,
              width: width,
              decoration: const BoxDecoration(
                color: ThemeApp.appBackgroundColor,
              ),
            ),

            titleSpacing: 1,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context, () {
                  setState(() {});
                }); // Provider.of<ProductProvider>(context, listen: false);
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
            title: widget.titleWidget,
            // Row
          ),
        ),
        widget.location
      ],
    ));
  }
}

///back with route

class AppBar_Back_RouteWidget extends StatefulWidget {
  final BuildContext context;
  final Widget titleWidget;
  final Widget location;
  final VoidCallback onTap;

  AppBar_Back_RouteWidget(
      {Key? key,
      required this.context,
      required this.titleWidget,
      required this.location,
      required this.onTap})
      : super(key: key);

  @override
  State<AppBar_Back_RouteWidget> createState() =>
      _AppBar_Back_RouteWidgetState();
}

class _AppBar_Back_RouteWidgetState extends State<AppBar_Back_RouteWidget> {
  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: ThemeApp.darkGreyTab,
          child: AppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: ThemeApp.appBackgroundColor,
            flexibleSpace: Container(
              height: height * .08,
              width: width,
              decoration: const BoxDecoration(
                color: ThemeApp.appBackgroundColor,
              ),
            ),

            titleSpacing: 1,
            leading: InkWell(
              onTap: widget.onTap,
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
            title: widget.titleWidget,
            // Row
          ),
        ),
        widget.location
      ],
    ));
  }
}

Widget appTitle(BuildContext context, String text) {
  return Container(
    alignment: Alignment.centerLeft,
    child: TextFieldUtils().dynamicText(
        text,
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            // fontWeight: FontWeight.w500,
            fontSize: MediaQuery.of(context).size.height * .022,
            fontWeight: FontWeight.w500)),
  );
}

Widget searchBar(BuildContext context) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  DashboardViewModel productCategories = DashboardViewModel();
  productCategories.productCategoryListingWithGet();

  return ChangeNotifierProvider<DashboardViewModel>.value(
    value: productCategories,
    child: Consumer<DashboardViewModel>(
        builder: (context, dashBoardProvider, child) {
      return Consumer<HomeProvider>(builder: (context, provider, child) {
        return Container(
          width: width,
          height: height * .1,
          // color: ThemeApp.redColor,
          padding: const EdgeInsets.only(top: 10, left: 0),
          alignment: Alignment.center,
          child: TextFormField(
            textInputAction: TextInputAction.search,

            controller: StringConstant.controllerSpeechToText,
            onFieldSubmitted: (value) {
              print("Getting Value" +
                  productCategories
                      .productCategoryList.data!.productList![0].name
                      .toString());
              switch (dashBoardProvider.productCategoryList.status) {
                case Status.LOADING:
                  return print("Getting Value");
                case Status.COMPLETED:
                  if (kDebugMode) {
                    print("Api calll");
                  }

                  List<ProductList>? serviceList =
                      productCategories.productCategoryList.data!.productList;
                  /*  productCategories.getProductBySearchTermsWithGet(
                    0,
                    10,
                    StringConstant.controllerSpeechToText.text.toString(),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchProductListScreen(
                        searchText: StringConstant.controllerSpeechToText.text,
                      ),
                    ),
                  );*/

                  productCategories.getProductBySearchTermsWithGet(
                    0,
                    10,
                    StringConstant.controllerSpeechToText.text.toString(),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchProductListScreen(
                        searchText: StringConstant.controllerSpeechToText.text,
                      ),
                    ),
                  );
              }
              /*  Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductListByCategoryActivity(
                      productList: productCategories.),
                ),
              );*/
              if (kDebugMode) {
                print("search.........");
              } // showDialog(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return OkDialog(text: StringConstant.controllerSpeechToText.text);
              //     });
            },
            onChanged: (val) {
              // print("StringConstant.speechToText..." +
              //     StringConstant.speechToText);
              // (() {
              //   if (val.isEmpty) {
              //     val = StringConstant.speechToText;
              //   } else {
              //     StringConstant.speechToText = StringConstant.controllerSpeechToText.text;
              //   }
              // });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: ThemeApp.whiteColor,
              isDense: true,
              // contentPadding:
              //     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              /* -- Text and Icon -- */
              hintText: "Search",
              hintStyle: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: ThemeApp.darkGreyTab,
              ),
              prefixIconColor: ThemeApp.primaryNavyBlackColor,
              prefixIcon: /*const Icon(
                  Icons.search,
                  size: 26,
                  color: Colors.black54,
                ),*/
                  Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/appImages/searchIcon.svg',
                  color: ThemeApp.primaryNavyBlackColor,
                  semanticsLabel: 'Acme Logo',
                  theme: SvgTheme(
                    currentColor: ThemeApp.primaryNavyBlackColor,
                  ),
                  height: height * .001,
                ),
              ),
              suffixIcon: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SpeechToTextDialog();
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/appImages/miceIcon.svg',
                    color: ThemeApp.primaryNavyBlackColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.primaryNavyBlackColor,
                    ),
                    height: height * .001,
                  ),
                ), /*const Icon(
                    Icons.mic,
                    size: 26,
                    color: Colors.black54,
                  ),*/
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: ThemeApp.redColor, width: 1)),
              // OutlineInputBorder
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: ThemeApp.appBackgroundColor, width: 1)),
              // OutlineInputBorder
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: ThemeApp.appBackgroundColor, width: 1)),
            ), // InputDecoration
          ),
        );
      });
    }),
  );
}

class AddressWidgets extends StatefulWidget {
  const AddressWidgets({Key? key}) : super(key: key);

  @override
  State<AddressWidgets> createState() => _AddressWidgetsState();
}

class _AddressWidgetsState extends State<AddressWidgets> {
  var finalPicode='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  getPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      finalPicode = prefs.getString('CurrentPinCodePrefs')??"";
      print(
          "placesFromCurrentLocation CurrentPinCode pref...${finalPicode.toString()}");

      StringConstant.placesFromCurrentLocation =
      (prefs.getString('SearchedPinCodePrefs'))??"";
      StringConstant.CurrentPinCode =
      (prefs.getString('CurrentPinCodePrefs') ?? '');
/*

        if (StringConstant.placesFromCurrentLocation == '') {
          finalPicode = StringConstant.CurrentPinCode;
          setState(() {});
        } else {
          finalPicode = selectedPincode;
          setState(() {});
        }
*/



      if (StringConstant.placesFromCurrentLocation == '') {
        finalPicode = StringConstant.CurrentPinCode;
      } else {
        finalPicode =
            StringConstant.placesFromCurrentLocation;
      }
      print(
          "placesFromCurrentLocation CurrentPinCode pref...${finalPicode.toString()}");

    });
  }

  @override
  Widget build(BuildContext context) {
    return addressWidget(
      context,
    );
  }

  Widget addressWidget(
    BuildContext context,
  ) {
    double height = 0.0;
    double width = 0.0;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    String pc = '';
    return InkWell(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AutoSearchPlacesPopUp();
            });
        StringConstant.placesFromCurrentLocation =
            (prefs.getString('SearchedPinCodePrefs'))!;
        StringConstant.CurrentPinCode =
            (prefs.getString('CurrentPinCodePrefs') ?? '');
/*

        if (StringConstant.placesFromCurrentLocation == '') {
          finalPicode = StringConstant.CurrentPinCode;
          setState(() {});
        } else {
          finalPicode = selectedPincode;
          setState(() {});
        }
*/



        if (StringConstant.placesFromCurrentLocation == '') {
          finalPicode = StringConstant.CurrentPinCode;
          setState(() {});
        } else {
          finalPicode =
              StringConstant.placesFromCurrentLocation;
          setState(() {});
        }

         await prefs.setString('SearchedPinCodePrefs',finalPicode.toString());


        prefs.setString(
            'selectedPincode', finalPicode.toString());

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => AddressScreen(),
        //   ),
        // );
      },
      child: Center(
        child: Container(
          height: height * .036,
          color: ThemeApp.appBackgroundColor,
          width: width,
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * .02,
              ),
              InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  finalPicode = StringConstant.CurrentPinCode;

                },
                child: Icon(
                  Icons.not_listed_location_outlined,
                  color: ThemeApp.tealButtonColor,
                  size: MediaQuery.of(context).size.height * .028,
                ),
              ),
              SizedBox(
                width: width * .01,
              ),
              SizedBox(
                child: TextFieldUtils().dynamicText(
                    "Deliver to - ${finalPicode} ",
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.tealButtonColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400)),
              ),
              /*   SizedBox(
              child: TextFieldUtils().dynamicText(

                  "Deliver to - ${StringConstant.FINALPINCODE.toString().isEmpty ? StringConstant.CurrentPinCode.toString() : StringConstant.FINALPINCODE} ",
                  context,
                  TextStyle(fontFamily: 'Roboto',
                      color: ThemeApp.tealButtonColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
            ),*/
              //Text(StringConstant.placesFromCurrentLocation),
              SizedBox(
                width: width * .01,
              ),
              Icon(
                Icons.keyboard_arrow_down_sharp,
                color: ThemeApp.tealButtonColor,
                // size: 20,
                size: MediaQuery.of(context).size.height * .028,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget bottomNavBarItems(BuildContext context, int indexSelected) {
  (() {
    final dashBoardData =
        Provider.of<DashboardViewModel>(context, listen: false);
    dashBoardData.productCategoryListingWithGet();
  });

  int _currentIndex = indexSelected;
  final dashBoardData = Provider.of<DashboardViewModel>(context);

  // return Consumer<HomeProvider>(builder: (context, provider, child) {
  //   return Consumer<ProductProvider>(builder: (context, product, child) {
  //     return Consumer<DashboardViewModel>(
  //         builder: (context, productCategories, child) {

  //     });
  //   });
  // });
  return BottomNavigationBar(
    backgroundColor: ThemeApp.whiteColor,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: ThemeApp.appColor,
    unselectedItemColor: ThemeApp.unSelectedBottomBarItemColor,
    currentIndex: _currentIndex,
    onTap: (int index) async {
      final preference = await SharedPreferences.getInstance();
      _currentIndex = index;

      if (_currentIndex == 0) {
        // Navigator.pushNamed(context, '/dashBoardScreen');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
            (route) => false);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));

      }
      if (_currentIndex == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OfferActivity(),
            ),
            (route) => false);
      }
      if (_currentIndex == 3) {
        // final dashBoardData = Provider.of<DashboardViewModel>(context, listen: false).productCategoryList;
        // List<ProductList>? serviceListss;
        // colors = ThemeApp.blackColor;
        // List<ProductList>? serviceList =
        //     productCategories.productCategoryList.data!.productList;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MerchantActvity(),
            ),
            (route) => false);

        /*    Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopByCategoryActivity(
                        shopByCategoryList: serviceListss,

                        // provider.jsonData["shopByCategoryList"],
                        shopByCategorySelected: 0),
                  ),
                  (route) => false);*/
      }
      /*      if (_currentIndex == 4) {
              if (StringConstant.isLogIn == true) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyAccountActivity(),
                  ),
                );
              }
            }*/

      if (_currentIndex == 4) {
        // colors = ThemeApp.blackColor;

        StringConstant.BadgeCounterValue =
            (preference.getString('setBadgeCountPrefs')) ?? '';
        print("Badge,........" + StringConstant.BadgeCounterValue);
        if (kDebugMode) {}
        // product.badgeFinalCount;

        // provider.isBottomAppCart = true;
        // provider.isHome = true;

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CartDetailsActivity(
                  /* value: product,
                          productList: provider.cartProductList*/
                  )),
        );
      }
    },
    items: [
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: _currentIndex == 0
            ? Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: SvgPicture.asset(
                  'assets/appImages/bottomApp/homeIcon.svg',
                  color: _currentIndex == 0
                      ? ThemeApp.appColor
                      : ThemeApp.unSelectedBottomBarItemColor,
                  semanticsLabel: 'Acme Logo',
                  theme: SvgTheme(
                    currentColor: ThemeApp.appColor,
                  ),
                  height: 25,
                  width: 25,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: SvgPicture.asset(
                  'assets/appImages/bottomApp/homeIcon.svg',
                  color: ThemeApp.unSelectedBottomBarItemColor,
                  semanticsLabel: 'Acme Logo',
                  theme: SvgTheme(
                    currentColor: ThemeApp.unSelectedBottomBarItemColor,
                  ),
                  height: 25,
                  width: 25,
                ),
              ),
        label: 'HOME',
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: _currentIndex == 1
            ? Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: SvgPicture.asset(
                  'assets/appImages/bottomApp/offerIcon.svg',
                  color: ThemeApp.appColor,
                  semanticsLabel: 'Acme Logo',
                  theme: SvgTheme(
                    currentColor: ThemeApp.appColor,
                  ),
                  height: 25,
                  width: 25,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: SvgPicture.asset(
                  'assets/appImages/bottomApp/offerIcon.svg',
                  color: ThemeApp.unSelectedBottomBarItemColor,
                  semanticsLabel: 'Acme Logo',
                  theme: SvgTheme(
                    currentColor: ThemeApp.appColor,
                  ),
                  height: 25,
                  width: 25,
                ),
              ),
        label: 'OFFER',
      ),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: _currentIndex == 2
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.add, color: Colors.transparent),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.add, color: Colors.transparent),
                ),
          label: ''),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: _currentIndex == 3
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: SvgPicture.asset(
                    'assets/appImages/bottomApp/shopIcon.svg',
                    color: ThemeApp.appColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.appColor,
                    ),
                    height: 25,
                    width: 25,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: SvgPicture.asset(
                    'assets/appImages/bottomApp/shopIcon.svg',
                    color: ThemeApp.unSelectedBottomBarItemColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.unSelectedBottomBarItemColor,
                    ),
                    height: 25,
                    width: 25,
                  ),
                ),
          label: 'SHOP'),
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Stack(
            children: <Widget>[
              _currentIndex == 4
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8),
                      child: SvgPicture.asset(
                        'assets/appImages/bottomApp/cartIcons.svg',
                        color: ThemeApp.appColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(
                          currentColor: ThemeApp.appColor,
                        ),
                        height: 25,
                        width: 25,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8),
                      child: SvgPicture.asset(
                        'assets/appImages/bottomApp/cartIcons.svg',
                        color: ThemeApp.unSelectedBottomBarItemColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(
                          currentColor: ThemeApp.unSelectedBottomBarItemColor,
                        ),
                        height: 25,
                        width: 25,
                      ),
                    ),
              StringConstant.BadgeCounterValue == '0' ||
                      StringConstant.BadgeCounterValue == ''
                  ? SizedBox()
                  : Positioned(
                      right: 0,
                      top: 0,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: Colors.red,
                          ),
                          // constraints: BoxConstraints(
                          //     minWidth: 15,
                          //     minHeight: 15,
                          //     maxHeight: 18,
                          //     maxWidth: 18),
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: Center(
                              child: Text(
                                // CartRepository().badgeLength.toString(),
                                StringConstant.BadgeCounterValue,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
          label: 'CART'),
    ],
  );
}

Widget bottomNavigationBarWidget(BuildContext context, int indexSelected) {
  final controller = BarcodeFinderController();
  return Container(
    // height: MediaQuery.of(context).size.height,

    // color: Colors.red,
    child: Stack(
      alignment: AlignmentDirectional.bottomCenter,

      // alignment: const FractionalOffset(.5, 1.0),
      // alignment: const FractionalOffset(.5, - 4.5),
      children: [
        bottomNavBarItems(context, indexSelected),
        Positioned(
          // right: 0,
          // left: 0,
          // top: -26,
          // alignment: Alignment(0, -2),
          // child: Padding(
          // padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            margin: EdgeInsets.only(bottom:50),
            height: 70,
            width: 70,
            // color: Colors.yellow,
            child: FloatingActionButton(
              backgroundColor: ThemeApp.appColor,
              onPressed: () {
                StringConstant().scanQR(context);
                // scanQRCode();
                // scanFile();
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => StepperScreen(),
                //   ),
                // );

                // showModalBottomSheet(
                //     isDismissible: true,
                //     context: context,
                //     builder: (context) {
                //       return ScannerWidget(state: controller.state);
                //     });
              },
              child: SvgPicture.asset(
                'assets/appImages/bottomApp/scanIcon.svg',
                color: ThemeApp.whiteColor,
                semanticsLabel: 'Acme Logo',
                width: 29,
                height: 29,

                // height: height * .03,
              ), /*   child: const Icon(Icons.document_scanner_outlined,
                color: ThemeApp.whiteColor),*/
            ),
          ),
          // ),
        ),
      ],
    ),
  );
}
/*Widget bottomNavBarItems(BuildContext context) {
  (() {
    final dashBoardData =
        Provider.of<DashboardViewModel>(context, listen: false);
    dashBoardData.productCategoryListingWithGet();
  });

  int _currentIndex = 0;
  final dashBoardData = Provider.of<DashboardViewModel>(context);

  return Consumer<HomeProvider>(builder: (context, provider, child) {
    return Consumer<ProductProvider>(builder: (context, product, child) {
      return Consumer<DashboardViewModel>(
          builder: (context, productCategories, child) {
        return BottomNavigationBar(
          backgroundColor: ThemeApp.whiteColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (int index) async {
            final preference = await SharedPreferences.getInstance();

            _currentIndex = index;
            if (_currentIndex == 0) {
              // Navigator.pushNamed(context, '/dashBoardScreen');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                  (route) => false);
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));

            }
            if (_currentIndex == 1) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OfferActivity(),
                  ),
                  (route) => false);
            }
            if (_currentIndex == 3) {
              // final dashBoardData = Provider.of<DashboardViewModel>(context, listen: false).productCategoryList;
              // List<ProductList>? serviceListss;
              // colors = ThemeApp.blackColor;
              // List<ProductList>? serviceList =
              //     productCategories.productCategoryList.data!.productList;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MerchantActvity(),
                  ),
                  (route) => false);

              */ /*    Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopByCategoryActivity(
                        shopByCategoryList: serviceListss,

                        // provider.jsonData["shopByCategoryList"],
                        shopByCategorySelected: 0),
                  ),
                  (route) => false);*/ /*
            }
            */ /*      if (_currentIndex == 4) {
              if (StringConstant.isLogIn == true) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyAccountActivity(),
                  ),
                );
              }
            }*/ /*

            if (_currentIndex == 4) {
              // colors = ThemeApp.blackColor;

              StringConstant.BadgeCounterValue =
                  (preference.getString('setBadgeCountPrefs')) ?? '';
              print("Badge,........" + StringConstant.BadgeCounterValue);
              if (kDebugMode) {}
              product.badgeFinalCount;

              provider.isBottomAppCart = true;
              provider.isHome = true;

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartDetailsActivity(
                        */ /* value: product,
                          productList: provider.cartProductList*/ /*
                        )),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: _currentIndex == 0
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: SvgPicture.asset(
                        'assets/appImages/bottomApp/homeIcon.svg',
                        color: ThemeApp.appColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(
                          currentColor: ThemeApp.appColor,
                        ),
                        height: 25,
                        width: 25,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: SvgPicture.asset(
                        'assets/appImages/bottomApp/homeIcon.svg',
                        color: ThemeApp.appColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(
                          currentColor: ThemeApp.appColor,
                        ),
                        height: 25,
                        width: 25,
                      ),
                    ),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: _currentIndex == 1
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: SvgPicture.asset(
                        'assets/appImages/bottomApp/offerIcon.svg',
                        color: ThemeApp.appColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(
                          currentColor: ThemeApp.appColor,
                        ),
                        height: 25,
                        width: 25,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: SvgPicture.asset(
                        'assets/appImages/bottomApp/offerIcon.svg',
                        color: ThemeApp.appColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(
                          currentColor: ThemeApp.appColor,
                        ),
                        height: 25,
                        width: 25,
                      ),
                    ),
              label: 'OFFER',
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: _currentIndex == 2
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Icon(Icons.add, color: Colors.transparent),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Icon(Icons.add, color: Colors.transparent),
                      ),
                label: ''),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: _currentIndex == 3
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: SvgPicture.asset(
                          'assets/appImages/bottomApp/shopIcon.svg',
                          color: ThemeApp.appColor,
                          semanticsLabel: 'Acme Logo',
                          theme: SvgTheme(
                            currentColor: ThemeApp.appColor,
                          ),
                          height: 25,
                          width: 25,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: SvgPicture.asset(
                          'assets/appImages/bottomApp/shopIcon.svg',
                          color: ThemeApp.appColor,
                          semanticsLabel: 'Acme Logo',
                          theme: SvgTheme(
                            currentColor: ThemeApp.appColor,
                          ),
                          height: 25,
                          width: 25,
                        ),
                      ),
                label: 'SHOP'),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Stack(
                  children: <Widget>[
                    _currentIndex == 4
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 8),
                            child: SvgPicture.asset(
                              'assets/appImages/bottomApp/cartIcons.svg',
                              color: ThemeApp.appColor,
                              semanticsLabel: 'Acme Logo',
                              theme: SvgTheme(
                                currentColor: ThemeApp.appColor,
                              ),
                              height: 25,
                              width: 25,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 8),
                            child: SvgPicture.asset(
                              'assets/appImages/bottomApp/cartIcons.svg',
                              color: ThemeApp.appColor,
                              semanticsLabel: 'Acme Logo',
                              theme: SvgTheme(
                                currentColor: ThemeApp.appColor,
                              ),
                              height: 25,
                              width: 25,
                            ),
                          ),
                    StringConstant.BadgeCounterValue == '0' ||
                            StringConstant.BadgeCounterValue == ''
                        ? SizedBox()
                        : Positioned(
                            right: 0,
                            top: 0,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                ),
                                // constraints: BoxConstraints(
                                //     minWidth: 15,
                                //     minHeight: 15,
                                //     maxHeight: 18,
                                //     maxWidth: 18),
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Center(
                                    child: Text(
                                      // CartRepository().badgeLength.toString(),
                                      '${StringConstant.BadgeCounterValue}',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
                label: 'CART'),
          ],
        );
      });
    });
  });
}

Widget bottomNavigationBarWidget(BuildContext context) {
  final controller = BarcodeFinderController();
  return Stack(
    // alignment: const FractionalOffset(.5, 1.0),
    alignment: const FractionalOffset(.5, 1.0),
    children: [
      bottomNavBarItems(context),
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            backgroundColor: ThemeApp.appColor,
            onPressed: () {
              StringConstant().scanQR(context);
              // scanQRCode();
              // scanFile();
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => StepperScreen(),
              //   ),
              // );

              // showModalBottomSheet(
              //     isDismissible: true,
              //     context: context,
              //     builder: (context) {
              //       return ScannerWidget(state: controller.state);
              //     });
            },
            child: SvgPicture.asset(
              'assets/appImages/bottomApp/scanIcon.svg',
              color: ThemeApp.whiteColor,
              semanticsLabel: 'Acme Logo',
              width: 29,
              height: 29,

              // height: height * .03,
            ), */ /*   child: const Icon(Icons.document_scanner_outlined,
                color: ThemeApp.whiteColor),*/ /*
          ),
        ),
      ),
    ],
  );
}*/

/*
class ScannerWidget extends StatefulWidget {
  BarcodeFinderState state;

  ScannerWidget({Key? key, required this.state}) : super(key: key);

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  ProductSpecificListViewModel getSingleProduct =
      ProductSpecificListViewModel();

  @override
  void initState() {
    // TODO: implement initState
    barcodeScanRes = '';
    super.initState();
  }

  var getResult = 'QR Code Result';
  final controller = BarcodeFinderController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _scanBarcode = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .25,
      color: Colors.cyan,
      margin: const EdgeInsets.all(10.0),
      child: Scaffold(
          key: _scaffoldKey,
          body: Center(
            child: Wrap(
              children: [
                AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) {
                    final state = controller.state;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        proceedButton("Scan with Camera",
                            ThemeApp.tealButtonColor, context, false, () async {
                          // Navigator.of(context).pop();
                          final prefs = await SharedPreferences.getInstance();

                          setState(() {
                            StringConstant.ScannedProductId = '';
                            prefs.setString('ScannedProductIDPref', '');
                            barcodeScanRes = '';
                          });

                          scanQR();
                        }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        _startScanFileButton(state),
                        // const Text(
                        //   'Code:',
                        //   textAlign: TextAlign.center,
                        // ),
                        */
/*    if (state is BarcodeFinderLoading)
                          _loading()
                        else if (state is BarcodeFinderError)


                          _text(
                            '${state.message}',
                          )
                        else if (state is BarcodeFinderSuccess)
                          _text(
                            '${state.code}',
                          ),*/ /*

                      ],
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget _loading() => Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFieldUtils().circularBar(context),
      );
  String barcodeScanRes = '';

  Future<void> scanQR() async {
    barcodeScanRes = '';
    setState(() {});
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      _scanBarcode = barcodeScanRes;
      print('_scanBarcode : ' + barcodeScanRes);
      print('_scanBarcode : ' + _scanBarcode);
      // getSingleProduct.getSingleProductScannerWithGet(_scanBarcode.toString());

      final prefs = await SharedPreferences.getInstance();

      // StringConstant.ScannedProductId =
      //     (prefs.getString('ScannedProductIDPref')) ?? '';

      if (_scanBarcode == '-1') {
        // Utils.flushBarErrorMessage("Please scan proper content", context);
      } else {
        // Utils.successToast(_scanBarcode);
      }
      print('_scanBarcode timer... : ' + _scanBarcode);
      print('_scanBarcode pref befor... : ' + StringConstant.ScannedProductId);

      getSingleProduct.getSingleProductScannerWithGet(
          barcodeScanRes.toString(), context);
      StringConstant.ScannedProductId =
          (prefs.getString('ScannedProductIDPref')) ?? '';

      print('_scanBarcode pref after... : ' +
          StringConstant.ScannedProductId.toString());

      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => ProductDetailsActivity(
      //       id:int.parse(StringConstant.ScannedProductId,
      //     ),
      //   ),
      //   ));
      if (!mounted) return;

      print('_scanBarcode : ' + _scanBarcode);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
//barcode scanner flutter ant
  }

  Widget _startScanFileButton(BarcodeFinderState state) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: ThemeApp.darkGreyColor,
      ),
      child: InkWell(
          onTap: state is! BarcodeFinderLoading
              ? () async {
                  FilePickerResult? pickedFile =
                      await FilePicker.platform.pickFiles();
                  if (pickedFile != null) {
                    String? filePath = pickedFile.files.single.path;
                    if (filePath != null) {
                      final file = File(filePath);
                      controller.scanFile(file);
                    }
                  } else {
                    Utils.errorToast('Please select content');
                  }
                }
              : null,
          child: TextFieldUtils().usingPassTextFields(
              "Open Gallery", ThemeApp.whiteColor, context)),
    );
  }
}
*/

class searchBarWidget extends StatefulWidget {
  const searchBarWidget({Key? key}) : super(key: key);

  @override
  State<searchBarWidget> createState() => _searchBarWidgetState();
}

class _searchBarWidgetState extends State<searchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return searchBar(context);
  }

  Widget searchBar(BuildContext context) {
    double height = 0.0;
    double width = 0.0;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    DashboardViewModel productCategories = DashboardViewModel();
    productCategories.productCategoryListingWithGet();

    return ChangeNotifierProvider<DashboardViewModel>.value(
      value: productCategories,
      child: Consumer<DashboardViewModel>(
          builder: (context, dashBoardProvider, child) {
        return Consumer<HomeProvider>(builder: (context, provider, child) {
          return Container(
            width: width,
            height: height * .1,
            // color: ThemeApp.redColor,
            padding: const EdgeInsets.only(top: 10, left: 0),
            alignment: Alignment.center,
            child: TextFormField(
              textInputAction: TextInputAction.search,

              controller: StringConstant.controllerSpeechToText,
              onFieldSubmitted: (value) {
                print("Getting Value" +
                    productCategories
                        .productCategoryList.data!.productList![0].name
                        .toString());
                switch (dashBoardProvider.productCategoryList.status) {
                  case Status.LOADING:
                    return print("Getting Value");
                  case Status.COMPLETED:
                    if (kDebugMode) {
                      print("Api calll");
                    }

                    List<ProductList>? serviceList =
                        productCategories.productCategoryList.data!.productList;
                    /*  productCategories.getProductBySearchTermsWithGet(
                    0,
                    10,
                    StringConstant.controllerSpeechToText.text.toString(),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchProductListScreen(
                        searchText: StringConstant.controllerSpeechToText.text,
                      ),
                    ),
                  );*/

                    productCategories.getProductBySearchTermsWithGet(
                      0,
                      10,
                      StringConstant.controllerSpeechToText.text.toString(),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchProductListScreen(
                          searchText:
                              StringConstant.controllerSpeechToText.text,
                        ),
                      ),
                    );
                }
                /*  Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductListByCategoryActivity(
                      productList: productCategories.),
                ),
              );*/
                if (kDebugMode) {
                  print("search.........");
                } // showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return OkDialog(text: StringConstant.controllerSpeechToText.text);
                //     });
              },
              onChanged: (val) {
                // print("StringConstant.speechToText..." +
                //     StringConstant.speechToText);
                // (() {
                //   if (val.isEmpty) {
                //     val = StringConstant.speechToText;
                //   } else {
                //     StringConstant.speechToText = StringConstant.controllerSpeechToText.text;
                //   }
                // });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: ThemeApp.whiteColor,
                isDense: true,
                // contentPadding:
                //     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                /* -- Text and Icon -- */
                hintText: "Search",
                hintStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: ThemeApp.darkGreyTab,
                ),
                prefixIconColor: ThemeApp.primaryNavyBlackColor,
                prefixIcon: /*const Icon(
                  Icons.search,
                  size: 26,
                  color: Colors.black54,
                ),*/
                    Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/appImages/searchIcon.svg',
                    color: ThemeApp.primaryNavyBlackColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.primaryNavyBlackColor,
                    ),
                    height: height * .001,
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SpeechToTextDialog();
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/appImages/miceIcon.svg',
                      color: ThemeApp.primaryNavyBlackColor,
                      semanticsLabel: 'Acme Logo',
                      theme: SvgTheme(
                        currentColor: ThemeApp.primaryNavyBlackColor,
                      ),
                      height: height * .001,
                    ),
                  ), /*const Icon(
                    Icons.mic,
                    size: 26,
                    color: Colors.black54,
                  ),*/
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: ThemeApp.redColor, width: 1)),
                // OutlineInputBorder
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: ThemeApp.appBackgroundColor, width: 1)),
                // OutlineInputBorder
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: ThemeApp.appBackgroundColor, width: 1)),
              ), // InputDecoration
            ),
          );
        });
      }),
    );
  }
}

/*
class LocationController extends GetxController {
  Position? currentPosition;
  var _isLoading = false.obs;

  String? currentLocation;

//if no permission ? ask

  Future<Position> getPosition() async {
    LocationPermission? permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddressFromLatLong(lat, long) async {
    try {
      List<Placemark> placemarcks = await placemarkFromCoordinates(lat, long);

      Placemark place = placemarcks[0];
      currentLocation = "${place.locality}${place.postalCode},${place.country}";
      print("place.locality" + place.locality.toString());

      update();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      _isLoading(true);
      update();
      currentPosition = await getPosition();
      getAddressFromLatLong(
          currentPosition!.latitude, currentPosition!.longitude);
      _isLoading(false);
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
*/