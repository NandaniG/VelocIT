import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocit/pages/homePage.dart';
import 'package:velocit/services/providers/Home_Provider.dart';

import '../../../services/providers/Products_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Payment_Activities/OrderPlaced_activity.dart';
import '../Payment_Activities/payments_Activity.dart';
import 'AddNewDeliveryAddress.dart';

class OrderReviewSubActivity extends StatefulWidget {
  ProductProvider value;

   OrderReviewSubActivity({Key? key, required this.value}) : super(key: key);

  @override
  State<OrderReviewSubActivity> createState() => _OrderReviewSubActivityState();
}

TextEditingController promoCodeController = new TextEditingController();

class _OrderReviewSubActivityState extends State<OrderReviewSubActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
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
    StringConstant.addressFromCurrentLocation =
        'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India';
    getPreferences();
    print("widget.productList");
  }

  var address =
      'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India - 380021';

  getPreferences() async {
    //get address

    StringConstant.addressFromCurrentLocation =
        (await Prefs().getToken(StringConstant.addressPref))!;
    print('StringConstant.addressFromCurrentLocation${StringConstant.addressFromCurrentLocation}');
    //
    StringConstant.totalOriginalPrice =
        (await Prefs().getDoubleToken(StringConstant.totalOriginalPricePref))!;

    print('StringConstant.totalOriginalPrice${StringConstant.totalOriginalPrice}');

    StringConstant.totalFinalPrice =
        (await Prefs().getDoubleToken(StringConstant.totalFinalPricePref))!;

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
        context, appTitle(context, "Order Checkout"),'/cartScreen', const SizedBox()),
      ),
      bottomNavigationBar: BottomAppBar(
    color: ThemeApp.backgroundColor,
    elevation: 0,
    child: Consumer<HomeProvider>(builder: (context, value, child) {
      return Container(
        height: height * .08,
        width: width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: ThemeApp.darkGreyTab,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        ),
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldUtils().pricesLineThroughWhite(
                    " ${indianRupeesFormat.format(finalOriginalPrice)}",
                    context,
                    MediaQuery.of(context).size.height * .021,
                  ),
                  TextFieldUtils().homePageheadingTextFieldWHITE(
                    "${indianRupeesFormat.format(StringConstant.totalFinalPrice)}",
                    context,
                  ),
                ]),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Payment_Creditcard_debitcardScreen(orderReview:  value.orderCheckOutDetails),
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
    }),
      ),
      body: SafeArea(
        child: Consumer<HomeProvider>(builder: (context, provider, child) {
    return Container(
        color: ThemeApp.backgroundColor,
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFieldUtils().dynamicText(
                                    AppLocalizations.of(context)
                                        .deliveryDetails,
                                    context,
                                    TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: height * .023,
                                        fontWeight: FontWeight.bold)),
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
                                          context: context,
                                          builder: (context) {
                                            return ChangeAddressBottomSheet();
                                          });
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
                                          AppLocalizations.of(context)
                                              .changeAddress,
                                          context,
                                          TextStyle(
                                              color: ThemeApp.whiteColor,
                                              fontSize: height * .021,
                                              fontWeight: FontWeight.w500)),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .03,
                          ),
                          Row(
                            children: [
                              TextFieldUtils().dynamicText(
                                  provider.orderCheckOutDetails[0]["orderCheckOutFullName"],
                                  context,
                                  TextStyle(
                                      color: ThemeApp.blackColor,
                                      fontSize: height * .021,
                                      fontWeight: FontWeight.w500)),
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
                                    left: 10, right: 10, top: 5, bottom: 5),
                                child: TextFieldUtils().dynamicText(
                                    provider.orderCheckOutDetails[0]["orderCheckOutTypeOfAddress"],
                                    context,
                                    TextStyle(
                                        color: ThemeApp.whiteColor,
                                        fontSize: height * .02,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          TextFieldUtils().dynamicText(
                              provider.orderCheckOutDetails[0]["orderCheckOutDeliveryAddress"],
                              context,
                              TextStyle(
                                  color: ThemeApp.darkGreyTab,
                                  fontSize: height * .021,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: height * .02,
                          ),
                          Container(
                            width: width,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                                bottom: BorderSide(
                                    color: ThemeApp.darkGreyTab, width: 0.5),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          Row(
                            children: [
                              TextFieldUtils().dynamicText(
                                  '${AppLocalizations.of(context).contactNumber} : ',
                                  context,
                                  TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: height * .022,
                                      fontWeight: FontWeight.w500)),
                              TextFieldUtils().dynamicText(
                                  provider.orderCheckOutDetails[0]["orderCheckOutContactNumber"],
                                  context,
                                  TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: height * .022,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldUtils().dynamicText(
                                AppLocalizations.of(context).orderSummary,
                                context,
                                TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: height * .023,
                                    fontWeight: FontWeight.bold)),
                            cartProductList(widget.value),
                          ],
                        )),
                    SizedBox(
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
                                AppLocalizations.of(context).applyPromoCode,
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
                                            AppLocalizations.of(context)
                                                .apply,
                                            context,
                                            TextStyle(
                                                color: ThemeApp.whiteColor,
                                                fontSize: height * .021,
                                                fontWeight: FontWeight.w500)),
                                      )),
                                ),
                              ],
                            )
                          ]),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    priceDetails(widget.value),
                  ],
                ),
              ),
            ]),
    );
        }),
      ),
    );
  }

  Widget cartProductList(ProductProvider value) {
    return value.cartList.length >= 0
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: value.cartList.length,
            itemBuilder: (BuildContext context, int index) {
              if (value.cartList.length < 0) {
                return Center(
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
                      decoration: BoxDecoration(
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
                                    BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  // width: double.infinity,
                                  // snapshot.data![index].serviceImage,
                                  value.cartList[index].cartProductsImage
                                      .toString(),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    TextFieldUtils().dynamicText(
                                        value.cartList[index]
                                            .cartProductsDescription
                                            .toString(),
                                        context,
                                        TextStyle(
                                            color: ThemeApp.blackColor,
                                            fontSize: height * .023,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    prices(value, index),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        value.cartList[index].cartProductsDeliveredBy
                                            .toString(),
                                        context,
                                        TextStyle(
                                          color: ThemeApp.darkGreyTab,
                                          fontSize: height * .016,
                                          fontWeight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis,
                                        )),
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
                  ],
                );
              }
            })
        : CircularProgressIndicator();
  }

  Widget prices(ProductProvider value, int index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFieldUtils().dynamicText(
              "${indianRupeesFormat.format(int.parse(value.cartList[index].cartProductsDiscountPrice.toString()))}",
              context,
              TextStyle(
                color: ThemeApp.blackColor,
                fontSize: height * .023,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              )),
          SizedBox(
            width: width * .02,
          ),
          TextFieldUtils().dynamicText(
              indianRupeesFormat.format(
                  int.parse(value.cartList[index].cartProductsOriginalPrice.toString())),
              context,
              TextStyle(
                fontSize: height * .023,
                color: ThemeApp.darkGreyTab,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 1.5,
              )),
          SizedBox(
            width: width * .01,
          ),
          TextFieldUtils().dynamicText(
              value.cartList[index].cartProductsOfferPercent.toString(),
              context,
              TextStyle(
                fontSize: height * .02,
                color: ThemeApp.darkGreyTab,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              )),
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
                      value.cartList[index].cartProductsTempCounter.toString(),
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
              setState(() {

              });
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

  void addQuantity(ProductProvider value, int index) {
    print("maxCounter counter ${value.cartList[index].cartProductsMaxCounter}");
    print("temp counter 1 ${value.cartList[index].cartProductsTempCounter}");
    if (int.parse(value.cartList[index].cartProductsTempCounter.toString()) <
        int.parse(value.cartList[index].cartProductsMaxCounter.toString())) {
      value.cartList[index].cartProductsTempCounter =
          int.parse(value.cartList[index].cartProductsTempCounter.toString()) + 1;
      print("temp counter 2 ${value.cartList[index].cartProductsTempCounter}");

      finalPrices(value, index);
    }
  }

  double finalOriginalPrice = 0.0;
  double finalDiscountPrice = 0.0;
  double finalDiffrenceDiscountPrice = 0.0;
  double finalTotalPrice = 0.0;

  Future<void> finalPrices(ProductProvider value, int index) async {
    finalOriginalPrice = 0.0;
    finalDiscountPrice = 0.0;
    finalDiffrenceDiscountPrice = 0.0;
    finalTotalPrice = 0.0;

    for (int i = 0; i < value.cartList.length; i++) {
      finalOriginalPrice = finalOriginalPrice +
          (int.parse(value.cartList[i].cartProductsTempCounter.toString()) *
              double.parse(value.cartList[i].cartProductsOriginalPrice.toString()));

      Prefs().setDoubleToken(
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
          (await Prefs().getDoubleToken(StringConstant.totalFinalPricePref))!;

      StringConstant.totalFinalPrice = value.deliveryAmount +
          (finalOriginalPrice - finalDiffrenceDiscountPrice);

      print("grandTotalAmount inside add: $i $finalTotalPrice");
    }
  }

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

  Widget stepperWidget() {
    return Container(
        height: height * .1,
        width: width,
        alignment: Alignment.center,
        color: ThemeApp.whiteColor,
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
          ? ThemeApp.darkGreyTab
          : ThemeApp.lightGreyTab;
      var lineColor =
          _curStep > i + 1 ? ThemeApp.darkGreyTab : ThemeApp.lightGreyTab;
      var iconColor = (i == 0 || i == 1 || _curStep > i + 1)
          ? ThemeApp.darkGreyTab
          : ThemeApp.lightGreyTab;

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
                    color: ThemeApp.darkGreyTab,
                    fontSize: height * .018,
                    fontWeight: FontWeight.bold))
            : TextFieldUtils().dynamicText(
                text,
                context,
                TextStyle(
                    color: ThemeApp.darkGreyTab,
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(body: SafeArea(child: deliveryAddress()));
  }

  int _selectedIndex = 0;
  int _value2 = 0;

  Widget deliveryAddress() {
    return Consumer<ProductProvider>(builder: (context, value, child) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: TextFieldUtils().dynamicText(
                    AppLocalizations.of(context).deliveryAddress,
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
                      builder: (context) => AddNewDeliveryAddress(isSavedAddress: false,),
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
                            AppLocalizations.of(context).addNewAddress,
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
                            var fullAddress =
                                "${value.addressList[index].myAddressHouseNoBuildingName!}, ${value.addressList[index].myAddressAreaColony}, ${value.addressList[index].myAddressCity},\n ${value.addressList[index].myAddressState}";
                            return InkWell(
                              onLongPress: () {
                                setState(() {
                                  value.addressList.removeAt(index);
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(20, 0, 20, 0),

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
                                                  print("Radio index is  $value");
                                                });
                                              }),
                                          Row(
                                            children: [
                                              TextFieldUtils().dynamicText(
                                                  value.addressList[index].myAddressFullName!,
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
                                                    value.addressList[index]
                                                        .myAddressTypeOfAddress!,
                                                    context,
                                                    TextStyle(
                                                        color: ThemeApp.whiteColor,
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
                                    padding:
                                        const EdgeInsets.only(left: 70, right: 20),
                                    child: TextFieldUtils().dynamicText(
                                        fullAddress,
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
                                        "${'${AppLocalizations.of(context).contactNumber} : ' + value.addressList[index].myAddressPhoneNumber!}",
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
                                        'Test Name',
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
                                          left: 10, right: 10, top: 5, bottom: 5),
                                      child: TextFieldUtils().dynamicText(
                                          'Home',
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
                              address,
                              context,
                              TextStyle(
                                  color: ThemeApp.darkGreyTab,
                                  fontSize: height * .021,
                                  fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 70, right: 20, top: 10),
                          child: TextFieldUtils().dynamicText(
                              "${'${AppLocalizations.of(context).contactNumber} : '}9857436255",
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
                child: proceedButton(AppLocalizations.of(context).deliverHere,
                    ThemeApp.blackColor, context, () {}),
              )
            ],
          ),
        ],
      );
    });
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
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: EdgeInsets.symmetric(
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
          margin: EdgeInsets.symmetric(horizontal: 20),
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
                  icon: Icon(Icons.send))
            ],
          ),
        )
      ],
    );
  }
}
