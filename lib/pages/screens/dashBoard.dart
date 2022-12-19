import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocit/Core/Model/CategoriesModel.dart';
import 'package:velocit/Core/repository/dashboard_repository.dart';
import 'package:velocit/utils/ProgressIndicatorLoader.dart';
import '../../Core/Model/ProductCategoryModel.dart';
import '../../Core/Model/ProductListingModel.dart';
import '../../Core/Model/servicesModel.dart';
import '../../Core/ViewModel/dashboard_view_model.dart';
import '../../Core/ViewModel/product_listing_view_model.dart';
import '../../Core/data/responses/status.dart';
import '../../services/models/JsonModelForApp/HomeModel.dart';
import '../../services/models/demoModel.dart';
import '../../services/providers/Home_Provider.dart';
import '../../utils/StringUtils.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/appBar.dart';
import '../../widgets/global/proceedButtons.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/global/textFormFields.dart';
import '../Activity/DashBoard_DetailScreens_Activities/BookService_Activity.dart';
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

  DashboardViewModel dashboardViewModel = DashboardViewModel();
  DashboardViewModel serviceViewModel = DashboardViewModel();
  DashboardViewModel productCategories = DashboardViewModel();

  double height = 0.0;
  double width = 0.0;
  String location = 'Null, Press Button';
  String Address = 'search';
  var homeData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productCategories.productCategoryListingWithGet();

    dashboardViewModel.shopByCategoriesWithGet();
    serviceViewModel.bookOurServicesWithGet();
    dashboardViewModel.productListingWithGet();
    getPincode();
    StringConstant.controllerSpeechToText.clear();
    Provider.of<HomeProvider>(context, listen: false).loadJson();
  }

  getPincode() async {
    await Prefs.instance.getToken(StringConstant.pinCodePref);
    StringConstant.placesFromCurrentLocation =
        (await Prefs.instance.getToken(StringConstant.pinCodePref))!;

    print(
        "placesFromCurrentLocation pref...${StringConstant.placesFromCurrentLocation.toString()}");
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
          preferredSize: Size.fromHeight(height * .12),
          child: appBarWidget(
              context,
              searchBar(context),
              addressWidget(context, StringConstant.placesFromCurrentLocation),
              setState(() {})),
        ),
        bottomNavigationBar: bottomNavigationBarWidget(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: /*ChangeNotifierProvider<DashboardViewModel>(
            create: (BuildContext context) => dashboardViewModel,
            child: Consumer<DashboardViewModel>(
                builder: (context, dashboardProvider, child) {
              switch (dashboardProvider.categoryList.status) {
                case Status.LOADING:
                  print("Api load");

                  return CircularProgressIndicator();
                case Status.ERROR:
                  print("Api error");

                  return Text(
                      dashboardProvider.categoryList.message.toString());
                case Status.COMPLETED:
                  print("Api calll");
                  return listOfShopByCategories(dashboardProvider
                      .categoryList.data!.response!.body!.payload);
              }
              return Text("sahdjashdj");
            }))*/

            ChangeNotifierProvider<DashboardViewModel>(
          create: (BuildContext context) => dashboardViewModel,
          child: Consumer<DashboardViewModel>(
              builder: (context, dashboardProvider, child) {
            // print('object-------------' + provider.jsonData.toString());
            return Consumer<HomeProvider>(builder: (context, provider, child) {
              var data = provider.loadJson();
              return SafeArea(
                  child: provider.jsonData.isNotEmpty
                      ? Container(
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
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),

                                listOfShopByCategories(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),

                                listOfBookOurServices(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
                                stepperOfDelivery(provider),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
                                TextFieldUtils().listHeadingTextField(
                                    StringUtils
                                        .recommendedForYou,
                                    context),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
                                recommendedList(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextFieldUtils().listHeadingTextField(
                                        StringUtils
                                            .merchantNearYou,
                                        context),
                                    viewMoreButton(
                                        StringUtils.viewAll,
                                        context, () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MerchantActvity(
                                              merchantList: provider
                                                  .merchantNearYouList[1]),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
                                merchantList(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
                                TextFieldUtils().listHeadingTextField(
                                    StringUtils.bestDeal,
                                    context),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
                                bestDealList(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
                                TextFieldUtils().listHeadingTextField(
                                    StringUtils.budgetBuys,
                                    context),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
                                budgetBuyList(),
                              ],
                            ),
                          ))
                      : const Center(
                          child: CircularProgressIndicator(
                          color: ThemeApp.blackColor,
                        )));
            });
          }),
        ));
  }

  Widget imageLists(HomeProvider provider) {
    return provider.jsonData.isNotEmpty
        ? FutureBuilder(
            future: provider.homeImageSliderService(),
            builder: (context, snapShot) {
              return Container(
                  height: (MediaQuery.of(context).orientation ==
                          Orientation.landscape)
                      ? height * .5
                      : height * 0.2,
                  width: width,
                  child: Carousel(
                    images: provider.homeSliderList["homeImageSlider"].map((e) {
                      return Card(
                        margin: EdgeInsets.zero,
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
                    dotIncreasedColor: ThemeApp.lightGreyTab,
                    indicatorBgPadding: 10.0,
                    dotBgColor: Colors.transparent,
                    animationDuration: const Duration(milliseconds: 100),
                    borderRadius: true,
                    boxFit: BoxFit.cover,
                    dotPosition: DotPosition.bottomCenter,
                  ));
            })
        : const CircularProgressIndicator();
  }

  Widget listOfShopByCategories() {
    return ChangeNotifierProvider<DashboardViewModel>(
        create: (BuildContext context) => productCategories,
        child: Consumer<DashboardViewModel>(
            builder: (context, productCategories, child) {
          switch (productCategories.productCategoryList.status) {
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
                  productCategories.productCategoryList.message.toString());

            case Status.COMPLETED:
              if (kDebugMode) {
                print("Api calll");
              }

              List<ProductList>? serviceList =
                  productCategories.productCategoryList.data!.productList;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFieldUtils().listHeadingTextField(
                          StringUtils.bookOurServices,
                          context),
                      viewMoreButton(
                          StringUtils.viewAll, context, () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BookServiceActivity(
                                shopByCategoryList: serviceList!,
                                shopByCategorySelected: 0),
                          ),
                        );
                      })
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .13,
                    width: width,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: serviceList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BookServiceActivity(
                                      shopByCategoryList: serviceList!,
                                      shopByCategorySelected: index),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: width * 0.24,
                                    decoration: const BoxDecoration(
                                        color: ThemeApp.whiteColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50)),
                                            child: Image.network(
                                              // width: double.infinity,
                                              serviceList[index]
                                                  .productCategoryImageId!,
                                              fit: BoxFit.fill,

                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .07,
                                            ),
                                          ),
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

                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .01,
                                          ),
                                          Center(
                                            child: TextFieldUtils().dynamicText(
                                                serviceList[index].name!,
                                                context,
                                                TextStyle(
                                                  color: ThemeApp.darkGreyColor,
                                                  // fontWeight: FontWeight.w500,
                                                  fontSize: height * .02,
                                                )),
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .03,
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            default:
              return Text("No Data found!");
          }
          return Text("No Data found!");
        }));
  }

  Widget listOfBookOurServices() {
    return ChangeNotifierProvider<DashboardViewModel>(
        create: (BuildContext context) => productCategories,
        child: Consumer<DashboardViewModel>(
            builder: (context, productCategories, child) {
          switch (productCategories.productCategoryList.status) {
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
                  productCategories.productCategoryList.message.toString());

            case Status.COMPLETED:
              if (kDebugMode) {
                print("Api calll");
              }

              List<ProductList>? serviceList =
                  productCategories.productCategoryList.data!.productList;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFieldUtils().listHeadingTextField(
                          StringUtils.bookOurServices,
                          context),
                      viewMoreButton(
                          StringUtils.viewAll, context, () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BookServiceActivity(
                                shopByCategoryList: serviceList!,
                                shopByCategorySelected: 0),
                          ),
                        );
                      })
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .13,
                    width: width,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: serviceList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BookServiceActivity(
                                      shopByCategoryList: serviceList!,
                                      shopByCategorySelected: index),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: width * 0.24,
                                    decoration: const BoxDecoration(
                                        color: ThemeApp.whiteColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50)),
                                            child: Image.network(
                                              // width: double.infinity,
                                              serviceList[index]
                                                  .productCategoryImageId!,
                                              fit: BoxFit.fill,

                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .07,
                                            ),
                                          ),
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

                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .01,
                                          ),
                                          Center(
                                            child: TextFieldUtils().dynamicText(
                                                serviceList[index].name!,
                                                context,
                                                TextStyle(
                                                  color: ThemeApp.darkGreyColor,
                                                  // fontWeight: FontWeight.w500,
                                                  fontSize: height * .02,
                                                )),
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .03,
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            default:
              return Text("No Data found!");
          }
          return Text("No Data found!");
        }));
  }

  Widget stepperOfDelivery(HomeProvider provider) {
    return Container(
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
                    decoration: const BoxDecoration(
                        color: ThemeApp.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                                          provider.jsonData[
                                                  "stepperOfDeliveryList"]
                                              [index]["stepperOfDeliveryImage"],
                                        )))),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .03,
                            ),
                            Flexible(
                              child: TextFieldUtils().stepperHeadingTextFields(
                                  provider.jsonData["stepperOfDeliveryList"]
                                          [index]
                                          ["stepperOfDeliveryDescription"]
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

  Widget recommendedList() {
    return ChangeNotifierProvider<DashboardViewModel>(
        create: (BuildContext context) => dashboardViewModel,
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
                                                TextStyle(
                                                    color: ThemeApp.blackColor,
                                                    fontSize: height * .022,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextFieldUtils().dynamicText(
                                                indianRupeesFormat.format(
                                                    productListing[index]
                                                            .currentPrice ??
                                                        0.0),
                                                context,
                                                TextStyle(
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
  }

  Widget merchantList() {
    return ChangeNotifierProvider<DashboardViewModel>(
        create: (BuildContext context) => dashboardViewModel,
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
                        return InkWell(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => MerchantActvity(
                            //         merchantList:
                            //             provider.merchantNearYouList[index]),
                            //   ),
                            // );
                          },
                          child: Row(
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * .45,
                                  decoration: const BoxDecoration(
                                      color: ThemeApp.darkGreyTab,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .28,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .45,
                                            decoration: const BoxDecoration(
                                                color: ThemeApp.whiteColor,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                )),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                              child: Image.network(
                                                // width: double.infinity,
                                                productListing[index]
                                                    .image1Url!,
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
                                              '1.2 KM away',
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
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(10),
                                        child: TextFieldUtils()
                                            .homePageTitlesTextFieldsWHITE(
                                                productListing[index]
                                                    .shortName!,
                                                context),
                                      ),
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
              default:
                return Text("No Data found!");
            }
            return Text("No Data found!");
          });
        }));
  }

  Widget bestDealList() {
    return ChangeNotifierProvider<DashboardViewModel>(
        create: (BuildContext context) => dashboardViewModel,
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
                                    Container(
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
                                              TextStyle(
                                                  color: ThemeApp.blackColor,
                                                  fontSize: height * .022,
                                                  fontWeight: FontWeight.bold)),
                                          TextFieldUtils().dynamicText(
                                              indianRupeesFormat.format(
                                                  productListing[index]
                                                          .currentPrice ??
                                                      0.0),
                                              context,
                                              TextStyle(
                                                  color: ThemeApp.darkGreyTab,
                                                  fontSize: height * .02,
                                                  fontWeight: FontWeight.w500,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  decorationThickness: 1.5)),
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
              default:
                return Text("No Data found!");
            }
            return Text("No Data found!");
          });
        }));
  }

  Widget budgetBuyList() {
    return ChangeNotifierProvider<DashboardViewModel>(
        create: (BuildContext context) => dashboardViewModel,
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
                    height: 580,
                    // width: MediaQuery.of(context).size.width,
                    // padding: EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                        // width / height: fixed for *all* items
                        childAspectRatio: 0.75,

                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: ThemeApp.darkGreyTab,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .25,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            color: ThemeApp.whiteColor,
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
                                            productListing![index].image1Url!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, right: 10),
                                        child: kmAwayOnMerchantImage(
                                          '1.1 KM away',
                                          context,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  // flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFieldUtils()
                                            .homePageTitlesTextFieldsWHITE(
                                                productListing[index]
                                                    .shortName!,
                                                context),
                                        TextFieldUtils().dynamicText(
                                            indianRupeesFormat.format(
                                                productListing[index]
                                                    .currentPrice),
                                            context,
                                            TextStyle(
                                                color: ThemeApp.whiteColor,
                                                fontSize: height * .022,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ));
                      },
                    ));
              default:
                return Text("No Data found!");
            }
            return Text("No Data found!");
          });
        }));
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
