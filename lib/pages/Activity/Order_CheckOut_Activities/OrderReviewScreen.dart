import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/repository/cart_repository.dart';
import 'package:velocit/pages/homePage.dart';
import 'package:velocit/pages/screens/cartDetail_Activity.dart';
import 'package:velocit/services/providers/Home_Provider.dart';

import '../../../Core/Model/CartModels/AddressListModel.dart';
import '../../../Core/Model/CartModels/CartSpecificIdModel.dart';
import '../../../Core/Model/CartModels/SendCartForPaymentModel.dart';
import '../../../Core/ViewModel/cart_view_model.dart';
import '../../../Core/data/responses/status.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes/routes.dart';
import '../../../utils/routes/routes_name.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../screens/dashBoard.dart';
import '../My_Account_Activities/Saved_address/saved_address_detailed_screen.dart';
import '../Payment_Activities/OrderPlaced_activity.dart';
import '../Payment_Activities/payments_Activity.dart';
import 'AddNewDeliveryAddress.dart';
import 'confirmationPopUpForNavBack.dart';

class OrderReviewActivity extends StatefulWidget {
  int cartId;

  OrderReviewActivity({
    Key? key,
    required this.cartId,
  }) : super(key: key);

  @override
  State<OrderReviewActivity> createState() => _OrderReviewActivityState();
}

TextEditingController promoCodeController = new TextEditingController();

