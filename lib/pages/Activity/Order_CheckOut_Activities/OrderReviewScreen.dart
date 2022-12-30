import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

import '../My_Account_Activities/Saved_address/saved_address_detailed_screen.dart';
import '../Payment_Activities/OrderPlaced_activity.dart';
import '../Payment_Activities/payments_Activity.dart';
import 'AddNewDeliveryAddress.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("Cart id in sub order " + widget.cartId.toString());
    cartListView.sendCartForPaymentWithGet(context, widget.cartId.toString());
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
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .09),
          child: appBar_backWidget(
              context, appTitle(context, "Order Checkout"), const SizedBox()),
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

                      return Container(
                        height: height * .09,
                        width: width,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: ThemeApp.tealButtonColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15)),
                        ),
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 10,),                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                ]),*/
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFieldUtils().pricesLineThroughWhite(
                                    "${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalMrp.toString()))}",
                                    context,
                                    MediaQuery.of(context).size.height * .021,
                                  ),
                                  TextFieldUtils()
                                      .homePageheadingTextFieldWHITE(
                                    "${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalPayable.toString()))}",
                                    context,
                                  ),
                                ]),
                            InkWell(
                                onTap: () {
                                  Map data = {
                                    "order_basket_id":
                                        cartForPaymentPayload.orderBasketId,
                                    "user_id": cartForPaymentPayload.userId,
                                    "payable_amount": cartForPaymentPayload
                                        .cart!.totalPayable,
                                  };
                                  CartRepository().putCartForPayment(data,
                                      cartForPaymentPayload.orderBasketId!);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Payment_Creditcard_debitcardScreen(
                                              cartForPaymentPayload:
                                                  cartForPaymentPayload),
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
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: TextFieldUtils().usingPassTextFields(
                                        "Pay Now",
                                        ThemeApp.tealButtonColor,
                                        context))),
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
                            color: ThemeApp.blackColor,
                            fontSize: height * .03,
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
                  */ /*  Column(
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

                      return Container(
                        color: ThemeApp.appBackgroundColor,
                        width: width,
                        child: ListView(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              stepperWidget(),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Container(
                                      // height: height * 0.5,
                                      width: width,
                                      padding: const EdgeInsets.all(20),
                                      decoration: const BoxDecoration(
                                        color: ThemeApp.whiteColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                    StringUtils.deliveryDetails,
                                                    style: TextStyle(
                                                        color:
                                                        ThemeApp.blackColor,
                                                        fontSize: height * .025,
                                                        letterSpacing: -0.25 ,
                                                        fontWeight:
                                                        FontWeight.w700)),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                    onTap: () {
                                                      // Navigator.of(context).push(
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) => AddNewDeliveryAddress(),
                                                      //   ),
                                                      // );
                                                      showModalBottomSheet(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        60.0),
                                                          ),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          context:
                                                              scaffoldGlobalKey
                                                                  .currentContext!,
                                                          builder: (context) {
                                                            return ChangeAddressBottomSheet(
                                                                cartForPaymentPayload:
                                                                    cartForPaymentPayload);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: height * 0.05,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                           BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(20),
                                                        ),
                                                        border: Border.all(color: ThemeApp.appColor)
                                                        // color:
                                                        //     ThemeApp.blackColor,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 15),
                                                      child: TextFieldUtils()
                                                          .dynamicText(
                                                              StringUtils
                                                                  .changeAddress,
                                                              context,
                                                          TextStyle(
                                                              color:
                                                              ThemeApp.appColor,
                                                              fontSize: height * .02,
                                                              letterSpacing: -0.08 ,
                                                              fontWeight:
                                                              FontWeight.w700)),

                                                    )),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * .03,
                                          ),
                                          cartForPaymentPayload
                                                      .isAddressPresent ==
                                                  true
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        TextFieldUtils().dynamicText(
                                                            StringConstant
                                                                .selectedFullName,
                                                            context,
                                                            TextStyle(
                                                                fontSize: height * .021,
                                                                letterSpacing: -0.08 ,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                color: ThemeApp
                                                                    .blackColor,
                                                            )),
                                                        SizedBox(
                                                          width: width * .02,
                                                        ),
                                                        Container(
                                                          // height: height * 0.05,

                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                            color: ThemeApp
                                                                .tealButtonColor,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: Text(
                                                              StringConstant
                                                                  .selectedTypeOfAddress,
                                                              style: TextStyle(
                                                                  color: ThemeApp
                                                                      .whiteColor,
                                                                  fontSize:
                                                                      height *
                                                                          .02,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * .02,
                                                    ),
                                                    Text(
                                                        // provider.orderCheckOutDetails[0]
                                                        //     ["orderCheckOutDeliveryAddress"],
                                                        StringConstant
                                                            .selectedFullAddress,
                                                        style: TextStyle(

                                                            fontSize: height * .019,
                                                            letterSpacing: -0.08 ,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            color: ThemeApp
                                                                .blackColor,
                                                          )),

                                                    SizedBox(
                                                      height: height * .03,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/appImages/callIcon.svg',
                                                          color:
                                                          ThemeApp.appColor,
                                                          semanticsLabel:
                                                          'Acme Logo',
                                                          theme: SvgTheme(
                                                            currentColor:
                                                            ThemeApp
                                                                .appColor,
                                                          ),
                                                          height: height * .025,
                                                        ),
                                                        SizedBox(
                                                          width: width * .03,
                                                        ),
                                                        TextFieldUtils().dynamicText(
                                                            "${StringConstant.selectedMobile}",
                                                            context,
                                                            TextStyle(
                                                                color: ThemeApp
                                                                    .blackColor,
                                                                fontSize:
                                                                height *
                                                                    .019,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : TextFieldUtils().dynamicText(
                                                  'No Address found',
                                                  context,
                                                  TextStyle(
                                                      color:
                                                          ThemeApp.darkGreyTab,
                                                      fontSize: height * .021,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Container(
                                        // height: height * 0.6,
                                        width: width,
                                        padding: const EdgeInsets.all(20),
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
                                            //     TextStyle(
                                            //         color: Colors.grey.shade700,
                                            //         fontSize: height * .023,
                                            //         fontWeight:
                                            //             FontWeight.bold)),
                                            cartProductList(cartOrderPurchase),
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
                                    TextStyle(
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
                                                TextStyle(
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
                                    priceDetails(cartOrderPurchase,
                                        cartForPaymentPayload),
                                  ],
                                ),
                              ),
                            ]),
                      );
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
                }))));
  }

  Widget cartProductList(List<CartOrdersForPurchase> cartOrderPurchase) {
    return cartOrderPurchase.length >= 0
        ? ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartOrderPurchase.length,
            itemBuilder: (BuildContext context, int index) {
              if (cartOrderPurchase!.length < 0) {
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Image.network(
                                  // width: double.infinity,
                                  // snapshot.data![index].serviceImage,
                                  cartOrderPurchase![index].imageUrl.toString(),
                                  fit: BoxFit.fill,
                                  // width: width*.18,
                                  height: height * .1,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFieldUtils().dynamicText(
                                        cartOrderPurchase![index]
                                            .itemName
                                            .toString(),
                                        context,
                                        TextStyle(

                                            color: ThemeApp.blackColor,
                                            fontSize: height * .02,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.25,

                                        )),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    prices(cartOrderPurchase, index),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        StringConstant().convertDateTimeDisplay(
                                            cartOrderPurchase![index]
                                                .deliveryDate
                                                .toString()),
                                        context,
                                        TextStyle(
                                          color: ThemeApp.lightFontColor,
                                          fontSize: height * .016,
                                          fontWeight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis,
                                        )),   SizedBox(
                                      height: height * .02,
                                    ),aadToCartCounter(cartOrderPurchase, index),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
            },  separatorBuilder: (context, index) {
      return Divider(color: ThemeApp.separatedLineColor,thickness: 1,);
    },)
        : const CircularProgressIndicator();
  }

  Widget prices(List<CartOrdersForPurchase> cartOrderPurchase, int index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFieldUtils().dynamicText(
              indianRupeesFormat.format(double.parse(
                  cartOrderPurchase![index].itemOfferPrice.toString())),
              context,
              TextStyle(
                color: ThemeApp.blackColor,
                fontSize: height * .026,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,

              )),
          SizedBox(
            width: width * .02,
          ),
          TextFieldUtils().dynamicText(
              indianRupeesFormat.format(double.parse(
                  cartOrderPurchase![index].itemMrpPrice.toString())),
              context,
              TextStyle(

                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,

                fontSize: height * .023,
                color: ThemeApp.lightFontColor,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 1.5,
              )),
          SizedBox(
            width: width * .01,
          ),
          TextFieldUtils().dynamicText(
              cartOrderPurchase![index]
                      .itemDiscountPercent
                      .toString()
                      .toString() +
                  " % Off",
              context,
              TextStyle(
                fontSize: height * .02,
                color: ThemeApp.blackColor,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                decorationThickness: 1.5,
              )),
        ],
      ),
    );
  }

  Widget aadToCartCounter(
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
      /*  InkWell(
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
        )*/
      ],
    );
  }

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
  Widget priceDetails(List<CartOrdersForPurchase> cartOrderPurchase,
      CartForPaymentPayload cartForPaymentPayload) {
    return /*Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [*/
      Container(
        // height: height * 0.25,
        width: width,
        decoration: const BoxDecoration(
          color: ThemeApp.whiteColor,
          borderRadius: BorderRadius.all( Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              15,15,15,15
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                  'Price Details',
                  style: TextStyle(
                      color: ThemeApp.primaryNavyBlackColor,
                      fontSize: height * .025,
                      fontWeight: FontWeight.w400)),
              SizedBox(height: height* .01,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Price',
                      style: TextStyle(
                          color: ThemeApp.lightFontColor,
                          fontSize: height * .019,
                          fontWeight: FontWeight.w400)),
                  // TextFieldUtils().homePageTitlesTextFields(
                  //     "Price (${payload.ordersForPurchase!.length.toString()} items)",
                  //     context),
                  Text(
                      indianRupeesFormat.format(double.parse(
                          cartForPaymentPayload.cart!.totalPayable
                              .toString())),   style: TextStyle(
                          color: ThemeApp.lightFontColor,
                          fontSize: height * .019,
                          fontWeight: FontWeight.w400)),
                  // TextFieldUtils().homePageTitlesTextFields(
                  //     indianRupeesFormat
                  //         .format(double.parse(payload.totalMrp.toString())),
                  //     context)
                ],
              ),                SizedBox(height: height* .01,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Discount',  style: TextStyle(
                      color: ThemeApp.lightFontColor,
                      fontSize: height * .019,
                      fontWeight: FontWeight.w400)),

                  Text(
                      "- ${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalDiscountAmount.toString()))}",
                      style: TextStyle(
                          color: ThemeApp.lightFontColor,
                          fontSize: height * .019,
                          fontWeight: FontWeight.w400)),
                  /*   TextFieldUtils()
                        .homePageTitlesTextFields("Discount", context),
                    TextFieldUtils().homePageTitlesTextFields(
                        "- ${indianRupeesFormat.format(double.parse(payload.totalDiscountAmount.toString()))}",
                        context),*/
                ],
              ),                SizedBox(height: height* .01,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Delivery charges',  style: TextStyle(
                      color: ThemeApp.lightFontColor,
                      fontSize: height * .019,
                      fontWeight: FontWeight.w400)),
                  Text(
                      indianRupeesFormat.format(double.parse(
                          cartForPaymentPayload.cart!.totalDeliveryCharges
                              .toString())),
                      style: TextStyle(
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
              ),                SizedBox(height: height* .01,),

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
              ),                SizedBox(height: height* .01,),

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
                    Text(
                        'Total Amount',  style: TextStyle(
                        color: ThemeApp.blackColor,
                        fontSize: height * .019,
                        fontWeight: FontWeight.w400)),
                    Text(
                        "${indianRupeesFormat.format(double.parse(cartForPaymentPayload.cart!.totalPayable.toString()))} ",
                        style: TextStyle(
                            color: ThemeApp.appColor,
                            fontSize: height * .025,
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
  }*//*
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
    return Container(
        height: height * .1,
        width: width,
        alignment: Alignment.center,
        color: ThemeApp.appBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
          ),
        ));
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, icon) {
      var circleColor = (i == 0 || i == 1 || _curStep > i + 1)
          ? ThemeApp.tealButtonColor
          : ThemeApp.appColor;
      var lineColor =
      (i == 0 || i == 1 || _curStep > i + 1) ? ThemeApp.tealButtonColor : ThemeApp.appColor;
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
            ? TextFieldUtils().dynamicText(
                text,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .018,
                    fontWeight: FontWeight.w400))
            : TextFieldUtils().dynamicText(
                text,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .018,
                    fontWeight: FontWeight.w400)),
      );
    });
    return list;
  }
}

