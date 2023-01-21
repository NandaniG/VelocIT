import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/pages/screens/dashBoard.dart';
import 'package:velocit/utils/utils.dart';

import '../../../../Core/Model/ServiceModels/SingleServiceModel.dart';
import '../../../../Core/Model/SimmilarProductModel.dart';

import '../../../../Core/ViewModel/cart_view_model.dart';
import '../../../../Core/ViewModel/dashboard_view_model.dart';
import '../../../../Core/ViewModel/product_listing_view_model.dart';
import '../../../../Core/data/responses/status.dart';
import '../../../../Core/repository/cart_repository.dart';
import '../../../../services/models/JsonModelForApp/HomeModel.dart';
import '../../../../services/models/demoModel.dart';
import '../../../../services/providers/Home_Provider.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/ProgressIndicatorLoader.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/routes/routes.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/textFormFields.dart';
import '../CRM_ui/CRM_Activity.dart';


class ServiceDetailsActivity extends StatefulWidget {
  // List<ProductList>? productList;
  // Content? productList;
  final int? id;

  ServiceDetailsActivity(
      {Key? key,
      // required this.productList,
      required this.id})
      : super(key: key);

  @override
  State<ServiceDetailsActivity> createState() => _ServiceDetailsActivityState();
}

class _ServiceDetailsActivityState extends State<ServiceDetailsActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  int imageVariantIndex = 0;
  late List<CartProductList> cartList;
  int counterPrice = 1;
  DashboardViewModel productListView = DashboardViewModel();

  int badgeData = 0;
  String sellerAvailable = "";
  Random random = new Random();
  int randomNumber = 0;

  int userId = 0;

  ProductSpecificListViewModel productSpecificListViewModel =
      ProductSpecificListViewModel();
  late Map<String, dynamic> data = new Map<String, dynamic>();

  List<SingleModelMerchants> merchantTemp = [];

  @override
  void initState() {
    imageVariantIndex;
    // TODO: implement initState
    super.initState();
    randomNumber = random.nextInt(100);
    productSpecificListViewModel.serviceSingleIDListWithGet(
        context, widget.id.toString());
    print("Random number : " + data.toString());
    print("widget.id! number : " + widget.id!.toString());
    print("Badge,........" + StringConstant.BadgeCounterValue);
    getBadgePref();
    productListView.similarProductWithGet(0, 10, 10);
  }

  CartViewModel cartListView = CartViewModel();

  getBadgePref() async {
    setState(() {});
    final prefs = await SharedPreferences.getInstance();
    StringConstant.BadgeCounterValue =
        (prefs.getString('setBadgeCountPrefs')) ?? '';
  }

