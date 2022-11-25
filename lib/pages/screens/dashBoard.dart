import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/models/JsonModelForApp/HomeModel.dart';
import '../../services/models/demoModel.dart';
import '../../services/providers/Home_Provider.dart';
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

final List<String> titles = ['Order Placed', 'Packed', 'Shipped', 'Delivered'];
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
  var homeData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPincode();
    StringConstant.controllerSpeechToText.clear();
    HomeProvider.signIn();

  }

  getPincode() async {
    await Prefs.instance.getToken(StringConstant.pinCodePref);
    StringConstant.placesFromCurrentLocation =
        (await Prefs.instance.getToken(StringConstant.pinCodePref))!;

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
        preferredSize: Size.fromHeight(height * .12),
        child: appBarWidget(
            context,
            searchBar(context),
            addressWidget(context, StringConstant.placesFromCurrentLocation),
            setState(() {})),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: Consumer<HomeProvider>(builder: (context, provider, child) {
        var data = provider.loadJson();
        print('object-------------' + provider.jsonData.toString());
        return
        SafeArea(
            child: provider.jsonData.isNotEmpty?Container(
                // height: MediaQuery.of(context).size.height,
                // padding: const EdgeInsets.only(
                //   left: 20,
                //   right: 20,
                // ),
                padding: const EdgeInsets.all(10),

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TextFieldUtils()
                      //     .listHeadingTextField(StringConstant.speechToText, context),
                      imageLists(provider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFieldUtils().listHeadingTextField(
                              AppLocalizations.of(context).shopByCategories,
                              context),
                          viewMoreButton(
                              AppLocalizations.of(context).viewAll, context,
                              () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ShopByCategoryActivity(
                                    shopByCategoryList: provider
                                        .jsonData["shopByCategoryList"]),
                              ),
                            );
                          })
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      listOfShopByCategories(provider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFieldUtils().listHeadingTextField(
                              AppLocalizations.of(context).bookOurServices,
                              context),
                          viewMoreButton(AppLocalizations.of(context).viewAll,
                              context, () {})
                        ],
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      listOfBookOurServices(provider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      stepperOfDelivery(provider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      TextFieldUtils().listHeadingTextField(
                          AppLocalizations.of(context).recommendedForYou,
                          context),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      recommendedList(provider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFieldUtils().listHeadingTextField(
                              AppLocalizations.of(context).merchantNearYou,
                              context),
                          viewMoreButton(
                              AppLocalizations.of(context).viewAll, context,
                              () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MerchantActvity(merchantList: provider.merchantNearYouList),
                              ),
                            );
                          })
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      merchantList(provider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      TextFieldUtils().listHeadingTextField(
                          AppLocalizations.of(context).bestDeal, context),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      bestDealList(provider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      TextFieldUtils().listHeadingTextField(
                          AppLocalizations.of(context).budgetBuys, context),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      budgetBuyList(provider),
                    ],
                  ),
                )): Center(child: CircularProgressIndicator(color: ThemeApp.blackColor,)));
      }),
    );
  }

  Widget imageLists(HomeProvider provider) {
    return provider.jsonData.isNotEmpty
        ? FutureBuilder(
            future: provider.homeImageSliderService(),
            builder: (context, snapShot) {
              print("provider.homeSliderList" +
                  provider.homeSliderList.toString());

              //once data is ready this else block will execute
              // items will hold all the data of DataModel
              //items[index].name can be used to fetch name of product as done below
              return Container(
                  height: (MediaQuery.of(context).orientation ==
                          Orientation.landscape)
                      ? height * .5
                      : height * 0.2,width: width,
                  child: Carousel(
                    images: provider.homeSliderList["homeImageSlider"].map((e) {
                      return Card(margin: EdgeInsets.zero,
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
                                Image.asset(
                              e["homeSliderImage"],
                              fit: BoxFit.fill,
                            )),
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
                  ));
            })
        : CircularProgressIndicator();
  }

  // Future<List<BookServiceModel>> getShopByCategoryLists() async {
  //   String response = '['
  //       '{"serviceImage":"assets/images/laptopImage.jpg","serviceName":"Appliances", "sellerName":"sellerName","ratting":0.2,"discountPrice":"47700", "originalPrice":"50600","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"Dell ZX3 108CM (44 inch) ultra HD(4k) LED Smart Android TV","maxCounter":"7","deliveredBy":"Delivered by sep 22"},'
  //       '{"serviceImage":"assets/images/iphones_Image.jpg","serviceName":"Electronics", "sellerName":"sellerName","ratting":3.5,"discountPrice":"12600", "originalPrice":"18990","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"IPhone 14 108CM LED smart display","maxCounter":"5","deliveredBy":"Delivered by sep 12"},'
  //       '{"serviceImage":"assets/images/laptopImage2.jpg","serviceName":"Home", "sellerName":"sellerName","ratting":4.0,"discountPrice":"21300", "originalPrice":"23300","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"Asus IK02 108CM (46 inch) ultra HD(4k) LED Smart","maxCounter":"5","deliveredBy":"Delivered by sep 03"},'
  //       '{"serviceImage":"assets/images/laptopImage.jpg","serviceName":"Electronics", "sellerName":"sellerName","ratting":4.5,"discountPrice":"42300", "originalPrice":"47600","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"HP WES3 108CM (41 inch) ultra HD(4k) LED Smart Android TV","maxCounter":"5","deliveredBy":"Delivered by sep 30"},'
  //       '{"serviceImage":"assets/images/laptopImage3.jpg","serviceName":"Fashion", "sellerName":"sellerName","ratting":2.8,"discountPrice":"14500", "originalPrice":"16400","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"Lenovo ZX3 108CM (46 inch) ultra HD(4k) LED Smart Android ","maxCounter":"8","deliveredBy":"Delivered by oct 01"},'
  //       '{"serviceImage":"assets/images/IPhoneImage.jpg","serviceName":"Home", "sellerName":"sellerName","ratting":4.8,"discountPrice":"65200", "originalPrice":"68300","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"IPhone 13 108CM (47 inch) ultra HD(4k) LED Smart Android TV","maxCounter":"10","deliveredBy":"Delivered by dec 31"}]';
  //   var serviceList = bookServiceFromJson(response);
  //   return serviceList;
  // }

  Widget listOfShopByCategories(HomeProvider provider) {
    return provider.jsonData.isNotEmpty
        ? FutureBuilder(
            future: provider.shopByCategoryService(),
            builder: (context, snapshot) {
              print("provider.shopByCategoryService" +
                  provider.shopByCategoryList.toString());

              if (snapshot.hasError) print(snapshot.error);
              return Container(
                height: MediaQuery.of(context).size.height * .13,
                width: width,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.shopByCategoryList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ShopByCategoryActivity(
                                  shopByCategoryList:
                                  provider.shopByCategoryList),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                  provider.shopByCategoryList[
                                                          index]
                                                      ["shopCategoryImage"],
                                                )))),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .01,
                                    ),
                                    TextFieldUtils().appliancesTitleTextFields(
                                        provider.shopByCategoryList[index]
                                            ['shopCategoryName'],
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
              );
            })
        : CircularProgressIndicator();
  }

  Widget listOfBookOurServices(HomeProvider provider) {
    return FutureBuilder(
        future: provider.bookOurServicesService(),
        builder: (context, snapshot) {
          print("provider.bookOurServicesService" +
              provider.bookOurServicesList.toString());

          if (snapshot.hasError) print(snapshot.error);
        return Container(
          height: MediaQuery.of(context).size.height * .13,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: provider.bookOurServicesList.length,
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                            provider.bookOurServicesList
                                                [index]["bookOurServicesImage"],
                                          )))),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .01,
                              ),
                              TextFieldUtils().appliancesTitleTextFields(
                                  provider.bookOurServicesList[index]
                                      ["bookOurServicesName"],
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
        );
      }
    );
  }

  Widget stepperOfDelivery(HomeProvider provider) {
    return  Container(
                  height: height * .225,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.jsonData["stepperOfDeliveryList"].length,
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

                                        Container(
                                            width: 60.0,
                                            height: 60.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new AssetImage(
                                                      provider.jsonData["stepperOfDeliveryList"][index]["stepperOfDeliveryImage"],
                                                    )))),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .03,
                                        ),
                                        Flexible(
                                          child: TextFieldUtils()
                                              .stepperHeadingTextFields(
                                              provider.jsonData["stepperOfDeliveryList"][index]["stepperOfDeliveryDescription"]
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
                );

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

  Widget recommendedList(HomeProvider provider) {
    return  FutureBuilder(
        future: provider.recommendedListService(),
        builder: (context, snapshot) {
          print("provider.recommendedListService" +
              provider.recommendedList.toString());

          if (snapshot.hasError) print(snapshot.error);
        return Container(
          height: MediaQuery.of(context).size.height * .35,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: provider.recommendedList.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Container(
                        // height: MediaQuery.of(context).size.height * .3,

                        // width: 200,
                        width: MediaQuery.of(context).size.width * .45,
                        decoration: BoxDecoration(
                            color: ThemeApp.whiteColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .26,
                              width: MediaQuery.of(context).size.width * .45,
                              decoration: BoxDecoration(
                                  color: ThemeApp.textFieldBorderColor,
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
                                  provider.recommendedList[index]
                                      ["recommendedForYouImage"],
                                  fit: BoxFit.fill,
                                  height: MediaQuery.of(context).size.height * .07,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Container(
                              padding:  EdgeInsets.only(left: 10,right: 10),
                              child: TextFieldUtils().homePageTitlesTextFields(
                                  provider.recommendedList[index]
                                      ["recommendedForYouDescription"],
                                  context),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Container(
                              padding:  EdgeInsets.only(left: 10,right: 10),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextFieldUtils().homePageheadingTextField(
                                      indianRupeesFormat.format(int.parse(provider.recommendedList[index]["recommendedForYouDiscountPrice"].toString())),
                                      context),
                                  TextFieldUtils().homePageheadingTextFieldLineThrough(
                                      indianRupeesFormat.format(int.parse(provider.recommendedList[index]["recommendedForYouPrice"].toString())),
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
        );
      }
    );
  }

  Widget merchantList(HomeProvider provider) {

    return FutureBuilder(
        future: provider.merchantNearYouListService(),
        builder: (context, snapshot) {
          // print("provider.merchantNearYouListService" +
          //     provider.merchantNearYouList.toString());

          if (snapshot.hasError) print(snapshot.error);
        return Container(
          height: MediaQuery.of(context).size.height * .35,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: provider.merchantNearYouList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MerchantActvity(merchantList: provider.merchantNearYouList[index]),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * .45,
                          decoration: BoxDecoration(
                              color: ThemeApp.darkGreyTab,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height * .26,
                                    width: MediaQuery.of(context).size.width * .45,
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
                                      child: Image.asset(
                                        // width: double.infinity,
                                        provider.merchantNearYouList
                                            [index]["merchantNearYouImage"],
                                        fit: BoxFit.fill,
                                        height: MediaQuery.of(context).size.height *
                                            .07,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 10, right: 10),
                                    child: kmAwayOnMerchantImage(
                                      provider.merchantNearYouList
                                          [index]["merchantNearYoukmAWAY"],
                                      context,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .01,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 10, right: 10),                                child: TextFieldUtils()
                                    .homePageTitlesTextFieldsWHITE(
                                    provider.merchantNearYouList
                                            [index]["merchantNearYouDescription"],
                                        context),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .01,
                              ),
                              Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 10),                                     child: TextFieldUtils().homePageheadingTextFieldWHITE(
                                      indianRupeesFormat.format(int.parse(provider.merchantNearYouList[index]["merchantNearYouPrice"].toString())),
                                      context)),
                            ],
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .03,
                      )
                    ],
                  ),
                );
              }),
        );
      }
    );
  }

  Widget bestDealList(HomeProvider provider) {
    return FutureBuilder(
        future: provider.bestDealListService(),
        builder: (context, snapshot) {
          print("provider.bestDealListService" +
              provider.bestDealList.toString());

          if (snapshot.hasError) print(snapshot.error);
        return Container(
          height: MediaQuery.of(context).size.height * .35,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: provider.bestDealList.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Container(
                      // height: MediaQuery.of(context).size.height * .3,

                      // width: 200,
                        width: MediaQuery.of(context).size.width * .45,
                        decoration: BoxDecoration(
                            color: ThemeApp.whiteColor,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .26,
                              width: MediaQuery.of(context).size.width * .45,
                              decoration: BoxDecoration(
                                  color: ThemeApp.textFieldBorderColor,
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
                                  provider.bestDealList[index]
                                  ["bestDealImage"],
                                  fit: BoxFit.fill,
                                  height: MediaQuery.of(context).size.height * .07,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Container(
                              padding:  EdgeInsets.only(left: 10,right: 10),
                              child: TextFieldUtils().homePageTitlesTextFields(
                                  provider.bestDealList[index]
                                  ["bestDealDescription"],
                                  context),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Container(
                              padding:  EdgeInsets.only(left: 10,right: 10),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextFieldUtils().homePageheadingTextField(
                                      indianRupeesFormat.format(int.parse(provider.bestDealList[index]["bestDealDiscountPrice"].toString())),
                                      context),
                                  TextFieldUtils().homePageheadingTextFieldLineThrough(
                                      indianRupeesFormat.format(int.parse(provider.bestDealList[index]["bestDealPrice"].toString())),
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
        );

          /* Container(
          height: MediaQuery.of(context).size.height * .3,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: provider.bestDealList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Image.asset(
                            // width: double.infinity,
                            provider.bestDealList[index]
                                ["bestDealImage"],
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height * .07,
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
        );*/
      }
    );
  }

  Widget budgetBuyList(HomeProvider provider) {
    return FutureBuilder(
        future: provider.budgetBuyListService(),
        builder: (context, snapshot) {
          print("provider.budgetBuyListService" +
              provider.budgetBuyList.toString());

          if (snapshot.hasError) print(snapshot.error);
        return Container(
            height: MediaQuery.of(context).size.height * .7,
            width: MediaQuery.of(context).size.width,
            // padding: EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio:
                      (MediaQuery.of(context).orientation == Orientation.landscape)
                          ? 5 / 1.8
                          : 2.3 / 3.2,
                  /*      childAspectRatio: (MediaQuery.of(context).orientation ==
                                Orientation.landscape)
                                ? width*.05 / 1.8
                                : width*.5 / 4,*/

                  crossAxisCount: 2,
                  crossAxisSpacing: width*.02,
                  mainAxisSpacing: 2),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * .45,
                        decoration: BoxDecoration(
                            color: ThemeApp.darkGreyTab,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
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
                                  height:
                                  MediaQuery.of(context).size.height * .25,
                                  width: MediaQuery.of(context).size.width * .45,
                                  // height: SizeConfig.orientations !=
                                  //         Orientation.landscape
                                  //     ? MediaQuery.of(context).size.height * .26
                                  //     : MediaQuery.of(context).size.height * .1,
                                  // width: MediaQuery.of(context).size.width,
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
                                    child: Image.asset(
                                      // width: double.infinity,
                                      provider.budgetBuyList[index]
                                          ["budgetBuyImage"],
                                      fit: BoxFit.fill,
                                        // height: MediaQuery.of(context)
                                        //                 .size
                                        //                 .height *
                                        //             .07,
                                      // height: (MediaQuery.of(context).orientation ==
                                      //         Orientation.landscape)
                                      //     ? MediaQuery.of(context).size.height * .26
                                      //     : MediaQuery.of(context).size.height * .1,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 10),
                                  child: kmAwayOnMerchantImage(
                                    provider.budgetBuyList[index]
                                        ["kmAWAY"],
                                    context,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 10,right: 10),                                child: TextFieldUtils().homePageTitlesTextFieldsWHITE(
                                  provider.budgetBuyList[index]
                                      ["budgetBuyDescription"],
                                  context),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .01,
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                child: TextFieldUtils().homePageheadingTextFieldWHITE(
                                    indianRupeesFormat.format(int.parse(provider.budgetBuyList[index]["budgetBuyPrice"])),
                                    context)),
                          ],
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .03,
                    )
                  ],
                );
              },
            ));
      }
    );
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
