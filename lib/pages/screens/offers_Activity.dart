import 'dart:convert';

import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../widgets/global/appBar.dart';
import '../../widgets/global/textFormFields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OfferActivity extends StatefulWidget {
  const OfferActivity({Key? key}) : super(key: key);

  @override
  State<OfferActivity> createState() => _OfferActivityState();
}

class _OfferActivityState extends State<OfferActivity> {
  double height = 0.0;
  double width = 0.0;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  Future<List<OfferBannerModel>> getOfferImages() async {
    String response = '['
        '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Appliances","serviceDescription":"Motorola ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV","price":"Starting from 14,232"},'
        '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Electronics","serviceDescription":"Samsang ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV","price":"Starting 5,232"},'
        '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Fashion","serviceDescription":"One Plus ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV","price":"Under 11,232"},'
        '{"serviceImage":"https://picsum.photos/250?image=9","serviceName":"Home","serviceDescription":"IPhone ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV","price":"Min 43% Off"}]';
    var serviceList = bannerServiceFromJson(response);
    return serviceList;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: scaffoldGlobalKey,
        backgroundColor: ThemeApp.backgroundColor,
        // resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * .12),
            child: appBarWidget(context, searchBar(context),
                addressWidget(context,StringConstant.placesFromCurrentLocation), setState(() {}))),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    bannerOffer(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    TextFieldUtils().listHeadingTextField(
                        AppLocalizations.of(context).lowerPriceOfTheDay,
                        context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    lowPriceOftTheDayList(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    TextFieldUtils().listHeadingTextField(
                        AppLocalizations.of(context).appliances, context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    appliancesList(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    TextFieldUtils().listHeadingTextField(
                        AppLocalizations.of(context).electronics, context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    appliancesList(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    TextFieldUtils().listHeadingTextField(
                        AppLocalizations.of(context).fashion, context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    appliancesList(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    bannerOffer(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    bannerOffer(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                  ]),
            ),
          ),
        ));
  }

  Widget bannerOffer() {
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
              child: Image.network(
                  // width: double.infinity,
                  //w:981 h:392
                  'https://picsum.photos/250?image=9',
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

    return FutureBuilder<List<OfferBannerModel>>(
        future: getOfferImages(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height: MediaQuery.of(context).size.height * .48,
                  // padding: EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: snapshot.data!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // childAspectRatio: 3 / 3.1,
                        childAspectRatio:
                            orientation ? 3 / 3.1 : width * 2 / height * 1,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height:  orientation
                              ? height * .6
                              : MediaQuery.of(context).size.height * .45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: orientation
                                    ? height * .35
                                    : MediaQuery.of(context).size.height * .16,
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
                                  child: Image.network(
                                    // width: double.infinity,
                                    snapshot.data![index].serviceImage,
                                    fit: BoxFit.fill,
                                    height: orientation
                                        ? height * .35
                                        : MediaQuery.of(context).size.height *
                                            .07,
                                  ),
                                ),
                              ),
                              Container(
                                width: width,
                                decoration: BoxDecoration(
                                    color: ThemeApp.darkGreyTab,
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    )),
                                padding: orientation? EdgeInsets.only(top: 10, bottom: 10): EdgeInsets.zero,
                                child: Column(
                                  children: [
                                    TextFieldUtils().subHeadingTextFieldsWhite(
                                        snapshot.data![index].serviceName,
                                        context),
                                    TextFieldUtils()
                                        .homePageTitlesTextFieldsWHITE(
                                            snapshot.data![index].price,
                                            context)
                                  ],
                                ),
                              ),
                            ],
                          ));
                    },
                  ))
              : const Center(child: CircularProgressIndicator());
        });
  }

  Widget appliancesList() {
    var orientation =
    (MediaQuery.of(context).orientation == Orientation.landscape);
    return FutureBuilder<List<OfferBannerModel>>(
        future: getOfferImages(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height: orientation ? MediaQuery.of(context).size.height * .32:height*.35,
                  // padding: EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: snapshot.data!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                         SliverGridDelegateWithFixedCrossAxisCount(
                            // childAspectRatio: 3 / 2,
                            childAspectRatio:
                            orientation ? width*3.2 / height*0.5 : width * 2 / height * 1.5,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (){

                        },
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
                            child: Image.network(
                              // width: double.infinity,
                              snapshot.data![index].serviceImage,
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * .07,
                            ),
                          ),
                        ),
                      );
                    },
                  ))
              : const Center(child: CircularProgressIndicator());
        });
  }
}

List<OfferBannerModel> bannerServiceFromJson(String str) =>
    List<OfferBannerModel>.from(
        json.decode(str).map((x) => OfferBannerModel.fromJson(x)));

String bookServiceToJson(List<OfferBannerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OfferBannerModel {
  String serviceImage;
  String serviceName;
  String serviceDescription;
  String price;

  OfferBannerModel({
    required this.serviceImage,
    required this.serviceName,
    required this.serviceDescription,
    required this.price,
  });

  factory OfferBannerModel.fromJson(Map<String, dynamic> json) =>
      OfferBannerModel(
        serviceImage: json["serviceImage"],
        serviceName: json["serviceName"],
        serviceDescription: json["serviceDescription"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "serviceImage": serviceImage,
        "serviceName": serviceName,
        "price": price,
      };
}