// update cart list
  updateCart(
    var merchantId,
    int quantity,
    ProductProvider productProvider,
    List<SingleProductsubCategory>? productsubCategory,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var userId = '';

    StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
    StringConstant.RandomUserLoginId = (prefs.getString('RandomUserId')) ?? '';

    StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
    print("Cart Id From Detail Activity " + StringConstant.UserCartID);
    var prefUserId = await Prefs.instance.getToken(
      Prefs.prefRandomUserId,
    );
    print("cartId from Pref" + StringConstant.UserCartID.toString());
    print("prefUserId from Pref" + prefUserId.toString());

    if (StringConstant.UserLoginId.toString() == '' ||
        StringConstant.UserLoginId.toString() == null) {
      userId = StringConstant.RandomUserLoginId;
      print('login user is GUEST');
    } else {
      userId = StringConstant.UserLoginId;
      print('login user is not GUEST');
    }
    Map<String, String> data = {
      // "cartId": StringConstant.UserCartID.toString(),
      "cartId": StringConstant.UserCartID.toString(),
      "userId": userId,
      "serviceId": widget.id.toString(),
      "merchantId": merchantId.toString(),
      "qty": quantity.toString(),
      "is_new_order": 'true'
    };
    print("update cart DATA" + data.toString());
    setState(() {});
    CartRepository().updateCartPostRequest(data, context).then((value) {
      setState(() {
        Utils.successToast('Added Successfully!');
      });
      StringConstant.BadgeCounterValue =
          (prefs.getString('setBadgeCountPrefs')) ?? '';
    });

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

    setState(() {
      // prefs.setString(
      //   'setBadgeCountPref',
      //   quantity.toString(),
      // );
      StringConstant.BadgeCounterValue =
          (prefs.getString('setBadgeCountPrefs')) ?? '';
      print("Badge,........" + StringConstant.BadgeCounterValue);
    });
  }

  remainingCounters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      StringConstant.availableCounterValues = (10 - counterPrice);
      print("totalCounterValues${StringConstant.availableCounterValues}");
      print("totalCounterValues${counterPrice}");
    });

    prefs.setInt(StringConstant.availableCounter, 1);
  }

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

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(context, appTitle(context, "My Service"),
            const SizedBox(), setState),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context,0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            // padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: ChangeNotifierProvider<ProductSpecificListViewModel>.value(
                value: productSpecificListViewModel,
                child: Consumer<ProductSpecificListViewModel>(
                    builder: (context, productSubCategoryProvider, child) {
                  switch (productSubCategoryProvider
                      .singleServiceSpecificList.status) {
                    case Status.LOADING:
                      print("Api load");

                      return TextFieldUtils().circularBar(context);
                    case Status.ERROR:
                      print("Api error");

                      return Text(productSubCategoryProvider
                          .singleServiceSpecificList.message.toString());
                    case Status.COMPLETED:
                      print("Api calll");
                      SingleProductPayload? model = productSubCategoryProvider
                          .singleServiceSpecificList.data!.payload;

                      List<SingleModelMerchants>? merchants =
                          productSubCategoryProvider.singleServiceSpecificList
                              .data!.payload!.merchants;

                      merchantTemp = [];
                      //adding selected merchants
                      for (int i = 0; i < merchants.length; i++) {
                        if (merchants[i].id ==
                            productSubCategoryProvider.singleServiceSpecificList
                                .data!.payload!.selectedMerchantId) {
                          merchantTemp.add(merchants[i]);
                        }
                      }
                      //adding remaining merchant list
                      for (int i = 0; i < merchants.length; i++) {
                        if (merchants[i].id !=
                            productSubCategoryProvider.singleServiceSpecificList
                                .data!.payload!.selectedMerchantId) {
                          merchantTemp.add(merchants[i]);
                        }
                      }
                      for (int i = 0; i < merchantTemp.length; i++) {
                        // print("merchantTemp id"+merchantTemp[i].id.toString());
                        // print("merchantTemp merchantName"+merchantTemp[i].merchantName.toString());

                      }
// print("merchants length"+productSubCategoryProvider
//     .singleproductSpecificList.data!.payload!.merchants.length.toString());
// print("merchants selected index"+productSubCategoryProvider
//         .singleproductSpecificList.data!.payload!.selectedMerchantId.toString());

                      if (widget.id == model!.id) {
                        return ListView(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                productImage(model),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: TextFieldUtils().headingTextField(
                                      model.shortName!, context),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                rattingBar(model),
                                SizedBox(
                                  height: 10,
                                ),
                                prices(model),
                                SizedBox(
                                  height: height * .01,
                                ),
                                merchantDetails(model),
                                // Text("Merchant  "+model.merchants![0].merchantName.toString() ),
                                /*    model.merchants!.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: TextFieldUtils()
                                            .homePageTitlesTextFields(
                                                model!.merchants![0]
                                                    .merchantName!,
                                                context),
                                      )
                                    : SizedBox(),
                                model!.merchants!.isNotEmpty
                                    ? SizedBox(
                                        height: height * .01,
                                      )
                                    : SizedBox(),
*/
                                // prices(model),
                                /* SizedBox(
                                  height: height * .01,
                                ),*/
                                model.productVariants.isNotEmpty
                                    ? availableVariant(model)
                                    : SizedBox(),
                                model.productVariants.isNotEmpty
                                    ? SizedBox(
                                        height: height * .01,
                                      )
                                    : SizedBox(),
                                productDescription(model),
                                SizedBox(
                                  height: height * .01,
                                ),
                                counterWidget(model),


                                //similar product

                                // SizedBox(
                                //   height: height * .03,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //     left: 20,
                                //     right: 20,
                                //   ),
                                //   child: TextFieldUtils().headingTextField(
                                //       'Similar Products', context),
                                // ),
                                // SizedBox(
                                //   height:
                                //       MediaQuery.of(context).size.height * .02,
                                // ),
                                // similarProductList()
                              ],
                            ) ??
                            SizedBox();
                      } else {
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
                }))),
      ),
    );
  }
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
  int _radioValue = 0;

  Widget productImage(SingleProductPayload? model) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: height * .28,
            child: CarouselSlider(
                  carouselController: _carouselController,
                  items: model!.imageUrls!.map<Widget>((e) {
                        return Stack(
                          children: [
                            Container(
                              height: height * .28,
                              child: Card(
                                    margin: EdgeInsets.zero,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    color: ThemeApp.whiteColor,
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Container(
                                              width: width,
                                              color: Colors.white,
                                              child: InstaImageViewer(
                                                child: Image.network(
                                                        e.imageUrl ?? "",
                                                        // fit: BoxFit.fill,
                                                        errorBuilder: ((context,
                                                            error, stackTrace) {
                                                      return Icon(
                                                          Icons.image_outlined);
                                                    })) ??
                                                    SizedBox(),
                                              ),
                                            ) ??
                                            SizedBox()),
                                  ) ??
                                  SizedBox(),
                            ),
                          ],
                        );
                      }).toList() ??
                      [],
                  options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        index = _currentIndex;

                        // _currentIndex = index;
                        setState(() {});
                      },
                      autoPlay:model.imageUrls!.length>1? true:false,
                      viewportFraction: 1,
                      height: height * .3),
                ) ??
                SizedBox(),
          ),

          // Card(
          //   shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(10)),
          //   ),
          //   color: ThemeApp.whiteColor,
          //   child: ClipRRect(
          //     borderRadius: const BorderRadius.all(Radius.circular(10)),
          //     child: model!.imageUrls![0].imageUrl!.isNotEmpty
          //         ? Image.network(
          //               // width: double.infinity,
          //               model!.imageUrls![imageVariantIndex].imageUrl! ?? '',
          //               fit: BoxFit.fill,
          //               width: width,
          //               height: height * .28,
          //             ) ??
          //             SizedBox()
          //         : SizedBox(
          //             height: height * .28,
          //             width: width,
          //             child: Icon(
          //               Icons.image_outlined,
          //               size: 50,
          //             )),
          //   ),
          // ),
          variantImages(model),
        ],
      ),
    );
  }

  Widget rattingBar(SingleProductPayload model) {
    return Container(
        width: width * .7,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: rattingBarWidget(model, 5, width * .7, 4.5));
  }

  Widget rattingBarWidget(
      SingleProductPayload model, int count, double width, double ratingValue) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.34,
      // padding: const EdgeInsets.only(
      //   left: 20,
      //   right: 20,
      // ),
      child: Row(
        children: [
          RatingBar.builder(
            itemSize: height * .03,
            // initialRating: double.parse(widget.productList["productRatting"]),
            initialRating: ratingValue,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: count,
            itemPadding: const EdgeInsets.symmetric(horizontal: 0.5),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
        ],
      ),
    );
  }

  bool isMerchantfive = false;

  Widget merchantDetails(SingleProductPayload model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: isMerchantfive == false && merchantTemp.length < 5
                ? merchantTemp.length
                : isMerchantfive == true
                    ? merchantTemp.length
                    : 5,
            // itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                    // height: height*.02,
                    padding: const EdgeInsets.only(left: 14, right: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: width * .08,
                              child: Radio(
                                activeColor: ThemeApp.appColor,
                                value: index,

// contentPadding: EdgeInsets.zero,
//                   dense: true,
                                // visualDensity: const VisualDensity(horizontal: -4.0),
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                groupValue: _radioValue,
                                onChanged: (value) async {
                                  setState(() {
                                    _radioValue = 0;
                                    print("radio value " +
                                        _radioValue.toString());
                                    // _radioValue = index;
                                    print("before change" +
                                        model.selectedMerchantId.toString());
                                    model.selectedMerchantId =
                                        merchantTemp[index].id;
                                    print("after change" +
                                        model.selectedMerchantId.toString());
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text(
                                      merchantTemp[index].merchantName ?? "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: ThemeApp.blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)) ??
                                  SizedBox(),
                            ),
                          ],
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width * .08,
                            ),
                            Text(
                                merchantTemp[index].deliveryDays.toString() +
                                    " Day(s)",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.darkGreyColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                            Container(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                height: height * .02,
                                child: TextFieldUtils().lineVertical()),
                            merchantTemp[index].unitOfferPrice != null
                                ? Text(
                                    indianRupeesFormat.format(double.parse(
                                            merchantTemp[index]
                                                .unitOfferPrice
                                                .toString()) ??
                                        0.0),
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: ThemeApp.darkGreyColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))
                                : Text('0.0',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color: ThemeApp.darkGreyColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                            SizedBox(
                              width: width * .02,
                            ),
                            /*   model.merchants![index].unitMrp!=null?  Text(
                                indianRupeesFormat.format(
                                    double.parse(model.merchants![index].unitMrp.toString()) ??
                                        0.0)??'0.0',
                                style: TextStyle(fontFamily: 'Roboto',
                                    decoration: TextDecoration.lineThrough,
                                    color: ThemeApp.darkGreyColor,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            .02,
                                    fontWeight: FontWeight.w400)):Text(
                                indianRupeesFormat.format(
                                    double.parse(model.merchants![index].unitMrp.toString()) ??
                                        0.0)??'0.0',
                                style: TextStyle(fontFamily: 'Roboto',
                                    decoration: TextDecoration.lineThrough,
                                    color: ThemeApp.darkGreyColor,
                                    fontSize:
                                    MediaQuery.of(context).size.height *
                                        .02,
                                    fontWeight: FontWeight.w400)),*/
                            Container(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                height: height * .02,
                                child: TextFieldUtils().lineVertical()),
                            Text(
                                merchantTemp[index]
                                        .unitDiscountPerc
                                        .toString() +
                                    "% Off",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.darkGreyColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                            Container(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                height: height * .02,
                                child: TextFieldUtils().lineVertical()),
                            Flexible(
                                child: rattingBarWidget(
                                    model,
                                    5,
                                    width * .3,
                                    merchantTemp[index]
                                        .merchantRating!
                                        .toDouble()))
                          ],
                        ),
                      ],
                    ),
                  ) ??
                  SizedBox();
            }),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          decoration: BoxDecoration(),
          child: merchantTemp.length > 5 && isMerchantfive == false
              ? InkWell(
                  onTap: () {
                    setState(() {
                      isMerchantfive = !isMerchantfive;
                    });
                  },
                  child: TextFieldUtils().dynamicText(
                      'View more',
                      context,
                      TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.tealButtonColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 3,
                      )),
                )
              : Container(),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          child: isMerchantfive == true
              ? InkWell(
                  onTap: () {
                    setState(() {
                      isMerchantfive = !isMerchantfive;
                    });
                  },
                  child: TextFieldUtils().dynamicText(
                      'View less',
                      context,
                      TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.tealButtonColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 3,
                      )),
                )
              : Container(),
        )
      ],
    );
  }

  Widget prices(SingleProductPayload model) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        color: ThemeApp.priceContainerColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            model.merchants.isNotEmpty
                ? TextFieldUtils().dynamicText(
                    indianRupeesFormat.format(double.parse(
                            merchantTemp[_radioValue]
                                .unitOfferPrice
                                .toString()) ??
                        '0.0'),
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: 34,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.w700))
                : TextFieldUtils().dynamicText(
                    indianRupeesFormat.format(
                        double.parse(model.defaultSellPrice.toString()) ??
                            '0.0'),
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: 34,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.w700)),
            SizedBox(
              width: 25,
            ),
            merchantTemp.isNotEmpty
                ? TextFieldUtils().dynamicText(
                    indianRupeesFormat.format(double.parse(
                            merchantTemp[_radioValue].unitMrp.toString()) ??
                        '0.0'),
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        decoration: TextDecoration.lineThrough,
                        letterSpacing: 0.2,
                        fontSize: 22,
                        fontWeight: FontWeight.w700))
                : TextFieldUtils().dynamicText(
                    indianRupeesFormat.format(
                        double.parse(model.defaultMrp.toString()) ?? '0.0'),
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        decoration: TextDecoration.lineThrough,
                        letterSpacing: 0.2,
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
            SizedBox(
              width: 15,
            ),
            merchantTemp.isNotEmpty
                ? TextFieldUtils().dynamicText(
                    merchantTemp[_radioValue].unitDiscountPerc.toString() +
                        "% Off",
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: 14,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.w500))
                : TextFieldUtils().dynamicText(
                    model.defaultDiscount.toString() + "% Off",
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: 14,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget availableVariant(SingleProductPayload model) {
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
            Text("Available variants",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: height * .022)),
            variantImages(model),
            TextFieldUtils().subHeadingTextFields(
                "* Images may differ in appearance from the actual product",
                context),
          ],
        ),
      ),
    );
  }

  Widget productDescription(SingleProductPayload model) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        // border: Border(
        //   bottom: BorderSide(color: Colors.grey, width: 1),
        // ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Product Description",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
            SizedBox(
              height: height * .01,
            ),
            Text(model.oneliner!,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: ThemeApp.lightFontColor,
                  // fontWeight: FontWeight.w500,
                  fontSize: 14,
                )),
          ],
        ),
      ),
    );
  }

  List<Widget> listSubImages = [];

  Widget subImages(SingleProductPayload model) {
    return Container();
  }

  Widget variantImages(SingleProductPayload model) {
    return Container(
      height: height * .08,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: model.imageUrls!.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {});
                    // imageVariantIndex = index;
                    index = _currentIndex;
                    print(imageVariantIndex);
                  },
                  child: Container(
                        // width: width * 0.24,
                        decoration: const BoxDecoration(
                            color: ThemeApp.whiteColor,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Image.network(
                                  // width: double.infinity,
                                  model.imageUrls![index].imageUrl ?? "",
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height * .05,
                                  width: width * .1,
                                  errorBuilder: ((context, error, stackTrace) {
                                return Icon(Icons.image_outlined);
                              })) ??
                              SizedBox(),
                        ),
                      ) ??
                      SizedBox(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .01,
                )
              ],
            );
          }),
    );
  }

  Widget counterWidget(SingleProductPayload model) {
    return model.merchants.isNotEmpty
        ? Container(color: ThemeApp.whiteColor,
            padding:
                const EdgeInsets.only(left: 20, right: 20, top:20, bottom: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20,),
                  child: Row(
                    children: [
                      TextFieldUtils().dynamicText(
                          'Quantity : ',
                          context,
                          TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              // fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      SizedBox(
                        width: 11,
                      ),

                      Container(
                        height:30,
                        // width: width * .2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            border: Border.all(
                                color: ThemeApp.separatedLineColor, width: 1.5)),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    counterPrice--;
                                    remainingCounters();

                                    var data = {
                                      "user_id": userId.toString(),
                                      "item_code": model.productCode.toString(),
                                      "qty": counterPrice.toString()
                                    };
                                    print("data maping " + data.toString());
                                    // productSpecificListViewModel.cartListWithPut(
                                    //     context, data);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                                  child: const Icon(Icons.remove,
                                      // size: 20,
                                      color: ThemeApp.lightFontColor),
                                ),
                              ),
                              Container(
                                height:30,
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(
                                  20,
                                  0,
                                  20,
                                  0,
                                ),
                                color: ThemeApp.separatedLineColor,
                                child: Text(
                                  counterPrice.toString().padLeft(2, '0'),
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
                                    counterPrice++;
                                    remainingCounters();


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
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                addToCart(model),
              ],
            ),
          )
        : Container(
      width: width,
      height: 72,
      color: ThemeApp.whiteColor,
      padding: const EdgeInsets.only(
          left: 20, right: 20, top: 5, bottom: 5),
      child: Center(
        child: TextFieldUtils().dynamicText(
            "SERVICE NOT AVAILABLE",
            context,
            TextStyle(
              fontFamily: 'Roboto',
              color: ThemeApp.redColor,
              fontWeight: FontWeight.w500,
              fontSize: height * .035,
            )),
      ),
    );
  }

  Widget addToCart(SingleProductPayload model) {
    return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
      return Consumer<ProductSpecificListViewModel>(
          builder: (context, productListProvider, child) {
            print("model.merchants lengthghgfjgfj "+merchantTemp.length.toString());
        return model.merchants.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*counterPrice == 0
                        ?*/
                    Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();

                              setState(() {
                                updateCart(
                                    model.selectedMerchantId,
                                    counterPrice,
                                    productProvider,
                                    model.productsubCategory);

                                StringConstant.BadgeCounterValue =
                                    (prefs.getString('setBadgeCountPrefs')) ??
                                        '';
                                print("Badge,........" +
                                    StringConstant.BadgeCounterValue);
                              });
                            },
                            child: Container(
                                height:40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  border: Border.all(
                                      color: ThemeApp.tealButtonColor),
                                  color: ThemeApp.containerColor,
                                ),
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize:16,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                    color: ThemeApp.tealButtonColor,
                                  ),
                                )))),
                    /* : Expanded(
                            flex: 1,
                            child: Container(
                              height: height * 0.06,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: ThemeApp.whiteColor,
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

                                          var data = {
                                            "user_id": userId.toString(),
                                            "item_code": subProductList
                                                .productCode
                                                .toString(),
                                            "qty": counterPrice.toString()
                                          };
                                          print(
                                              "data maping " + data.toString());
                                          productSpecificListViewModel
                                              .cartListWithPut(context, data);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: ThemeApp.whiteColor,
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          // size: 20,
                                          color: ThemeApp.tealButtonColor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8,
                                          top: 0,
                                          bottom: 0),
                                      child: Text(
                                        counterPrice.toString().padLeft(2, '0'),
                                        style: TextStyle(fontFamily: 'Roboto',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .016,
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.ellipsis,
                                            color: ThemeApp.tealButtonColor),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          counterPrice++;
                                          remainingCounters();

                                          //badge counting
                                          badgeData = 0;

                                          ///counting will manage after api
                                          */
                    /*   for (int i = 0;
                                    i < cartProvider.cartList.length;
                                    i++) {
                                      if (widget.productList.shortName==
                                          cartProvider.cartList[i]
                                              .cartProductsDescription) {
                                        widget.productList[
                                        "productCartMaxCounter"] =
                                            counterPrice;
                                        widget.value.cartList[i]
                                            .cartProductsTempCounter =
                                        widget.productList[
                                        "productCartMaxCounter"];
                                      }
                                      //badge counting
                                      print("Badge counting before" +
                                          badgeData.toString());
                                      print("Badge cTemp Counting" +
                                          widget.value.cartList[i]
                                              .cartProductsTempCounter
                                              .toString());
                                      print("Badge Product name" +
                                          widget.value.cartList[i]
                                              .cartProductsDescription
                                              .toString());

                                      badgeData = badgeData +
                                          widget.value.cartList[i]
                                              .cartProductsTempCounter!;
                                      widget.value.badgeFinalCount =
                                          badgeData;
                                    }
                                    print("Badge counting" +
                                        badgeData.toString());
                                    //setting value of count to the badge
*/
                    /*

                                          ///api for counting

                                          var data = {
                                            "user_id": userId.toString(),
                                            // "item_code": widget
                                            //     .productList.categoryCode
                                            //     .toString(),
                                            "item_code": '1',
                                            "qty": counterPrice.toString()
                                          };
                                          print(
                                              "data maping " + data.toString());
                                          productSpecificListViewModel
                                              .cartListWithPut(context, data);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: ThemeApp.whiteColor,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          // size: 20,
                                          color: ThemeApp.tealButtonColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),*/
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .05,
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            productListProvider.isHome = false;
                            productListProvider.isBottomAppCart = false;
                          });

                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString(
                              'isBuyNow', 'true');
                          prefs.setString(
                              'isBuyNowFrom', 'Services');
                          StringConstant.isUserLoggedIn =
                              (prefs.getInt('isUserLoggedIn')) ?? 0;

                          final navigator =
                              Navigator.of(context); // <- Add this
                          model.productsubCategory;

                          //send data to login user for direct purchase api
                          prefs.setString('selectedMerchantId',
                              model.selectedMerchantId.toString());
                          prefs.setString(
                              'selectedProductId', model.id.toString());
                          prefs.setString(
                              'selectedCounterPrice', counterPrice.toString());

                          //get cartID from DirectUser for purchase

                          var directCartId =
                              prefs.getString('directCartIdPref');
                          var loginUserId = (prefs.getString('isUserId')) ?? '';
                          if (StringConstant.isUserLoggedIn == 1) {
                            //if user logged in

                            CartRepository()
                                .buyNowGetRequest(loginUserId, context);
                          } else {
                            //if user not login
                            prefs.setString(
                                'isUserNavigateFromDetailScreen', 'BN');
                            Navigator.pushReplacementNamed(
                                context, RoutesName.signInRoute);

                            print("Not Logged in");
                            // Navigator.pushReplacementNamed(context, RoutesName.signInRoute);
                          }
                        },
                        child: Container(
                            height:40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              border: Border.all(
                                  color: ThemeApp.tealButtonColor),
                              color: ThemeApp.tealButtonColor,
                            ),
                            child: Text(
                              "Buy now",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize:16,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: ThemeApp.whiteColor,
                              ),
                            )),
                      ),
                    )
                  ],
                ))
            : Container(
                width: width,
                height: 72,
                color: ThemeApp.whiteColor,
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: Center(
                  child: TextFieldUtils().dynamicText(
                      "OUT OF STOCK",
                      context,
                      TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.redColor,
                        fontWeight: FontWeight.w500,
                        fontSize: height * .035,
                      )),
                ),
              );
      });
    });
  }

  Widget similarProductList() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: productListView,
        child: Consumer<DashboardViewModel>(
            builder: (context, productCategories, child) {
          switch (productCategories.similarList.status) {
            case Status.LOADING:
              if (kDebugMode) {
                print("Api load");
              }
              return ProgressIndicatorLoader(true);

            case Status.ERROR:
              if (kDebugMode) {
                print("Api error : " +
                    productCategories.similarList.message.toString());
              }
              return Text(productCategories.similarList.message.toString());

            case Status.COMPLETED:
              if (kDebugMode) {
                print("Api calll");
              }

              List<SimilarContent>? similarList =
                  productCategories.similarList.data!.payload!.content;

              return Container(
                height: 228,
                child: similarList!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: similarList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ServiceDetailsActivity(
                                            id: similarList[index].id,
                                            // productList: subProductList[index],
                                            // productSpecificListViewModel:
                                            //     productSpecificListViewModel,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 163,
                                          width: 191,
                                          decoration: const BoxDecoration(
                                            color: ThemeApp.whiteColor,
                                          ),
                                          child: ClipRRect(
                                              child: Image.network(
                                            // width: double.infinity,
                                            similarList[index]
                                                    .imageUrls![0]
                                                    .imageUrl
                                                    .toString() ??
                                                "",
                                            fit: BoxFit.scaleDown,
                                            errorBuilder:
                                                ((context, error, stackTrace) {
                                              return Icon(Icons.image_outlined);
                                            }),
                                          )),
                                        ),
                                        Container(
                                          color: ThemeApp.tealButtonColor,
                                          width: 191,
                                          height: 65,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        21, 9, 21, 4),
                                                child: Text(
                                                    similarList[index]
                                                        .shortName!,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color:
                                                            ThemeApp.whiteColor,
                                                        fontSize: height * .022,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        21, 0, 21, 9),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    //discount
                                                    TextFieldUtils()
                                                        .listPriceHeadingTextField(
                                                            indianRupeesFormat
                                                                .format(similarList[
                                                                            index]
                                                                        .defaultSellPrice ??
                                                                    0.0),
                                                            context),

                                                    TextFieldUtils()
                                                        .listScratchPriceHeadingTextField(
                                                            indianRupeesFormat
                                                                .format(similarList[
                                                                            index]
                                                                        .defaultMrp ??
                                                                    0.0),
                                                            context),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .03,
                                  )
                                ],
                              ) ??
                              SizedBox();
                        })
                    : SizedBox(),
              );
            default:
              return Text("No Data found!");
          }
          return Text("No Data found!");
        }));

