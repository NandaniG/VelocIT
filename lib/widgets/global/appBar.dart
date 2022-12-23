import 'dart:async';
import 'dart:io';

import 'package:barcode_finder/barcode_finder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Model/ProductCategoryModel.dart';
import 'package:velocit/pages/Activity/DashBoard_DetailScreens_Activities/Categories_Activity.dart';
import 'package:velocit/pages/screens/cartDetail_Activity.dart';
import 'package:velocit/utils/utils.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';
import 'package:velocit/widgets/global/textFormFields.dart';

import '../../Core/ViewModel/dashboard_view_model.dart';
import '../../Core/ViewModel/product_listing_view_model.dart';
import '../../Core/data/responses/status.dart';
import '../../Core/repository/cart_repository.dart';
import '../../pages/Activity/My_Account_Activities/AccountSetting/NotificationScreen.dart';
import '../../pages/Activity/My_Account_Activities/SaveCardAndWallets/CardList_manage_Payment_Activity.dart';
import '../../pages/Activity/My_Account_Activities/MyAccount_activity.dart';
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

Widget appBarWidget(
  BuildContext context,
  Widget titleWidget,
  Widget location,
  void setState,
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
                      Navigator.of(context).pop();
                      // Provider.of<ProductProvider>(context, listen: false);
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
            /*   leading: Consumer<HomeProvider>(builder: (context, provider, child) {
                return  Consumer  <ProductProvider>(builder: (context, product, child) {

                  return StringConstant.isLogIn == false
                        ? const SizedBox(
                            width: 0,
                          )
                        : InkWell(
                            onTap: () {
                              /// locale languages
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //       builder: (context) => FlutterLocalizationDemo()),
                              // );

                              if (kDebugMode) {
                                print("provider.cartProductList");
                                print(provider.cartProductList);
                              }
                              product.badgeFinalCount;

                              provider.isBottomAppCart = true;
                              provider.isHome = true;

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CartDetailsActivity(
                                          value: product, productList: provider.cartProductList)),
                                      (route) => false);

                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => const MyAccountActivity(),
                              //   ),
                              // );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                child: Icon(Icons.account_circle_rounded,
                                    size:
                                        40) */ /*Container(
                              alignment: Alignment.center,
                              child: const Image(
                                image: NetworkImage(
                                    'https://cdn1.iconfinder.com/data/icons/technology-devices-2/100/Profile-512.png'),
                                fit: BoxFit.fill,
                              ))*/ /*
                                ,
                              ),
                            ),
                          );
                  }
                );
              }
            ),*/
            // leadingWidth: width * .06,
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
                  padding: const EdgeInsets.only(
                      top: 13, bottom: 13, right: 15, left: 15),
                  child: Image.asset(
                    'assets/appImages/bellIcon.png',
                    // width: double.infinity,
                    height: height * .11,
                    color: ThemeApp.primaryNavyBlackColor,
                    fit: BoxFit.fill,
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
                    onTap: () {
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

                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CartDetailsActivity(
                      //             value: product, productList: provider.cartProductList)),
                      //         (route) => false);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MyAccountActivity(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        'assets/appImages/profileIcon.svg',
                        color: ThemeApp.primaryNavyBlackColor,
                        semanticsLabel: 'Acme Logo',
                        theme: SvgTheme(
                          currentColor: ThemeApp.primaryNavyBlackColor,
                        ),
                        height: height * .04,
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
/*              Consumer<HomeProvider>(builder: (context, provider, child) {
                return Consumer<ProductProvider>(
                    builder: (context, product, child) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            /// locale languages
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //       builder: (context) => FlutterLocalizationDemo()),
                            // );

                            if (kDebugMode) {
                              print("provider.cartProductList");
                              print(provider.cartProductList);
                            }
                            product.badgeFinalCount;

                            provider.isBottomAppCart = true;
                            provider.isHome = true;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartDetailsActivity(
                                      value: product,
                                      productList: provider.cartProductList)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 13, bottom: 13, right: 15),
                            child: Image.asset(
                              'assets/appImages/shoppingCart.png',
                              // width: double.infinity,
                              height: height * .11,
                              color: ThemeApp.primaryNavyBlackColor,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        product.badgeFinalCount == 0
                            ? SizedBox()
                            : Positioned(
                                right: 5,
                                top: 2,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  constraints: BoxConstraints(
                                      minWidth: 22,
                                      minHeight: 10,
                                      maxHeight: 25,
                                      maxWidth: 25),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Text(
                                      '${product.badgeFinalCount}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  );
                });
              }),*/
            ],
          ),
        ),
        location
      ],
    ),
  );
}

