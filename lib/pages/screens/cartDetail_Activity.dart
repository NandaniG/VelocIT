import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/ViewModel/cart_view_model.dart';
import 'package:velocit/utils/routes/routes.dart';

import '../../Core/Model/CartModels/CartSpecificIdModel.dart';
import '../../Core/data/responses/status.dart';
import '../../Core/repository/cart_repository.dart';
import '../../services/models/CartModel.dart';
import '../../services/models/ProductDetailModel.dart';
import '../../services/providers/Home_Provider.dart';
import '../../services/providers/Products_provider.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/appBar.dart';
import '../../widgets/global/dynamicPopUp.dart';
import '../../widgets/global/okPopUp.dart';
import '../../widgets/global/proceedButtons.dart';
import '../../widgets/global/textFormFields.dart';
import '../Activity/Order_CheckOut_Activities/OrderReviewScreen.dart';
import '../Activity/Payment_Activities/payments_Activity.dart';
import 'dashBoard.dart';

class CartDetailsActivity extends StatefulWidget {
  final dynamic productList;

  // ProductDetailsModel model;
  ProductProvider value;

  CartDetailsActivity(
      {Key? key, required this.value, required this.productList})
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
  final DateTime now = DateTime.now();

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );
  CartViewModel cartListView = CartViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getListFromPref();
    getCartId();
    // dateFormat();
    /*  if (kDebugMode) {
      print("widget.cartDetailScreen[]${widget.productList}");
      print("value.cartList.length");
      print(widget.value.cartList.length);
    }
    // print("_________widget.productListcart......" +
    //     widget.productList["productTempCounter"].toString());
    // widget.productList[0]["productCartMaxCounter"] = '1';
    finalOriginalPrice = 0.0;
    finalDiscountPrice = 0.0;
    finalDiffrenceDiscountPrice = 0.0;
    finalTotalPrice = 0.0;

    for (int i = 0; i < widget.value.cartList.length; i++) {
      // widget.value.cartList[i].cartProductsTempCounter= widget.productList["productTempCounter"];
      print("_________widget.productListcart......" +
          widget.value.cartList[i].cartProductsTempCounter.toString());

      finalOriginalPrice = finalOriginalPrice +
          (int.parse(
                  widget.value.cartList[i].cartProductsTempCounter.toString()) *
              double.parse(widget.value.cartList[i].cartProductsOriginalPrice
                  .toString()));

      Prefs.instance.setDoubleToken(
          StringConstant.totalOriginalPricePref, finalOriginalPrice);

      if (kDebugMode) {
        print("________finalOriginalPrice add: $i $finalOriginalPrice");
      }
      finalDiscountPrice = finalDiscountPrice +
          (int.parse(
                  widget.value.cartList[i].cartProductsTempCounter.toString()) *
              double.parse(widget.value.cartList[i].cartProductsDiscountPrice
                  .toString()));
      if (kDebugMode) {
        print("________finalDiscountPrice add: $i $finalDiscountPrice");
      }
      finalDiffrenceDiscountPrice = finalOriginalPrice - finalDiscountPrice;
      if (kDebugMode) {
        print(
            "________finalDiffrenceDiscountPrice add: $i $finalDiffrenceDiscountPrice");
      }

      finalTotalPrice = widget.value.deliveryAmount +
          (finalOriginalPrice - finalDiffrenceDiscountPrice);

      Prefs.instance
          .setDoubleToken(StringConstant.totalFinalPricePref, finalTotalPrice);
      if (kDebugMode) {
        print("grandTotalAmount inside add: $i $finalTotalPrice");
      }
    }*/
  }

  // var date = '2021-01-26T03:17:00.000000Z';

  String convertDateTimeDisplay(String date) {
    // toISOString().replace('Z', '').replace('T', '')
    final DateFormat displayFormater = DateFormat('yyyy-MM-ddTHH:mm:ssZ');

    final DateFormat serverFormater =
        DateFormat('E' + " " + 'd' + ' ' + 'MMM' + " " + 'y');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  getCartId() async {
    final prefs = await SharedPreferences.getInstance();

    StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
    StringConstant.RandomUserLoginId =
        (prefs.getString('isRandomUserId')) ?? '';
    StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';

    cartListView.cartSpecificIDWithGet(context, StringConstant.UserCartID);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  updateCart(List<OrdersForPurchase>? value, var merchantId, int quantity,
      String productId) async {
    final prefs = await SharedPreferences.getInstance();
    var userId = '';

    StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
    StringConstant.RandomUserLoginId =
        (prefs.getString('isRandomUserId')) ?? '';

    StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';

    var prefUserId = await Prefs.instance.getToken(
      Prefs.prefRandomUserId,
    );
    print("cartId from Pref" + StringConstant.UserCartID.toString());
    print("prefUserId from Pref" + prefUserId.toString());

    if (StringConstant.UserLoginId.toString() == '' ||
        StringConstant.UserLoginId.toString() == null) {
      userId = StringConstant.RandomUserLoginId;
    } else {
      userId = StringConstant.UserLoginId;
    }
    Map<String, String> data = {
      // "cartId": StringConstant.UserCartID.toString(),
      "cartId": StringConstant.UserCartID.toString(),
      "userId": userId,
      "productId": productId,
      "merchantId": merchantId.toString(),
      "qty": quantity.toString()
    };
    print("update cart DATA" + data.toString());
    CartRepository().updateCartPostRequest(data, context);

    for (int i = 0; i < value!.length; i++) {
      StringConstant.BadgeCounterValue =
          value!.length.toString() + value[i].itemQty.toString();
      print("Badge,.......in for." + StringConstant.BadgeCounterValue);
    }
    setState(() {
      StringConstant.BadgeCounterValue =
          (prefs.getString('setBadgeCountPrefs')) ?? '';
      print("Badge,........" + StringConstant.BadgeCounterValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: Consumer<HomeProvider>(builder: (context, provider, child) {
          return provider.isBottomAppCart == false
              ? PreferredSize(
                  preferredSize: Size.fromHeight(height * .09),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: ThemeApp.darkGreyTab,
                    child: AppBar(
                      centerTitle: false,
                      elevation: 0,
                      backgroundColor: ThemeApp.appBackgroundColor,
                      flexibleSpace: Container(
                        height: height * .11,
                        width: width,
                        decoration: const BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                      ),
                      leadingWidth: 40,
                      leading: Center(
                        child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: ThemeApp.blackColor,
                              size: 30,
                            ),
                            onPressed: () {
                              // Navigator.pop(context);
                              Navigator.pop(context);
                              // Navigator.pushReplacementNamed(context, '/productDetailsActivity').then((_) => setState(() {}));
                            }),
                      ),

                      // leadingWidth: width * .06,
                      title: Text("My Cart"),
                      // Row
                    ),
                  ),
                )
              : PreferredSize(
                  preferredSize: Size.fromHeight(height * .09),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: ThemeApp.darkGreyTab,
                    child: AppBar(
                      centerTitle: false,
                      elevation: 0,
                      backgroundColor: ThemeApp.appBackgroundColor,
                      flexibleSpace: Container(
                        height: height * .11,
                        width: width,
                        decoration: const BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                      ),
                      titleSpacing: 0,
                      leadingWidth: 20,
                      leading: Transform.scale(
                          scale: 0,
                          child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white, size: 10),
                              onPressed: () {})),

                      // leadingWidth: width * .06,
                      title: Text("My Cart"),
                      // Row
                    ),
                  ),
                );
        }),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ThemeApp.appBackgroundColor,
        elevation: 0,
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          return widget.value.cartList.isEmpty
              ? bottomNavigationBarWidget(context)
              : Container(
                  height: 144,
                  width: width,
                  decoration: const BoxDecoration(
                    color: ThemeApp.darkGreyColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 10,
                        ),
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
                                  TextFieldUtils()
                                      .homePageheadingTextFieldWHITE(
                                    "${indianRupeesFormat.format(finalTotalPrice)}",
                                    context,
                                  ),
                                ]),
                            InkWell(
                                onTap: () async {
                                  if (widget.value.deliveryAmount == 0.0) {
                                    Utils.flushBarErrorMessage(
                                        'Please enter Product length', context);
                                  }

                                  if (kDebugMode) {
                                    print(StringConstant.isLogIn);
                                  }
                                  // Utils.flushBarErrorMessage(
                                  //     "Please Sign Up", context);
                                  StringConstant.isLogIn == true
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderReviewSubActivity(
                                                    value: value,
                                                    cartListFromHome:
                                                        widget.productList),
                                          ),
                                        )
                                      : Navigator.pushNamed(
                                          context, RoutesName.signInRoute);

                                  // Prefs.instance.clear();
                                  StringConstant.totalOriginalPrice =
                                      (await Prefs.instance.getDoubleToken(
                                          StringConstant
                                              .totalOriginalPricePref))!;
                                  if (kDebugMode) {
                                    print(
                                        'StringConstant.totalOriginalPrice${StringConstant.totalOriginalPrice}');
                                  }

                                  StringConstant.totalFinalPrice =
                                      (await Prefs.instance.getDoubleToken(
                                          StringConstant.totalFinalPricePref))!;
                                  if (kDebugMode) {
                                    print(
                                        'StringConstant.totalFinalPrice${StringConstant.totalFinalPrice}');
                                  }
                                },
                                child: Container(
                                    height: height * 0.05,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: ThemeApp.whiteColor,
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: TextFieldUtils().usingPassTextFields(
                                        "Place Order",
                                        ThemeApp.blackColor,
                                        context))),
                          ],
                        ),
                      ),
                      bottomNavigationBarWidget(context),
                    ],
                  ),
                );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
          child: ChangeNotifierProvider<CartViewModel>(
              create: (BuildContext context) => cartListView,
              child: Consumer<CartViewModel>(
                  builder: (context, cartProvider, child) {
                switch (cartProvider.cartSpecificID.status) {
                  case Status.LOADING:
                    print("Api load");

                    return TextFieldUtils().circularBar(context);
                  case Status.ERROR:
                    print("Api error");

                    return Text(cartProvider.cartSpecificID.message.toString());
                  case Status.COMPLETED:
                    print("Api calll");
                    List<OrdersForPurchase>? orderPurchaseList = cartProvider
                        .cartSpecificID.data!.payload!.ordersForPurchase;

                    print("orderPurchaseList" +
                        orderPurchaseList!.length.toString());
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: cartProvider.cartSpecificID.data!.payload!
                                      .ordersForPurchase!.length <=
                                  0
                              ? Container(
                                  height: height * .5,
                                  alignment: Alignment.center,
                                  child: TextFieldUtils().dynamicText(
                                      "Cart is Empty",
                                      context,
                                      TextStyle(
                                          color: ThemeApp.blackColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: height * .03,
                                          overflow: TextOverflow.ellipsis)),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    cartProductList(orderPurchaseList),
                                    priceDetails(cartProvider
                                        .cartSpecificID.data!.payload!),
                                  ],
                                ),
                        ));
                }
                return Container(
                  height: height * .8,
                  alignment: Alignment.center,
                  child: TextFieldUtils().dynamicText(
                      'No Match found!',
                      context,
                      TextStyle(
                          color: ThemeApp.blackColor,
                          fontSize: height * .03,
                          fontWeight: FontWeight.bold)),
                );
              }))),
    );
  }

  Widget cartProductList(List<OrdersForPurchase>? orderPurchaseList) {
    return Container(
        height: orderPurchaseList!.length == 1
            ? MediaQuery.of(context).size.height * .5
            : MediaQuery.of(context).size.height * .6,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: orderPurchaseList.length == 1
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            itemCount: orderPurchaseList.length,
            itemBuilder: (BuildContext context, int index) {
              return orderPurchaseList.isEmpty
                  ? const Center(
                      child: Text(
                      "No Match",
                    ))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 0.2,
                          width: width,
                          decoration: const BoxDecoration(
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Image.network(
                                      // width: double.infinity,
                                      // snapshot.data![index].serviceImage,
                                      orderPurchaseList[index]
                                          .imageUrl
                                          .toString(),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFieldUtils().appBarTextField(
                                            orderPurchaseList[index]
                                                .itemName
                                                .toString(),
                                            context),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        rattingBar(
                                            orderPurchaseList[index], index),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        prices(orderPurchaseList[index], index),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        Row(
                                          children: [
                                            TextFieldUtils()
                                                .subHeadingTextFields(
                                                    'Delivery by ', context),
                                            TextFieldUtils()
                                                .subHeadingTextFields(
                                                    convertDateTimeDisplay(
                                                        orderPurchaseList[index]
                                                            .deliveryDate
                                                            .toString()),
                                                    context),
                                          ],
                                        ),
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
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: ThemeApp.whiteColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                          ),
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 10),
                          child: aadToCartCounter(orderPurchaseList, index),
                        ),
                        SizedBox(
                          height: height * .02,
                        )
                      ],
                    );
            }));
  }

  Widget rattingBar(OrdersForPurchase value, int index) {
    return Container(
      // width: width * .7,
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RatingBar.builder(
              itemSize: height * .022,
              initialRating: value.itemRating!,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                if (kDebugMode) {
                  print(rating);
                }
              },
            ),
            // TextFieldUtils()
            //     .subHeadingTextFields('${value.itemRating} Reviews', context),
          ],
        ),
      ),
    );
  }

  Widget prices(OrdersForPurchase value, int index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFieldUtils().homePageheadingTextField(
              "${indianRupeesFormat.format(double.parse(value.itemOfferPrice.toString()))}",
              context),
          SizedBox(
            width: width * .02,
          ),
          TextFieldUtils().homePageheadingTextFieldLineThrough(
              indianRupeesFormat
                  .format(double.parse(value.itemMrpPrice.toString())),
              context),
          SizedBox(
            width: width * .02,
          ),
          TextFieldUtils().homePageTitlesTextFields(
              value.itemDiscountPercent.toString() + "%", context),
        ],
      ),
    );
  }

  Widget aadToCartCounter(List<OrdersForPurchase>? value, int index) {
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
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
                        // minusQuantity(value![index], index);
                        if (value![index].itemQty > 1) {
                          value![index].itemQty--;
                          updateCart(
                              value,
                              value[index].merchantId,
                              value[index].itemQty,
                              value[index].productItemId.toString());
                          StringConstant.BadgeCounterValue =
                              value!.length.toString() +
                                  value![index].itemQty.toString();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmDialog(
                                  text:
                                      "Are you sure, you want to remove product from cart list?",
                                  tap: () {
                                    setState(() {
                                      print("value[index].merchantId" +
                                          value[index].merchantId.toString());

                                      updateCart(value, value[index].merchantId, 0,
                                          value[index].productItemId.toString());


                                      value.removeAt(index);
                                      Navigator.pop(context);

                                    });
                                  },
                                );
                              });
                        }
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ThemeApp.lightGreyTab,
                      ),
                      child: const Icon(
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
                      value![index].itemQty.toString().padLeft(2, '0'),
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
                        value![index].itemQty++;
                        // StringConstant.BadgeCounterValue = value![index].itemQty.toString();
                        updateCart(
                            value,
                            value[index].merchantId,
                            value[index].itemQty,
                            value[index].productItemId.toString());
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ThemeApp.lightGreyTab,
                      ),
                      child: const Icon(
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
              setState(() {});
              print("value[index].merchantId" +
                  value[index].merchantId.toString());
              updateCart(value, value[index].merchantId, 0,
                  value[index].productItemId.toString());
              value.removeAt(index);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.delete_rounded),
                TextFieldUtils().subHeadingTextFields('Remove', context),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget priceDetails(CartPayLoad payload) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height * 0.16,
          width: width,
          decoration: const BoxDecoration(
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
                        "Price (${payload.ordersForPurchase!.length.toString()} items)",
                        context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat
                            .format(double.parse(payload.totalMrp.toString())),
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
                        "- ${indianRupeesFormat.format(double.parse(payload.totalDiscountAmount.toString()))}",
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
                        indianRupeesFormat.format(double.parse(
                            payload.totalDeliveryCharges.toString())),
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
          decoration: const BoxDecoration(
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
                  "${indianRupeesFormat.format(payload.totalPayable)} ",
                  context),
            ],
          ),
        ),
        SizedBox(
          height: height * .02,
        )
      ],
    );
  }
}

class ConfirmDialog extends StatefulWidget {
  final String text;
  final VoidCallback tap;

  ConfirmDialog({required this.text, required this.tap});

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: 300.0,
          maxWidth: 100.0,
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(
                //     child: TextFieldUtils()
                //         .textFieldHeightThree("Searched Data is ", context)),
                Flexible(
                  child: TextFieldUtils().dynamicText(
                      widget.text,
                      context,
                      TextStyle(
                          color: ThemeApp.primaryNavyBlackColor,

                          // fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
                proceedButton('Ok', ThemeApp.blackColor, context, false, widget.tap),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