class _OrderReviewActivityState extends State<OrderReviewActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );
  CartViewModel cartListView = CartViewModel();
  bool isSelfPickUp = false;
  String FromType = '';
  String isTypeService = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    StringConstant.addressFromCurrentLocation;
    StringConstant.selectedFullName;
    StringConstant.selectedFullAddress;
    StringConstant.selectedTypeOfAddress;
    StringConstant.selectedMobile;
    getPreferences();
  }

  var address =
      'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India - 380021';

  getPreferences() async {
    //get address
    SharedPreferences prefs = await SharedPreferences.getInstance();

    StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
    print("Cart Id From Order Review" + StringConstant.UserCartID);

    StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
    cartListView.sendAddressWithGet(
        context, StringConstant.UserLoginId.toString());

    print("Cart id in sub order " + widget.cartId.toString());
    cartListView.sendCartForPaymentWithGet(context, widget.cartId.toString());
////////////////
    StringConstant.addressFromCurrentLocation =
        (await Prefs.instance.getToken(StringConstant.addressPref))!;
    StringConstant.selectedFullAddress = (await Prefs.instance
        .getToken(StringConstant.selectedFullAddressPref))!;
    print(
        'StringConstant.addressFromCurrentLocation${StringConstant.addressFromCurrentLocation}');
    //
    StringConstant.totalOriginalPrice = (await Prefs.instance
        .getDoubleToken(StringConstant.totalOriginalPricePref))!;

    print(
        'StringConstant.totalOriginalPrice${StringConstant.totalOriginalPrice}');

    StringConstant.totalFinalPrice = (await Prefs.instance
        .getDoubleToken(StringConstant.totalFinalPricePref))!;

    print('StringConstant.totalFinalPrice${StringConstant.totalFinalPrice}');

    ///
    FromType = (prefs.getString('FromType')) ?? '';
    print("FromType in order review: " + FromType.toString());
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return NavBackConfirmationFromPayment();
            });
        return Future.value(true);
      },
      child: Scaffold(
          key: scaffoldGlobalKey,
          appBar: AppBar(
            backgroundColor: ThemeApp.appBackgroundColor,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NavBackConfirmationFromPayment();
                    });

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
            title: TextFieldUtils().dynamicText(
                'Order Checkout',
                context,
                TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    // fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.height * .022,
                    fontWeight: FontWeight.w500)),
          ),
          bottomNavigationBar: BottomAppBar(
              color: ThemeApp.appBackgroundColor,
              elevation: 0,
              child: ChangeNotifierProvider<CartViewModel>.value(
                  value: cartListView,
                  child: Consumer<CartViewModel>(
                      builder: (context, cartProvider, child) {
                    switch (cartProvider.sendCartForPayment.status) {
                      case Status.LOADING:
                        print("Api load");

                        return Container();
                      case Status.ERROR:
                        print("Api error");

                        return Text('Please try after some time');
                      case Status.COMPLETED:
                        print("Api calll");
                        CartForPaymentPayload cartForPaymentPayload =
                            cartProvider.sendCartForPayment.data!.payload!;
                        print("cartForPaymentPayload " +
                            cartForPaymentPayload.toString());

                        List<CartOrdersForPurchase> cartOrderPurchase =
                            cartProvider.sendCartForPayment.data!.payload!.cart!
                                .ordersForPurchase!;
                        for (int i = 0; i < cartOrderPurchase.length; i++) {
                          print(cartOrderPurchase[i].serviceId);
                          print(cartOrderPurchase[i].productId);
                        }

                        return cartProvider.sendCartForPayment.data!.status ==
                                'EXCEPTION'
                            ? Text('Please try after some time')
                            : Container(
                                height: 82,
                                // height: height * .09,
                                width: width,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: ThemeApp.tealButtonColor,
                                ),
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 15, bottom: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalPayable.toString()))}",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 20,
                                                color:
                                                    ThemeApp.separatedLineColor,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFieldUtils()
                                              .pricesLineThroughWhite(
                                            "${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalMrp.toString()))}",
                                            context,
                                            14,
                                          ),
                                        ]),
                                    InkWell(
                                        onTap: () {
                                          Map data = {
                                            "order_basket_id":
                                                cartForPaymentPayload
                                                    .orderBasketId,
                                            "user_id":
                                                cartForPaymentPayload.userId,
                                            "payable_amount":
                                                cartForPaymentPayload
                                                    .cart!.totalPayable,
                                            "is_self_pickup": isSelfPickUp,
                                          };
                                          print("defaultAddressList ..." +
                                              defaultAddressList!.length
                                                  .toString());

                                          if (isSelfPickUp == true) {
                                            CartRepository().putCartForPayment(
                                                data,
                                                cartForPaymentPayload
                                                    .orderBasketId!);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Payment_Creditcard_debitcardScreen(
                                                        cartForPaymentPayload:
                                                            cartForPaymentPayload),
                                              ),
                                            );
                                          } else {
                                            if (defaultAddressList!.length - 1 >
                                                0) {
                                              CartRepository()
                                                  .putCartForPayment(
                                                      data,
                                                      cartForPaymentPayload
                                                          .orderBasketId!);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Payment_Creditcard_debitcardScreen(
                                                          cartForPaymentPayload:
                                                              cartForPaymentPayload),
                                                ),
                                              );
                                            } else {
                                              isSelfPickUp == false
                                                  ? Utils.successToast(
                                                      "Please select delivery address")
                                                  : '';
                                            }
                                          }

                                          // Navigator.of(context).push(
                                          //   MaterialPageRoute(
                                          //     builder: (context) => OrderPlaceActivity(productList: widget.productList),
                                          //   ),
                                          // );
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 121,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(100),
                                              ),
                                              color: ThemeApp.whiteColor,
                                            ),
                                            // padding: const EdgeInsets.only(
                                            //     left: 21, right: 21),
                                            child: TextFieldUtils().dynamicText(
                                                "Pay now",
                                                context,
                                                TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: ThemeApp
                                                        .tealButtonColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: -0.25)))),
                                  ],
                                ),
                              );
                    }
                    return Container(
                      height: 72,
                      alignment: Alignment.center,
                      child: TextFieldUtils().dynamicText(
                          'No Match found!',
                          context,
                          TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    );
                  }))
              /*    Consumer<HomeProvider>(builder: (context, value, child) {
              return Container(
                height: height * .08,
                width: width,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ThemeApp.appColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15)),
                ),
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    */
              /*  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFieldUtils().pricesLineThroughWhite(
                      // " ${indianRupeesFormat.format(finalOriginalPrice)}",
                      " ${indianRupeesFormat.format(finalOriginalPrice)}",
                      context,
                      MediaQuery.of(context).size.height * .021,
                    ),
                    TextFieldUtils().homePageheadingTextFieldWHITE(
                      "${indianRupeesFormat.format(StringConstant.totalFinalPrice)}",
                      context,
                    ),
                  ]),*/ /*
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
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  Payment_Creditcard_debitcardScreen(),
                            ),
                          );
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => OrderPlaceActivity(productList: widget.productList),
                          //   ),
                          // );
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
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: TextFieldUtils().usingPassTextFields(
                                "Pay Now", ThemeApp.blackColor, context))),
                  ],
                ),
              );
            }),*/
              ),
          body: SafeArea(
              child: ChangeNotifierProvider<CartViewModel>.value(
                  value: cartListView,
                  child: Consumer<CartViewModel>(
                      builder: (context, cartProvider, child) {
                    switch (cartProvider.sendCartForPayment.status) {
                      case Status.LOADING:
                        print("Api load");

                        return TextFieldUtils().circularBar(context);
                      case Status.ERROR:
                        print("Api error");

                        return Text(
                            cartProvider.sendCartForPayment.message.toString());
                      case Status.COMPLETED:
                        print("Api calll");
                        CartForPaymentPayload cartForPaymentPayload =
                            cartProvider.sendCartForPayment.data!.payload!;

                        List<CartOrdersForPurchase> cartOrderPurchase =
                            cartProvider.sendCartForPayment.data!.payload!.cart!
                                .ordersForPurchase!;
                        for (int i = 0; i < cartOrderPurchase.length; i++) {
                          print(cartOrderPurchase[i].serviceId);
                          print(cartOrderPurchase[i].productId);
                          if (cartOrderPurchase[i].serviceId.toString() != 'null' &&
                              cartOrderPurchase[i].productId.toString() != 'null') {
                            isTypeService = 'Both';
                            print(isTypeService);
                          } else if (cartOrderPurchase[i].serviceId.toString() == 'null' &&
                              cartOrderPurchase[i].productId != null) {
                            isTypeService = 'Products';
                            print(isTypeService);
                          } else if (cartOrderPurchase[i].productId.toString() == 'null') {
                            isTypeService = 'Service';
                            print(isTypeService);
                          } else {
                            isTypeService = 'not';
                            print(isTypeService);
                          }
                          return Container(
                            color: ThemeApp.appBackgroundColor,
                            width: width,
                            child: ListView(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // StepperGlobalWidget(),
                                  stepperWidget(),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isSelfPickUp = true;
                                                    isSelfPickUp =
                                                        !isSelfPickUp;

                                                    // _usingPassVisible==true ? _validateEmail = true:_validateEmail=false;
                                                  });
                                                },
                                                child: Container(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        0, 15.0, 0, 15.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                100),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                100),
                                                      ),
                                                      color: isSelfPickUp
                                                          ? Colors.white
                                                          : ThemeApp.appColor,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          'Deliver to Address',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 14,
                                                              color: isSelfPickUp
                                                                  ? ThemeApp
                                                                      .blackColor
                                                                  : Colors
                                                                      .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  -0.08)),
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                  onTap: isTypeService == 'Yes'
                                                      ? () {}
                                                      : () {
                                                          setState(() {
                                                            isSelfPickUp = true;
                                                          });
                                                        },
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 15.0, 0, 15.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  100),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  100),
                                                        ),
                                                        color: isSelfPickUp
                                                            ? ThemeApp.appColor
                                                            : ThemeApp
                                                                .whiteColor,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            'Pickup from Store',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 14,
                                                                color: isSelfPickUp
                                                                    ? ThemeApp
                                                                        .whiteColor
                                                                    : ThemeApp
                                                                        .blackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    -0.08)),
                                                      ))),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 18,
                                        ),
                                        isSelfPickUp != true
                                            ? Container(
                                                // height: height * 0.5,
                                                width: width,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 10, 13),
                                                decoration: const BoxDecoration(
                                                  color: ThemeApp.whiteColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            StringUtils
                                                                .deliveryDetails,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: ThemeApp
                                                                    .blackColor,
                                                                fontSize: 16,
                                                                letterSpacing:
                                                                    -0.25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                        InkWell(
                                                            onTap: () {
                                                              // Navigator.of(context).push(
                                                              //   MaterialPageRoute(
                                                              //     builder: (context) => AddNewDeliveryAddress(),
                                                              //   ),
                                                              // );
                                                              print("widget.cartForPaymentPayload!.cartId11" +
                                                                  widget.cartId
                                                                      .toString());

                                                              showModalBottomSheet(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            60.0),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  context:
                                                                      scaffoldGlobalKey
                                                                          .currentContext!,
                                                                  builder:
                                                                      (context) {
                                                                    return ChangeAddressBottomSheet(
                                                                        cartForPaymentPayload:
                                                                            cartForPaymentPayload,
                                                                        cartId:
                                                                            widget.cartId);
                                                                  });
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            20),
                                                                      ),
                                                                      border: Border.all(
                                                                          color:
                                                                              ThemeApp.appColor)
                                                                      // color:
                                                                      //     ThemeApp.blackColor,
                                                                      ),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      5,
                                                                      10,
                                                                      5),
                                                              child: TextFieldUtils().dynamicText(
                                                                  StringUtils
                                                                      .changeAddress,
                                                                  context,
                                                                  TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      color: ThemeApp
                                                                          .appColor,
                                                                      fontSize:
                                                                          10,
                                                                      letterSpacing:
                                                                          -0.08,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    deliveryAddress(),

                                                    /*cartForPaymentPayload
                                                              .isAddressPresent ==
                                                          true*/
                                                    /*    StringConstant
                                                              .selectedFullName !=
                                                          ''
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [






                                                            Row(
                                                              children: [
                                                                TextFieldUtils()
                                                                    .dynamicText(
                                                                        StringConstant
                                                                            .selectedFullName,
                                                                        context,
                                                                        TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              14,
                                                                          letterSpacing:
                                                                              -0.08,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              ThemeApp.blackColor,
                                                                        )),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                  // height: height * 0.05,

                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          100),
                                                                    ),
                                                                    color: ThemeApp
                                                                        .tealButtonColor,
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                                  child: Text(
                                                                      StringConstant
                                                                          .selectedTypeOfAddress,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          color: ThemeApp
                                                                              .whiteColor,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                                // provider.orderCheckOutDetails[0]
                                                                //     ["orderCheckOutDeliveryAddress"],
                                                                StringConstant
                                                                    .selectedFullAddress,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        12,
                                                                    letterSpacing:
                                                                        -0.08,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: ThemeApp
                                                                        .blackColor,
                                                                    height: 2)),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/appImages/callIcon.svg',
                                                                  color: ThemeApp
                                                                      .appColor,
                                                                  semanticsLabel:
                                                                      'Acme Logo',
                                                                  theme:
                                                                      SvgTheme(
                                                                    currentColor:
                                                                        ThemeApp
                                                                            .appColor,
                                                                  ),
                                                                  height:
                                                                      height *
                                                                          .025,
                                                                ),
                                                                SizedBox(
                                                                  width: width *
                                                                      .03,
                                                                ),
                                                                TextFieldUtils().dynamicText(
                                                                    "${StringConstant.selectedMobile}",
                                                                    context,
                                                                    TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w700)),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      : TextFieldUtils().dynamicText(
                                                          'No Address found',
                                                          context,
                                                          TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color: ThemeApp
                                                                  .darkGreyTab,
                                                              fontSize:
                                                                  height * .021,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),*/
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          height: height * .02,
                                        ),

                                        /*  cartOrderPurchase[i]
                                            .serviceId
                                            .toString() !=
                                            "null"
                                            ? Text(
                                                'Pickup from Store is not available for services',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: ThemeApp.redColor,
                                                    fontSize: 16,
                                                    letterSpacing: -0.25,
                                                    fontWeight:
                                                        FontWeight.w700))
                                            : SizedBox(),*/

                                        isTypeService == 'Both'||isTypeService=="Service"
                                            ? Text(
                                                'Pickup from Store is not available for services',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: ThemeApp.redColor,
                                                    fontSize: 16,
                                                    letterSpacing: -0.25,
                                                    fontWeight:
                                                        FontWeight.w700))
                                            : SizedBox(),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        Container(
                                            // height: height * 0.6,
                                            width: width,
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 12, 15, 20),
                                            decoration: const BoxDecoration(
                                              color: ThemeApp.whiteColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // TextFieldUtils().dynamicText(
                                                //     StringUtils.orderSummary,
                                                //     context,
                                                //     TextStyle(fontFamily: 'Roboto',
                                                //         color: Colors.grey.shade700,
                                                //         fontSize: height * .023,
                                                //         fontWeight:
                                                //             FontWeight.bold)),
                                                cartProductList(
                                                    cartOrderPurchase),
                                              ],
                                            )),

                                        //apply promo code
                                        /*   SizedBox(
                            height: height * .02,
                          ),
                          Container(
                            // height: height * 0.16,
                            width: width,
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: ThemeApp.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFieldUtils().dynamicText(
                                      StringUtils.applyPromoCode,
                                      context,
                                      TextStyle(fontFamily: 'Roboto',
                                          color: ThemeApp.darkGreyColor,
                                          fontSize: height * .023,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: TextFormFieldsWidget(
                                          textInputType: TextInputType.number,
                                          controller: promoCodeController,
                                          autoValidation:
                                              AutovalidateMode.onUserInteraction,
                                          onChange: (val) {
                                            setState(() {});
                                          },
                                          validator: (value) {
                                            return null;
                                          },
                                          errorText: '',
                                          hintText: '',
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * .02,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                            onTap: () {
                                              // Navigator.of(context).push(
                                              //   MaterialPageRoute(
                                              //     builder: (context) => AddNewCardScreen(),
                                              //   ),
                                              // );
                                            },
                                            child: Container(
                                              height: height * 0.05,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color: ThemeApp.blackColor,
                                              ),
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: TextFieldUtils().dynamicText(
                                                  StringUtils
                                                      .apply,
                                                  context,
                                                  TextStyle(fontFamily: 'Roboto',
                                                      color: ThemeApp.whiteColor,
                                                      fontSize: height * .021,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            )),
                                      ),
                                    ],
                                  )
                                ]),
                          ),*/
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        priceDetails(cartForPaymentPayload),
                                      ],
                                    ),
                                  ),
                                ]),
                          );
                        }
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
                  })))),
    );
  }

  List<AddressContent>? defaultAddressList;

  Widget deliveryAddress() {
    return ChangeNotifierProvider<CartViewModel>.value(
        value: cartListView,
        child: Consumer<CartViewModel>(builder: (context, cartProvider, child) {
          switch (cartProvider.getAddress.status) {
            case Status.LOADING:
              print("Api load");

              return Container();
            case Status.ERROR:
              print("Api error");

              return Text(cartProvider.getAddress.message.toString());
            case Status.COMPLETED:
              print("Api calll");
              List<AddressContent>? addressList =
                  cartProvider.getAddress.data!.payload!.content;
              defaultAddressList =
                  cartProvider.getAddress.data!.payload!.content;
              print("addressList" + addressList!.length.toString());
              return addressList.length > 0
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addressList.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        TextFieldUtils().dynamicText(
                                            StringConstant
                                                    .selectedFullName.isNotEmpty
                                                ? StringConstant
                                                    .selectedFullName
                                                : addressList[0]
                                                    .name
                                                    .toString(),
                                            context,
                                            TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 14,
                                              letterSpacing: -0.08,
                                              fontWeight: FontWeight.w400,
                                              color: ThemeApp.blackColor,
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          // height: height * 0.05,

                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(100),
                                            ),
                                            color: ThemeApp.tealButtonColor,
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Text(
                                              StringConstant
                                                      .selectedTypeOfAddress
                                                      .isNotEmpty
                                                  ? StringConstant
                                                      .selectedTypeOfAddress
                                                  : addressList[0]
                                                      .addressType
                                                      .toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: ThemeApp.whiteColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        // provider.orderCheckOutDetails[0]
                                        //     ["orderCheckOutDeliveryAddress"],
                                        StringConstant
                                                .selectedFullAddress.isNotEmpty
                                            ? StringConstant.selectedFullAddress
                                            : "${addressList[0].addressLine1!}, ${addressList[0].addressLine2}, ${addressList[0].stateName},\n ${addressList[0].cityName}, ${addressList[0].pincode}",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                            letterSpacing: -0.08,
                                            fontWeight: FontWeight.w400,
                                            color: ThemeApp.blackColor,
                                            height: 2)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/appImages/callIcon.svg',
                                          color: ThemeApp.appColor,
                                          semanticsLabel: 'Acme Logo',
                                          theme: SvgTheme(
                                            currentColor: ThemeApp.appColor,
                                          ),
                                          height: height * .025,
                                        ),
                                        SizedBox(
                                          width: width * .03,
                                        ),
                                        TextFieldUtils().dynamicText(
                                            StringConstant
                                                    .selectedMobile.isNotEmpty
                                                ? StringConstant.selectedMobile
                                                : "${addressList[0].contactNumber}",
                                            context,
                                            TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ThemeApp.blackColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                )
                              : TextFieldUtils().dynamicText(
                                  'No Address found',
                                  context,
                                  TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.darkGreyTab,
                                      fontSize: height * .021,
                                      fontWeight: FontWeight.w400)),
                        ],
                      ),
                    )
                  : TextFieldUtils().dynamicText(
                      'No Address found!',
                      context,
                      TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.blackColor,
                          fontSize: height * .02,
                          fontWeight: FontWeight.w400));
          }
          return Container(
            height: height * .8,
            alignment: Alignment.center,
            child: TextFieldUtils().dynamicText(
                'No Address found!',
                context,
                TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .03,
                    fontWeight: FontWeight.bold)),
          );
        }));
  }

  Widget cartProductList(List<CartOrdersForPurchase> cartOrderPurchase) {
    return cartOrderPurchase.length >= 0
        ? ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartOrderPurchase.length,
            itemBuilder: (BuildContext context, int index) {
              if (cartOrderPurchase.length < 0) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: ThemeApp.darkGreyColor,
                ));
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // height: height * 0.15,
                      width: width,
                      decoration: const BoxDecoration(
                        color: ThemeApp.whiteColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              // height: 83,
                              // width: 79,
                              child: Image.network(
                                  // width: double.infinity,
                                  // snapshot.data![index].serviceImage,
                                  cartOrderPurchase[index].imageUrl.toString(),
                                  // fit: BoxFit.fill,
                                  // width: width*.18,
                                  height: 85,
                                  width: 85,
                                  errorBuilder: ((context, error, stackTrace) {
                                return Icon(Icons.image_outlined);
                              })),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 11,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFieldUtils().dynamicText(
                                      cartOrderPurchase[index]
                                          .oneliner
                                          .toString(),
                                      context,
                                      TextStyle(
                                          fontFamily: 'Roboto',
                                          color: ThemeApp.primaryNavyBlackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  prices(cartOrderPurchase, index),
                                  SizedBox(
                                    height: 11,
                                  ),
                                  Row(
                                    children: [
                                      TextFieldUtils().dynamicText(
                                          'Quantity : ',
                                          context,
                                          TextStyle(
                                              fontFamily: 'Roboto',
                                              color: ThemeApp.lightFontColor,
                                              // fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                      Text(
                                        cartOrderPurchase[index]
                                            .itemQty
                                            .toString()
                                            .padLeft(2, '0'),
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .016,
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.ellipsis,
                                            color: ThemeApp.lightFontColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFieldUtils().dynamicText(
                                      StringConstant().convertDateTimeDisplay(
                                          cartOrderPurchase[index]
                                              .deliveryDate
                                              .toString()),
                                      context,
                                      TextStyle(
                                        fontFamily: 'Roboto',
                                        color: ThemeApp.lightFontColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                      )),

/*
                                  aadToCartCounter(cartOrderPurchase, index),
*/
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /*       Container(
                      decoration: const BoxDecoration(
                        color: ThemeApp.whiteColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 10),
                      child: aadToCartCounter(cartOrderPurchase, index),
                    ),*/
                  ],
                );
              }
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: ThemeApp.separatedLineColor,
                thickness: 1,
              );
            },
          )
        : const CircularProgressIndicator();
  }

  Widget prices(List<CartOrdersForPurchase> cartOrderPurchase, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              cartOrderPurchase[index].offer.toString().isNotEmpty
                  ? TextFieldUtils().dynamicText(
                      indianRupeesFormat.format(double.parse(
                                  cartOrderPurchase[index].offer.toString()) ??
                              0.0) ??
                          "0.0",
                      context,
                      TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: 22,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ))
                  : SizedBox(),
              SizedBox(
                width: 5,
              ),
              TextFieldUtils().dynamicText(
                  "(${cartOrderPurchase[index].discountPercent.toString().toString()} % Off)",
                  context,
                  TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: ThemeApp.blackColor,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    decorationThickness: 1.5,
                  )),
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
              cartOrderPurchase![index].mrp.toString().isNotEmpty
                  ? Text(
                      "${indianRupeesFormat.format(double.parse(cartOrderPurchase![index].mrp.toString()) ?? 0.0) ?? "0.0"}",
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

  Widget aadToCartCounter(List<CartOrdersForPurchase>? value, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text(value.lst[index].totalOriginalPrice.toString()),
        Container(
          height: height * 0.05,
          // width: width * .2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(
                  color: ThemeApp.buttonBorderLightGreyColor, width: 1.5)),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  /*      onTap: () {
                    // setState(() {
                    // minusQuantity(value![index], index);
                    if (value![index].itemQty! > 1) {
                      value[index].itemQty = (value[index].itemQty! - 1);
                      // StringConstant.BadgeCounterValue = value![index].itemQty.toString();
                      updateCart(
                          value,
                          value[index].merchantId,
                          value[index].itemQty!,
                          value[index].productId.toString());

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
                                      value[index].productId.toString());

                                  value.removeAt(index);
                                  Navigator.pop(context);
                                });
                              },
                            );
                          });
                    }
                    // });
                  },*/
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: const Icon(Icons.remove,
                        // size: 20,
                        color: ThemeApp.buttonCounterFontColor),
                  ),
                ),
                Container(
                  height: height * 0.06,
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    0,
                  ),
                  color: ThemeApp.buttonBorderLightGreyColor,
                  child: Text(
                    value![index].itemQty.toString().padLeft(2, '0'),
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: MediaQuery.of(context).size.height * .016,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        color: ThemeApp.buttonCounterFontColor),
                  ),
                ),
                InkWell(
                  /*         onTap: () {
                    setState(() {
                      value![index].itemQty = value![index].itemQty! + 1;
                      // StringConstant.BadgeCounterValue = value![index].itemQty.toString();
                      updateCart(
                          value,
                          value[index].merchantId,
                          value[index].itemQty!,
                          value[index].productId.toString());
                    });
                  },*/
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: const Icon(Icons.add,
                        // size: 20,
                        color: ThemeApp.buttonCounterFontColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

/*  Widget aadToCartCounter(
      List<CartOrdersForPurchase> cartOrderPurchase, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text(value.lst[index].totalOriginalPrice.toString()),
        Container(
          height: height * 0.05,
          // width: width * .2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(
                  color: ThemeApp.buttonBorderLightGreyColor, width: 1.5)),

          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      // minusQuantity(value, index);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: const Icon(Icons.remove,
                        // size: 20,
                        color: ThemeApp.buttonCounterFontColor),
                  ),
                ),
                Container(
                  height: height * 0.05,
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    0,
                  ),
                  color: ThemeApp.buttonBorderLightGreyColor,
                  child: Text(
                    cartOrderPurchase![index].itemQty.toString(),
                    style: TextStyle(fontFamily: 'Roboto',
                        fontSize: MediaQuery.of(context).size.height * .016,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      // addQuantity(value, index);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: const Icon(Icons.add,
                        // size: 20,
                        color: ThemeApp.buttonCounterFontColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        */ /*  InkWell(
          onTap: () {
            setState(() {});
            cartOrderPurchase!.removeAt(index);
            // finalPrices(value, index);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CartDetailsActivity()),
            );
          },
          child: SvgPicture.asset(
            'assets/appImages/deleteIcon.svg',
            color: ThemeApp.lightFontColor,
            semanticsLabel: 'Acme Logo',
            theme: SvgTheme(
              currentColor: ThemeApp.lightFontColor,
            ),
            height: height * .03,
          ),
        )*/ /*
      ],
    );
  }*/

  /*void addQuantity(ProductProvider value, int index) {
    print("maxCounter counter ${value.cartList[index].cartProductsMaxCounter}");
    print("temp counter 1 ${value.cartList[index].cartProductsTempCounter}");
    if (int.parse(value.cartList[index].cartProductsTempCounter.toString()) <
        int.parse(value.cartList[index].cartProductsMaxCounter.toString())) {
      value.cartList[index].cartProductsTempCounter =
          int.parse(value.cartList[index].cartProductsTempCounter.toString()) + 1;
      print("temp counter 2 ${value.cartList[index].cartProductsTempCounter}");

      finalPrices(value, index);
    }
  }*/

  double finalOriginalPrice = 0.0;
  double finalDiscountPrice = 0.0;
  double finalDiffrenceDiscountPrice = 0.0;
  double finalTotalPrice = 0.0;

  /* void finalPrices(ProductProvider value, int index) {
    finalOriginalPrice = 0.0;
    finalDiscountPrice = 0.0;
    finalDiffrenceDiscountPrice = 0.0;
    finalTotalPrice = 0.0;
    widget.value.deliveryAmount = 0.0;

    for (int i = 0; i < value.cartList.length; i++) {
      finalOriginalPrice = finalOriginalPrice +
          (int.parse(value.cartList[i].cartProductsTempCounter.toString()) *
              double.parse(
                  value.cartList[i].cartProductsOriginalPrice.toString()));

      Prefs.instance.setDoubleToken(
          StringConstant.totalOriginalPricePref, finalOriginalPrice);
      if (kDebugMode) {
        print("______finaloriginalPrice______$finalOriginalPrice");
      }
      finalDiscountPrice = finalDiscountPrice +
          (int.parse(value.cartList[i].cartProductsTempCounter.toString()) *
              double.parse(
                  value.cartList[i].cartProductsDiscountPrice.toString()));
      if (kDebugMode) {
        print("______finalDiscountPrice______$finalDiscountPrice");
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
      if (finalTotalPrice == 0) {
        value.del(index);
        finalPrices(value, index);
      }
      if (kDebugMode) {
        print("grandTotalAmount inside add: $i $finalTotalPrice");
      }
    }
  }*/

/*
  Future<void> finalPrices(ProductProvider value, int index) async {
    finalOriginalPrice = 0.0;
    finalDiscountPrice = 0.0;
    finalDiffrenceDiscountPrice = 0.0;
    finalTotalPrice = 0.0;

    for (int i = 0; i < value.cartList.length; i++) {
      finalOriginalPrice = finalOriginalPrice +
          (int.parse(value.cartList[i].cartProductsTempCounter.toString()) *
              double.parse(value.cartList[i].cartProductsOriginalPrice.toString()));

      Prefs.instance.setDoubleToken(
          StringConstant.totalOriginalPricePref, finalOriginalPrice);

      print("______finaloriginalPrice______$finalOriginalPrice");

      finalDiscountPrice = finalDiscountPrice +
          (int.parse(value.cartList[i].cartProductsTempCounter.toString()) *
              double.parse(value.cartList[i].cartProductsDiscountPrice.toString()));
      print("______finalDiscountPrice______$finalDiscountPrice");

      finalDiffrenceDiscountPrice = finalOriginalPrice - finalDiscountPrice;
      print(
          "________finalDiffrenceDiscountPrice add: $i $finalDiffrenceDiscountPrice");
      StringConstant.totalFinalPrice =
          (await Prefs.instance.getDoubleToken(StringConstant.totalFinalPricePref))!;

      StringConstant.totalFinalPrice = value.deliveryAmount +
          (finalOriginalPrice - finalDiffrenceDiscountPrice);

      print("grandTotalAmount inside add: $i $finalTotalPrice");
    }
  }
*/

/*
  Future<void> minusQuantity(ProductProvider value, int index) async {
    print("maxCounter counter ${value.cartList[index].cartProductsMaxCounter}");
    print("temp counter 1 ${value.cartList[index].cartProductsTempCounter}");
    if (int.parse(value.cartList[index].cartProductsTempCounter.toString()) > 0){
      value.cartList[index].cartProductsTempCounter =
          int.parse(value.cartList[index].cartProductsTempCounter.toString()) - 1;
      print("temp counter 2 ${value.cartList[index].cartProductsTempCounter}");


////PRICE CODE AFTER ADDING COUNT
      finalPrices(value, index);
    }
  }
*/

/*
  void addQuantity(ProductProvider value, int index) {
    if (kDebugMode) {
      print(
          "maxCounter counter ${value.cartList[index].cartProductsMaxCounter}");
      print("temp counter 1 ${value.cartList[index].cartProductsTempCounter}");
    }
    if (int.parse(value.cartList[index].cartProductsTempCounter.toString()) <
        int.parse(value.cartList[index].cartProductsMaxCounter.toString())) {
      value.cartList[index].cartProductsTempCounter =
          int.parse(value.cartList[index].cartProductsTempCounter.toString()) +
              1;
      if (kDebugMode) {
        print(
            "temp counter 2 ${value.cartList[index].cartProductsTempCounter}");
      }
      finalPrices(value, index);
    }
  }
*/

/*
  void finalPrices(ProductProvider value, int index) {
    finalOriginalPrice = 0.0;
    finalDiscountPrice = 0.0;
    finalDiffrenceDiscountPrice = 0.0;
    finalTotalPrice = 0.0;
    widget.value.deliveryAmount = 60.0;

    for (int i = 0; i < value.cartList.length; i++) {
      finalOriginalPrice = finalOriginalPrice +
          (int.parse(value.cartList[i].cartProductsTempCounter.toString()) *
              double.parse(
                  value.cartList[i].cartProductsOriginalPrice.toString()));

      Prefs.instance.setDoubleToken(
          StringConstant.totalOriginalPricePref, finalOriginalPrice);
      if (kDebugMode) {
        print("______finaloriginalPrice______$finalOriginalPrice");
      }
      finalDiscountPrice = finalDiscountPrice +
          (int.parse(value.cartList[i].cartProductsTempCounter.toString()) *
              double.parse(
                  value.cartList[i].cartProductsDiscountPrice.toString()));
      if (kDebugMode) {
        print("______finalDiscountPrice______$finalDiscountPrice");
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
      if (finalTotalPrice == 0) {
        value.del(index);
        finalPrices(value, index);
      }
      if (kDebugMode) {
        print("grandTotalAmount inside add: $i $finalTotalPrice");
      }
    }
  }
*/

/*
  Future<void> minusQuantity(CartPayLoad value, int index) async {
    if (kDebugMode) {
      print(
          "maxCounter counter ${value.cartList[index].cartProductsMaxCounter}");
      print(
          "temp counter 1 minus ${value.cartList[index].cartProductsTempCounter}");
    }
    if (int.parse(value.cartList[index].cartProductsTempCounter.toString()) >
        1) {
      value.cartList[index].cartProductsTempCounter =
          int.parse(value.cartList[index].cartProductsTempCounter.toString()) -
              1;
      if (kDebugMode) {
        print(
            "temp counter minus  ${value.cartList[index].cartProductsTempCounter}");
      }
      value.cartList[index].cartProductsTotalOriginalPrice =
          ((value.cartList[index].cartProductsTempCounter)! *
              int.parse(
                  value.cartList[index].cartProductsOriginalPrice.toString()));
      if (kDebugMode) {
        print(
            "_____________value.lst[index].totalOriginalPrice ${value.cartList[index].cartProductsTotalOriginalPrice}");
      }
////PRICE CODE AFTER ADDING COUNT
      finalPrices(value, index);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => CartDetailsActivity()),
      );
    }
  }
*/

/*
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
                        indianRupeesFormat.format(StringConstant.totalOriginalPrice),
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
                        "- ${indianRupeesFormat.format(StringConstant.totalDiscountPrice)}",
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
                  "${indianRupeesFormat.format(StringConstant.totalFinalPrice)} ",
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
*/
  Widget priceDetails(CartForPaymentPayload payload) {
    return /*Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [*/
        Container(
      // height: height * 0.25,
      width: width,
      decoration: const BoxDecoration(
        color: ThemeApp.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 11, 10, 45),
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
                    indianRupeesFormat.format(
                        double.parse(payload.cart!.totalMrp.toString() ?? '')),
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
                    "- ${indianRupeesFormat.format(double.parse(payload.cart!.totalDiscountAmount.toString()))}",
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
                        fontSize: height * .019,
                        fontWeight: FontWeight.w400)),
                Text(
                    indianRupeesFormat.format(double.parse(
                        payload.cart!.totalDeliveryCharges.toString())),
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: height * .019,
                        fontWeight: FontWeight.w400)),
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
                  Text(
                      "${indianRupeesFormat.format(payload.cart!.totalPayable)} ",
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

  /* Widget priceDetails(
      CartForPaymentPayload cartForPaymentPayload) {
    return */ /*Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [*/ /*
        Container(
      // height: height * 0.25,
      width: width,
      decoration: const BoxDecoration(
        color: ThemeApp.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price Details',
                style: TextStyle(fontFamily: 'Roboto',
                    color: ThemeApp.primaryNavyBlackColor,
                    fontSize: height * .025,
                    fontWeight: FontWeight.w400)),
            SizedBox(
              height: height * .01,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price',
                    style: TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: height * .019,
                        fontWeight: FontWeight.w400)),
                // TextFieldUtils().homePageTitlesTextFields(
                //     "Price (${payload.ordersForPurchase!.length.toString()} items)",
                //     context),
                Text(
                    indianRupeesFormat.format(double.parse(
                        cartForPaymentPayload.cart!.totalPayable.toString())),
                    style: TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: height * .019,
                        fontWeight: FontWeight.w400)),
                // TextFieldUtils().homePageTitlesTextFields(
                //     indianRupeesFormat
                //         .format(double.parse(payload.totalMrp.toString())),
                //     context)
              ],
            ),
            SizedBox(
              height: height * .01,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discount',
                    style: TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: height * .019,
                        fontWeight: FontWeight.w400)),
                Text(
                    "- ${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalDiscountAmount.toString()))}",
                    style: TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: height * .019,
                        fontWeight: FontWeight.w400)),
                */ /*   TextFieldUtils()
                        .homePageTitlesTextFields("Discount", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        "- ${indianRupeesFormat.format(double.parse(payload.totalDiscountAmount.toString()))}",
                        context),*/ /*
              ],
            ),
            SizedBox(
              height: height * .01,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery charges',
                    style: TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: height * .019,
                        fontWeight: FontWeight.w400)),
                Text(
                    indianRupeesFormat.format(double.parse(cartForPaymentPayload
                        .cart!.totalDeliveryCharges
                        .toString())),
                    style: TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: height * .019,
                        fontWeight: FontWeight.w400)),
                */ /* TextFieldUtils()
                        .homePageTitlesTextFields("Delivery charges", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(double.parse(
                            payload.totalDeliveryCharges.toString())),
                        context),*/ /*
              ],
            ),
            SizedBox(
              height: height * .01,
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
                      style: TextStyle(fontFamily: 'Roboto',
                          color: ThemeApp.blackColor,
                          fontSize: height * .019,
                          fontWeight: FontWeight.w400)),
                  Text(
                      "${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalPayable.toString()))} ",
                      style: TextStyle(fontFamily: 'Roboto',
                          color: ThemeApp.appColor,
                          fontSize: height * .025,
                          fontWeight: FontWeight.w700)),
                  */ /* TextFieldUtils().titleTextFields("Total Amount", context),
                      TextFieldUtils().titleTextFields(
                          "${indianRupeesFormat.format(payload.totalPayable)} ",
                          context),*/ /*
                ],
              ),
            ),
          ],
        ),
      ),
    );
    */ /*  Container(
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
        )*/ /*
    */ /* ],
    );*/ /*
  }*/

/*
  Widget priceDetails(List<CartOrdersForPurchase> cartOrderPurchase,
      CartForPaymentPayload cartForPaymentPayload) {
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
                    TextFieldUtils().homePageTitlesTextFields("Price", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(double.parse(
                            cartForPaymentPayload.cart!.totalPayable
                                .toString())),
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
                        "- ${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalDiscountAmount.toString()))}",
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
                            cartForPaymentPayload.cart!.totalDeliveryCharges
                                .toString())),
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
                  "${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalPayable.toString()))} ",
                  context),
            ],
          ),
        ),
        SizedBox(
          height: height * .02,
        )
      ],
    );
  }*/ /*
  Widget priceDetails(List<CartOrdersForPurchase> cartOrderPurchase,
      CartForPaymentPayload cartForPaymentPayload) {
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
                    TextFieldUtils().homePageTitlesTextFields("Price", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        indianRupeesFormat.format(double.parse(
                            cartForPaymentPayload.cart!.totalPayable
                                .toString())),
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
                        "- ${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalDiscountAmount.toString()))}",
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
                            cartForPaymentPayload.cart!.totalDeliveryCharges
                                .toString())),
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
                  "${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalPayable.toString()))} ",
                  context),
            ],
          ),
        ),
        SizedBox(
          height: height * .02,
        )
      ],
    );
  }*/

  Widget stepperWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 16, 19, 14),
      child: Container(
          height: 78,
          width: width,
          alignment: Alignment.center,
          color: ThemeApp.appBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: _iconViews(),
              ),
              const SizedBox(
                height: 8,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _titleViews(context),
                ),
              ),
            ],
          )),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, icon) {
      var circleColor = (i == 0 || i == 1 || _curStep > i + 1)
          ? ThemeApp.tealButtonColor
          : ThemeApp.appColor;
      var lineColor = (i == 0 || i == 1 || _curStep > i + 1)
          ? ThemeApp.tealButtonColor
          : ThemeApp.appColor;
      var iconColor = (i == 0 || i == 1 || _curStep > i + 1)
          ? ThemeApp.tealButtonColor
          : ThemeApp.appColor;

      list.add(
        Container(
          width: 23.0,
          height: 23.0,
          padding: const EdgeInsets.all(0),
          // decoration:(i == 0 || _curStep > i + 1) ? new  BoxDecoration(
          //
          // ):BoxDecoration(   /* color: circleColor,*/
          //   borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
          //   border: new Border.all(
          //     color: circleColor,
          //     width: 2.0,
          //   ),),
          child: (i == 0 || _curStep > i + 1)
              ? Icon(
                  Icons.circle,
                  color: iconColor,
                  size: 18.0,
                )
              : Icon(
                  Icons.radio_button_checked_outlined,
                  color: iconColor,
                  size: 18.0,
                ),
        ),
      );

      //line between icons
      if (i != titles.length - 1) {
        list.add(Expanded(
            child: Container(
          height: 3.0,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews(BuildContext context) {
    var list = <Widget>[];
    titles.asMap().forEach((i, text) {
      list.add(
        (i == 0 || i == 1 || _curStep > i + 1)
            ? SizedBox(
                width: 61,
                child: TextFieldUtils().dynamicText(
                    text,
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400)),
              )
            : SizedBox(
                width: 61,
                child: TextFieldUtils().dynamicText(
                    text,
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400)),
              ),
      );
    });
    return list;
  }
}

final List<String> titles = [
  'Order review',
  'Delivery detail',
  'Payment',
  'Order confirmation',
];
int _curStep = 1;

///////////////show bottom sheet

class ChangeAddressBottomSheet extends StatefulWidget {
  final CartForPaymentPayload cartForPaymentPayload;
  final int cartId;

  ChangeAddressBottomSheet(
      {required this.cartForPaymentPayload, required this.cartId});

  @override
  _ChangeAddressBottomSheetState createState() =>
      _ChangeAddressBottomSheetState();
}

class _ChangeAddressBottomSheetState extends State<ChangeAddressBottomSheet> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  List<String> allMessages = [];
  TextEditingController _textEditingController = TextEditingController();
  var address =
      'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India - 380021';
  int? _radioSelected = 0;
  String _radioVal = "";
  CartViewModel cartViewModel = CartViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartViewModel.sendAddressWithGet(
        context, widget.cartForPaymentPayload.userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: deliveryAddress())));
  }

  int _selectedIndex = 0;
  int _value2 = 0;

  Widget deliveryAddress() {
    return ChangeNotifierProvider<CartViewModel>.value(
        value: cartViewModel,
        child: Consumer<CartViewModel>(builder: (context, cartProvider, child) {
          switch (cartProvider.getAddress.status) {
            case Status.LOADING:
              print("Api load");

              return Container();
            case Status.ERROR:
              print("Api error");

              return Text(cartProvider.getAddress.message.toString());
            case Status.COMPLETED:
              print("Api calll");
              List<AddressContent>? addressList =
                  cartProvider.getAddress.data!.payload!.content;

              print("addressList" + addressList!.length.toString());
              return Stack(
                alignment: Alignment.center, // <---------

                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 20, 24, 0),
                      decoration: const BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFieldUtils().dynamicText(
                                    StringUtils.deliveryAddress,
                                    context,
                                    TextStyle(
                                        fontFamily: 'Roboto',
                                        color: ThemeApp.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddNewDeliveryAddress(
                                        isSavedAddress: false,
                                        /*      cartForPaymentPayload: widget
                                                  .cartForPaymentPayload!*/
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 5, 15.0, 5),
                                  decoration: BoxDecoration(
                                    color: ThemeApp.appColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: ThemeApp.whiteColor,
                                        ),
                                        Text(StringUtils.addNewAddress,
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ThemeApp.whiteColor,
                                                // fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          /*   Container(
                            width: width,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: ThemeApp.lightGreyTab,
                                  width: 0.5,
                                ),
                                bottom: BorderSide(
                                    color: ThemeApp.darkGreyTab, width: 0.5),
                              ),
                            ),
                          ),*/
/*
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddNewDeliveryAddress(
                                      isSavedAddress: false,
                                      cartForPaymentPayload:
                                          widget.cartForPaymentPayload!),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                padding: const EdgeInsets.all(12),
                                color: ThemeApp.textFieldBorderColor,
                                dashPattern: [5, 5],
                                strokeWidth: 1,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Container(
                                    width: width,
                                    alignment: Alignment.center,
                                    child: TextFieldUtils().dynamicText(
                                        StringUtils.addNewAddress,
                                        context,
                                        TextStyle(fontFamily: 'Roboto',
                                            color: ThemeApp.blackColor,
                                            fontSize: height * .023,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                            ),
                          ),
*/
                          SizedBox(
                            height: 11,
                          ),
                          addressList.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                      itemCount: addressList.length,
                                      itemBuilder: (_, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {});
                                            StringConstant.selectedFullName =
                                                "${addressList[index].name!}";
                                            StringConstant.selectedFullAddress =
                                                "${addressList[index].addressLine1!}, ${addressList[index].addressLine2}, ${addressList[index].stateName},\n ${addressList[index].cityName}, ${addressList[index].pincode}";

                                            // cartViewModel.loadAddressJson(
                                            //     widget.cartForPaymentPayload!
                                            //         .userId
                                            //         .toString(),
                                            //     addressList[index]
                                            //         .id
                                            //         .toString());
                                            // cartViewModel.loadAddressJson('130', '42');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: ThemeApp.appColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 20, 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        // padding: const EdgeInsets
                                                        //         .fromLTRB(
                                                        //     20, 0, 20, 0),

                                                        // padding: EdgeInsets.symmetric(
                                                        //     horizontal: 10, vertical: 7),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Radio(
                                                                activeColor:
                                                                    ThemeApp
                                                                        .appColor,
                                                                value: index,
                                                                groupValue:
                                                                    _value2,
                                                                onChanged: (int?
                                                                    value) {
                                                                  setState(() {
                                                                    _value2 =
                                                                        value!;
                                                                    _selectedIndex =
                                                                        index;
                                                                    print(
                                                                        "Radio index is  $value");
                                                                    Prefs.instance.setToken(
                                                                        StringConstant
                                                                            .selectedFullAddressPref,
                                                                        StringConstant
                                                                            .selectedFullAddress);

                                                                    print("selected Address " +
                                                                        StringConstant
                                                                            .selectedFullAddress);
                                                                  });
                                                                }),
                                                            Row(
                                                              children: [
                                                                TextFieldUtils().dynamicText(
                                                                    addressList[
                                                                            index]
                                                                        .name!,
                                                                    context,
                                                                    TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w400)),
                                                                SizedBox(
                                                                  width: 23,
                                                                ),
                                                                Container(
                                                                  // height: height * 0.05,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          100),
                                                                    ),
                                                                    color: ThemeApp
                                                                        .appColor,
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                                  child: TextFieldUtils().dynamicText(
                                                                      addressList[
                                                                              index]
                                                                          .addressType!,
                                                                      context,
                                                                      TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          color: ThemeApp
                                                                              .whiteColor,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 50,
                                                              right: 20),
                                                      child: TextFieldUtils().dynamicText(
                                                          "${addressList[index].addressLine1!}, ${addressList[index].addressLine2}, ${addressList[index].stateName},\n ${addressList[index].cityName}, ${addressList[index].pincode}",
                                                          context,
                                                          TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color: ThemeApp
                                                                  .blackColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              letterSpacing:
                                                                  -0.25,
                                                              height: 1.5)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 50,
                                                              right: 20,
                                                              top: 10),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/appImages/callIcon.svg',
                                                            color: ThemeApp
                                                                .appColor,
                                                            semanticsLabel:
                                                                'Acme Logo',
                                                            theme: SvgTheme(
                                                              currentColor:
                                                                  ThemeApp
                                                                      .appColor,
                                                            ),
                                                            height: 12,
                                                            width: 12,
                                                          ),
                                                          SizedBox(
                                                            width: width * .03,
                                                          ),
                                                          TextFieldUtils().dynamicText(
                                                              "${StringConstant.selectedMobile}",
                                                              context,
                                                              TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: ThemeApp
                                                                      .blackColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 21,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              addressList
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/appImages/deleteIcon.svg',
                                                            color: ThemeApp
                                                                .lightFontColor,
                                                            semanticsLabel:
                                                                'Acme Logo',
                                                            theme: SvgTheme(
                                                              currentColor:
                                                                  ThemeApp
                                                                      .appColor,
                                                            ),
                                                            height: 19,
                                                            width: 17.54,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width * .03,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            // Navigator.of(context).push(
                                                            //   MaterialPageRoute(
                                                            //     builder: (context) =>
                                                            //         EditDeliveryAddress(
                                                            //           cartForPaymentPayload: widget.cartForPaymentPayload,
                                                            //           model: addressList,isSavedAddress: ture,
                                                            //         ),
                                                            //   ),
                                                            // );
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/appImages/editIcon.svg',
                                                            color: ThemeApp
                                                                .appColor,
                                                            semanticsLabel:
                                                                'Acme Logo',
                                                            theme: SvgTheme(
                                                              currentColor:
                                                                  ThemeApp
                                                                      .appColor,
                                                            ),
                                                            height: 16.72,
                                                            width: 16.72,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }))
                              : TextFieldUtils().dynamicText(
                                  'No Address found',
                                  context,
                                  TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.blackColor,
                                      fontSize: height * .02,
                                      fontWeight: FontWeight.w400)),
                          Container(
                            alignment: FractionalOffset.bottomCenter,
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: proceedButton(StringUtils.deliverHere,
                                ThemeApp.tealButtonColor, context, false, () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              setState(() {
                                cartViewModel.loadAddressJson(
                                    widget.cartForPaymentPayload.userId
                                        .toString(),
                                    addressList[_value2].id.toString());

                                StringConstant.selectedFullAddress =
                                    "${addressList[_value2].addressLine1!}, ${addressList[_value2].addressLine2}, ${addressList[_value2].stateName},\n ${addressList[_value2].cityName}, ${addressList[_value2].pincode}";
                                Prefs.instance.setToken(
                                    StringConstant.selectedFullAddressPref,
                                    StringConstant.selectedFullAddress);

                                StringConstant.selectedFullName =
                                    addressList[_value2].name!;
                                Prefs.instance.setToken(
                                    StringConstant.selectedFullNamePref,
                                    StringConstant.selectedFullName);

                                StringConstant.selectedMobile =
                                    addressList[_value2].contactNumber!;
                                Prefs.instance.setToken(
                                    StringConstant.selectedMobilePref,
                                    StringConstant.selectedMobile);

                                StringConstant.selectedTypeOfAddress =
                                    addressList[_value2].addressType!;
                                Prefs.instance.setToken(
                                    StringConstant.selectedTypeOfAddressPref,
                                    StringConstant.selectedTypeOfAddress);
                              });
                              Navigator.pop(context); //closes bottom sheet
                              print("widget.cartForPaymentPayload!.cartId" +
                                  widget.cartId.toString());
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => OrderReviewActivity(
                                    cartId: widget.cartId ?? 0,
                                  ),
                                ),
                              );

                              /*  Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                          builder: (context) => OrderReviewSubActivity(
                           cartPayLoad: null,),
                            ),
                          );*/
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.close,
                            size: 30,
                            color: ThemeApp.whiteColor,
                          )),
                    ),
                  ),
                ],
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
        }));

