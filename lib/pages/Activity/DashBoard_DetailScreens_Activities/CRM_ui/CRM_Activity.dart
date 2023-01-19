import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../Core/Model/CRMModel.dart';
import '../../../../Core/Model/CategoriesModel.dart';
import '../../../../Core/Model/ProductCategoryModel.dart';
import '../../../../Core/Model/ServiceModels/ServiceCategoryAndSubCategoriesModel.dart';
import '../../../../Core/ViewModel/dashboard_view_model.dart';
import '../../../../Core/data/responses/status.dart';
import '../../../../services/models/demoModel.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/ProgressIndicatorLoader.dart';
import '../../../../utils/StringUtils.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../homePage.dart';
import '../../../screens/dashBoard.dart';
import '../../Product_Activities/Products_List.dart';
import '../service_ui/ServicesDetailScreen.dart';

class CRMActivity extends StatefulWidget {
  // List<ProductList>? shopByCategoryList;
  // final int shopByCategorySelected;

  CRMActivity({
    Key? key,
    // required this.shopByCategoryList,
    // required this.shopByCategorySelected,
  }) : super(key: key);

  @override
  State<CRMActivity> createState() => _CRMActivityState();
}

class _CRMActivityState extends State<CRMActivity> {
  int selected = 0;
  double height = 0.0;
  double width = 0.0;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  DashboardViewModel productViewModel = DashboardViewModel();
  Map data = {
    "category_code": "EOLP",
    "recommended_for_you": "1",
    "Merchants Near You": "1",
    "best_deal": "",
    'budget_buys': ""
  };
  var dataJson;

  @override
  void initState() {
    // TODO: implement initState


    dataJson = productViewModel.CRMListingWithGet();
    super.initState();
  }

