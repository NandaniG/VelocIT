import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/Core/Model/CRMModel.dart';
import 'package:velocit/Core/repository/productlisting_repository.dart';
import 'package:velocit/pages/screens/dashBoard.dart';
import 'package:velocit/utils/utils.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';

import '../../../../Core/AppConstant/apiMapping.dart';
import '../../../../Core/Model/CRMModels/CRMSingleIDModel.dart';
import '../../../../Core/Model/ServiceModels/SingleServiceModel.dart';
import '../../../../Core/Model/SimmilarProductModel.dart';

import '../../../../Core/ViewModel/cart_view_model.dart';
import '../../../../Core/ViewModel/dashboard_view_model.dart';
import '../../../../Core/ViewModel/product_listing_view_model.dart';
import '../../../../Core/data/app_excaptions.dart';
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
import 'CRMFormScreen.dart';
import 'package:http/http.dart' as http;

class CRMDetailsActivity extends StatefulWidget {
  // List<ProductList>? productList;
  // Content? productList;
  final int? id;

  CRMDetailsActivity(
      {Key? key,
      // required this.productList,
      required this.id})
      : super(key: key);

  @override
  State<CRMDetailsActivity> createState() => _CRMDetailsActivityState();
}

class _CRMDetailsActivityState extends State<CRMDetailsActivity> {
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
    productSpecificListViewModel.CRMSingleIDListWithGet(
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
        child: AppBar_BackWidget(
            context: context,
            titleWidget: appTitle(context, "CRM"),
            location: const SizedBox()),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context, 0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            // padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: ChangeNotifierProvider<ProductSpecificListViewModel>.value(
                value: productSpecificListViewModel,
                child: Consumer<ProductSpecificListViewModel>(
                    builder: (context, crmSubCategoryProvider, child) {
                  switch (crmSubCategoryProvider.singleCRMSpecificList.status) {
                    case Status.LOADING:
                      print("Api load");

                      return TextFieldUtils().circularBar(context);
                    case Status.ERROR:
                      print("Api error");

                      return Text(crmSubCategoryProvider
                          .singleCRMSpecificList.message
                          .toString());
                    case Status.COMPLETED:
                      print("Api calll");
                      CRMDetailsPayload? model = crmSubCategoryProvider
                          .singleCRMSpecificList.data!.payload;
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
                                      model.crm!.shortName!, context),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                prices(model),
                                const SizedBox(
                                  height: 20,
                                ),
                                model.crmFormId.toString().isEmpty
                                    ? Container(
                                        width: width,
                                        height: 72,
                                        color: ThemeApp.whiteColor,
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 5,
                                            bottom: 5),
                                        child: Center(
                                            child: TextFieldUtils().dynamicText(
                                                "SERVICE NOT AVAILABLE",
                                                context,
                                                TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: ThemeApp.redColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: height * .035,
                                                ))))
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: proceedButton(
                                            'Enquiry',
                                            ThemeApp.tealButtonColor,
                                            context,
                                            false, () {
                                          getCRMForm(model.crmFormId!)
                                              .then((value) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CRMFormScreen(
                                                  shortName: model
                                                      .crm!.shortName
                                                      .toString(),
                                                  payload: model,
                                                ),
                                              ),
                                            );
                                          });
                                        }),
                                      )

                                /*         InkWell(
                                  onTap: () {
                                  getCRMForm(model.crmFormId!).then((value){
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CRMFormScreen(shortName:  model.crm!.shortName.toString(),payload:model , ),
                                      ),
                                    );
                                  });


                                  },
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                          ),
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(100),
                                                ),
                                                border: Border.all(
                                                    color:
                                                        ThemeApp.tealButtonColor),
                                                color: ThemeApp.tealButtonColor,
                                              ),
                                              child: const Text(
                                                "Enquiry",
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: ThemeApp.whiteColor,
                                                ),
                                              )),
                                        ),
                                    ),*/
                              ],
                            ) ??
                            const SizedBox();
                      } else {
                        return Container(
                          height: height * .8,
                          alignment: Alignment.center,
                          child: Center(
                              child: Text(
                            "Match not found",
                            style: TextStyle(fontSize: 20),
                          )),
                        );
                      }
                  }
                  return Container(
                    height: height * .8,
                    alignment: Alignment.center,
                    child: Center(
                        child: Text(
                      "Match not found",
                      style: TextStyle(fontSize: 20),
                    )),
                  );
                }))),
      ),
    );
  }

  Future getCRMForm(int formId) async {
    dynamic responseJson;
    try {
      var url = ApiMapping.getURI(apiEndPoint.crm_form);
      print(url + formId.toString());
      final client = http.Client();
      final response =
          await client.get(Uri.parse(url)).timeout(const Duration(seconds: 30));

      var responseJson = json.decode(response.body.toString());
      final prefs = await SharedPreferences.getInstance();

      print('responseJson' + responseJson['status'].toString());
      print('responseJson' + responseJson['payload'].toString());
      print('responseJson' + responseJson['payload'][0]['f1_label'].toString());
      print('responseJson' + responseJson.toString());

      prefs.setBool(
          'is_f1_enabled', responseJson['payload'][0]['is_f1_enabled']);
      prefs.setBool(
          'is_f2_enabled', responseJson['payload'][0]['is_f2_enabled']);
      prefs.setBool(
          'is_f3_enabled', responseJson['payload'][0]['is_f3_enabled']);
      prefs.setBool(
          'is_f4_enabled', responseJson['payload'][0]['is_f4_enabled']);
      prefs.setBool(
          'is_f5_enabled', responseJson['payload'][0]['is_f5_enabled']);

      prefs.setString('f1_label', responseJson['payload'][0]['f1_label']);
      prefs.setString('f2_label', responseJson['payload'][0]['f2_label']);
      prefs.setString('f3_label', responseJson['payload'][0]['f3_label']);
      prefs.setString('f4_label', responseJson['payload'][0]['f4_label']);
      prefs.setString('f5_label', responseJson['payload'][0]['f5_label']);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print("Error on Get : " + e.toString());
    }
    return responseJson;
  }

  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
  int _radioValue = 0;

  Widget productImage(CRMDetailsPayload? model) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: height * .28,
            child: CarouselSlider(
                  carouselController: _carouselController,
                  items: model!.crm!.imageUrls!.map<Widget>((e) {
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
                                                child: Image.network(e ?? "",
                                                        // fit: BoxFit.fill,
                                                        errorBuilder: ((context,
                                                            error, stackTrace) {
                                                      return const Icon(
                                                          Icons.image_outlined);
                                                    })) ??
                                                    const SizedBox(),
                                              ),
                                            ) ??
                                            const SizedBox()),
                                  ) ??
                                  const SizedBox(),
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
                      autoPlay: model.crm!.imageUrls!.length > 1 ? true : false,
                      viewportFraction: 1,
                      height: height * .3),
                ) ??
                const SizedBox(),
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

  Widget rattingBar(CRMDetailsPayload model) {
    return Container(
        width: width * .7,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: rattingBarWidget(model, 5, width * .7, 4.5));
  }

  Widget rattingBarWidget(
      CRMDetailsPayload model, int count, double width, double ratingValue) {
    return Container(
      width: width,
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

  Widget merchantDetails(CRMDetailsPayload model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text(
                                      merchantTemp[index].merchantName ?? "",
                                      style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          color: ThemeApp.blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)) ??
                                  const SizedBox(),
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
                                style: const TextStyle(
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
                                    style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        color: ThemeApp.darkGreyColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))
                                : const Text('0.0',
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
                                style: const TextStyle(
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
                  const SizedBox();
            }),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          decoration: const BoxDecoration(),
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
                      const TextStyle(
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
                      const TextStyle(
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

  Widget prices(CRMDetailsPayload model) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        color: ThemeApp.priceContainerColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.crm!.oneliner.toString(),
              style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text(model.merchant!.name ?? "",
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)) ??
                  const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

/*
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
*/

  Widget productDescription(CRMDetailsPayload model) {
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
            const Text("Product Description",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
            SizedBox(
              height: height * .01,
            ),
            Text(model.crm!.oneliner.toString(),
                style: const TextStyle(
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

  Widget variantImages(CRMDetailsPayload model) {
    return Container(
      height: height * .08,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: model.crm!.imageUrls!.length,
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
                                  model.crm!.imageUrls![index] ?? "",
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height * .05,
                                  width: width * .1,
                                  errorBuilder: ((context, error, stackTrace) {
                                return const Icon(Icons.image_outlined);
                              })) ??
                              const SizedBox(),
                        ),
                      ) ??
                      const SizedBox(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .01,
                )
              ],
            );
          }),
    );
  }
}