final List<String> titles = [
  'Order Placed',
  'Payment',
  'Order Completed',
];
int _curStep = 1;

///////////////show bottom sheet

class ChangeAddressBottomSheet extends StatefulWidget {
  final CartForPaymentPayload? cartForPaymentPayload;

  ChangeAddressBottomSheet({required this.cartForPaymentPayload});

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
        context, widget.cartForPaymentPayload!.userId.toString());
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

              return TextFieldUtils().circularBar(context);
            case Status.ERROR:
              print("Api error");

              return Text(cartProvider.getAddress.message.toString());
            case Status.COMPLETED:
              print("Api calll");
              List<AddressPayload>? addressList =
                  cartProvider.getAddress.data!.payload!;

              print("addressList" + addressList!.length.toString());
              return Stack(
                alignment: Alignment.center, // <---------

                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFieldUtils().dynamicText(
                                      StringUtils.deliveryAddress,
                                      context,
                                      TextStyle(
                                          color: ThemeApp.blackColor,
                                          fontSize: height * .025,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddNewDeliveryAddress(
                                                    isSavedAddress: false,
                                                    cartForPaymentPayload: widget
                                                        .cartForPaymentPayload!),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10.0, 5, 10.0, 5),
                                        decoration: BoxDecoration(
                                          color: ThemeApp.appColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                                      color:
                                                          ThemeApp.whiteColor,
                                                      // fontWeight: FontWeight.w500,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
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
                                        TextStyle(
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
                            height: height * .02,
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
                                            addressList[index].name!;
                                            StringConstant.selectedFullAddress =
                                                "${addressList[index].addressLine1!}, ${addressList[index].addressLine2}, ${addressList[index].stateName},\n ${addressList[index].cityName}, ${addressList[index].pincode}";
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
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
                                                padding: const EdgeInsets.fromLTRB(10,10,20,20),
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
                                                        decoration: BoxDecoration(
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
                                                                onChanged:
                                                                    (int? value) {
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
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            height *
                                                                                .022,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400)),
                                                                SizedBox(
                                                                  width:
                                                                      width * .02,
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
                                                                      Radius
                                                                          .circular(
                                                                              5),
                                                                    ),
                                                                    color: ThemeApp
                                                                        .appColor,
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                          top: 5,
                                                                          bottom:
                                                                              5),
                                                                  child: TextFieldUtils().dynamicText(
                                                                      addressList[
                                                                              index]
                                                                          .addressType!,
                                                                      context,
                                                                      TextStyle(
                                                                          color: ThemeApp
                                                                              .whiteColor,
                                                                          fontSize:
                                                                              height *
                                                                                  .02,
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
                                                      child: TextFieldUtils()
                                                          .dynamicText(
                                                              "${addressList[index].addressLine1!}, ${addressList[index].addressLine2}, ${addressList[index].stateName},\n ${addressList[index].cityName}, ${addressList[index].pincode}",
                                                              context,
                                                              TextStyle(
                                                                  color: ThemeApp
                                                                      .blackColor,
                                                                  fontSize:
                                                                      height *
                                                                          .02,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
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
                                                            color:
                                                                ThemeApp.appColor,
                                                            semanticsLabel:
                                                                'Acme Logo',
                                                            theme: SvgTheme(
                                                              currentColor:
                                                                  ThemeApp
                                                                      .appColor,
                                                            ),
                                                            height: height * .025,
                                                          ),
                                                          SizedBox(
                                                            width: width * .03,
                                                          ),
                                                          TextFieldUtils().dynamicText(
                                                              "${StringConstant.selectedMobile}",
                                                              context,
                                                              TextStyle(
                                                                  color: ThemeApp
                                                                      .blackColor,
                                                                  fontSize:
                                                                      height *
                                                                          .021,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        ],
                                                      ),
                                                    ),SizedBox(height: height*.02,),
                                                    Row( crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                      InkWell(
                                                        onTap:(){ setState(() {
                                                          addressList.removeAt(index);
                                                        });},
                                                        child: SvgPicture.asset(
                                                          'assets/appImages/deleteIcon.svg',
                                                          color: ThemeApp.lightFontColor,
                                                          semanticsLabel: 'Acme Logo',
                                                          theme: SvgTheme(
                                                            currentColor: ThemeApp.appColor,
                                                          ),
                                                          height: height * .03,
                                                        ),
                                                      ),    SizedBox(
                                                        width: width * .03,
                                                      ),InkWell(

                                                          onTap:(){
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
                                                        child: SvgPicture.asset(
                                                          'assets/appImages/editIcon.svg',
                                                          color: ThemeApp.appColor,
                                                          semanticsLabel: 'Acme Logo',
                                                          theme: SvgTheme(
                                                            currentColor: ThemeApp.appColor,
                                                          ),
                                                          height: height * .03,
                                                        ),
                                                      ),
                                                    ],)
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
                                      color: ThemeApp.whiteColor,
                                      fontSize: height * .02,
                                      fontWeight: FontWeight.w400)),
                          Container(
                            alignment: FractionalOffset.bottomCenter,
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: proceedButton(StringUtils.deliverHere,
                                ThemeApp.blackColor, context, false, () {
                              setState(() {
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

                              Navigator.of(context)
                                  .pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => OrderReviewActivity(
                                        cartId: widget
                                            .cartForPaymentPayload!.cartId!,
                                      ),
                                    ),
                                  )
                                  .then((value) => setState(() {}));

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
    TextStyle(
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
    TextStyle(
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
    StringConstant
        .selectedFullAddress);
    });
    }),
    Row(
    children: [
    TextFieldUtils().dynamicText(
    value.addressList[index]
        .myAddressFullName!,
    context,
    TextStyle(
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
    TextStyle(
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
    TextStyle(
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
    TextStyle(
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
    TextStyle(
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
    TextStyle(
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
    TextStyle(
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
    TextStyle(
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