Widget appBar_backWidget(
  BuildContext context,
  Widget titleWidget,
  Widget location,
) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey();

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
          titleSpacing: 10,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              // Provider.of<ProductProvider>(context, listen: false);
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
          title: titleWidget,
          // Row
        ),
      ),
      location
    ],
  ));
}

Widget appTitle(BuildContext context, String text) {
  return Container(
      alignment: Alignment.centerLeft,
      child: TextFieldUtils().textFieldHeightThree(text, context));
}

//codeElan.velocIT
Widget searchBar(BuildContext context) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  DashboardViewModel productCategories = DashboardViewModel();
  productCategories.productCategoryListingWithGet();

  return ChangeNotifierProvider<DashboardViewModel>(
    create: (BuildContext context) => productCategories,
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
                  productCategories.getProductBySearchTermsWithGet(
                    0,
                    10,
                    StringConstant.controllerSpeechToText.text.toString(),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchProductListScreen(),
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
              hintText: "Search for Products",
              hintStyle: const TextStyle(
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

Widget addressWidget(BuildContext context, String addressString) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  return InkWell(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AutoSearchPlacesPopUp();
          });
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
            Icon(
              Icons.not_listed_location_outlined,
              color: ThemeApp.tealButtonColor,
              size: MediaQuery.of(context).size.height * .028,
            ),
            SizedBox(
              width: width * .01,
            ),
            SizedBox(
              child: TextFieldUtils().dynamicText(
                  "Deliver to - $addressString ",
                  context,
                  TextStyle(
                      color: ThemeApp.tealButtonColor,
                      fontSize: height * .022,
                      fontWeight: FontWeight.bold)),
            ),
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

final List _tabIcons = List.unmodifiable([
  {'icon': 'assets/icons/home.png'},
  {'icon': 'assets/icons/percentage.png'},
  {'icon': 'assets/icons/percentage.png'},
  {'icon': 'assets/icons/shop.png'},
  {'icon': 'assets/icons/shopping-cart.png'},
]);

final List<Widget> _tabs = List.unmodifiable([
  // SearchList(),
  const DashboardScreen(),
  const OfferActivity(),
  Container(),
  Container(),
  Container(),
]);

Widget bottomNavBarItems(BuildContext context) {
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
              List<ProductList>? serviceListss;
              // colors = ThemeApp.blackColor;
              List<ProductList>? serviceList =
                  productCategories.productCategoryList.data!.productList;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopByCategoryActivity(
                        shopByCategoryList: serviceListss,

                        // provider.jsonData["shopByCategoryList"],
                        shopByCategorySelected: 0),
                  ),
                  (route) => false);
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

//             StringConstant.BadgeCounterValue =  (preference.getString('setBadgeCountPref'))??'';
// print("Badge,........"+ StringConstant.BadgeCounterValue);
              if (kDebugMode) {}
              product.badgeFinalCount;

              provider.isBottomAppCart = true;
              provider.isHome = true;

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartDetailsActivity(
                          value: product,
                          productList: provider.cartProductList)),
                  (route) => false);
            }
          },
          items: [
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: _currentIndex == 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Image.asset('assets/icons/home.png', height: 30),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Image.asset('assets/icons/home.png', height: 30),
                      ),
                label: ''),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: _currentIndex == 1
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Image.asset('assets/icons/percentage.png',
                            height: 30),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Image.asset('assets/icons/percentage.png',
                            height: 30),
                      ),
                label: ''),
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
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Image.asset('assets/icons/shop.png', height: 30),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Image.asset('assets/icons/shop.png', height: 30),
                      ),
                label: ''),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: /*_currentIndex == 4
                    ?  Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                          child: */ /*Icon(Icons.account_circle_rounded,
                              size:
                                  40) */ /*
                          Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/appImages/shoppingCart.png',
                        // width: double.infinity,
                        // height: height * .11,
                        color: ThemeApp.primaryNavyBlackColor,
                        fit: BoxFit.fill,
                      ),)
                          ,
                        ),
                      )
                    :  Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                          child:*/ /* Icon(Icons.account_circle_rounded,
                              size:
                                  40) */ /*Image.asset(
                                    'assets/appImages/shoppingCart.png',
                                    // width: double.infinity,
                                    // height: height * .11,
                                    color: ThemeApp.primaryNavyBlackColor,
                                    fit: BoxFit.fill,
                                  ),

                        ),
                      ),*/
                    Stack(
                  children: <Widget>[
                    _currentIndex == 4
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Image.asset('assets/icons/shopping-cart.png',
                                height: 35),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Image.asset('assets/icons/shopping-cart.png',
                                height: 35),
                          ),
                    StringConstant.BadgeCounterValue == ''
                        ? SizedBox()
                        : Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              constraints: BoxConstraints(
                                  minWidth: 22,
                                  minHeight: 10,
                                  maxHeight: 25,
                                  maxWidth: 25),
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: Text(
                                  // CartRepository().badgeLength.toString(),
                                  '${StringConstant.BadgeCounterValue}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                  ],
                ),
                label: ''),
          ],
        );
      });
    });
  });
}