/*
    return Consumer<ProductProvider>(builder: (context, value, child) {
    return Stack(
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Padding(
    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
    child: TextFieldUtils().dynamicText(
    StringUtils.deliveryAddress,
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.blackColor,
    fontSize: height * .03,
    fontWeight: FontWeight.bold)),
    ),
    Container(
    width: width,
    decoration: const BoxDecoration(
    border: Border(
    top: BorderSide(
    color: ThemeApp.lightGreyTab,
    width: 0.5,
    ),
    bottom: BorderSide(color: ThemeApp.darkGreyTab, width: 0.5),
    ),
    ),
    ),
    InkWell(
    onTap: () {
    Navigator.of(context).push(
    MaterialPageRoute(
    builder: (context) => AddNewDeliveryAddress(
    isSavedAddress: false,
    ),
    ),
    );
    },
    child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
    child: DottedBorder(
    borderType: BorderType.RRect,
    radius: Radius.circular(10),
    padding: EdgeInsets.all(12),
    color: ThemeApp.textFieldBorderColor,
    dashPattern: [5, 5],
    strokeWidth: 1,
    child: ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    child: Container(
    width: width,
    alignment: Alignment.center,
    child: TextFieldUtils().dynamicText(
    StringUtils.addNewAddress,
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.blackColor,
    fontSize: height * .023,
    fontWeight: FontWeight.w400)),
    ),
    ),
    ),
    ),
    ),
    SizedBox(
    height: height * .02,
    ),
    value.addressList.length > 0
    ? Expanded(
    child: ListView.builder(
    itemCount: value.addressList.length,
    itemBuilder: (_, index) {
    return InkWell(
    onLongPress: () {
    setState(() {
    value.addressList.removeAt(index);
    });
    },
    onTap: () {
    setState(() {});
    StringConstant.selectedFullAddress =
    "${value.addressList[index].myAddressHouseNoBuildingName!}, ${value.addressList[index].myAddressAreaColony}, ${value.addressList[index].myAddressCity},\n ${value.addressList[index].myAddressState}";
    },
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Center(
    child: Container(
    padding: const EdgeInsets.fromLTRB(
    20, 0, 20, 0),

    // padding: EdgeInsets.symmetric(
    //     horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
    children: [
    Radio(
    value: index,
    groupValue: _value2,
    onChanged: (int? value) {
    setState(() {
    _value2 = value!;
    _selectedIndex = index;
    print(
    "Radio index is  $value");
    Prefs.instance.setToken(
    StringConstant
        .selectedFullAddressPref,
    StringConstant
        .selectedFullAddress);

    print("selected Address " +
    StringConstantF
        .selectedFullAddress);
    });
    }),
    Row(
    children: [
    TextFieldUtils().dynamicText(
    value.addressList[index]
        .myAddressFullName!,
    context,
    TextStyle(fontFamily: 'Roboto',
    color:
    ThemeApp.blackColor,
    fontSize: height * .023,
    fontWeight:
    FontWeight.w400)),
    SizedBox(
    width: width * .02,
    ),
    Container(
    // height: height * 0.05,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
    borderRadius:
    BorderRadius.all(
    Radius.circular(5),
    ),
    color: ThemeApp.darkGreyTab,
    ),
    padding: const EdgeInsets.only(
    left: 10,
    right: 10,
    top: 5,
    bottom: 5),
    child: TextFieldUtils().dynamicText(
    value.addressList[index]
        .myAddressTypeOfAddress!,
    context,
    TextStyle(fontFamily: 'Roboto',
    color:
    ThemeApp.whiteColor,
    fontSize: height * .02,
    fontWeight:
    FontWeight.w400)),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(
    left: 70, right: 20),
    child: TextFieldUtils().dynamicText(
    "${value.addressList[index].myAddressHouseNoBuildingName!}, ${value.addressList[index].myAddressAreaColony}, ${value.addressList[index].myAddressCity},\n ${value.addressList[index].myAddressState}",
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.darkGreyTab,
    fontSize: height * .021,
    fontWeight: FontWeight.w400)),
    ),
    Padding(
    padding: const EdgeInsets.only(
    left: 70, right: 20, top: 10),
    child: TextFieldUtils().dynamicText(
    "${'${StringUtils.contactNumber} : ' + StringConstant.selectedMobile}",
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.blackColor,
    fontSize: height * .021,
    fontWeight: FontWeight.w400)),
    ),
    ],
    ),
    );
    }))
        : Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Center(
    child: Container(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

    // padding: EdgeInsets.symmetric(
    //     horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
    children: [
    Radio(
    value: 1,
    groupValue: _value2,
    onChanged: (int? value) {
    setState(() {
    _value2 = value!;
    print("Radio index is  $value");
    });
    }),
    Row(
    children: [
    TextFieldUtils().dynamicText(
    StringConstant.selectedFullName,
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.blackColor,
    fontSize: height * .023,
    fontWeight: FontWeight.w400)),
    SizedBox(
    width: width * .02,
    ),
    Container(
    // height: height * 0.05,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
    borderRadius: BorderRadius.all(
    Radius.circular(5),
    ),
    color: ThemeApp.darkGreyTab,
    ),
    padding: const EdgeInsets.only(
    left: 10,
    right: 10,
    top: 5,
    bottom: 5),
    child: TextFieldUtils().dynamicText(
    StringConstant.selectedTypeOfAddress,
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.whiteColor,
    fontSize: height * .02,
    fontWeight: FontWeight.w400)),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(left: 70, right: 20),
    child: TextFieldUtils().dynamicText(
    'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India - 380021',
    context,
    TextStyle(fontFamily: 'Roboto',
    overflow: TextOverflow.ellipsis,
    color: ThemeApp.darkGreyTab,
    fontSize: height * .021,
    fontWeight: FontWeight.w400)),
    ),
    Padding(
    padding: const EdgeInsets.only(
    left: 70, right: 20, top: 10),
    child: TextFieldUtils().dynamicText(
    "${'${StringUtils.contactNumber} : ${StringConstant.selectedMobile}'}",
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.blackColor,
    fontSize: height * .021,
    fontWeight: FontWeight.w400)),
    ),
    ],
    ),
    Container(
    alignment: FractionalOffset.bottomCenter,
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
    child: proceedButton(StringUtils.deliverHere,
    ThemeApp.blackColor, context, false, () {
    setState(() {
    StringConstant.selectedFullAddress =
    "${value.addressList[_value2].myAddressHouseNoBuildingName!}, ${value.addressList[_value2].myAddressAreaColony}, ${value.addressList[_value2].myAddressCity},\n ${value.addressList[_value2].myAddressState}";
    Prefs.instance.setToken(
    StringConstant.selectedFullAddressPref,
    StringConstant.selectedFullAddress);

    StringConstant.selectedFullName =
    value.addressList[_value2].myAddressFullName!;
    Prefs.instance.setToken(StringConstant.selectedFullNamePref,
    StringConstant.selectedFullName);

    StringConstant.selectedMobile =
    value.addressList[_value2].myAddressPhoneNumber!;
    Prefs.instance.setToken(StringConstant.selectedMobilePref,
    StringConstant.selectedMobile);

    StringConstant.selectedTypeOfAddress =
    value.addressList[_value2].myAddressTypeOfAddress!;
    Prefs.instance.setToken(
    StringConstant.selectedTypeOfAddressPref,
    StringConstant.selectedTypeOfAddress);
    });
    */
/*  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => OrderReviewSubActivity(
                       cartPayLoad: null,),
                    ),
                  );*/ /*

    }),
    )
    ],
    ),
    ],
    );
    });
*/
  }

  Widget checkingData() {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: allMessages.length,
                itemBuilder: (_, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            allMessages.removeAt(index);
                          });
                        },
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green),
                            child: Text(allMessages[index]),
                          ),
                        ),
                      ),
                    ],
                  );
                })),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  onEditingComplete: () {
                    setState(() {
                      allMessages.add(_textEditingController.text);
                      _textEditingController.text = "";
                    });
                  },
                  controller: _textEditingController,
                ),
              ),
              IconButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    setState(() {
                      allMessages.add(_textEditingController.text);
                      _textEditingController.text = "";
                    });
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
        )
      ],
    );
  }
}
