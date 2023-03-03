import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/ViewModel/product_listing_view_model.dart';
import '../../../Core/Model/CategoriesModel.dart';
import '../../../Core/Model/FindProductBySubCategoryModel.dart';
import '../../../Core/Model/ProductCategoryModel.dart';
import '../../../Core/Model/productSpecificListModel.dart';
import '../../../Core/data/responses/status.dart';
import '../../../services/models/CartModel.dart';
import '../../../services/models/ProductDetailModel.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../services/providers/cart_Provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../Core/Model/ProductsModel/Product_by_search_term_model.dart';
import '../../Core/ViewModel/dashboard_view_model.dart';
import '../../services/providers/Home_Provider.dart';
import '../../utils/routes/routes.dart';
import '../Activity/My_Account_Activities/AccountSetting/NotificationScreen.dart';
import '../Activity/My_Account_Activities/MyAccount_activity.dart';
import '../Activity/My_Account_Activities/is_My_account_login_dialog.dart';
import '../Activity/Product_Activities/FilterScreen_Products.dart';
import '../Activity/Product_Activities/ProductDetails_activity.dart';

class SearchProductListScreen extends StatefulWidget {
  final String searchText;

  const SearchProductListScreen({
    Key? key,
    required this.searchText,
    /* this.productList*/
  }) : super(key: key);

  @override
  State<SearchProductListScreen> createState() =>
      _SearchProductListScreenState();
}

