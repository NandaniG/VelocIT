import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/ViewModel/cart_view_model.dart';
import 'package:velocit/utils/routes/routes.dart';
import '../../Core/Model/CartModels/CartSpecificIdModel.dart';
import '../../Core/data/responses/status.dart';
import '../../Core/repository/cart_repository.dart';
import '../../services/providers/Home_Provider.dart';
import '../../services/providers/Products_provider.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/ConfirmationDialog.dart';
import '../../widgets/global/appBar.dart';
import '../../widgets/global/proceedButtons.dart';
import '../../widgets/global/textFormFields.dart';
import '../Activity/Order_CheckOut_Activities/OrderReviewScreen.dart';

class CartDetailsActivity extends StatefulWidget {
  /* final dynamic productList;

  // ProductDetailsModel model;
  ProductProvider value;*/

  CartDetailsActivity({
    Key? key,
    /* required this.value, required this.productList*/
  }) : super(key: key);

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
    // getCartDetailsFromPref();
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

  var data;

  getCartId() async {
    final prefs = await SharedPreferences.getInstance();

    StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
    StringConstant.RandomUserLoginId =
        (prefs.getString('isRandomUserId')) ?? '';
    StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
    print("Cart Id From Cart Activity " + StringConstant.UserCartID);
    setState(() {});
    var getDirectCartID = prefs.getString('directCartIdPref');
    var getDirectCartIDIsTrue = prefs.getString('directCartIdIsTrue');

    if (getDirectCartIDIsTrue == 'true') {
      print(" get DirectCartIDIs True ");

      await cartListView.cartSpecificIDWithGet(
          context, getDirectCartID.toString());
    } else {
      print(" get DirectCartIDIs false ");

      await cartListView.cartSpecificIDWithGet(
          context, StringConstant.UserCartID);
    }
    print("Cart Id ForDirect" + getDirectCartID.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  updateCart(List<OrdersForPurchase>? value, var merchantId, int quantity,
      String productId, String serviceId) async {
    final prefs = await SharedPreferences.getInstance();
    var userId = '';

    StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
    StringConstant.RandomUserLoginId = (prefs.getString('RandomUserId')) ?? '';

    StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
    print("Cart Id From Cart Update " + StringConstant.UserCartID);
    var prefUserId = await Prefs.instance.getToken(
      Prefs.prefRandomUserId,
    );
    print("Cart Id From Cart Activity " + StringConstant.UserCartID.toString());
    print("prefUserId from Pref" + prefUserId.toString());

    if (StringConstant.UserLoginId.toString() == '') {
      userId = StringConstant.RandomUserLoginId;
    } else {
      userId = StringConstant.UserLoginId;
    }
    String FromType = (prefs.getString('FromType')) ?? '';
    print("FromType : " + FromType.toString());
    Map<String, String> data;
    print('productId' + productId ?? serviceId);
    print('serviceId' + serviceId);
    if (StringConstant().isNumeric(productId)) {
      FromType = 'FromProduct';
      print("This is Product ");
    } else {
      FromType = 'FromServices';
      print("This is service ");
    }
    print("This is FromType "+FromType.toString());
    if (FromType == 'FromServices') {
      data = {
        // "cartId": StringConstant.UserCartID.toString(),
        "cartId": StringConstant.UserCartID.toString(),
        "userId": userId,
        "serviceId": serviceId,
        "merchantId": merchantId.toString(),
        "qty": quantity.toString()
      };
    } else {
      data = {
        // "cartId": StringConstant.UserCartID.toString(),
        "cartId": StringConstant.UserCartID.toString(),
        "userId": userId,
        "productId": productId,
        "merchantId": merchantId.toString(),
        "qty": quantity.toString()
      };
    }
    print("update cart DATA" + data.toString());
    setState(() {});
    await CartRepository().updateCartPostRequest(data, context);
    // getCartDetailsFromPref();
    getCartId();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return     WillPopScope(
      onWillPop: () {
        Provider.of<CartViewModel>(context, listen: false);
        setState(() {

        });
        Navigator.pop(context,true);
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
                  Provider.of<CartViewModel>(context, listen: false);      Navigator.pop(context,true);
setState(() {

});


                  // Navigator.pushReplacementNamed(
                  //         context, RoutesName.dashboardRoute)
                  //     .then((value) => setState(() {}));
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
                  'My Cart',
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
        bottomNavigationBar: BottomAppBar(
            color: ThemeApp.appBackgroundColor,
            elevation: 0,
            child: Container(
              height: 130,
              child: ChangeNotifierProvider<CartViewModel>.value(
                  value: cartListView,
                  child: Consumer<CartViewModel>(
                      builder: (context, cartProvider, child) {
                    switch (cartProvider.cartSpecificID.status) {
                      case Status.LOADING:
                        print("Api load");

                        return Container();
                      case Status.ERROR:
                        print("Api error");

                        return Text('');
                      case Status.COMPLETED:
                        print("Api calll");
                        List<OrdersForPurchase>? orderPurchaseList = cartProvider
                            .cartSpecificID.data!.payload!.ordersForPurchase;

                        print("orderPurchaseList" +
                            orderPurchaseList!.length.toString());

                        return cartProvider.cartSpecificID.data!.payload!
                                .ordersForPurchase!.isEmpty
                            ? bottomNavigationBarWidget(context)
                            : Container(
                                height: 100,
                                width: width,
                                decoration: const BoxDecoration(
                                  color: ThemeApp.tealButtonColor,
                                  // borderRadius: BorderRadius.only(
                                  //     topRight: Radius.circular(15),
                                  //     topLeft: Radius.circular(15)),
                                ),
                                child: Stack(
                                  alignment: const FractionalOffset(.5, 1.0),
                                  children: [
                                    Container(
                                      color: ThemeApp.tealButtonColor,
                                      margin: const EdgeInsets.only(
                                          left: 20,
                                          right: 15,
                                          top: 15,
                                          bottom: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  indianRupeesFormat.format(
                                                      double.parse(cartProvider
                                                          .cartSpecificID
                                                          .data!
                                                          .payload!
                                                          .totalPayable
                                                          .toString())),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 20,
                                                      color: ThemeApp
                                                          .separatedLineColor,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                TextFieldUtils()
                                                    .pricesLineThroughWhite(
                                                  indianRupeesFormat.format(
                                                      double.parse(cartProvider
                                                          .cartSpecificID
                                                          .data!
                                                          .payload!
                                                          .totalMrp
                                                          .toString())),
                                                  context,
                                                  14,
                                                ),
                                              ]),
                                          InkWell(
                                              onTap: () async {
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();

                                                StringConstant.isUserLoggedIn =
                                                    (prefs.getInt(
                                                            'isUserLoggedIn')) ??
                                                        0;
                                                print(
                                                    "IS USER LOGGEDIN ..............." +
                                                        StringConstant
                                                            .isUserLoggedIn
                                                            .toString());

                                                if (kDebugMode) {
                                                  print(StringConstant
                                                      .isUserLoggedIn);
                                                }

                                                prefs.setString(
                                                    'isUserNavigateFromDetailScreen',
                                                    'Yes');
                                                if (StringConstant
                                                        .isUserLoggedIn ==
                                                    1) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderReviewActivity(
                                                        cartId: cartProvider
                                                            .cartSpecificID
                                                            .data!
                                                            .payload!
                                                            .id!,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  for (int i = 0;
                                                      i <
                                                          cartProvider
                                                              .cartSpecificID
                                                              .data!
                                                              .payload!
                                                              .ordersForPurchase!
                                                              .length;
                                                      i++) {
                                                    prefs.setString(
                                                        'CartSpecificUserIdPref',
                                                        cartProvider
                                                            .cartSpecificID
                                                            .data!
                                                            .payload!
                                                            .userId
                                                            .toString());
                                                    prefs.setString(
                                                        'CartSpecificItem_codePref',
                                                        cartProvider
                                                            .cartSpecificID
                                                            .data!
                                                            .payload!
                                                            .ordersForPurchase![i]
                                                            .productCode
                                                            .toString());
                                                    prefs.setString(
                                                        'CartSpecificItemQuantityPref',
                                                        cartProvider
                                                            .cartSpecificID
                                                            .data!
                                                            .payload!
                                                            .ordersForPurchase![i]
                                                            .itemQty
                                                            .toString());

                                                    /*       Map data = {
                                                      'user_id': cartProvider
                                                          .cartSpecificID
                                                          .data!
                                                          .payload!
                                                          .userId,
                                                      'item_code': cartProvider
                                                          .cartSpecificID
                                                          .data!
                                                          .payload!
                                                          .ordersForPurchase![i]
                                                          .productCode,
                                                      'qty': cartProvider
                                                          .cartSpecificID
                                                          .data!
                                                          .payload!
                                                          .ordersForPurchase![i]
                                                          .itemQty
                                                    };*/

                                                    Navigator.pushNamed(context,
                                                        RoutesName.signInRoute);
                                                    print(cartProvider
                                                        .cartSpecificID
                                                        .data!
                                                        .payload!
                                                        .totalItemCount);
                                                  }

                                                  // cartListView
                                                  //     .cartSpecificIDEmbeddedWithGet(
                                                  //         context,
                                                  //         StringConstant
                                                  //             .UserCartID)
                                                  //     .then((value) =>
                                                  //         setState(() {}));

                                                }
                                              },
                                              child: Container(
                                                  // height: height * 0.05,
                                                  height: 40,
                                                  width: 121,
                                                  alignment: Alignment.center,
                                                  decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(100),
                                                    ),
                                                    color: ThemeApp.whiteColor,
                                                  ),
                                                  // padding: const EdgeInsets.only(
                                                  //     left: 15, right: 15),
                                                  child: TextFieldUtils()
                                                      .dynamicText(
                                                          "Checkout",
                                                          context,
                                                          TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color: ThemeApp
                                                                  .tealButtonColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              letterSpacing:
                                                                  -0.25)))),
                                        ],
                                      ),
                                    ),
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
                                          ), /*   child: const Icon(Icons.document_scanner_outlined,
                  color: ThemeApp.whiteColor),*/
                                        ),
                                      ),
                                    ),
                                    // bottomNavigationBarWidget(context),
                                  ],
                                ),
                              );
                    }
                    return Container(
                      height: height * .8,
                      alignment: Alignment.center,
                      child: TextFieldUtils().dynamicText(
                          'No Match found!',
                          context,
                          TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              fontSize: height * .03,
                              fontWeight: FontWeight.bold)),
                    );
                  })),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
            child: ChangeNotifierProvider<CartViewModel>.value(
                value: cartListView,
                child: Consumer<CartViewModel>(
                    builder: (context, cartProvider, child) {
                  switch (cartProvider.cartSpecificID.status) {
                    case Status.LOADING:
                      print("Api load");

                      return TextFieldUtils().circularBar(context);
                      return TextFieldUtils().circularBar(context);
                    case Status.ERROR:
                      print("Api error");

                      return Text(cartProvider.cartSpecificID.status.toString());
                    case Status.COMPLETED:
                      print("Api calll");
                      List<OrdersForPurchase>? orderPurchaseList = cartProvider
                          .cartSpecificID.data!.payload!.ordersForPurchase;

                      print("orderPurchaseList" +
                          orderPurchaseList!.length.toString());
                      return Container(
                          // height: MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.all(10),
                          child: cartProvider.cartSpecificID.data!.payload!
                                  .ordersForPurchase!.isEmpty
                              ? Container(
                                  height: height * .5,
                                  alignment: Alignment.center,
                                  child: TextFieldUtils().dynamicText(
                                      "Cart is Empty",
                                      context,
                                      TextStyle(
                                          fontFamily: 'Roboto',
                                          color: ThemeApp.blackColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: height * .03,
                                          overflow: TextOverflow.ellipsis)),
                                )
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    cartProductList(orderPurchaseList),
                                    priceDetails(cartProvider
                                        .cartSpecificID.data!.payload!),
                                  ],
                                ));
                  }
                  return Container(
                    height: height * .8,
                    alignment: Alignment.center,
                    child: TextFieldUtils().dynamicText(
                        'No Match found!',
                        context,
                        TextStyle(
                            fontFamily: 'Roboto',
                            color: ThemeApp.blackColor,
                            fontSize: height * .03,
                            fontWeight: FontWeight.bold)),
                  );
                }))),
      ),
    );
  }

  Widget cartProductList(List<OrdersForPurchase>? orderPurchaseList) {
    return Container(
        height: 360,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            // physics: NeverScrollableScrollPhysics(),
            itemCount: orderPurchaseList!.length,
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
                          // height: height * 0.2,
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
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Image.network(
                                      // width: double.infinity,
                                      // snapshot.data![index].serviceImage,
                                      orderPurchaseList[index]
                                          .imageUrl
                                          .toString(),
                                      // fit: BoxFit.fill,
                                      // width: width*.18,
                                      height: 85,
                                      width: 85, errorBuilder:
                                          ((context, error, stackTrace) {
                                    return Icon(Icons.image_outlined);
                                  })),
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
                                        TextFieldUtils().dynamicText(
                                            orderPurchaseList[index]
                                                .oneliner
                                                .toString(),
                                            context,
                                            TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ThemeApp
                                                    .primaryNavyBlackColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700)),

                                        // SizedBox(
                                        //   height: height * .005,
                                        // ),
                                        /*  rattingBar(
                                            orderPurchaseList[index], index),*/
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        prices(orderPurchaseList[index], index),
                                        SizedBox(
                                          height: height * .01,
                                        ),

                                        Text(
                                            'Merchant Name : ${orderPurchaseList[index].merchantName}' ??
                                                "",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ThemeApp.lightFontColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        Row(
                                          children: [
                                            Text('Delivery by ',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color:
                                                        ThemeApp.lightFontColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Text(
                                                convertDateTimeDisplay(
                                                    orderPurchaseList[index]
                                                        .deliveryDate
                                                        .toString()),
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color:
                                                        ThemeApp.lightFontColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
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
                          decoration: const BoxDecoration(
                            color: ThemeApp.whiteColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                          ),
                          padding: const EdgeInsets.only(
                              top: 5, left: 15, right: 20, bottom: 20),
                          child: aadToCartCounter(orderPurchaseList, index),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
            }));
  }

/*
  Widget cartProductList(List<OrdersForPurchase>? orderPurchaseList) {
    return Container(
        height: 340,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            // physics: NeverScrollableScrollPhysics(),
            itemCount: orderPurchaseList!.length,
            itemBuilder: (BuildContext context, int index) {
              return orderPurchaseList.isEmpty
                  ? const Center(
                      child: Text(
                      "No Match",
                    ))
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width,
                              decoration: const BoxDecoration(
                                color: ThemeApp.whiteColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(6, 12, 8, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 79,
                                      width: 79,
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
                                            height: 79,
                                            width: 79, errorBuilder:
                                                ((context, error, stackTrace) {
                                          return Icon(Icons.image_outlined);
                                        })),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      padding: const EdgeInsets.only(
                                        left: 11,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextFieldUtils().dynamicText(
                                              orderPurchaseList[index]
                                                  .oneliner
                                                  .toString(),
                                              context,
                                              TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: ThemeApp
                                                      .primaryNavyBlackColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700)),

                                          // SizedBox(
                                          //   height: height * .005,
                                          // ),
                                          */
/*  rattingBar(
                                              orderPurchaseList[index], index),*/ /*

                                          SizedBox(
                                            height: 15,
                                          ),
                                          prices(
                                              orderPurchaseList[index], index),
                                          SizedBox(
                                            height: 11,
                                          ),
                                          Row(
                                            children: [
                                              Text('Delivery by ',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: ThemeApp
                                                          .lightFontColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Text(
                                                  convertDateTimeDisplay(
                                                      orderPurchaseList[index]
                                                          .deliveryDate
                                                          .toString()),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: ThemeApp
                                                          .lightFontColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 20,
                              ),
                              child: aadToCartCounter(orderPurchaseList, index),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    );
            }));
  }
*/

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
              initialRating: value.productRating!,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              value.unitOffer.toString().isNotEmpty
                  ? Text(
                      "${indianRupeesFormat.format(double.parse(value.unitOffer.toString()) ?? 0.0) ?? "0.0"}",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.blackColor,
                          fontSize: 22,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500))
                  : Text('0.0',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.blackColor,
                          fontSize: 22,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500)),
              /*      SizedBox(
                width: 1,
              ),
              value.mrp.toString().isNotEmpty
                  ? Text(
                      "${indianRupeesFormat.format(double.parse(value.mrp.toString()) ?? 0.0) ?? "0.0"}",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.lightFontColor,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500))
                  : Text('0.0',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.lightFontColor,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500)),*/
              SizedBox(
                width: 1,
              ),
              Text("(${value.discountPercent.toString()} % Off)",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      fontSize: 12,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text("M.R.P.: ",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.lightFontColor,
                      fontSize: 16,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500)),
              value.mrp.toString().isNotEmpty
                  ? Text(
                      "${indianRupeesFormat.format(double.parse(value.unitMrp.toString()) ?? 0.0) ?? "0.0"}",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.lightFontColor,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500))
                  : Text('0.0',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.lightFontColor,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

/*
  Widget prices(OrdersForPurchase value, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              value.offer.toString().isNotEmpty
                  ? Text(
                      "${indianRupeesFormat.format(double.parse(value.offer.toString()) ?? 0.0) ?? "0.0"}",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.blackColor,
                          fontSize: 22,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500))
                  : Text('0.0',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.blackColor,
                          fontSize: 22,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500)),
              SizedBox(
                width: 5,
              ),
              value.mrp.toString().isNotEmpty
                  ? Text(
                      "${indianRupeesFormat.format(double.parse(value.mrp.toString()) ?? 0.0) ?? "0.0"}",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.lightFontColor,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500))
                  : Text('0.0',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.lightFontColor,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500)),
              SizedBox(
                width: 5,
              ),
              Text("(${value.discountPercent.toString()} % Off)",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      fontSize: 12,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          */
/*      SizedBox(
            height: height * .01,
          ),
          Row(
            children: [
              Text(
                  "M.R.P.: ",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.lightFontColor,
                      fontSize: 16,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500)),
              value.mrp.toString().isNotEmpty
                  ? Text(
                  "${indianRupeesFormat.format(double.parse(value.mrp.toString()) ?? 0.0) ?? "0.0"}",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.lightFontColor,
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500))
                  : Text('0.0',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.lightFontColor,
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500)),
            ],
          ),*/ /*

        ],
      ),
    );
  }
*/

  Widget aadToCartCounter(List<OrdersForPurchase>? value, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text(value.lst[index].totalOriginalPrice.toString()),
        Container(
          height: 30,
          // width: width * .2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              border:
                  Border.all(color: ThemeApp.separatedLineColor, width: 1.5)),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    // setState(() {
                    // minusQuantity(value![index], index);
                    if (value![index].itemQty! > 1) {
                      // value[index].itemQty = (value[index].itemQty! - 1);
                      // StringConstant.BadgeCounterValue = value![index].itemQty.toString();
                      updateCart(
                          value,
                          value[index].merchantId,
                          value[index].itemQty! - 1,
                          value[index].productId.toString(),
                          value[index].serviceId.toString());

                      // StringConstant.BadgeCounterValue =
                      //     value.length.toString();
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationDialog(
                              heading: "Warning message",
                              subTitle:
                                  'Are you sure that you want to completely remove the item from the cart?',
                              button1: 'Keep',
                              button2: 'Remove',
                              onTap1: () async {
                                Navigator.pop(context);
                              },
                              onTap2: () {
                                setState(() {
                                  print("value[index].merchantId" +
                                      value[index].merchantId.toString());

                                  updateCart(
                                      value,
                                      value[index].merchantId,
                                      0,
                                      value[index].productId.toString(),
                                      value[index].serviceId.toString());

                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              CartDetailsActivity()))
                                      .then((value) {
                                    setState(() {});
                                  });
                                  Navigator.pop(context);
                                });
                              },
                            );
                          });
                    }
                    // });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: const Icon(Icons.remove,
                        // size: 20,
                        color: ThemeApp.lightFontColor),
                  ),
                ),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    0,
                  ),
                  color: ThemeApp.separatedLineColor,
                  child: Text(
                    value![index].itemQty.toString().padLeft(2, '0'),
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: MediaQuery.of(context).size.height * .016,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        color: ThemeApp.blackColor),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      // value[index].itemQty = value[index].itemQty! + 1;
                      // StringConstant.BadgeCounterValue = value![index].itemQty.toString();
                      updateCart(
                          value,
                          value[index].merchantId,
                          value[index].itemQty! + 1,
                          value[index].productId.toString(),
                          value[index].serviceId.toString());
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: const Icon(Icons.add,
                        // size: 20,
                        color: ThemeApp.lightFontColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationDialog(
                    heading: "Warning message",
                    subTitle:
                        'Are you sure that you want to completely remove the item from the cart?',
                    button1: 'Keep',
                    button2: 'Remove',
                    onTap1: () async {
                      Navigator.pop(context);
                    },
                    onTap2: () {
                      setState(() {
                        print("value[index].merchantId" +
                            value[index].merchantId.toString());
                        updateCart(
                            value,
                            value[index].merchantId,
                            0,
                            value[index].productId.toString(),
                            value[index].serviceId.toString());

                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                                builder: (context) => CartDetailsActivity()))
                            .then((value) {
                          setState(() {});
                        });
                        Navigator.pop(context);
                      });
                    },
                  );
                });

            // value.removeAt(index);
          },
          child: SvgPicture.asset(
            'assets/appImages/deleteIcon.svg',
            color: ThemeApp.lightFontColor,
            semanticsLabel: 'Acme Logo',
            theme: SvgTheme(
              currentColor: ThemeApp.lightFontColor,
            ),
            height: 19.5,
            width: 18,
          ),
        )
      ],
    );
  }

  Widget priceDetails(CartPayLoad payload) {
    return /*Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [*/
        Container(
      // height: 180,
      width: width,
      decoration: const BoxDecoration(
        color: ThemeApp.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 11, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price Details',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: ThemeApp.primaryNavyBlackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                // TextFieldUtils().homePageTitlesTextFields(
                //     "Price (${payload.ordersForPurchase!.length.toString()} items)",
                //     context),
                Text(
                    indianRupeesFormat
                        .format(double.parse(payload.totalMrp.toString())),
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                // TextFieldUtils().homePageTitlesTextFields(
                //     indianRupeesFormat
                //         .format(double.parse(payload.totalMrp.toString())),
                //     context)
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discount',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                Text(
                    "- ${indianRupeesFormat.format(double.parse(payload.totalDiscountAmount.toString()))}",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                /*   TextFieldUtils()
                        .homePageTitlesTextFields("Discount", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        "- ${indianRupeesFormat.format(double.parse(payload.totalDiscountAmount.toString()))}",
                        context),*/
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery charges',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                Text(
                    indianRupeesFormat.format(
                        double.parse(payload.totalDeliveryCharges.toString())),
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                /* TextFieldUtils()
                        .homePageTitlesTextFields("Delivery charges", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(double.parse(
                            payload.totalDeliveryCharges.toString())),
                        context),*/
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: width,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: ThemeApp.separatedLineColor,
                    width: 0.5,
                  ),
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
            ),
            SizedBox(
              height: height * .01,
            ),
            Container(
              // width: width,
              // decoration: const BoxDecoration(
              //   color: ThemeApp.whiteColor,
              //   borderRadius: BorderRadius.only(
              //       bottomRight: Radius.circular(10),
              //       bottomLeft: Radius.circular(10)),
              // ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  Text("${indianRupeesFormat.format(payload.totalPayable)} ",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.appColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  /* TextFieldUtils().titleTextFields("Total Amount", context),
                      TextFieldUtils().titleTextFields(
                          "${indianRupeesFormat.format(payload.totalPayable)} ",
                          context),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
    /*  Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ThemeApp.separatedLineColor,
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
        )*/
    /* ],
    );*/
  }
}
/*
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
                          fontFamily: 'Roboto',
                          color: ThemeApp.primaryNavyBlackColor,

                          // fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
                proceedButton(
                    'Ok', ThemeApp.tealButtonColor, context, false, widget.tap),
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
}*/