Widget bottomNavigationBarWidget(BuildContext context) {
  final controller = BarcodeFinderController();
  return Stack(
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
              // scanQRCode();
              // scanFile();
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => StepperScreen(),
              //   ),
              // );
              showModalBottomSheet(
                  isDismissible: true,
                  context: context,
                  builder: (context) {
                    return ScannerWidget(state: controller.state);
                  });
            },
            child: const Icon(Icons.document_scanner_outlined,
                color: ThemeApp.whiteColor),
          ),
        ),
      ),
    ],
  );
}

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
    super.initState();
  }

  var getResult = 'QR Code Result';
  final controller = BarcodeFinderController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _scanBarcode = 'Please scan proper content';

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
                            ThemeApp.darkGreyColor, context, false, () {
                          // Navigator.of(context).pop();

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
                        /*    if (state is BarcodeFinderLoading)
                          _loading()
                        else if (state is BarcodeFinderError)


                          _text(
                            '${state.message}',
                          )
                        else if (state is BarcodeFinderSuccess)
                          _text(
                            '${state.code}',
                          ),*/
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
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      _scanBarcode = barcodeScanRes;
      print('_scanBarcode : ' + barcodeScanRes);
      print('_scanBarcode : ' + _scanBarcode);
      // getSingleProduct.getSingleProductScannerWithGet(_scanBarcode.toString());
      getSingleProduct.getSingleProductScannerWithGet(_scanBarcode.toString(),context);

      final prefs = await SharedPreferences.getInstance();

      StringConstant.ScannedProductId = (prefs.getString('ScannedProductIDPref')) ?? '';


      if (_scanBarcode == '-1') {
        Utils.flushBarErrorMessage("Please scan proper content", context);
      } else {
        Utils.successToast(_scanBarcode);
      }
      print('_scanBarcode timer... : ' + _scanBarcode);
      print('_scanBarcode timer... : ' + StringConstant.ScannedProductId);
      if( StringConstant.ScannedProductId !=''||StringConstant.ScannedProductId !=null) {

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsActivity(
              id: int.parse(StringConstant.ScannedProductId),

            ),
          ),
        ).then((value) => setState(() {  _scanBarcode = '';}));
        _scanBarcode = '';
      }else{
        _scanBarcode = '';
      }
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
