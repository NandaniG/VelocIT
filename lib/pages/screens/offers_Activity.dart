import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/Model/OfferProductListModel.dart';
import '../../Core/Model/OfferProductModel.dart';
import '../../Core/ViewModel/dashboard_view_model.dart';
import '../../Core/ViewModel/product_listing_view_model.dart';
import '../../Core/data/responses/status.dart';
import '../../services/models/JsonModelForApp/HomeModel.dart';
import '../../services/providers/Home_Provider.dart';
import '../../utils/ProgressIndicatorLoader.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../widgets/global/appBar.dart';
import '../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../Activity/DashBoard_DetailScreens_Activities/Offer_List_Screen.dart';

class OfferActivity extends StatefulWidget {
 // final OfferPayload payload;

  const OfferActivity({Key? key/*,required this.payload*/}) : super(key: key);

  @override
  State<OfferActivity> createState() => _OfferActivityState();
}

class _OfferActivityState extends State<OfferActivity> {
  double height = 0.0;
  double width = 0.0;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  ProductSpecificListViewModel productSpecificListViewModel =
  ProductSpecificListViewModel();



  DashboardViewModel productListView = DashboardViewModel();

  @override
  void initState() {

    productListView.getOfferWithGet();

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: scaffoldGlobalKey,
        backgroundColor: ThemeApp.appBackgroundColor,
        // resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * .12),
            child: appBarWidget(
                context,
                searchBar(context),
                addressWidget(
                    context, StringConstant.placesFromCurrentLocation),
                setState(() {}))),
        bottomNavigationBar: bottomNavigationBarWidget(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        body:




        SafeArea(
          child: SingleChildScrollView(
            child: Consumer<HomeProvider>(builder: (context, provider, child) {

                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       /* bannerOffer(provider.offerList["topBanner"]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),*/TextFieldUtils().headingTextField(
                            StringUtils.lowerPriceOfTheDay,
                            context),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        /*
                        // lowPriceOftTheDayList(),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * .02,
                        // ),
                        TextFieldUtils().headingTextField(
                            StringUtils.appliances, context),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),*/
                        budgetBuyList(),
                        // appliancesList(provider),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * .02,
                        // ),
                        // TextFieldUtils().listHeadingTextField(
                        //     StringUtils.electronics, context),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * .02,
                        // ),
                        // appliancesList(),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * .02,
                        // ),
                        // TextFieldUtils().listHeadingTextField(
                        //     StringUtils.fashion, context),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * .02,
                        // ),
                        // appliancesList(),
                      /*  SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        bannerOffer(provider.offerList["bottomBanner1"]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        bannerOffer(provider.offerList["bottomBanner2"]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),*/
                      ]),
                );
              }
            ),
          ),
        ));
  }
  Widget budgetBuyList() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: productListView,
        child: Consumer<DashboardViewModel>(
            builder: (context, offers, child) {
              switch (offers.offerResponse.status) {
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
                      offers.offerResponse.message.toString());

                case Status.COMPLETED:
                  if (kDebugMode) {
                    print("Api calll");
                  }

                  List<OfferPayload>? offerList = offers.offerResponse.data!
                      .payload;

                  return Container(
                    height: offerList!.length > 2 ? 420 : 240,
                    child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 12,
                          // childAspectRatio: 1.0,
                          childAspectRatio:
                          MediaQuery
                              .of(context)
                              .size
                              .height / 800,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(
                            offerList.length >= 4 ? 4 : offerList.length,
                                (index) {
                              return Container(
                                // height: 191,
                                // width: 191,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OfferListByCategoryActivity(
                                              offerList: offerList[index],
                                            ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Container(
                                        height: 141,
                                        width: 191,
                                        decoration: const BoxDecoration(
                                          color: ThemeApp.whiteColor,
                                          // borderRadius: BorderRadius.only(
                                          //   topRight: Radius.circular(10),
                                          //   topLeft: Radius.circular(10),
                                          // )
                                        ),
                                        child: Image.network(
                                          // width: double.infinity,
                                          offerList[index].offerImageUrl
                                              .toString() ?? "",
                                          // fit: BoxFit.fill,
                                          errorBuilder: ((context, error,
                                              stackTrace) {
                                            return Container(
                                                height: 141,
                                                width: 191,
                                                color: ThemeApp.whiteColor,
                                                child: Icon(
                                                  Icons.image_outlined,
                                                ));
                                          }),
                                          // height: 163,
                                          // width: 191,
                                        ),
                                      ),
                                      SizedBox(),
                                      Container(
                                        color: ThemeApp.tealButtonColor,
                                        width: 191,
                                        // height: 65,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets
                                                  .fromLTRB(
                                                  21, 10, 21, 0),
                                              child: TextFieldUtils()
                                                  .listNameHeadingTextField(
                                                  offerList[index]
                                                      .productSubCategoryName
                                                      .toString() ?? "",
                                                  context) ?? SizedBox() /*Text(
                                                    serviceList[index].shortName!,
                                                    maxLines: 1,
                                                    style: TextStyle(fontFamily: 'Roboto',
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        color:
                                                            ThemeApp.whiteColor,
                                                        fontSize: height * .022,
                                                        fontWeight:
                                                            FontWeight.bold))*/
                                              ,
                                            ),
                                            offerList[index].isAmountBased==true?   Container(
                                              padding: const EdgeInsets
                                                  .fromLTRB(
                                                  21, 4, 21, 9),
                                              child: TextFieldUtils()
                                                  .listPriceHeadingTextField(

                                                  "Under "+  offerList[index]
                                                      .belowAmountDisplay.toString(),
                                                  context),

                                            ):Container(
                                              padding: const EdgeInsets
                                                  .fromLTRB(
                                                  21, 4, 21, 9),
                                              child: TextFieldUtils()
                                                  .listPriceHeadingTextField(

                                                  "Under "+  offerList[index]
                                                      .belowDiscountPercentDisplay.toString(),
                                                  context),

                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                  );

              /*    Container(
                      height: serviceList!.length > 2 ? 480 : 240,
                      // width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.all(12.0),
                      child: GridView.builder(
                        itemCount: 4,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 0.5,
                          crossAxisSpacing: 0.5,
                          // width / height: fixed for *all* items
                          childAspectRatio: 0.85,

                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsActivity(
                                    id: serviceList[index].id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 163,
                                    width: 191,
                                    decoration: const BoxDecoration(
                                        color: ThemeApp.textFieldBorderColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                        )),
                                    child: ClipRRect(
                                        child: Image.network(
                                          // width: double.infinity,
                                          serviceList[index]
                                              .imageUrls![0]
                                              .imageUrl
                                              .toString(),
                                          fit: BoxFit.fill,
                                          errorBuilder: ((context, error, stackTrace) {
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              21, 9, 21, 4),
                                          child: TextFieldUtils()
                                              .listNameHeadingTextField(
                                              serviceList[index].shortName!,
                                              context) */ /*Text(
                                                    serviceList[index].shortName!,
                                                    maxLines: 1,
                                                    style: TextStyle(fontFamily: 'Roboto',
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        color:
                                                            ThemeApp.whiteColor,
                                                        fontSize: height * .022,
                                                        fontWeight:
                                                            FontWeight.bold))*/ /*
                                          ,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              21, 0, 21, 9),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              //discount
                                              TextFieldUtils()
                                                  .listPriceHeadingTextField(
                                                  indianRupeesFormat.format(
                                                      serviceList[index]
                                                          .defaultSellPrice ??
                                                          0.0),
                                                  context),

                                              TextFieldUtils()
                                                  .listScratchPriceHeadingTextField(
                                                  indianRupeesFormat.format(
                                                      serviceList[index]
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
                              */ /* Column(
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
                                          child: serviceList[index]
                                                  .imageUrls![0]
                                                  .imageUrl!
                                                  .isNotEmpty
                                              ? Image.network(
                                                  // width: double.infinity,
                                                  serviceList![index]
                                                      .imageUrls![0]
                                                      .imageUrl!,
                                                  fit: BoxFit.fill,
                                                )
                                              : SizedBox(
                                                  // height: height * .28,
                                                  width: width,
                                                  child: Icon(
                                                    Icons.image_outlined,
                                                    size: 50,
                                                  )),
                                        ),
                                      ),
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
                                                serviceList[index].shortName!,
                                                context),
                                        TextFieldUtils().dynamicText(
                                            "under 9532",
                                            context,
                                            TextStyle(fontFamily: 'Roboto',
                                                color: ThemeApp.whiteColor,
                                                fontSize: height * .022,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )*/ /*
                            ),
                          );
                        },
                      ));*/
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
                                            TextStyle(fontFamily: 'Roboto',
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
*/
  }
Widget productList(List<OfferPayload>? offerList){
    return  Container(
      height: 900,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: offerList!.length,
          itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              TextFieldUtils().headingTextField(
                  offerList[index].productSubCategoryName.toString(), context),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              // appliancesList(offerList[index]),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              /*   TextFieldUtils().listHeadingTextField(
                                  StringUtils.electronics, context),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .02,
                              ),
                              appliancesList(),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .02,
                              ),
                              TextFieldUtils().listHeadingTextField(
                                  StringUtils.fashion, context),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .02,
                              ),
                              appliancesList(),*/
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
            ],
          );
        }
      ),
    );
}
  Widget bannerOffer(String bannerImage) {
    return Container(
      height: height * 0.2,
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .26,
            width: width,
            decoration: BoxDecoration(
                color: ThemeApp.whiteColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                )
              ),
            child: ClipRRect(
              // borderRadius: const BorderRadius.all(
              //   Radius.circular(10),
              // ),
              child: Image.asset(
                  // width: double.infinity,
                  //w:981 h:392
                  bannerImage,
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height * .07,
                  colorBlendMode: BlendMode.modulate,
                  color: Colors.grey.withOpacity(0.7)),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldUtils()
                    .homePageTitlesTextFieldsWHITE("Deal of the day", context),
                TextFieldUtils().homePageheadingTextFieldWHITE(
                    "Up to 70% discounts on clothing", context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget lowPriceOftTheDayList() {
    var orientation =
        (MediaQuery.of(context).orientation == Orientation.landscape);

    return Consumer<HomeProvider>(builder: (context, provider, child) {
    return  Container(
          height:400,
          // padding: EdgeInsets.all(12.0),
          child: GridView.builder(
            itemCount: orientation?2:4,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // childAspectRatio: 3 / 3.1,
                /*childAspectRatio:
                    orientation ? 3 / 3.1 : width * 2 / height * 1,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10*/
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              // width / height: fixed for *all* items
              childAspectRatio: 1,

              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  // height: orientation
                  //     ? height * .6
                  //     : MediaQuery.of(context).size.height * .45,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2,
                        child: Container(
                          // height: orientation
                          //     ? height * .35
                          //     : MediaQuery.of(context).size.height * .16,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: ThemeApp.whiteColor,
                            border: Border.all(color: ThemeApp.tealButtonColor,)
                            /*  borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              )*/),
                          child: ClipRRect(
                          /*  borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),*/
                            child: Image.asset(
                              // width: double.infinity,
                              provider.offerListDetails[index]["offerImage"],
                              // fit: BoxFit.fill,
                              height: orientation
                                  ? height * .35
                                  : MediaQuery.of(context).size.height * .07,
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 1,
                        child: Container(
                          width: width,
                          decoration: BoxDecoration(
                              color: ThemeApp.tealButtonColor,
                             /* borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )*/),
                          padding: orientation
                              ? EdgeInsets.only(top: 10, bottom: 10)
                              : EdgeInsets.zero,
                          child: Column(
                            children: [
                              TextFieldUtils().subHeadingTextFieldsWhite(
                                  provider.offerListDetails[index]["offerName"], context),
                              TextFieldUtils().homePageTitlesTextFieldsWHITE(
                                  'Starting from ${provider.offerListDetails[index]
                                    ["offerDiscountPrice"]}', context)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
            },
          ));
    });
  }

  Widget appliancesList(OfferListContent offerList) {
    var orientation =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    return Container(
                  height: orientation
                      ? MediaQuery.of(context).size.height * .32
                      : height * .35,
                  // padding: EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: offerList.imageUrls!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // childAspectRatio: 3 / 2,
                        childAspectRatio: orientation
                            ? width * 3.2 / height * 0.5
                            : width * 2 / height * 1.5,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          height: MediaQuery.of(context).size.height * .26,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: ThemeApp.whiteColor,
                           /*   borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),*/border: Border.all(color: ThemeApp.tealButtonColor)),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.asset(
                              // width: double.infinity,
                              offerList.imageUrls![index].imageUrl.toString(),
                              // fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * .07,
                            ),
                          ),
                        ),
                      );
                    },
                  ));
  }
}
//
// List<OfferBannerModel> bannerServiceFromJson(String str) =>
//     List<OfferBannerModel>.from(
//         json.decode(str).map((x) => OfferBannerModel.fromJson(x)));
//
// String bookServiceToJson(List<OfferBannerModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class OfferBannerModel {
//   String serviceImage;
//   String serviceName;
//   String serviceDescription;
//   String price;
//
//   OfferBannerModel({
//     required this.serviceImage,
//     required this.serviceName,
//     required this.serviceDescription,
//     required this.price,
//   });
//
//   factory OfferBannerModel.fromJson(Map<String, dynamic> json) =>
//       OfferBannerModel(
//         serviceImage: json["serviceImage"],
//         serviceName: json["serviceName"],
//         serviceDescription: json["serviceDescription"],
//         price: json["price"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "serviceImage": serviceImage,
//         "serviceName": serviceName,
//         "price": price,
//       };
// }
