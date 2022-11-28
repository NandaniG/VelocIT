import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductListByCategoryActivity extends StatefulWidget {
  final dynamic productList;

  const ProductListByCategoryActivity({Key? key, required this.productList})
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

  // late List<CartModel> cartList;
  late List<ProductDetailsModel> productList;
  int? _radioSelected = 1;
  String _radioVal = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StringConstant.sortByRadio;
    getListFromPref();
  }

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );

// var listFromPref;
//
//   getListFromPref() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     listFromPref = Prefs.instance.getToken(StringConstant.cartListForPreferenceKey);
//
//     print('____________CartData AFTER GETTING PREF______________');
//     StringConstant.prettyPrintJson(listFromPref.toString());
//
//   }
  getListFromPref() async {
    final prefs = await SharedPreferences.getInstance();
    StringConstant.getCartList_FromPref =
    await Prefs.instance.getToken(StringConstant.cartListForPreferenceKey);
    print('____________CartData AFTER GETTING PREF______________');
    StringConstant.prettyPrintJson(
        StringConstant.getCartList_FromPref.toString());
  }

  String sortedBy = "Low to High";


  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    final cart = Provider.of<CartProvider>(context);
    final availableProducts = Provider.of<ProductProvider>(context);

    final productsList = availableProducts.getProductsLists();

    return Scaffold(
      backgroundColor: ThemeApp.backgroundColor,
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
        child: Consumer<ProductProvider>(builder: (context, product, _) {
          return Padding(padding:
          const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),

            child: SingleChildScrollView(
              // height: MediaQuery.of(context).size.height,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listOfMobileDevices(productsList),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .02,
                    ),
                    filterWidgets(productsList),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .02,
                    ),
                    mobileGridList(productsList, product)
                  ],
                )),
          );
        }),
      ),
    );
  }

  Widget listOfMobileDevices(List<ProductDetailsModel> product) {
    return Container(
      height: height * .15,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.productList["productsList"].length,
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
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                        widget
                                            .productList["productsList"][index]["productsListImage"],
                                      )))),
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * .01,
                          ),
                          TextFieldUtils().appliancesTitleTextFields(
                              widget
                                  .productList["productsList"][index]["productsListName"],
                              context)
                        ],
                      )),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .03,
                  )
                ],
              ),
            );
          }),
    );
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
                child: TextFieldUtils()
                    .titleTextFields("Sort By: ${sortedBy}", context)),
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

  SortPrice() {
    for (int i = 0; i <= widget.productList["productsList"].length; i ++) {
      widget.productList["productsList"][i]["discountPrice"].sort((a, b) =>
          a.compareTo(b));
      for (ProductDetailsModel p in widget.productList["productsList"]) {
        print("p.originalPrice");
        print(p.discountPrice);
      }
    }
  }

  Widget mobileGridList(List<ProductDetailsModel> product,
      ProductProvider value) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * .75,
      // width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        itemCount: widget.productList["productsList"].length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
       /*     childAspectRatio:
            (MediaQuery
                .of(context)
                .orientation == Orientation.landscape)
                ? 5 / 1.8
                : 2.3 / 3.2,
*/  childAspectRatio:
        (MediaQuery.of(context).orientation == Orientation.landscape)
            ? 5 / 1.8
            : 2.3 / 3.2,

            crossAxisCount: 2,
            crossAxisSpacing: width*.02,
            mainAxisSpacing: 15),

        itemBuilder: (BuildContext context, int index) {
          print(" widget.productList['productsList']");
          print("SortPrice");
          print(
              widget.productList["productsList"][index]["productDiscountPrice"]
                  .toString());
          // SortPrice(int.parse(widget.productList["productsList"]));
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailsActivity(
                        productList: widget.productList["productsList"][index],
                        model: product[index],
                        value: value,
                      ),
                ),
              );
              /*    Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailsActivity(model: product[index], value: value,),
                ),
              );*/
            },
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * .45,
                decoration: const BoxDecoration(
                    color: ThemeApp.darkGreyTab,
                    borderRadius:
                    BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height:
                      SizeConfig.orientations != Orientation.landscape
                          ? MediaQuery
                          .of(context)
                          .size
                          .height * .25
                          : MediaQuery
                          .of(context)
                          .size
                          .height * .1,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                        child: Image.asset(
                          // width: double.infinity,
                          widget
                              .productList["productsList"][index]["productsListImage"],
                          fit: BoxFit.fill,
                          height: (MediaQuery
                              .of(context)
                              .orientation ==
                              Orientation.landscape)
                              ? MediaQuery
                              .of(context)
                              .size
                              .height * .26
                              : MediaQuery
                              .of(context)
                              .size
                              .height * .1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: TextFieldUtils().homePageTitlesTextFieldsWHITE(
                          widget
                              .productList["productsList"][index]["productsListDescription"],
                          context),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .01,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: TextFieldUtils().homePageheadingTextFieldWHITE(
                            "${indianRupeesFormat.format(int.parse(widget
                                .productList["productsList"][index]["productDiscountPrice"]
                                .toString()))}",
                            context)),
                  ],
                )),
          );
        },
      ),
    );
  }
  int? _radioValue = 0;

  /* var sheetController = showBottomSheet(
        context: context,
        builder: (context) => BottomSheetWidget());*/
  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value;
    });
    print("first" + value.toString() + "radiovalue" + _radioValue.toString());
  }

  Widget bottomSheetForPrice(){
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
                  AppLocalizations
                      .of(context)
                      .sortByPrice,
                  context,
                  TextStyle(
                      color: ThemeApp.blackColor,
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .height * .025,
                      fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: (value) {
                      setState(() {
                        _radioValue = value;
                        StringConstant.sortByRadio=_radioValue!;
                        StringConstant.sortByRadio == 0 ? sortedBy = "Low to High" : '';
                        print(sortedBy);
                      });
                      print("radiofirst" +
                          value.toString() +
                          "radiovalue" +
                          StringConstant.sortByRadio.toString());
                      _handleRadioValueChange(value);
                    },
                  ),
                  TextFieldUtils().dynamicText(
                      "Low to High",
                      context,
                      TextStyle(
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .height * .02,
                          fontWeight: FontWeight.w400)),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: (value) {
                      setState(() {
                        _radioValue = value;
                        StringConstant.sortByRadio=_radioValue!;
                        StringConstant.sortByRadio == 1 ? sortedBy = "High to Low" : '';
                        print(sortedBy);
                      });
                      print("radiofirst" +
                          value.toString() +
                          "radiovalue" +
                          _radioValue.toString());
                      _handleRadioValueChange(value);
                    },
                  ),
                  TextFieldUtils().dynamicText(
                      "High to Low",
                      context,
                      TextStyle(
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .height * .02,
                          fontWeight: FontWeight.w400)),
                ],
              ),
              proceedButton("Sort Now", ThemeApp.darkGreyColor, context, false,() {
            Navigator.pop(context);

              })
            ],
          ),
        ],
      ),
    );
  }
}
/*

class SortByPriceBottomSheet extends StatefulWidget {
  String sortedBy;

  SortByPriceBottomSheet({required this.sortedBy});

  @override
  _SortByPriceBottomSheetState createState() => _SortByPriceBottomSheetState();
}

class _SortByPriceBottomSheetState extends State<SortByPriceBottomSheet> {
  bool _show = true;
  int? _radioValue = 0;

  */
