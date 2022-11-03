import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/models/CartModel.dart';
import '../../../services/models/ProductDetailModel.dart';
import '../../../services/models/demoModel.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../services/providers/cart_Provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';

import '../../screens/dashBoard.dart';
import '../../screens/cartDetail_Activity.dart';

class ProductDetailsActivity extends StatefulWidget {
  ProductDetailsModel model;
  ProductProvider value;

  ProductDetailsActivity({Key? key, required this.model, required this.value})
      : super(key: key);

  @override
  State<ProductDetailsActivity> createState() => _ProductDetailsActivityState();
}

class _ProductDetailsActivityState extends State<ProductDetailsActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

  late List<CartModel> cartList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    remainingCounters();
  }

  remainingCounters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      StringConstant.availableCounterValues =
          (int.parse(widget.model.maxCounter) - counterPrice);
      print("totalCounterValues${StringConstant.availableCounterValues}");
      print("totalCounterValues${counterPrice}");
    });

    prefs.setInt(StringConstant.availableCounter, 1);
  }

  // late List<ProductDetailsModel> productList;
  //
  // void addDataCart() {
  //   Provider.of<ProductProvider>(context, listen: false).addCardManager(
  //       widget.model.serviceImage,
  //       widget.model.serviceName,
  //       widget.model.sellerName,
  //       widget.model.ratting,
  //       widget.model.discountPrice,
  //       widget.model.originalPrice,
  //       widget.model.offerPercent,
  //       widget.model.availableVariants,
  //       widget.model.cartProductsLength,
  //       widget.model.serviceDescription,
  //       widget.model.conterProducts);
  // }
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    final cartList = Provider.of<CartProvider>(context);

    // return Consumer<ProductProvider>(builder: (context, product, _) {
    return Scaffold(
      backgroundColor: ThemeApp.whiteColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(
          context,
          appTitle(context, "My Product"),SizedBox(),
        ),
      ),
      body: SafeArea(
        child: Container(
        height: MediaQuery.of(context).size.height,
        // padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productImage(),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: TextFieldUtils().homePageheadingTextField(
                    widget.model.serviceDescription, context),
              ),
              SizedBox(
                height: height * .01,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: TextFieldUtils().homePageTitlesTextFields(
                    widget.model.sellerName, context),
              ),
              SizedBox(
                height: height * .01,
              ),
              rattingBar(),
              SizedBox(
                height: height * .01,
              ),
              prices(),
              SizedBox(
                height: height * .01,
              ),
              availableVariant(),
              SizedBox(
                height: height * .01,
              ),
              addToCart(),
              SizedBox(
                height: height * .03,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: TextFieldUtils()
                    .listHeadingTextField("Similar Products", context),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              similarProductList()
            ],
          ),
        )),
      ),
    );
    // });
  }

  Widget productImage() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            color: ThemeApp.whiteColor,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset(
                // width: double.infinity,
                widget.model.serviceImage,
                fit: BoxFit.fill,
                width: width,
                height: height * .28,
              ),
            ),
          ),
          variantImages(),
        ],
      ),
    );
  }

  Widget rattingBar() {
    return Container(
      width: width * .7,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          RatingBar.builder(
            itemSize: height * .03,
            initialRating: widget.model.ratting,
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
          TextFieldUtils()
              .subHeadingTextFields('${widget.model.ratting} Reviews', context),
        ],
      ),
    );
  }

  Widget prices() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFieldUtils().textFieldHeightFour(
              "${indianRupeesFormat.format(int.parse(widget.model.discountPrice.toString()))}",
              context),
          SizedBox(
            width: width * .02,
          ),
          TextFieldUtils().pricesLineThrough(
              indianRupeesFormat.format(int.parse(widget.model.originalPrice)),
              context),
          SizedBox(
            width: width * .02,
          ),
          TextFieldUtils()
              .textFieldTwoFiveGrey(widget.model.offerPercent, context),
        ],
      ),
    );
  }

  Widget availableVariant() {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1),
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldUtils()
                .homePageTitlesTextFields("Available variants", context),
            variantImages()
          ],
        ),
      ),
    );
  }

  Widget variantImages() {
    return FutureBuilder<List<Payload>>(
        future: getImageSlide(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height: height * .08,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                // width: width * 0.24,
                                decoration: BoxDecoration(
                                    color: ThemeApp.greenappcolor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  child: Image.asset(
                                    // width: double.infinity,
                                    snapshot.data![index].sponsorlogo,
                                    fit: BoxFit.fill,
                                    height: MediaQuery.of(context).size.height *
                                        .05,
                                    width: width * .1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .01,
                            )
                          ],
                        );
                      }),
                )
              : CircularProgressIndicator();
        });
  }

  int counterPrice = 0;

  Widget addToCart() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: /*counterPrice < int.parse(widget.model.maxCounter)
          ?*/
            Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            counterPrice == 0
                ? Expanded(
                    flex: 1,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            counterPrice++;
                            remainingCounters();
                          });
                        },
                        child: Container(
                            height: height * 0.06,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: ThemeApp.lightGreyTab,
                            ),
                            child: TextFieldUtils().usingPassTextFields(
                                "Add to cart",
                                ThemeApp.blackColor,
                                context))),
                  )
                : Expanded(
                    flex: 1,
                    child: Container(
                      height: height * 0.06,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: ThemeApp.lightGreyTab,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  counterPrice--;
                                  remainingCounters();
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
                                counterPrice.toString().padLeft(2, '0'),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            .016,
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (counterPrice <
                                      int.parse(widget.model.maxCounter)) {
                                    counterPrice++;
                                    remainingCounters();
                                  }

                                  // totalConter = counterPrice * item.price;
                                  // counterPrice == 1
                                  //     ? totalConter = item.price
                                  //     : totalConter;
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
            SizedBox(
              width: MediaQuery.of(context).size.width * .05,
            ),
            Consumer<ProductProvider>(builder: (context, value, child) {
              return Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    widget.model.tempCounter = counterPrice;
                    print("_________widget.model.tempCounter_" +
                        widget.model.tempCounter.toString());
                    final navigator = Navigator.of(context); // <- Add this

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    var contain = value.cartList.where((element) =>
                        element.serviceDescription ==
                        widget.model.serviceDescription);
                    if (value.cartList.length >= 0) {
                      if (contain.isNotEmpty) {
                        print("-------------I got Values_________" +
                            widget.model.serviceDescription.toString());
                        navigator
                            .push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CartDetailsActivity(widget.model,
                                        value: value)))
                            .then((value) => setState(() {}));
                        print("_________widget.model.tempCounter_1111111" +
                            widget.model.tempCounter.toString());
                      } else {
                        print("-------------I do not have any Values_________");

                        navigator
                            .push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CartDetailsActivity(widget.model,
                                        value: value)))
                            .then((value) => setState(() {}));
                        print(
                            "-------------Cart Length before ADD in product details_________${value.cartList.length}");

                        value.add(
                          widget.model.serviceImage,
                          widget.model.serviceName,
                          widget.model.sellerName,
                          widget.model.ratting,
                          widget.model.discountPrice,
                          widget.model.originalPrice,
                          widget.model.offerPercent,
                          widget.model.availableVariants,
                          widget.model.cartProductsLength,
                          widget.model.serviceDescription,
                          widget.model.maxCounter,
                          widget.model.deliveredBy,
                          widget.model.tempCounter == 0
                              ? widget.model.tempCounter = 1
                              : widget.model.tempCounter,
                        );
                        print("_________widget.model.tempCounter_22222222222" +
                            widget.model.tempCounter.toString());
                        print(
                            "-------------Cart Length after ADD in product details_________${value.cartList.length}");
                      }
                    } else {
                      print("-------------List is empty_________");
                      print(
                          "-------------Cart Length before ADD in product details_________${value.cartList.length}");

                      value.add(
                        widget.model.serviceImage,
                        widget.model.serviceName,
                        widget.model.sellerName,
                        widget.model.ratting,
                        widget.model.discountPrice,
                        widget.model.originalPrice,
                        widget.model.offerPercent,
                        widget.model.availableVariants,
                        widget.model.cartProductsLength,
                        widget.model.serviceDescription,
                        widget.model.maxCounter,
                        widget.model.deliveredBy,
                        widget.model.tempCounter == 0
                            ? widget.model.tempCounter = 1
                            : widget.model.tempCounter,
                      );
                      print("_________widget.model.tempCounter_333333333" +
                          widget.model.tempCounter.toString());
                      print(
                          "-------------Cart Length after ADD in product details_________${value.cartList.length}");

                      // if(value.lst.length>=0) {
                      navigator
                          .push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CartDetailsActivity(widget.model,
                                      value: value)))
                          .then((value) => setState(() {}));
                      // }
                    }
                  },
                  child: Container(
                      height: height * 0.06,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: ThemeApp.blackColor,
                      ),
                      child: TextFieldUtils().usingPassTextFields(
                          "Buy now", ThemeApp.whiteColor, context)),
                ),
              );
            })
          ],
        )
        // : TextFieldUtils().textFieldHeightFour("OUT OF STOCK", context),
        );
  }

  Widget similarProductList() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: FutureBuilder<List<BookServiceModel>>(
          future: getSimmilarProductLists(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? Container(
                    height: MediaQuery.of(context).size.height * .35,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Container(
                                  // height: MediaQuery.of(context).size.height * .3,

                                  // width: 200,
                                  width:
                                      MediaQuery.of(context).size.width * .42,
                                  decoration: BoxDecoration(
                                      color: ThemeApp.whiteColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .26,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .45,
                                        decoration: BoxDecoration(
                                            color:
                                                ThemeApp.textFieldBorderColor,
                                            borderRadius:
                                                const BorderRadius.only(
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
                                            snapshot.data![index].serviceImage,
                                            fit: BoxFit.fill,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .07,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .01,
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 18),
                                        child: TextFieldUtils()
                                            .homePageTitlesTextFields(
                                                snapshot.data![index]
                                                    .serviceDescription,
                                                context),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .01,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18),
                                        child: Row(
                                          children: [
                                            TextFieldUtils()
                                                .homePageheadingTextField(
                                                    "${indianRupeesFormat.format(9030)}",
                                                    context),
                                            // SizedBox(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width *
                                            //       .02,
                                            // ),
                                            TextFieldUtils()
                                                .homePageheadingTextFieldLineThrough(
                                                    "${indianRupeesFormat.format(9030)}",
                                                    context),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .03,
                              )
                            ],
                          );
                        }),
                  )
                : new Center(child: new CircularProgressIndicator());
          }),
    );
  }

  getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    StringConstant.serviceImageGetValues =
        prefs.getString(StringConstant.serviceImage).toString();
    StringConstant.serviceNameGetValues =
        prefs.getString(StringConstant.serviceName).toString();
    StringConstant.sellerNameGetValues =
        prefs.getString(StringConstant.sellerName).toString();
    StringConstant.rattingGetValues =
        prefs.getString(StringConstant.ratting).toString();
    StringConstant.discountPriceGetValues =
        prefs.getString(StringConstant.discountPrice).toString();
    StringConstant.originalPriceGetValues =
        prefs.getString(StringConstant.originalPrice).toString();
    StringConstant.offerPercentGetValues =
        prefs.getString(StringConstant.offerPercent).toString();
    StringConstant.availableVariantsGetValues =
        prefs.getString(StringConstant.availableVariants).toString();
    StringConstant.cartProductsLengthGetValues =
        prefs.getString(StringConstant.cartProductsLength).toString();
    StringConstant.serviceDescriptionGetValues =
        prefs.getString(StringConstant.serviceDescription).toString();
    StringConstant.conterProductsGetValues =
        prefs.getString(StringConstant.conterProducts).toString();
    StringConstant.deliveredByGetValues =
        prefs.getString(StringConstant.deliveredBy).toString();
    StringConstant.availableCounterValues =
        prefs.getInt(StringConstant.availableCounter)!;
  }

  Future<List<BookServiceModel>> getSimmilarProductLists() async {
    String response = '['
        '{"serviceImage":"assets/images/laptopImage.jpg","serviceName":"Appliances","serviceDescription":"Motorola ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
        '{"serviceImage":"assets/images/iphones_Image.jpg","serviceName":"Electronics","serviceDescription":"Samsang ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
        '{"serviceImage":"assets/images/laptopImage2.jpg","serviceName":"Fashion","serviceDescription":"One Plus ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
        '{"serviceImage":"assets/images/laptopImage.jpg","serviceName":"Home","serviceDescription":"IPhone ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"}]';
    var serviceList = bookServiceFromJson(response);
    return serviceList;
  }

  Future<List<Payload>> getImageSlide() async {
    //final response = await http.get("getdata.php");
    //return json.decode(response.body);
    String response = '['
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"},'
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"},'
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"},'
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"}]';
    var payloadList = payloadFromJson(response);
    return payloadList;
  }
}
