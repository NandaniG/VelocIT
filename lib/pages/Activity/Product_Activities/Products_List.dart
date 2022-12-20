import 'dart:convert';

import 'package:flutter/material.dart';
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
import 'FilterScreen_Products.dart';
import 'ProductDetails_activity.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

class ProductListByCategoryActivity extends StatefulWidget {
  SimpleSubCats? productList;

  ProductListByCategoryActivity({Key? key, this.productList})
      : super(key: key);

  @override
  State<ProductListByCategoryActivity> createState() =>
      _ProductListByCategoryActivityState();
}

class _ProductListByCategoryActivityState
    extends State<ProductListByCategoryActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  double height = 0.0;
  double width = 0.0;

  var categoryCode;
  ProductSpecificListViewModel productSpecificListViewModel =
      ProductSpecificListViewModel();
  late Map<String, dynamic> data = new Map<String, dynamic>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = {
      "category_code": 'EOLP',
      "recommended_for_you": "1",
      "Merchants Near You": "1",
      "best_deal": "",
      'budget_buys': ""
    };
    // data = {"category_code": widget.productList!.categoryCode,"recommended_for_you":"1","Merchants Near You":"1","best_deal":"",'budget_buys':""};
    print(data.toString());
    print("subProduct............." +
        widget.productList!.id .toString());
    productSpecificListViewModel.productBySubCategoryWithGet(
      0,
      10,
      widget.productList!.id!,
    );
    // categoryCode =widget.productList!.categoryCode;

    // print("productList"+widget.productList!.categoryCode!);
    // productSpecificListViewModel.productSpecificListWithGet(context, data);
    StringConstant.sortByRadio;
    StringConstant.sortedBy;
    // getListFromPref();
    dataCount();
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
        StringConstant.getCartList_FromPref.toString());
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
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: SingleChildScrollView(
                // height: MediaQuery.of(context).size.height,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                listOfMobileDevices(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                filterWidgets(productsList),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                productListView()
              ],
            )),
          ),
        ));
  }

  Widget listOfMobileDevices() {
    return ChangeNotifierProvider<ProductSpecificListViewModel>(
        create: (BuildContext context) => productSpecificListViewModel,
        child: Consumer<ProductSpecificListViewModel>(
            builder: (context, productSubCategoryProvider, child) {
              switch (productSubCategoryProvider.productSubCategory.status) {
                case Status.LOADING:
                  print("Api load");

                  return CircularProgressIndicator(
                    color: ThemeApp.appColor,
                  );
                case Status.ERROR:
                  print("Api error");

                  return Text(productSubCategoryProvider.productSubCategory.message
                      .toString());
                case Status.COMPLETED:
                  print("Api calll");
                  List<Content>? subProductList = productSubCategoryProvider
                      .productSubCategory.data!.payload!.content;
                  return Container(
                    height: height * .15,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: subProductList!.length,
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
                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(50)),
                                          child: Image.network(
                                            // width: double.infinity,
                                            subProductList [index].imageUrls![0].imageUrl!,
                                            fit: BoxFit.fill,

                                            height: MediaQuery.of(context).size.height * .07,
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * .01,
                                        ),
                                        Center(
                                          child:
                                          TextFieldUtils().dynamicText(
                                              subProductList[index].shortName!,
                                              context,
                                              TextStyle(
                                                color: ThemeApp
                                                    .darkGreyColor,
                                                // fontWeight: FontWeight.w500,
                                                fontSize: height * .02,
                                              )),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .03,
                                )
                              ],
                            ),
                          );
                        }),
                  );
              }
              return Text("fgd");
            }));

  }

  Widget filterWidgets(List<ProductDetailsModel> product) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1),
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return bottomSheetForPrice();
                      });
                },
                child: TextFieldUtils().titleTextFields(
                    "Sort By: ${StringConstant.sortedBy}", context)),
            const Icon(Icons.keyboard_arrow_down)
          ]),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FilterScreen()));
            },
            child: Row(children: [
              _icon(Icons.filter_list_sharp),
              TextFieldUtils().titleTextFields("Filter", context),
            ]),
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
    return ChangeNotifierProvider<ProductSpecificListViewModel>(
        create: (BuildContext context) => productSpecificListViewModel,
        child: Consumer<ProductSpecificListViewModel>(
            builder: (context, productSubCategoryProvider, child) {
          switch (productSubCategoryProvider.productSubCategory.status) {
            case Status.LOADING:
              print("Api load");

              return CircularProgressIndicator(
                color: ThemeApp.appColor,
              );
            case Status.ERROR:
              print("Api error");

              return Text(productSubCategoryProvider.productSubCategory.message
                  .toString());
            case Status.COMPLETED:
              print("Api calll");
              List<Content>? subProductList = productSubCategoryProvider
                  .productSubCategory.data!.payload!.content;
              return SizedBox(
                height: 600,
                // width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  itemCount: subProductList!.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 20,
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
                          productList: subProductList[index],
                          productSpecificListViewModel:   productSpecificListViewModel,

                        ),
                      ),
                    );
                  },
                      child: Container(
                          decoration: const BoxDecoration(
                              color: ThemeApp.darkGreyTab,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: SizeConfig.orientations !=
                                          Orientation.landscape
                                      ? MediaQuery.of(context).size.height * .25
                                      : MediaQuery.of(context).size.height * .1,
                                  width: MediaQuery.of(context).size.width,
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
                                      subProductList[index]
                                          .imageUrls![0]
                                          .imageUrl!,
                                      fit: BoxFit.fill,
                                      height: (MediaQuery.of(context)
                                                  .orientation ==
                                              Orientation.landscape)
                                          ? MediaQuery.of(context).size.height *
                                              .26
                                          : MediaQuery.of(context).size.height *
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFieldUtils()
                                          .homePageTitlesTextFieldsWHITE(
                                              subProductList[index].shortName!,
                                              context),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextFieldUtils().dynamicText(
                                              indianRupeesFormat.format(
                                                  subProductList[index]
                                                          .defaultSellPrice ??
                                                      0.0),
                                              context,
                                              TextStyle(
                                                  color: ThemeApp.whiteColor,
                                                  fontSize: height * .022,
                                                  fontWeight: FontWeight.bold)),
                                          TextFieldUtils().dynamicText(
                                              indianRupeesFormat.format(
                                                  subProductList[index]
                                                          .defaultMrp ??
                                                      0.0),
                                              context,
                                              TextStyle(
                                                  color: ThemeApp.whiteColor,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: height * .022,
                                                  fontWeight: FontWeight.bold)),
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
          return Text("fgd");
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
                        color: ThemeApp.blackColor,
                        fontSize: MediaQuery.of(context).size.height * .025,
                        fontWeight: FontWeight.w600)),
                RadioListTile(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: (value) {
                    setState(() {
                      _radioValue = value;
                      StringConstant.sortByRadio = _radioValue!;
                      print(StringConstant.sortedBy);
                    });
                  },
                  title: TextFieldUtils().dynamicText(
                      "Low to High",
                      context,
                      TextStyle(
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery.of(context).size.height * .02,
                          fontWeight: FontWeight.w400)),
                ),
                RadioListTile(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: (value) {
                    setState(() {
                      _radioValue = value;
                      StringConstant.sortByRadio = _radioValue!;
                      print(StringConstant.sortedBy);
                    });
                  },
                  title: TextFieldUtils().dynamicText(
                      "High to Low",
                      context,
                      TextStyle(
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery.of(context).size.height * .02,
                          fontWeight: FontWeight.w400)),
                ),
                proceedButton(
                    "Sort Now", ThemeApp.darkGreyColor, context, false, () {
                  setState(() {
                    StringConstant.sortByRadio == 1
                        ? StringConstant.sortedBy = "High to Low"
                        : 'Low to High';

                    onChangeText(StringConstant.sortByRadio);
                  });
                  Navigator.pop(context);
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