class _SearchProductListScreenState extends State<SearchProductListScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  double height = 0.0;
  double width = 0.0;

  var categoryCode;
  DashboardViewModel dashboardViewModel = DashboardViewModel();
  late Map<String, dynamic> data = new Map<String, dynamic>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // dashboardViewModel.getProductBySearchTermsWithGet(0, 10, 'Apple');
    dashboardViewModel.getProductBySearchTermsWithGet(0, 10, widget.searchText);

    _scrollController.addListener(() {
      // if(_scrollController.position.pixels >=_scrollController.position.maxScrollExtent ){
      //   productSpecificListViewModel.productBySubCategoryWithGet(
      //     0,
      //     10,
      //     widget.productList!.id!,
      //   );
      // }
    });
    data = {
      "category_code": 'EOLP',
      "recommended_for_you": "1",
      "Merchants Near You": "1",
      "best_deal": "",
      'budget_buys': ""
    };
    // data = {"category_code": widget.productList!.categoryCode,"recommended_for_you":"1","Merchants Near You":"1","best_deal":"",'budget_buys':""};
    print(data.toString());
    // productSpecificListViewModel.productBySubCategoryWithGet(
    //   0,
    //   10,
    //   widget.productList!.id!,
    // );
    // categoryCode =widget.productList!.categoryCode;

    // print("productList"+widget.productList!.categoryCode!);
    // productSpecificListViewModel.productSpecificListWithGet(context, data);
    StringConstant.sortByRadio;
    StringConstant.sortedBy;
    // getListFromPref();
    dataCount();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );

  dataCount() async {
    StringConstant.cartCounters =
        await Prefs.instance.getIntToken("counterProduct");
    print("dataCount..." + StringConstant.cartCounters.toString());
  }

  getListFromPref() async {
    final prefs = await SharedPreferences.getInstance();
    StringConstant.getCartList_FromPref =
        await Prefs.instance.getToken(StringConstant.cartListForPreferenceKey);
    print('____________CartData AFTER GETTING PREF______________');
    StringConstant.prettyPrintJson(
        StringConstant.getCartList_FromPref.toString(), 'Cartlist pref');
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
          /*     key: scaffoldGlobalKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * .12),
            child: AppBarWidget(
             context:context,
              titleWidget:  AddressWidgets(),
              location:   addressWidget(context, StringConstant.placesFromCurrentLocation),
   ),
          ),*/

          appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * .14),
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: ThemeApp.appBackgroundColor,
              alignment: Alignment.center,
              child: Column(
                children: [
                  AppBar(
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
                    title: searchBarWidget(),
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
                      Consumer<HomeProvider>(
                          builder: (context, provider, child) {
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

                              final prefs =
                                  await SharedPreferences.getInstance();
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
                                        currentColor:
                                            ThemeApp.primaryNavyBlackColor,
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
                  const AddressWidgets(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: bottomNavigationBarWidget(context, 0),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //

                  /* listOfMobileDevices(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),*/
                  filterWidgets(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  productListView()
                ],
              ),
            ),
          )),
    );
  }

  Widget listOfMobileDevices() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: dashboardViewModel,
        child: Consumer<DashboardViewModel>(
            builder: (context, productSearchProvider, child) {
          switch (productSearchProvider.productByTermResponse.status) {
            case Status.LOADING:
              print("Api load");

              return TextFieldUtils().circularBar(context);
            case Status.ERROR:
              print("Api error");

              return Text(productSearchProvider.productByTermResponse.message
                  .toString());
            case Status.COMPLETED:
              print("Api calll");
              List<SearchProduct>? searchProductList = productSearchProvider
                  .productByTermResponse.data!.payload!.content;
              print("searchProductList" + searchProductList!.length.toString());
              return searchProductList!.length == ''
                  ? Container(
                      height: height * .8,
                      alignment: Alignment.center,
                      child:Center(
                          child: Text(
                            "Match not found",
                            style: TextStyle(fontSize: 20),
                          )),
                    )
                  : Container(
                      height: height * .15,
                      child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: searchProductList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            print("widget.productList.length");
                            return InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Container(
                                      width: width * .27,
                                      decoration: const BoxDecoration(
                                          color: ThemeApp.whiteColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50)),
                                            child: Image.network(
                                              // width: double.infinity,
                                              searchProductList[index]
                                                  .imageUrls![0]
                                                  .imageUrl!,
                                              errorBuilder: ((context, error,
                                                  stackTrace) {
                                                return Icon(
                                                    Icons.image_outlined);
                                              }),
                                              fit: BoxFit.fill,

                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .07,
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .01,
                                          ),
                                          Center(
                                            child: TextFieldUtils().dynamicText(
                                                searchProductList[index]
                                                    .shortName!,
                                                context,
                                                TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: ThemeApp.darkGreyColor,
                                                  // fontWeight: FontWeight.w500,
                                                  fontSize: height * .02,
                                                )),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .03,
                                  )
                                ],
                              ),
                            );
                          }),
                    );
          }
          return Container(
            height: height * .8,
            alignment: Alignment.center,
            child: Center(
                child: Text(
                  "Match not found",
                  style: TextStyle(fontSize: 20),
                )),
          );
        }));
  }

  Widget filterWidgets() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          // border: Border(
          //   top: BorderSide(color: Colors.grey, width: 1),
          //   bottom: BorderSide(color: Colors.grey, width: 1),
          // ),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextFieldUtils().dynamicText(
                'Sort By  ',
                context,
                TextStyle(
                  fontFamily: 'Roboto',
                  color: ThemeApp.lightFontColor,
                  // fontWeight: FontWeight.w500,
                  fontSize: height * .02,
                )),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return bottomSheetForPrice();
                    });
              },
              child: TextFieldUtils().dynamicText(
                  StringConstant.sortedBy,
                  context,
                  TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    // fontWeight: FontWeight.w500,
                    fontSize: height * .022,
                  )),
            ),
            const Icon(Icons.keyboard_arrow_down)
          ]),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FilterScreen()));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: ThemeApp.tealButtonColor)),
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                TextFieldUtils().dynamicText(
                    'Filters',
                    context,
                    TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      // fontWeight: FontWeight.w500,
                      fontSize: height * .022,
                    )),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    'assets/appImages/filterIcon.svg',
                    color: ThemeApp.primaryNavyBlackColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.primaryNavyBlackColor,
                    ),
                    height: height * .02,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(IconData icon, {Color color = ThemeApp.iconColor}) {
    return Container(
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget productListView() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: dashboardViewModel,
        child: Consumer<DashboardViewModel>(
            builder: (context, productSearchProvider, child) {
          switch (productSearchProvider.productByTermResponse.status) {
            case Status.LOADING:
              print("Api load");

              return TextFieldUtils().circularBar(context);
            case Status.ERROR:
              print("Api error");

              return Text(productSearchProvider.productByTermResponse.message
                  .toString());
            case Status.COMPLETED:
              print("Api calll");
              List<SearchProduct>? searchProductList = productSearchProvider
                  .productByTermResponse.data!.payload!.content;

              /*   if (searchProductList!.length == 0) {
                print("productSearchProvider length" +
                    searchProductList!.length.toString());
              } else {
                print("productSearchProvider length........" +
                    searchProductList!.length.toString());
              }*/

              print("searchProductList ,.,.," +
                  searchProductList!.length.toString());
              return Expanded(
                child: searchProductList.isEmpty
                    ? Center(
                        child: Text(
                        "Match not found",
                        style: TextStyle(fontSize: 20),
                      ))
                    : GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 30,
                          // childAspectRatio: 1.0,
                          childAspectRatio:
                              MediaQuery.of(context).size.height / 900,
                        ),
                        shrinkWrap: true,
                        children: List.generate(
                          searchProductList.length,
                          (index) {
                            return Stack(
                              children: [
                                index == searchProductList.length
                                    ? Container(
                                        // width: constrains.minWidth,
                                        height: 20,
                                        // height: MediaQuery.of(context).size.height * .08,
                                        // alignment: Alignment.center,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: ThemeApp.blackColor,
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          print(
                                              "Id ........${searchProductList[index].id}");

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailsActivity(
                                                id: searchProductList[index].id,
                                                // productList: subProductList[index],
                                                // productSpecificListViewModel:
                                                //     productSpecificListViewModel,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
// height: 205,
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /*   Expanded(
                                              flex: 2,
                                              child:*/
                                            Container(
                                              height: 143,
                                              width: 191,
                                              /* height: SizeConfig.orientations !=
                                                        Orientation.landscape
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        .25
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        .1,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,*/
                                              decoration: const BoxDecoration(
                                                color: ThemeApp.whiteColor,
                                              ),
                                              child: ClipRRect(
                                                  child: Image.network(
                                                      searchProductList[index]
                                                              .imageUrls![0]
                                                              .imageUrl
                                                              .toString() ??
                                                          "",
                                                      // fit: BoxFit.fill,
                                                      height: (MediaQuery.of(
                                                                      context)
                                                                  .orientation ==
                                                              Orientation
                                                                  .landscape)
                                                          ? MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .26
                                                          : MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .1, errorBuilder:
                                                          ((context, error,
                                                              stackTrace) {
                                                return Container(
                                                    height: 79,
                                                    width: 79,
                                                    child: Icon(
                                                        Icons.image_outlined));
                                              }))),
                                            ),
                                            // ),
                                            Container(
                                              color: ThemeApp.tealButtonColor,
                                              width: 191,
                                              height: 66,
                                              padding: const EdgeInsets.only(
                                                left: 12,
                                                right: 12,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextFieldUtils()
                                                      .listNameHeadingTextField(
                                                          searchProductList[
                                                                  index]
                                                              .shortName!,
                                                          context),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextFieldUtils().listPriceHeadingTextField(
                                                          indianRupeesFormat.format(
                                                              searchProductList[
                                                                          index]
                                                                      .defaultSellPrice ??
                                                                  0.0),
                                                          context),
                                                      TextFieldUtils().listScratchPriceHeadingTextField(
                                                          indianRupeesFormat.format(
                                                              searchProductList[
                                                                          index]
                                                                      .defaultMrp ??
                                                                  0.0),
                                                          context)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                      ),
                                index == searchProductList!.length
                                    ? Container(
                                        // width: constrains.minWidth,
                                        height: 20,
                                        // height: MediaQuery.of(context).size.height * .08,
                                        // alignment: Alignment.center,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: ThemeApp.blackColor,
                                          ),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            );
                            /*else {
                          return  Container(
                            // width: constrains.minWidth,
                            height: 80,
                            // height: MediaQuery.of(context).size.height * .08,
                            // alignment: Alignment.center,
                            child: TextFieldUtils().dynamicText(
                                'Nothing more to load',
                                context,
                                TextStyle(fontFamily: 'Roboto',
                                    color: ThemeApp.blackColor,
                                    fontSize: height * .03,
                                    fontWeight: FontWeight.bold)),
                          );
                        }*/
                          },
                        )),
              );
          }
          return Container(
            height: height * .8,
            alignment: Alignment.center,
            child:Center(
                child: Text(
                  "Match not found",
                  style: TextStyle(fontSize: 20),
                )),
          );
        }));
  }

  int? _radioValue = 0;

  Widget bottomSheetForPrice() {
    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return Container(
        margin: const EdgeInsets.all(10.0),
        child: Wrap(
          children: <Widget>[
            Center(
                child: Container(
                    height: 3.0, width: 40.0, color: const Color(0xFF32335C))),
            const SizedBox(
              height: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldUtils().dynamicText(
                    StringUtils.sortByPrice,
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: MediaQuery.of(context).size.height * .025,
                        fontWeight: FontWeight.w600)),
                RadioListTile(
                  activeColor: ThemeApp.appColor,
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: (value) {
                    setState(() {
                      _radioValue = value;
                      StringConstant.sortByRadio = _radioValue!;
                      print(StringConstant.sortedBy);
                    });
                  },
                  title: Text("Low to High",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery.of(context).size.height * .02,
                          fontWeight: FontWeight.w400)),
                ),
                RadioListTile(
                  activeColor: ThemeApp.appColor,
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: (value) {
                    setState(() {
                      _radioValue = value;
                      StringConstant.sortByRadio = _radioValue!;
                      print(StringConstant.sortedBy);
                    });
                  },
                  title: Text("High to Low",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery.of(context).size.height * .02,
                          fontWeight: FontWeight.w400)),
                ),
                proceedButton(
                    "Sort Now", ThemeApp.tealButtonColor, context, false, () {
                  setState(() {
                    StringConstant.sortByRadio == 1
                        ? StringConstant.sortedBy = "High to Low"
                        : 'Low to High';

                    onChangeText(StringConstant.sortByRadio);
                  });
                  Navigator.of(context).pop(true);

                  // Navigator.pop(context);
                })
              ],
            ),
          ],
        ),
      );
    });
  }

  void onChangeText(int sortByRadio) {
    setState(() {});
    if (StringConstant.sortByRadio == 1) {
      StringConstant.sortedBy = "High to Low";
    } else {
      StringConstant.sortedBy = "Low to High";
    }
  }
}
