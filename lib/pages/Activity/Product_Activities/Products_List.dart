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

class MobileListActivity extends StatefulWidget {
  const MobileListActivity({Key? key}) : super(key: key);

  @override
  State<MobileListActivity> createState() => _MobileListActivityState();
}

class _MobileListActivityState extends State<MobileListActivity> {
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
//     listFromPref = Prefs().getToken(StringConstant.cartListForPreferenceKey);
//
//     print('____________CartData AFTER GETTING PREF______________');
//     StringConstant.prettyPrintJson(listFromPref.toString());
//
//   }
  getListFromPref() async {
    final prefs = await SharedPreferences.getInstance();
    StringConstant.getCartList_FromPref =
        await Prefs().getToken(StringConstant.cartListForPreferenceKey);
    print('____________CartData AFTER GETTING PREF______________');
    StringConstant.prettyPrintJson(
        StringConstant.getCartList_FromPref.toString());
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
      body: SafeArea(
        child: Consumer<ProductProvider>(builder: (context, product, _) {
    return Container(
          height: MediaQuery.of(context).size.height,
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              listOfMobileDevices(productsList),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              filterWidgets(productsList),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              mobileGridList(productsList, product)
            ],
          ));
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
          itemCount: product.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                      width: width * .27,
                      decoration: BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /*  ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: Image.network(
                              // width: double.infinity,
                              product[index].serviceImage,
                              fit: BoxFit.fitWidth,
                              height: MediaQuery.of(context).size.height * .07,
                            ),
                          ),*/
                          Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new AssetImage(
                                        product[index].serviceImage,
                                      )))),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .01,
                          ),
                          TextFieldUtils().appliancesTitleTextFields(
                              product[index].serviceName, context)
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

  Widget filterWidgets(List<ProductDetailsModel> product) {
    return Container(
      padding: EdgeInsets.all(10),
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
                  /* showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 15, right: 15, bottom: 15),
                        child: Wrap(
                          children: [
                            TextFieldUtils().dynamicText(
                                AppLocalizations.of(context).sortByPrice,
                                context,
                                TextStyle(
                                    color: ThemeApp.blackColor,
                                    fontSize: height * .025,
                                    fontWeight: FontWeight.w600)),
                            Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: _radioSelected,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _radioSelected = value as int;
                                      _radioVal = 'UPI';
                                      print(_radioVal);
                                    });
                                  },
                                ),
                                const Text("UPI"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 2,
                                  groupValue: _radioSelected,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _radioSelected = value as int;
                                      _radioVal = 'Wallets';
                                      print(_radioVal);
                                    });
                                  },
                                ),
                                const Text("Wallets"),
                              ],
                            ),
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            ),
                          ],
                        ),
                      );
                    },
                  );*/
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SortByPriceBottomSheet();
                      });
                },
                child: TextFieldUtils()
                    .titleTextFields("Sort By: Price Low to High", context)),
            Icon(Icons.keyboard_arrow_down)
          ]),
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FilterScreen()));
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

  Widget mobileGridList(
      List<ProductDetailsModel> product, ProductProvider value) {
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height * .7,
          // padding: EdgeInsets.all(12.0),

          child: GridView.builder(
            itemCount: product.length,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // childAspectRatio: 4 / 4.8,
                childAspectRatio: (MediaQuery.of(context).orientation ==
                        Orientation.landscape)
                    ? 5 / 1.8
                    : 2.3 / 4,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsActivity(
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
                    width: MediaQuery.of(context).size.width * .45,
                    decoration: BoxDecoration(
                        color: ThemeApp.darkGreyTab,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height:
                              SizeConfig.orientations != Orientation.landscape
                                  ? MediaQuery.of(context).size.height * .26
                                  : MediaQuery.of(context).size.height * .1,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: ThemeApp.whiteColor,
                              borderRadius: const BorderRadius.only(
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
                              product[index].serviceImage,
                              fit: BoxFit.fill,
                              height: (MediaQuery.of(context).orientation ==
                                      Orientation.landscape)
                                  ? MediaQuery.of(context).size.height * .26
                                  : MediaQuery.of(context).size.height * .1,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: TextFieldUtils().homePageTitlesTextFieldsWHITE(
                              product[index].serviceDescription, context),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: TextFieldUtils().homePageheadingTextFieldWHITE(
                                "${indianRupeesFormat.format(int.parse(product[index].originalPrice.toString()))}",
                                context)),
                      ],
                    )),
              );
            },
          )),
    );
  }
}

class SortByPriceBottomSheet extends StatefulWidget {
  @override
  _SortByPriceBottomSheetState createState() => _SortByPriceBottomSheetState();
}

class _SortByPriceBottomSheetState extends State<SortByPriceBottomSheet> {
  bool _show = true;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Wrap(
        children: <Widget>[
          Center(
              child: Container(
                  height: 3.0, width: 40.0, color: Color(0xFF32335C))),
          SizedBox(
            height: 10.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldUtils().dynamicText(
                  AppLocalizations.of(context).sortByPrice,
                  context,
                  TextStyle(
                      color: ThemeApp.blackColor,
                      fontSize: MediaQuery.of(context).size.height * .025,
                      fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: (value) {
                      setState(() {
                        _radioValue = value;
                      });
                      print("radiofirst" +
                          value.toString() +
                          "radiovalue" +
                          _radioValue.toString());
                      _handleRadioValueChange(value);
                    },
                  ),
                  TextFieldUtils().dynamicText(
                      "Low to High",
                      context,
                      TextStyle(
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery.of(context).size.height * .02,
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
                          fontSize: MediaQuery.of(context).size.height * .02,
                          fontWeight: FontWeight.w400)),
                ],
              ),
              proceedButton("Sort Now", ThemeApp.darkGreyColor, context, () { Navigator.of(context).pop();})
            ],
          ),
        ],
      ),
    );
  }
}
