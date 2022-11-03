import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../services/models/demoModel.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/appBar.dart';
import '../../widgets/global/proceedButtons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/global/textFormFields.dart';
import '../Activity/Merchant_Near_Activities/merchant_Activity.dart';
import '../Activity/DashBoard_DetailScreens_Activities/Categories_Activity.dart';
import 'offers_Activity.dart';

final List<String> titles = [
  'Order Placed',
  'Packed',
  'Shipped',
  'Delivered'
];
int _curStep = 1;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  String location = 'Null, Press Button';
  String Address = 'search';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPincode();
    StringConstant.controllerSpeechToText.clear();
  }

  getPincode() async {
    await Prefs().getToken(StringConstant.pinCodePref);
    StringConstant.placesFromCurrentLocation =
    (await Prefs().getToken(StringConstant.pinCodePref))!;

    print(
        "placesFromCurrentLocation pref...${StringConstant.placesFromCurrentLocation.toString()}");
  }

  Future<List<Payload>> getImageSlide() async {
    //final response = await http.get("getdata.php");
    //return json.decode(response.body);
    String response = '['
        // '{"sponsorlogo":"https://picsum.photos/250?image=9"},'
        '{"sponsorlogo":"assets/images/laptopImage.jpg"},'
        '{"sponsorlogo":"assets/images/iphones_Image.jpg"},'
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"}]';
    var payloadList = payloadFromJson(response);
    return payloadList;
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
      backgroundColor: ThemeApp.backgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
    preferredSize:  Size.fromHeight(height*.12),
    child: appBarWidget(context,searchBar(context), addressWidget(context,StringConstant.placesFromCurrentLocation),setState((){})),
      ),
      body: SafeArea(
        child: Container(
        // height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 20, right: 20, ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFieldUtils()
              //     .listHeadingTextField(StringConstant.speechToText, context),
              imageLists(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFieldUtils().listHeadingTextField(
                      AppLocalizations.of(context).shopByCategories, context),
                  viewMoreButton(
                      AppLocalizations.of(context).viewAll, context, () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                        const ShopByCategoryActivity(),
                      ),
                    );
                  })
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              listOfShopByCategories(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFieldUtils().listHeadingTextField(
                      AppLocalizations.of(context).bookOurServices, context),
                  viewMoreButton(
                      AppLocalizations.of(context).viewAll, context, () {})
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              listOfBookOurServices(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              stepperOfDelivery(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              TextFieldUtils().listHeadingTextField(
                  AppLocalizations.of(context).recommendedForYou, context),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              recommendedList(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFieldUtils().listHeadingTextField(
                      AppLocalizations.of(context).merchantNearYou, context),
                  viewMoreButton(
                      AppLocalizations.of(context).viewAll, context, () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MerchantActvity(),
                      ),
                    );
                  })
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              merchantList(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              TextFieldUtils().listHeadingTextField(
                  AppLocalizations.of(context).bestDeal, context),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              bestDealList(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              TextFieldUtils().listHeadingTextField(
                  AppLocalizations.of(context).budgetBuys, context),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              budgetBuyList(),
            ],
          ),
        )),
      ),
    );
  }

  Widget imageLists() {
    return FutureBuilder<List<Payload>>(
        future: getImageSlide(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height:  (MediaQuery.of(context).orientation ==
                      Orientation.landscape)?height*.5:height * 0.23,
                  child: Carousel(
                    images: snapshot.data?.map((e) {
                      return Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        color: ThemeApp.whiteColor,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: /*Image.network(
                            // width: double.infinity,
                            e.sponsorlogo,
                            fit: BoxFit.fill,
                          ),*/
                          Image.asset(e.sponsorlogo, fit: BoxFit.fill,)
                        ),
                      );
                    }).toList(),
                    dotSize: 8.0,
                    autoplay: false,
                    dotSpacing: 15.0,
                    dotColor: ThemeApp.lightGreyTab,
                    dotIncreasedColor: ThemeApp.darkGreyTab,
                    indicatorBgPadding: 10.0,
                    dotBgColor: Colors.transparent,
                    borderRadius: true,
                    boxFit: BoxFit.cover,
                    dotPosition: DotPosition.bottomCenter,
                  ))
              : new Center(child: new CircularProgressIndicator());
        });
  }

  // Future<List<BookServiceModel>> getShopByCategoryLists() async {
  //   String response = '['
  //       '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Appliances","serviceDescription":"Motorola ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
  //       '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Electronics","serviceDescription":"Samsang ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
  //       '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Fashion","serviceDescription":"One Plus ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
  //       '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Home","serviceDescription":"IPhone ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"}]';
  //   var serviceList = bookServiceFromJson(response);
  //   return serviceList;
  // }
  Future<List<BookServiceModel>> getShopByCategoryLists()async {
    String response = '['
        '{"serviceImage":"assets/images/laptopImage.jpg","serviceName":"Appliances", "sellerName":"sellerName","ratting":0.2,"discountPrice":"47700", "originalPrice":"50600","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"Dell ZX3 108CM (44 inch) ultra HD(4k) LED Smart Android TV","maxCounter":"7","deliveredBy":"Delivered by sep 22"},'
        '{"serviceImage":"assets/images/iphones_Image.jpg","serviceName":"Electronics", "sellerName":"sellerName","ratting":3.5,"discountPrice":"12600", "originalPrice":"18990","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"IPhone 14 108CM LED smart display","maxCounter":"5","deliveredBy":"Delivered by sep 12"},'
        '{"serviceImage":"assets/images/laptopImage2.jpg","serviceName":"Home", "sellerName":"sellerName","ratting":4.0,"discountPrice":"21300", "originalPrice":"23300","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"Asus IK02 108CM (46 inch) ultra HD(4k) LED Smart","maxCounter":"5","deliveredBy":"Delivered by sep 03"},'
        '{"serviceImage":"assets/images/laptopImage.jpg","serviceName":"Electronics", "sellerName":"sellerName","ratting":4.5,"discountPrice":"42300", "originalPrice":"47600","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"HP WES3 108CM (41 inch) ultra HD(4k) LED Smart Android TV","maxCounter":"5","deliveredBy":"Delivered by sep 30"},'
        '{"serviceImage":"assets/images/laptopImage3.jpg","serviceName":"Fashion", "sellerName":"sellerName","ratting":2.8,"discountPrice":"14500", "originalPrice":"16400","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"Lenovo ZX3 108CM (46 inch) ultra HD(4k) LED Smart Android ","maxCounter":"8","deliveredBy":"Delivered by oct 01"},'
        '{"serviceImage":"assets/images/IPhoneImage.jpg","serviceName":"Home", "sellerName":"sellerName","ratting":4.8,"discountPrice":"65200", "originalPrice":"68300","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"IPhone 13 108CM (47 inch) ultra HD(4k) LED Smart Android TV","maxCounter":"10","deliveredBy":"Delivered by dec 31"}]';
    var serviceList = bookServiceFromJson(response);
    return serviceList;
  }
  Widget listOfShopByCategories() {
    return FutureBuilder<List<BookServiceModel>>(
        future: getShopByCategoryLists(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height: MediaQuery.of(context).size.height * .13,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ShopByCategoryActivity(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                  width: width * 0.24,
                                  decoration: BoxDecoration(
                                      color: ThemeApp.whiteColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                   /*   Image.network(
                                        // width: double.infinity,
                                        snapshot.data![index].serviceImage,
                                        fit: BoxFit.fill,

                                        height:
                                            MediaQuery.of(context).size.height *
                                                .07,
                                      ),*/
                                      //     ClipRRect(
                                      //   borderRadius: const BorderRadius.all(
                                      //       Radius.circular(50)),
                                      //   child: Image.asset(
                                      //     // width: double.infinity,
                                      //     snapshot.data![index].serviceImage,
                                      //     fit: BoxFit.fill,
                                      //
                                      //     height: MediaQuery.of(context)
                                      //             .size
                                      //             .height *
                                      //         .07,
                                      //   ),
                                      // ),
                                      Container(
                                          width: 60.0,
                                          height: 60.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                    snapshot.data![index].serviceImage,)
                                              )
                                          )),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .01,
                                      ),
                                      TextFieldUtils()
                                          .appliancesTitleTextFields(
                                              snapshot.data![index].serviceName,
                                              context)
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .03,
                              )
                            ],
                          ),
                        );
                      }),
                )
              : new Center(child: new CircularProgressIndicator());
        });
  }

  Widget listOfBookOurServices() {
    return FutureBuilder<List<BookServiceModel>>(
        future: getShopByCategoryLists(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height: MediaQuery.of(context).size.height * .13,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => const OfferActivity(),
                            //   ),
                            // );
                          },
                          child: Row(
                            children: [
                              Container(
                                  // width: 130,
                                  width: width * 0.24,
                                  decoration: BoxDecoration(
                                      color: ThemeApp.whiteColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                               /*       ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                        child: Image.network(
                                          // width: double.infinity,
                                          snapshot.data![index].serviceImage,
                                          fit: BoxFit.fitWidth,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .07,
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
                                                    snapshot.data![index].serviceImage,)
                                              )
                                          )),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .01,
                                      ),
                                      TextFieldUtils()
                                          .appliancesTitleTextFields(
                                              snapshot.data![index].serviceName,
                                              context)
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .03,
                              )
                            ],
                          ),
                        );
                      }),
                )
              : new Center(child: new CircularProgressIndicator());
        });
  }

  Widget stepperOfDelivery() {
    return FutureBuilder<List<BookServiceModel>>(
        future: getShopByCategoryLists(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height: height * .225,

                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Container(
                                // width: 300,
                                width: width * 0.85,

                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: ThemeApp.whiteColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        // ClipRRect(
                                        //   borderRadius: const BorderRadius.all(
                                        //       Radius.circular(100)),
                                        //   child: Image.network(
                                        //     // width: double.infinity,
                                        //     snapshot.data![index].serviceImage,
                                        //     fit: BoxFit.fitWidth,
                                        //     height: MediaQuery.of(context)
                                        //             .size
                                        //             .height *
                                        //         .07,
                                        //   ),
                                        // ),
                                        Container(
                                            width: 60.0,
                                            height: 60.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new AssetImage(
                                                      snapshot.data![index].serviceImage,)
                                                )
                                            )),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .03,
                                        ),
                                        Flexible(
                                          child: TextFieldUtils()
                                              .stepperHeadingTextFields(
                                                  snapshot.data![index]
                                                      .serviceDescription
                                                      .toString(),
                                                  context),
                                        )
                                      ],
                                    ),
                                    stepperWidget(),
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
        });
  }

  Widget stepperWidget() {
    return Container(
        height: height * .1,
        width: width,
        alignment: Alignment.center,
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
        ));
  }

  Widget recommendedList() {
    return FutureBuilder<List<BookServiceModel>>(
        future: getShopByCategoryLists(),
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
                                width: MediaQuery.of(context).size.width * .45,
                                decoration: BoxDecoration(
                                    color: ThemeApp.whiteColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
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
                                      decoration: BoxDecoration(
                                          color:
                                              ThemeApp.textFieldBorderColor,
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
                                      padding: const EdgeInsets.only(left: 18),
                                      child: TextFieldUtils()
                                          .homePageTitlesTextFields(
                                              "Beardo ultra glow face",
                                              context),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .01,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18),
                                      child: Row(
                                        children: [
                                          TextFieldUtils()
                                              .homePageheadingTextField(
                                                  "${indianRupeesFormat.format(3080)}", context),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .02,
                                          ),
                                          TextFieldUtils()
                                              .homePageheadingTextFieldLineThrough(
                                                  "${indianRupeesFormat.format(2900)}", context),
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
        });
  }

  Widget merchantList() {
    return FutureBuilder<List<BookServiceModel>>(
        future: getShopByCategoryLists(),
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
                        return InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MerchantActvity(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width * .45,
                                  decoration: BoxDecoration(
                                      color: ThemeApp.darkGreyTab,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .26,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .45,
                                            decoration: BoxDecoration(
                                                color: ThemeApp.whiteColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                )),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                              child: Image.asset(
                                                // width: double.infinity,
                                                snapshot
                                                    .data![index].serviceImage,
                                                fit: BoxFit.fill,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .07,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, right: 10),
                                            child: kmAwayOnMerchantImage(
                                              '1.2 km away',
                                              context,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .01,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 18),
                                        child: TextFieldUtils()
                                            .homePageTitlesTextFieldsWHITE(
                                                "Beardo ultra glow face",
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
                                          child: TextFieldUtils()
                                              .homePageheadingTextFieldWHITE(
                                                  "${indianRupeesFormat.format(2570)}", context)),
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .03,
                              )
                            ],
                          ),
                        );
                      }),
                )
              : new Center(child: new CircularProgressIndicator());
        });
  }

  Widget bestDealList() {
    return FutureBuilder<List<BookServiceModel>>(
        future: getShopByCategoryLists(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height: MediaQuery.of(context).size.height * .3,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const OfferActivity(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                // width: 200,
                                width: width * .45,
                                height: MediaQuery.of(context).size.height * .25,
                                decoration: BoxDecoration(
                                    color: ThemeApp.whiteColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: Image.asset(
                                    // width: double.infinity,
                                    snapshot.data![index].serviceImage,
                                    fit: BoxFit.fill,
                                    height: MediaQuery.of(context).size.height *
                                        .07,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .03,
                              )
                            ],
                          ),
                        );
                      }),
                )
              : new Center(child: new CircularProgressIndicator());
        });
  }

  Widget budgetBuyList() {
    return FutureBuilder<List<BookServiceModel>>(
        future: getShopByCategoryLists(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height: MediaQuery.of(context).size.height*.7,
                  width: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: snapshot.data!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (MediaQuery.of(context).orientation ==
                            Orientation.landscape)
                            ? 5 / 1.8
                            : 2.3 / 4,
                  /*      childAspectRatio: (MediaQuery.of(context).orientation ==
                            Orientation.landscape)
                            ? width*.05 / 1.8
                            : width*.5 / 4,*/

                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * .45,
                              decoration: BoxDecoration(
                                  color: ThemeApp.darkGreyTab,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        // height:
                                        //     MediaQuery.of(context).size.height *
                                        //         .26,
                                        // width:
                                        //     MediaQuery.of(context).size.width *
                                        //         .45,
                                        height: SizeConfig.orientations != Orientation.landscape
                                            ? MediaQuery.of(context).size.height * .26
                                            : MediaQuery.of(context).size.height * .1,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: ThemeApp.whiteColor,
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
                                          /*  height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .07,*/ height: (MediaQuery.of(context).orientation ==
                                              Orientation.landscape)
                                              ? MediaQuery.of(context).size.height * .26
                                              : MediaQuery.of(context).size.height * .1,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, right: 10),
                                        child: kmAwayOnMerchantImage(
                                          '1.2 km away',
                                          context,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .01,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: TextFieldUtils()
                                        .homePageTitlesTextFieldsWHITE(
                                            "Beardo ultra glow face", context),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .01,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 18),
                                      child: TextFieldUtils()
                                          .homePageheadingTextFieldWHITE(
                                              "${indianRupeesFormat.format(2250)}", context)),
                                ],
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .03,
                          )
                        ],
                      );
                      /*Container(
                          height: MediaQuery.of(context).size.height * .7,
                          decoration: BoxDecoration(
                              color: ThemeApp.darkGreyTab,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // height:
                                //     MediaQuery.of(context).size.height * .22,
                                // width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context)
                                    .size
                                    .height *
                                    .26,
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    .45,
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
                                  child: Image.network(
                                    // width: double.infinity,
                                    snapshot.data![index].serviceImage,
                                    fit: BoxFit.fill,
                                    height: MediaQuery.of(context).size.height *
                                        .07,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .01,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: TextFieldUtils()
                                    .subHeadingTextFieldsWhite(
                                        snapshot.data![index].serviceName,
                                        context),
                              ),
                              TextFieldUtils().subHeadingTextFieldsWhite(
                                  "    \$250", context)
                            ],
                          ));*/
                    },
                  ))
              : new Center(child: new CircularProgressIndicator());
        });
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
          width: 20.0,
          height: 20.0,
          padding: const EdgeInsets.all(0),
          // decoration:(i == 0 || _curStep > i + 1) ? new  BoxDecoration(
          //
          // ):BoxDecoration(   /* color: circleColor,*/
          //   borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
          //   border: new Border.all(
          //     color: circleColor,
          //     width: 2.0,
          //   ),),
          child: (i == 0 || i == 1 || _curStep > i + 1)
              ? Icon(
                  Icons.circle,
                  color: iconColor,
                  size: 15.0,
                )
              : Icon(
                  Icons.radio_button_checked_outlined,
                  color: iconColor,
                  size: 15.0,
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
            ? TextFieldUtils()
                .stepperTextFields(text, context, ThemeApp.darkGreyTab)
            : TextFieldUtils()
                .stepperTextFields(text, context, ThemeApp.lightGreyTab),
      );
    });
    return list;
  }

  final List<String> imageList = [
    'assets/icons/image.png',
    'assets/icons/image.png',
    'assets/icons/image.png',
    'assets/icons/image.png',
  ];
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