/*
    return ChangeNotifierProvider<DashboardViewModel>(
        value:  dashboardViewModel,
        child: Consumer<DashboardViewModel>(
            builder: (context, dashboardProvider, child) {
          return Consumer<DashboardViewModel>(
              builder: (context, dashboardProvider, child) {
            switch (dashboardViewModel.productListingList.status) {
              case Status.LOADING:
                if (kDebugMode) {
                  print("Api load");
                }
                return ProgressIndicatorLoader(true);

              case Status.ERROR:
                if (kDebugMode) {
                  print("Api error");
                }
                return Text(
                    dashboardViewModel.productListingList.message.toString());

              case Status.COMPLETED:
                if (kDebugMode) {
                  print("Api calll");
                }

                List<ProductListing>? productListing = dashboardViewModel
                    .productListingList.data!.response!.body!.productListing;

                return Container(
                  height: MediaQuery.of(context).size.height * .35,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: productListing!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Container(
                                // height: MediaQuery.of(context).size.height * .3,

                                // width: 200,
                                width: MediaQuery.of(context).size.width * .45,
                                decoration: const BoxDecoration(
                                    color: ThemeApp.whiteColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .26,
                                      width: MediaQuery.of(context).size.width *
                                          .45,
                                      decoration: const BoxDecoration(
                                          color: ThemeApp.textFieldBorderColor,
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
                                          // width: double.infinity,
                                          productListing[index].image1Url!,
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
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: TextFieldUtils()
                                          .homePageTitlesTextFields(
                                              productListing[index].shortName!,
                                              context),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .01,
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextFieldUtils().dynamicText(
                                                indianRupeesFormat.format(
                                                    productListing[index]
                                                            .scrappedPrice ??
                                                        0.0),
                                                context,
                                                TextStyle(fontFamily: 'Roboto',
                                                    color: ThemeApp.primaryNavyBlackColor
                                                    fontSize: height * .022,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextFieldUtils().dynamicText(
                                                indianRupeesFormat.format(
                                                    productListing[index]
                                                            .currentPrice ??
                                                        0.0),
                                                context,
                                                TextStyle(fontFamily: 'Roboto',
                                                    color: ThemeApp.darkGreyTab,
                                                    fontSize: height * .02,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationThickness: 1.5)),
                                          ],
                                        ),
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
                );
              default:
                return Text("No Data found!");
            }
            return Text("No Data found!");
          });
        }));
*/
  }

  Widget similarProductListss() {
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
                                  decoration: const BoxDecoration(
                                      color: ThemeApp.whiteColor,
                                      borderRadius: BorderRadius.all(
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
                                        decoration: const BoxDecoration(
                                            color:
                                                ThemeApp.textFieldBorderColor,
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

  Future<void> addProductInCartBadge(
      ProductProvider productProvider, HomeProvider homeProvider) async {
/*    if (counterPrice > 0) {
      widget.productList["productTempCounter"] = counterPrice;

      var contain = productProvider.cartList.where((element) =>
          element.cartProductsDescription ==
          widget.productList["productsListDescription"]);

      if (productProvider.cartList.length >= 0) {
        if (contain.isNotEmpty) {
          widget.productList["productTempCounter"] = counterPrice;
        } else {
          productProvider.add(
            widget.productList["productsListImage"],
            widget.productList["productsListName"],
            widget.productList["productSellerName"],
            double.parse(widget.productList["productRatting"].toString()),
            widget.productList["productDiscountPrice"],
            widget.productList["productOriginalPrice"],
            widget.productList["productOfferPercent"],
            widget.productList["productAvailableVariants"],
            widget.productList["productCartProductsLength"],
            widget.productList["productsListDescription"],
            widget.productList["productCartMaxCounter"],
            widget.productList["productDeliveredBy"],
            widget.productList["productTempCounter"] == 0
                ? widget.productList["productTempCounter"] = 1
                : widget.productList["productTempCounter"],
          );
        }
      } else {
        productProvider.add(
          widget.productList["productsListImage"],
          widget.productList["productsListName"],
          widget.productList["productSellerName"],
          double.parse(widget.productList["productRatting"].toString()),
          widget.productList["productDiscountPrice"],
          widget.productList["productOriginalPrice"],
          widget.productList["productOfferPercent"],
          widget.productList["productAvailableVariants"],
          widget.productList["productCartProductsLength"],
          widget.productList["productsListDescription"],
          widget.productList["productCartMaxCounter"],
          widget.productList["productDeliveredBy"],
          widget.productList["productTempCounter"] == 0
              ? widget.productList["productTempCounter"] = 1
              : widget.productList["productTempCounter"],
        );
      }
    } else {

    }*/
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

  Future<List<Payloads>> getImageSlide() async {
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

List<BookServiceModel> bookServiceFromJson(String str) =>
    List<BookServiceModel>.from(
        json.decode(str).map((x) => BookServiceModel.fromJson(x)));

String bookServiceToJson(List<BookServiceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookServiceModel {
  String serviceImage;
  String serviceName;
  String serviceDescription;

  BookServiceModel({
    required this.serviceImage,
    required this.serviceName,
    required this.serviceDescription,
  });

  factory BookServiceModel.fromJson(Map<String, dynamic> json) =>
      BookServiceModel(
        serviceImage: json["serviceImage"],
        serviceName: json["serviceName"],
        serviceDescription: json["serviceDescription"],
      );

  Map<String, dynamic> toJson() => {
        "serviceImage": serviceImage,
        "serviceName": serviceName,
        "serviceDescription": serviceDescription,
      };
}
