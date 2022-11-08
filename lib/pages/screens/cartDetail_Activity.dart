import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/models/CartModel.dart';
import '../../services/models/ProductDetailModel.dart';
import '../../services/providers/Products_provider.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/appBar.dart';
import '../../widgets/global/textFormFields.dart';
import '../Activity/Payment_Activities/payments_Activity.dart';
import 'dashBoard.dart';

class CartDetailsActivity extends StatefulWidget {
  final dynamic productList;

  // ProductDetailsModel model;
  ProductProvider value;

  CartDetailsActivity( {Key? key, required this.value, this.productList})
      : super(key: key);

  @override
  State<CartDetailsActivity> createState() => _CartDetailsActivityState();
}

class _CartDetailsActivityState extends State<CartDetailsActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  int counterPrice = 1;
  ProductProvider? value;
  double finalOriginalPrice = 0.0;
  double finalDiscountPrice = 0.0;
  double finalDiffrenceDiscountPrice = 0.0;
  double finalTotalPrice = 0.0;

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getListFromPref();
    print("widget.cartDetailScreen[]"+widget.productList.toString());

    getListFromPref();
    widget.productList["productCartMaxCounter"] = '1';
    finalOriginalPrice = 0.0;
    finalDiscountPrice = 0.0;
    finalDiffrenceDiscountPrice = 0.0;
    finalTotalPrice = 0.0;

    for (int i = 0; i < widget.value.cartList.length; i++) {
      finalOriginalPrice = finalOriginalPrice +
          (int.parse(widget.value.cartList[i].tempCounter.toString()) *
              double.parse(widget.value.cartList[i].originalPrice.toString()));

      Prefs().setDoubleToken(StringConstant.totalOriginalPricePref,finalOriginalPrice);

      print("________finalOriginalPrice add: $i $finalOriginalPrice");

      finalDiscountPrice = finalDiscountPrice +
          (int.parse(widget.value.cartList[i].tempCounter.toString()) *
              double.parse(widget.value.cartList[i].discountPrice.toString()));

      print("________finalDiscountPrice add: $i $finalDiscountPrice");

      finalDiffrenceDiscountPrice = finalOriginalPrice - finalDiscountPrice;
      print(
          "________finalDiffrenceDiscountPrice add: $i $finalDiffrenceDiscountPrice");

      finalTotalPrice = widget.value.deliveryAmount +
          (finalOriginalPrice - finalDiffrenceDiscountPrice);

      Prefs().setDoubleToken(StringConstant.totalFinalPricePref,finalTotalPrice);

      print("grandTotalAmount inside add: $i $finalTotalPrice");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var listFromPref;

  //getting preference for Cart list

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
    return Scaffold(
      backgroundColor: ThemeApp.backgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(
          context,
          appTitle(context, "My Cart"),SizedBox(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ThemeApp.backgroundColor,
        elevation: 0,
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          return Container(
            height: height * .08,
            width: width,
            decoration: BoxDecoration(
              color: ThemeApp.darkGreyTab,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15)),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldUtils().pricesLineThroughWhite(
                        " ${indianRupeesFormat.format(finalOriginalPrice)}",
                        context,
                        MediaQuery.of(context).size.height * .021,
                      ),
                      TextFieldUtils().homePageheadingTextFieldWHITE(
                        "${indianRupeesFormat.format(finalTotalPrice)}",
                        context,
                      ),
                    ]),
                InkWell(
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Payment_Creditcard_debitcardScreen(productList: widget.productList),
                        ),
                      );
                      // Prefs().clear();
                        StringConstant.totalOriginalPrice =
                        (await Prefs().getDoubleToken(StringConstant.totalOriginalPricePref))!;
                        print('StringConstant.totalOriginalPrice' +
                            StringConstant.totalOriginalPrice.toString());

                        StringConstant.totalFinalPrice =
                        (await Prefs().getDoubleToken(StringConstant.totalFinalPricePref))!;
                        print('StringConstant.totalFinalPrice' +
                            StringConstant.totalFinalPrice.toString());

                    },
                    child: Container(
                        height: height * 0.05,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: ThemeApp.whiteColor,
                        ),
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextFieldUtils().usingPassTextFields(
                            "Place Order", ThemeApp.blackColor, context))),
              ],
            ),
          );
        }),
      ),
      body: SafeArea(
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          return Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cartProductList(value),
                    priceDetails(value),
                  ],
                ),
              ));
        }),
      ),
    );
  }

  Widget cartProductList(ProductProvider value) {
    return Container(
      height: MediaQuery.of(context).size.height * .6,
      child: value.cartList.length >= 0
          ? ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: value.cartList.length,
              itemBuilder: (BuildContext context, int index) {
                if (value.cartList.length < 0) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: height * 0.2,
                        width: width,
                        decoration: BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.asset(
                                    // width: double.infinity,
                                    // snapshot.data![index].serviceImage,
                                    value.cartList[index].serviceImage.toString(),
                                    fit: BoxFit.fill,
                                    // width: width*.18,
                                    height: height * .18,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFieldUtils().appBarTextField(
                                          value.cartList[index].serviceDescription
                                              .toString(),
                                          context),
                                      SizedBox(
                                        height: height * .01,
                                      ),
                                      rattingBar(value, index),
                                      SizedBox(
                                        height: height * .01,
                                      ),
                                      prices(value, index),
                                      SizedBox(
                                        height: height * .01,
                                      ),
                                      TextFieldUtils().subHeadingTextFields(
                                          value.cartList[index].deliveredBy
                                              .toString(),
                                          context),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: width,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            bottom: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                        ),
                        padding: const EdgeInsets.only(
                            top: 10, left: 15, right: 15, bottom: 10),
                        child: aadToCartCounter(value, index),
                      ),
                      SizedBox(
                        height: height * .02,
                      )
                    ],
                  );
                }
              })
          : CircularProgressIndicator(),
    );
  }

  var originialAmount;

  void addQuantity(ProductProvider value, int index) {
    print("maxCounter counter ${value.cartList[index].maxCounter}");
    print("temp counter 1 ${value.cartList[index].tempCounter}");
    if (int.parse(value.cartList[index].tempCounter.toString()) <
        int.parse(value.cartList[index].maxCounter.toString())) {
      value.cartList[index].tempCounter =
          int.parse(value.cartList[index].tempCounter.toString()) + 1;
      print("temp counter 2 ${value.cartList[index].tempCounter}");

      finalPrices(value, index);
    }
  }

  void finalPrices(ProductProvider value, int index) {
    finalOriginalPrice = 0.0;
    finalDiscountPrice = 0.0;
    finalDiffrenceDiscountPrice = 0.0;
    finalTotalPrice = 0.0;

    for (int i = 0; i < value.cartList.length; i++) {
      finalOriginalPrice = finalOriginalPrice +
          (int.parse(value.cartList[i].tempCounter.toString()) *
              double.parse(value.cartList[i].originalPrice.toString()));

      Prefs().setDoubleToken(StringConstant.totalOriginalPricePref,finalOriginalPrice);

      print("______finaloriginalPrice______" + finalOriginalPrice.toString());

      finalDiscountPrice = finalDiscountPrice +
          (int.parse(value.cartList[i].tempCounter.toString()) *
              double.parse(value.cartList[i].discountPrice.toString()));
      print("______finalDiscountPrice______" + finalDiscountPrice.toString());


      finalDiffrenceDiscountPrice = finalOriginalPrice - finalDiscountPrice;
      print(
          "________finalDiffrenceDiscountPrice add: $i $finalDiffrenceDiscountPrice");

      finalTotalPrice = widget.value.deliveryAmount +
          (finalOriginalPrice - finalDiffrenceDiscountPrice);
      Prefs().setDoubleToken(StringConstant.totalFinalPricePref,finalTotalPrice);

      print("grandTotalAmount inside add: $i $finalTotalPrice");


    }
  }

  Future<void> minusQuantity(ProductProvider value, int index) async {
    print("maxCounter counter ${value.cartList[index].maxCounter}");
    print("temp counter 1 minus ${value.cartList[index].tempCounter}");

    if (int.parse(value.cartList[index].tempCounter.toString()) > 0) {
      value.cartList[index].tempCounter =
          int.parse(value.cartList[index].tempCounter.toString()) - 1;
      print("temp counter 2 minus  ${value.cartList[index].tempCounter}");
      value.cartList[index].totalOriginalPrice = ((value.cartList[index].tempCounter)! *
          double.parse(value.cartList[index].originalPrice.toString()));
      print(
          "_____________value.lst[index].totalOriginalPrice ${value.cartList[index].totalOriginalPrice}");

////PRICE CODE AFTER ADDING COUNT
      finalPrices(value, index);
    }
  }

  Widget rattingBar(ProductProvider value, int index) {
    return Container(
      // width: width * .7,
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RatingBar.builder(
              itemSize: height * .022,
              initialRating: value.cartList[index].ratting!.toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            TextFieldUtils().subHeadingTextFields(
                '${value.cartList[index].ratting} Reviews', context),
          ],
        ),
      ),
    );
  }

  Widget prices(ProductProvider value, int index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFieldUtils().homePageheadingTextField(
              "${indianRupeesFormat.format(int.parse(value.cartList[index].discountPrice.toString()))}",
              context),
          SizedBox(
            width: width * .02,
          ),
          TextFieldUtils().homePageheadingTextFieldLineThrough(
              indianRupeesFormat
                  .format(int.parse(value.cartList[index].originalPrice.toString())),
              context),
          SizedBox(
            width: width * .02,
          ),
          TextFieldUtils().homePageTitlesTextFields(
              value.cartList[index].offerPercent.toString(), context),
        ],
      ),
    );
  }

  Widget aadToCartCounter(ProductProvider value, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text(value.lst[index].totalOriginalPrice.toString()),
        Expanded(
          flex: 1,
          child: Container(
            height: height * 0.06,
            width: width * .2,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        minusQuantity(value, index);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeApp.lightGreyTab,
                      ),
                      child: Icon(
                        Icons.remove,
                        // size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, top: 0, bottom: 0),
                    child: Text(
                      value.cartList[index].tempCounter.toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .016,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        addQuantity(value, index);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeApp.lightGreyTab,
                      ),
                      child: Icon(
                        Icons.add,
                        // size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              value.del(index);
              finalPrices(value, index);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.delete_rounded),
                TextFieldUtils().subHeadingTextFields('Remove', context),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget priceDetails(ProductProvider value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height * 0.16,
          width: width,
          decoration: BoxDecoration(
            color: ThemeApp.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldUtils().appBarTextField("Price Details", context),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFieldUtils().homePageTitlesTextFields(
                        "Price (${value.cartList.length.toString()} items)",
                        context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(finalOriginalPrice),
                        // counterPrice == 1
                        //     ? value.originialAmount.toString()
                        //     : value.originalPriceCounter.toString(),
                        context)
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFieldUtils()
                        .homePageTitlesTextFields("Discount", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        "- ${indianRupeesFormat.format(finalDiffrenceDiscountPrice)}",
                        context),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFieldUtils()
                        .homePageTitlesTextFields("Delivery charges", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(value.deliveryAmount),
                        context),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
        ),
        Container(
          width: width,
          decoration: BoxDecoration(
            color: ThemeApp.whiteColor,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          padding:
              const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFieldUtils().titleTextFields("Total Amount", context),
              TextFieldUtils().titleTextFields(
                  "${indianRupeesFormat.format(finalTotalPrice)} ", context),
            ],
          ),
        ),
        SizedBox(
          height: height * .02,
        )
      ],
    );
  }

  Future<List<BookServiceModel>> getSimmilarProductLists() async {
    String response = '['
        '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Appliances","serviceDescription":"Motorola ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
        '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Electronics","serviceDescription":"Samsang ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
        '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Fashion","serviceDescription":"One Plus ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
        '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Home","serviceDescription":"IPhone ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"}]';
    var serviceList = bookServiceFromJson(response);
    return serviceList;
  }
}