/* var sheetController = showBottomSheet(
        context: context,
        builder: (context) => BottomSheetWidget());*//*

  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value;
    });
    print("first" + value.toString() + "radiovalue" + _radioValue.toString());
  }

  @override
  Widget build(BuildContext context) {
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
                  AppLocalizations
                      .of(context)
                      .sortByPrice,
                  context,
                  TextStyle(
                      color: ThemeApp.blackColor,
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .height * .025,
                      fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: (value) {
                      setState(() {
                        _radioValue = value;
                       StringConstant.sortByRadio=_radioValue!;
                        StringConstant.sortByRadio == 0 ? widget.sortedBy = "Low to High" : '';
                        print(widget.sortedBy);
                      });
                      print("radiofirst" +
                          value.toString() +
                          "radiovalue" +
                          StringConstant.sortByRadio.toString());
                      _handleRadioValueChange(value);
                    },
                  ),
                  TextFieldUtils().dynamicText(
                      "Low to High",
                      context,
                      TextStyle(
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .height * .02,
                          fontWeight: FontWeight.w400)),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: (value) {
                      setState(() {
                        _radioValue = value;
                        StringConstant.sortByRadio=_radioValue!;
                        StringConstant.sortByRadio == 1 ? widget.sortedBy = "High to Low" : '';
                        print(widget.sortedBy);
                      });
                      print("radiofirst" +
                          value.toString() +
                          "radiovalue" +
                          _radioValue.toString());
                      _handleRadioValueChange(value);
                    },
                  ),
                  TextFieldUtils().dynamicText(
                      "High to Low",
                      context,
                      TextStyle(
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .height * .02,
                          fontWeight: FontWeight.w400)),
                ],
              ),
              proceedButton("Sort Now", ThemeApp.darkGreyColor, context, () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  ProductListByCategoryActivity(productList: null,),
                  ),
                );

              })
            ],
          ),
        ],
      ),
    );
  }
}
*/