  Future<List<Payloads>> getImageSlide() async {
    String response = '['
        '{"sponsorlogo":"assets/images/laptopImage.jpg"},'
        '{"sponsorlogo":"assets/images/iphones_Image.jpg"},'
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"}]';
    var payloadList = payloadFromJson(response);
    return payloadList;
  }

  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: scaffoldGlobalKey,
        backgroundColor: ThemeApp.appBackgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .12),
          child: appBarWidget(
              context,
              searchBar(context),
              addressWidget(context, StringConstant.placesFromCurrentLocation),
              setState(() {})),
        ),
        bottomNavigationBar: bottomNavigationBarWidget(context,0),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: SingleChildScrollView(
            child: ChangeNotifierProvider<DashboardViewModel>.value(
              value: productViewModel,
              child: dataJson == ''
                  ? CircularProgressIndicator()
                  : Consumer<DashboardViewModel>(
                  builder: (context, productCategories, child) {
                    switch (productCategories.CRMList.status) {
                      case Status.LOADING:
                        if (kDebugMode) {
                          print("Api load");
                        }
                        return ProgressIndicatorLoader(true);

                      case Status.ERROR:
                        if (kDebugMode) {
                          print("Api error");
                        }
                        return Text(productCategories
                            .CRMList.message
                            .toString());

                      case Status.COMPLETED:
                        if (kDebugMode) {
                          print("Api calll");
                        }
                        List<CRMPayload> crmPayload =
                        productCategories
                            .CRMList.data!.payload!;
                        return crmPayload.length==[]?CircularProgressIndicator():Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imageLists(),
                                // carouselImages(),
                                SizedBox(
                                  height: height * .02,
                                ),
                                TextFieldUtils().dynamicText(
                                    StringUtils.bookOurServices,
                                    context,
                                    TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.primaryNavyBlackColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: height * .03,
                                    )),

                                SizedBox(
                                  height: height * .02,
                                ),

                                ListView.builder(
                                  key: Key('builder ${selected.toString()}'),
                                  shrinkWrap: true,
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  itemCount: productCategories
                                      .CRMList
                                      .data!
                                      .payload!
                                      .length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            ExpansionTile(
                                              key: Key(index.toString()),
                                              onExpansionChanged:
                                              ((newState) {
                                                if (newState) {
                                                  setState(() {
                                                    const Duration(
                                                        seconds: 20000);
                                                    selected = index;
                                                  });
                                                } else {
                                                  setState(() {
                                                    selected = -1;
                                                  });
                                                }
                                              }),
                                              initiallyExpanded:
                                              index == selected,

                                              // initiallyExpanded: selected,
                                              // trailing: selected == true
                                              //     ? Icon(
                                              //         Icons.arrow_drop_up,
                                              //         color:
                                              //             ThemeApp.textFieldBorderColor,
                                              //         size: height * .05,
                                              //       )
                                              //     : Icon(
                                              //         Icons.arrow_drop_down,
                                              //         color:
                                              //             ThemeApp.textFieldBorderColor,
                                              //         size: height * .05,
                                              //       ),
                                              // tilePadding: const EdgeInsets.symmetric(
                                              //     horizontal: 15, vertical: 2),
                                              // childrenPadding: const EdgeInsets.symmetric(
                                              //     horizontal: 15, vertical: 5),
                                              textColor: Colors.black,
                                              title: Row(
                                                children: [
                                                  Container( color: ThemeApp
                                                      .appColor,
                                                    height: 17,
                                                    width: 19,
                                                    // borderRadius:
                                                    // const BorderRadius.all(
                                                    //     Radius.circular(50)),
                                                    child: Image.network(
                                                     crmPayload[index]
                                                          .crmCategoryImageId ??
                                                          "",
                                                      // fit: BoxFit.fill,
                                                      height: 17,
                                                      width: 19,
                                                      errorBuilder:
                                                          (context, error,
                                                          stackTrace) {
                                                        return Icon(
                                                          Icons.image,
                                                          color: ThemeApp
                                                              .appColor,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  /*  SvgPicture.asset(
                                                      'assets/appImages/appliancesIcon.svg',
                                                      height: 17,
                                                      width: 26,
                                                    ),*/
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  categoryListFont(
                                                      crmPayload[index]
                                                          .name!,
                                                      context)
                                                ],
                                              ),
                                              expandedAlignment:
                                              Alignment.centerLeft,
                                              expandedCrossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 15),
                                                  child: subListOfCategories(
                                                      productCategories
                                                          .CRMList.data!.payload![index]),
                                                )
                                              ],
                                            ),
                                          ]),
                                    );
                                  },
                                )
                              ]),
                        );
                    }
                    return Text('');
                  }),
            ),
          ),
        ));
  }

  Widget categoryListFont(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.25,
          color: ThemeApp.primaryNavyBlackColor),
    );
  }

  Widget subCategoryListFont(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 13,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.25,
          color: ThemeApp.primaryNavyBlackColor),
    );
  }

  Widget imageLists() {
    return FutureBuilder<List<Payloads>>(
        future: getImageSlide(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? /*Container(
                  height: height * 0.23,
                  child: CarouselSlider(
                    items: snapshot.data?.map((e) {
                      return Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        color: ThemeApp.whiteColor,
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: */ /*Image.network(
                            // width: double.infinity,
                            e.sponsorlogo,
                            fit: BoxFit.fill,
                          ),*/ /*
                                Image.asset(
                              e.sponsorlogo,
                              fit: BoxFit.fill,
                            )),
                      );
                    }).toList(),
                   */ /* dotSize: 8.0,
                    autoplay: false,
                    dotSpacing: 15.0,
                    dotColor: ThemeApp.lightGreyTab,
                    dotIncreasedColor: ThemeApp.darkGreyTab,
                    indicatorBgPadding: 10.0,
                    dotBgColor: Colors.transparent,
                    borderRadius: true,
                    boxFit: BoxFit.cover,
                    dotPosition: DotPosition.bottomCenter,*/ /*
                    options: CarouselOptions(
                      autoPlay: false
                    ),
                  ))*/
          Container(
              height: (MediaQuery.of(context).orientation ==
                  Orientation.landscape)
                  ? height * .5
                  : height * 0.2,
              width: width,
              child: CarouselSlider(
                items: snapshot.data?.map((e) {
                  return Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    color: ThemeApp.whiteColor,
                    child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          width: width,
                          color: Colors.white,
                          child: Image.asset(
                            e.sponsorlogo,
                            fit: BoxFit.fill,
                          ),
                        )),
                  );
                }).toList(),
                options: CarouselOptions(
                    autoPlay: false,
                    viewportFraction: 1,
                    height: height * .3),
              ))
              : const Center(child: CircularProgressIndicator());
        });
  }

  Widget subListOfCategories(CRMPayload servicePayload) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
        // childAspectRatio: 1.0,
        childAspectRatio: MediaQuery.of(context).size.height / 500,
      ),itemCount: servicePayload.simpleSubCats!.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => ServiceDetailScreen(
            //       productList: servicePayload.simpleSubCats![index]),
            // ));
          },
          // child: Padding(
          // padding: const EdgeInsets.only(right: 8.0, bottom: 8),
          child: Container(
            // width: width * .25,
              width: 97,
              height: 59,
              padding: EdgeInsets.fromLTRB(14, 10, 16, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: ThemeApp.containerColor, width: 1.5),
                  color: ThemeApp.containerColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                           Container( color: ThemeApp
                      .appColor,
                    height: 17,
                    width: 19,
                    // borderRadius:
                    // const BorderRadius.all(
                    //     Radius.circular(50)),
                    child: Image.network(
                      servicePayload.simpleSubCats![index]
                          .imageUrl ??
                          "",
                      // fit: BoxFit.fill,
                      height: 17,
                      width: 19,
                      errorBuilder:
                          (context, error,
                          stackTrace) {
                        return Container(
                          height: 17,
                          width: 19,
                          child: Icon(
                            Icons.image,
                            color: ThemeApp
                                .whiteColor,
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    height: 6,
                  ),
                  subCategoryListFont(
                      servicePayload.simpleSubCats![index].name.toString()??"",
                      context),
                ],
              )),
          // ),
        );
      },
    );

  }
}
