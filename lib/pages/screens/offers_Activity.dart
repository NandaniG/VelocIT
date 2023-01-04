import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/models/JsonModelForApp/HomeModel.dart';
import '../../services/providers/Home_Provider.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../widgets/global/appBar.dart';
import '../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

class OfferActivity extends StatefulWidget {
  const OfferActivity({Key? key}) : super(key: key);

  @override
  State<OfferActivity> createState() => _OfferActivityState();
}

class _OfferActivityState extends State<OfferActivity> {
  double height = 0.0;
  double width = 0.0;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();



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

        body: SafeArea(
          child: SingleChildScrollView(
            child: Consumer<HomeProvider>(builder: (context, provider, child) {

                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        bannerOffer(provider.offerList["topBanner"]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        TextFieldUtils().headingTextField(
                            StringUtils.lowerPriceOfTheDay,
                            context),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        lowPriceOftTheDayList(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        TextFieldUtils().headingTextField(
                            StringUtils.appliances, context),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        appliancesList(provider),
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
                        bannerOffer(provider.offerList["bottomBanner1"]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        bannerOffer(provider.offerList["bottomBanner2"]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                      ]),
                );
              }
            ),
          ),
        ));
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
                  Radius.circular(10),
                )),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 2,
                        child: Container(
                          // height: orientation
                          //     ? height * .35
                          //     : MediaQuery.of(context).size.height * .16,
                          width: MediaQuery.of(context).size.width,
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
                              provider.offerListDetails[index]["offerImage"],
                              fit: BoxFit.fill,
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
                              color: ThemeApp.darkGreyTab,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )),
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

  Widget appliancesList(HomeProvider provider) {
    var orientation =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    return Container(
                  height: orientation
                      ? MediaQuery.of(context).size.height * .32
                      : height * .35,
                  // padding: EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: provider.offerByType!.length,
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
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              )),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.asset(
                              // width: double.infinity,
                              provider.offerByTypeImagesList[index]["imagesForOffer"],
                              fit: BoxFit.fill,
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
