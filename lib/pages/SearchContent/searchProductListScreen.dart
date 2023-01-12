import 'dart:async';
import 'dart:convert';

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
    final availableProducts = Provider.of<ProductProvider>(context);

    final productsList = availableProducts.getProductsLists();

    return Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .12),
          child: appBarWidget(
              context,
              searchBar(context),
              addressWidget(context, StringConstant.placesFromCurrentLocation),
              setState(() {})),
        ),
        bottomNavigationBar: bottomNavigationBarWidget(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //

                /* listOfMobileDevices(),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),*/
                filterWidgets(productsList),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                productListView()
              ],
            ),
          ),
        ));
  }

  Widget listOfMobileDevices() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value:  dashboardViewModel,
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
                      child: TextFieldUtils().dynamicText(
                          'No Match found!',
                          context,
                          TextStyle(fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              fontSize: height * .03,
                              fontWeight: FontWeight.bold)),
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
                                              errorBuilder: ((context, error, stackTrace) {
                                                return Icon(Icons.image_outlined);
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
                                                TextStyle(fontFamily: 'Roboto',
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
            child: TextFieldUtils().dynamicText(
                'No Match found!',
                context,
                TextStyle(fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .03,
                    fontWeight: FontWeight.bold)),
          );
        }));
  }

  Widget filterWidgets(List<ProductDetailsModel> product) {
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
                TextStyle(fontFamily: 'Roboto',
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
                  TextStyle(fontFamily: 'Roboto',
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
                    TextStyle(fontFamily: 'Roboto',
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
        value:  dashboardViewModel,
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

              if (searchProductList!.length == 0) {
                print("productSearchProvider length" +
                    searchProductList!.length.toString());
              } else {
                print("productSearchProvider length........" +
                    searchProductList!.length.toString());
              }
              return searchProductList!.isEmpty ||
                      searchProductList!.length == 0
                  ? Container(
                      height: height * .5,
                      alignment: Alignment.center,
                      child: TextFieldUtils().dynamicText(
                          'No Match found!',
                          context,
                          TextStyle(fontFamily: 'Roboto',
                              color: ThemeApp.darkGreyTab,
                              fontSize: height * .03,
                              fontWeight: FontWeight.bold)),
                    )
                  : SizedBox(
                      height: height,
                      // width: MediaQuery.of(context).size.width,
                      child: GridView.builder(
                        itemCount: searchProductList!.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 30,
                          crossAxisSpacing: 10,
                          // width / height: fixed for *all* items
                          childAspectRatio: 0.75,

                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsActivity(
                                    id: searchProductList[index].id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: ThemeApp.tealButtonColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: SizeConfig.orientations !=
                                                Orientation.landscape
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .25
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .1,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            color: ThemeApp.whiteColor,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            )),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                          ),
                                          child: Image.network(
                                            searchProductList[index]
                                                .imageUrls![0]
                                                .imageUrl!??"",
                                            fit: BoxFit.fill,
                                            errorBuilder: ((context, error, stackTrace) {
                                              return Icon(Icons.image_outlined);
                                            }),
                                            height: (MediaQuery.of(context)
                                                        .orientation ==
                                                    Orientation.landscape)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .26
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      // flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 12),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                searchProductList[index]
                                                    .shortName!,
                                                style: TextStyle(fontFamily: 'Roboto',
                                                    color: ThemeApp.whiteColor,
                                                    fontSize: height * .022,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextFieldUtils().dynamicText(
                                                    indianRupeesFormat.format(
                                                        searchProductList[index]
                                                                .defaultSellPrice ??
                                                            0.0),
                                                    context,
                                                    TextStyle(fontFamily: 'Roboto',
                                                        color:
                                                            ThemeApp.whiteColor,
                                                        fontSize: height * .023,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                TextFieldUtils().dynamicText(
                                                    indianRupeesFormat.format(
                                                        searchProductList[index]
                                                                .defaultMrp ??
                                                            0.0),
                                                    context,
                                                    TextStyle(fontFamily: 'Roboto',
                                                        color:
                                                            ThemeApp.whiteColor,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontSize: height * .022,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          );
                        },
                      ),
                    );
          }
          return Container(
            height: height * .8,
            alignment: Alignment.center,
            child: TextFieldUtils().dynamicText(
                'No Match found!',
                context,
                TextStyle(fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .03,
                    fontWeight: FontWeight.bold)),
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
                    TextStyle(fontFamily: 'Roboto',
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
                      style: TextStyle(fontFamily: 'Roboto',
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
                      style: TextStyle(fontFamily: 'Roboto',
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
