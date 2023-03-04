import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Core/Model/CRMModel.dart';
import '../../../../Core/Model/CategoriesModel.dart';
import '../../../../Core/Model/ProductCategoryModel.dart';
import '../../../../Core/Model/ServiceModels/ServiceCategoryAndSubCategoriesModel.dart';
import '../../../../Core/ViewModel/dashboard_view_model.dart';
import '../../../../Core/data/responses/status.dart';
import '../../../../services/models/demoModel.dart';
import '../../../../services/providers/Home_Provider.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/ProgressIndicatorLoader.dart';
import '../../../../utils/StringUtils.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/routes/routes.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../homePage.dart';
import '../../../screens/dashBoard.dart';
import '../../Product_Activities/Products_List.dart';
import '../service_ui/Service_Categories_Activity.dart';
import '../service_ui/ServicesDetailScreen.dart';
import 'CRM_List_Screen.dart';

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
    _isCRMListChip = true;

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

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .pop();
        return Future.value(true);
      },
      child: Scaffold(
          key: scaffoldGlobalKey,
          backgroundColor: ThemeApp.appBackgroundColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * .135),
            child: AppBarWidget(
              context: context,
              titleWidget: searchBarWidget(),
              location: const AddressWidgets(),
            ),
          ),
          bottomNavigationBar: bottomNavigationBarWidget(context, 0),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SafeArea(
            child: SingleChildScrollView(
              child: ChangeNotifierProvider<DashboardViewModel>.value(
                value: productViewModel,
                child: dataJson == ''
                    ? CircularProgressIndicator()
                    : Consumer<HomeProvider>(
                        builder: (context, provider, child) {
                        return Consumer<DashboardViewModel>(
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
                              return Text(
                                  productCategories.CRMList.message.toString());

                            case Status.COMPLETED:
                              if (kDebugMode) {
                                print("Api calll");
                              }
                              List<CRMPayload> crmPayload =
                                  productCategories.CRMList.data!.payload!;
                              return crmPayload.length == []
                                  ? CircularProgressIndicator()
                                  : Container(
                                padding: const EdgeInsets.only(left: 10, right: 10,),                                         child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            productServiceChip(),
                                            SizedBox(
                                              height: height * .02,
                                            ),
                                            imageLists(provider),
                                            // carouselImages(),
                                            SizedBox(
                                              height: height * .02,
                                            ),
                                            TextFieldUtils()
                                                .headingTextField('Engage with us', context),

                                            SizedBox(
                                              height: height * .02,
                                            ),

                                            ListView.builder(
                                              key: Key(
                                                  'builder ${selected.toString()}'),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: crmPayload!.length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  // margin: const EdgeInsets.symmetric(
                                                  //     horizontal: 5, vertical: 5),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        crmPayload[index]
                                                                .simpleSubCats!
                                                                .isEmpty
                                                            ? SizedBox()
                                                            : Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        15),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      color: ThemeApp
                                                                          .containerColor,
                                                                      height:
                                                                          25,
                                                                      width: 25,
                                                                      child: Image
                                                                          .network(
                                                                        crmPayload[index]
                                                                            .crmCategoryImageId!,
                                                                        // fit: BoxFit.fill,
                                                                      ),
                                                                    ),

                                                                    // SvgPicture.asset(
                                                                    //   'assets/appImages/appliancesIcon.svg',
                                                                    //
                                                                    //   height: 17,
                                                                    //   width: 26,
                                                                    // ),
                                                                    SizedBox(
                                                                      width: 16,
                                                                    ),
                                                                    categoryListFont(
                                                                        crmPayload[index]
                                                                            .name!,
                                                                        context)
                                                                  ],
                                                                ),
                                                              ),
                                                        crmPayload[index]
                                                                .simpleSubCats!
                                                                .isEmpty
                                                            ? SizedBox()
                                                            : subListOfCategories(
                                                                crmPayload[
                                                                    index])
                                                      ]),
                                                );
                                              },
                                            )

                                            /*                   ListView.builder(
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
                                                          height: 25,
                                                          width: 25,
                                                          // borderRadius:
                                                          // const BorderRadius.all(
                                                          //     Radius.circular(50)),
                                                          child: Image.network(
                                                           crmPayload[index]
                                                                .crmCategoryImageId ??
                                                                "",
                                                            height: 25,
                                                            width: 25,
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
                                                        */ /*  SvgPicture.asset(
                                                            'assets/appImages/appliancesIcon.svg',
                                                            height: 17,
                                                            width: 26,
                                                          ),*/ /*
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
                                      )*/
                                          ]),
                                    );
                          }
                          return Text('');
                        });
                      }),
              ),
            ),
          )),
    );
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

  bool _isProductListChip = false;
  bool _isServiceListChip = false;
  bool _isCRMListChip = false;

  Widget productServiceChip() {
    return Container(
      width: width / 1,
      padding: EdgeInsets.only(top: 10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff00a7bf)),
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();

                  setState(() {
                    _isProductListChip = true;

                    _isServiceListChip = false;
                    _isCRMListChip = false;
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                            RoutesName.dashboardRoute, (route) => false)
                        .then((value) {
                      setState(() {});
                    }) /*;
                    // return Future.value(true);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    ) */
                        .then((value) => setState(() {
                              _isProductListChip = true;

                              _isServiceListChip = false;
                              _isCRMListChip = false;

                              prefs.setString("FromType", 'FromProduct');
                            }));
                    print(
                        "_isProductListChip 1" + _isProductListChip.toString());
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: _isProductListChip
                        ? ThemeApp.appColor
                        : ThemeApp.whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: TextFieldUtils().dynamicText(
                        'Products',
                        context,
                        TextStyle(
                            fontFamily: 'Roboto',
                            color: _isProductListChip
                                ? ThemeApp.whiteColor
                                : ThemeApp.blackColor,
                            // fontWeight: FontWeight.w500,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();

                  setState(() {
                    prefs.setString("FromType", 'FromServices');

                    _isServiceListChip = true;
                    _isCRMListChip = false;
                    _isProductListChip = false;
                    // _isProductListChip = !_isProductListChip;
                    print(
                        "_isProductListChip 2" + _isServiceListChip.toString());
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => ShopByCategoryActivity(),
                          ),
                        )
                        .then((value) => setState(() {
                              _isProductListChip = true;

                              _isServiceListChip = false;
                              _isCRMListChip = false;
                            }));
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        _isServiceListChip ? Color(0xff00a7bf) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: TextFieldUtils().dynamicText(
                        'Services',
                        context,
                        TextStyle(
                            fontFamily: 'Roboto',
                            color: _isServiceListChip
                                ? ThemeApp.whiteColor
                                : ThemeApp.blackColor,
                            // fontWeight: FontWeight.w500,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();

                  setState(() {
                    prefs.setString("FromType", 'FromCRM');
                    // _isProductListChip = true;
                    _isCRMListChip = true;
                    _isServiceListChip = false;
                    _isProductListChip = false;
                    print("_isProductListChip 3" + _isCRMListChip.toString());
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => CRMActivity(),
                          ),
                        )
                        .then((value) => setState(() {
                              _isProductListChip = true;
                              //
                              _isServiceListChip = false;
                              _isCRMListChip = false;
                            }));
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: _isCRMListChip ? Color(0xff00a7bf) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: TextFieldUtils().dynamicText(
                        'CRM',
                        context,
                        TextStyle(
                            fontFamily: 'Roboto',
                            color: _isCRMListChip
                                ? ThemeApp.whiteColor
                                : ThemeApp.blackColor,
                            // fontWeight: FontWeight.w500,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final CarouselController _carouselController = CarouselController();

  Widget imageLists(HomeProvider provider) {
    return data == ''
        ? CircularProgressIndicator()
        : FutureBuilder(
            future: provider.homeImageSliderService(),
            builder: (context, snapShot) {
              return (provider.homeSliderList != null)
                  ? Container(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.landscape)
                          ? height * .5
                          : height * 0.2,
                      width: width,
                      child: Stack(
                        children: [
                          CarouselSlider(
                            carouselController: _carouselController,
                            items: provider.homeSliderList["homeImageSlider"]
                                    .map<Widget>((e) {
                                  return Card(
                                    margin: EdgeInsets.zero,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    color: ThemeApp.appBackgroundColor,
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Container(
                                          width: width,
                                          color: ThemeApp.appBackgroundColor,
                                          child: Image.network(
                                            e["homeSliderImage"],
                                            fit: BoxFit.fitWidth,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(Icons.image_outlined);
                                            },
                                          ),
                                        )),
                                  );
                                }).toList() ??
                                '',
                            options: CarouselOptions(
                                autoPlay: true,
                                viewportFraction: 1,
                                height: height * .3),
                          ),
                        ],
                      ))
                  : SizedBox();
            });
  }

  Widget subListOfCategories(CRMPayload servicePayload) {
    // final size = _displayAll ?     productList.simpleSubCats!.length :  productList.simpleSubCats!.length - 2;

    final size = servicePayload.simpleSubCats!.length > 6
        ? 5
        : servicePayload.simpleSubCats!.length;
    final contactsWidget = List.generate(
        size, (index) => detailsGrid(servicePayload.simpleSubCats![index]))
      ..add(servicePayload.simpleSubCats!.length > 6
          ? _seeNoSeeMore(servicePayload)
          : SizedBox());
    return Container(
        height: servicePayload.simpleSubCats!.length > 3 ? 200 : 90,
        // height: 200,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: /*ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: productList!.simpleSubCats!.length,*/
            GridView(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 12,
                  // childAspectRatio: 1.0,
                  childAspectRatio: MediaQuery.of(context).size.height / 500,
                ),
                shrinkWrap: true,
                children: contactsWidget));

    /*Container(
        height: 200,
        alignment: Alignment.center,color: ThemeApp.whiteColor,
        child: GridView.builder(
          itemCount: productList!.simpleSubCats!.length,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductListByCategoryActivity(
                      productList: productList!.simpleSubCats![index]),
                ));
              },
              child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ThemeApp.containerColor,
                        width: 1.5),color: ThemeApp.containerColor
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(50)),
                          child: Image.network(
                            productList.simpleSubCats![index]
                                .imageUrl! ??
                                '',
                            fit: BoxFit.fill,
                            height:
                            MediaQuery.of(context).size.height *
                                .07,
                          )??SizedBox(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: TextFieldUtils().dynamicText(
                              productList.simpleSubCats![index].name!,
                              context,
                              TextStyle(fontFamily: 'Roboto',
                                color: ThemeApp.blackColor,
                                // fontWeight: FontWeight.w500,
                                fontSize: height * .02,
                              )),
                        ),
                      )
                    ],
                  )),
            );
          },
        ));*/
  }

  Widget detailsGrid(CRMSimpleSubCats simpleSubCats) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
             CRMistByCategoryActivity(crmList: simpleSubCats),
        ));
      },
      // child: Padding(
      // padding: const EdgeInsets.only(right: 8.0, bottom: 8),
      child: Container(
          // width: width * .25,
          // width: 97,
          height: 59,
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: ThemeApp.containerColor, width: 1.5),
              color: ThemeApp.containerColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*      SvgPicture.asset(
                            'assets/appImages/televisionIcon.svg',
                            color: ThemeApp.blackColor,

                            height: 17,
                            width: 19,
                          ),*/
              Container(
                color: ThemeApp.appColor,
                height: 25,
                width: 25,
                // borderRadius:
                // const BorderRadius.all(
                //     Radius.circular(50)),
                child: Image.network(
                  simpleSubCats.imageUrl ?? "",
                  // fit: BoxFit.fill,
                  height: 25,
                  width: 25,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 25,
                      width: 25,
                      child: Icon(
                        Icons.image,
                        color: ThemeApp.whiteColor,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 6,
              ),
              subCategoryListFont(simpleSubCats.name!, context),
            ],
          )),
      // ),
    );
  }

  Widget _seeNoSeeMore(CRMPayload servicePayload) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              AllCRMSubCategoryScreen(serviceList: servicePayload),
        ));
      },
      child: Container(
        width: 97,
        height: 59,
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: ThemeApp.containerColor, width: 1.5),
            color: ThemeApp.containerColor),
        child: Center(
          child: Text(
            'View All',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.25,
                color: ThemeApp.tealButtonColor),
          ),
        ),
      ),
    );
  }

/*
  Widget subListOfCategories(CRMPayload servicePayload) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 5,
        // childAspectRatio: 1.0,
        // childAspectRatio: MediaQuery.of(context).size.height / 500,
      ),
      itemCount: servicePayload.simpleSubCats!.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            print("id............."+servicePayload.simpleSubCats![index].id.toString());
            Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CRMistByCategoryActivity(
                productList: servicePayload.simpleSubCats![index]),
          ));
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
                             height: 25,
                             width: 25,
                    // borderRadius:
                    // const BorderRadius.all(
                    //     Radius.circular(50)),
                    child: Image.network(
                      servicePayload.simpleSubCats![index]
                          .imageUrl ??
                          "",
                      // fit: BoxFit.fill,
                      height: 25,
                      width: 25,
                      errorBuilder:
                          (context, error,
                          stackTrace) {
                        return Container(
                          height: 25,
                          width: 25,
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
*/
}
class AllCRMSubCategoryScreen extends StatefulWidget {
  final CRMPayload serviceList;

  AllCRMSubCategoryScreen({Key? key, required this.serviceList}) : super(key: key);

  @override
  State<AllCRMSubCategoryScreen> createState() => _AllCRMSubCategoryScreenState();
}

class _AllCRMSubCategoryScreenState extends State<AllCRMSubCategoryScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;  return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * .14),
        child: AppBarWidget(
          context:    context,
          titleWidget:    AddressWidgets(),
          location: const AddressWidgets(),     ),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context,0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(10,20,10,10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldUtils()
                  .headingTextField(widget.serviceList.name.toString(), context),

              SizedBox(
                height: 10,
              ),
              subListOfCategories()
            ],
          ),
        ),
      ),
    );
  }

  Widget subListOfCategories() {
    return Expanded(
      // width: MediaQuery.of(context).size.width,
      child: widget.serviceList.simpleSubCats!.isEmpty
          ? Center(
          child: Text(
            "Match not found",
            style: TextStyle(fontSize: 20),
          ))
          : GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 30,
            // childAspectRatio: 1.0,
            childAspectRatio: MediaQuery.of(context).size.height / 900,
          ),
          shrinkWrap: true,
          children: List.generate(
            widget.serviceList.simpleSubCats!.length,
                (index) {
              return Stack(
                children: [
                  index == widget.serviceList.simpleSubCats!.length
                      ? Container(
                    // width: constrains.minWidth,
                    height: 20,
                    // height: MediaQuery.of(context).size.height * .08,
                    // alignment: Alignment.center,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ThemeApp.blackColor,
                      ),
                    ),
                  )
                      : InkWell(
                    onTap: () {
                      print(
                          "Id ........${widget.serviceList.simpleSubCats![index].id}");

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CRMistByCategoryActivity(
                                crmList: widget
                                    .serviceList.simpleSubCats![index],
                              ),
                        ),
                      );
                    },
                    child: Container(
// height: 205,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*   Expanded(
                                            flex: 2,
                                            child:*/
                            Container(
                              height: 143,
                              width: 191,

                              decoration: const BoxDecoration(
                                color: ThemeApp.whiteColor,
                              ),
                              child: ClipRRect(
                                child: widget
                                    .serviceList
                                    .simpleSubCats![index]
                                    .imageUrl!
                                    .isNotEmpty
                                    ? Image.network(
                                  widget
                                      .serviceList
                                      .simpleSubCats![index]

                                      .imageUrl!,
                                  // fit: BoxFit.fill,
                                  height: (MediaQuery.of(context)
                                      .orientation ==
                                      Orientation.landscape)
                                      ? MediaQuery.of(context)
                                      .size
                                      .height *
                                      .26
                                      : MediaQuery.of(context)
                                      .size
                                      .height *
                                      .1,
                                )
                                    : SizedBox(
                                  // height: height * .28,
                                    width: MediaQuery.of(context).size.width,
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: 50,
                                    )),
                              ),
                            ),
                            // ),
                            Container(
                              color: ThemeApp.tealButtonColor,
                              width: 191,
                              height: 56,
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  TextFieldUtils()
                                      .listNameHeadingTextField(
                                      widget
                                          .serviceList
                                          .simpleSubCats![index]
                                          .name!,
                                      context),
                                  SizedBox(height: 10),

                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  index == widget
                      .serviceList
                      .simpleSubCats!.length
                      ? Container(
                    // width: constrains.minWidth,
                    height: 20,
                    // height: MediaQuery.of(context).size.height * .08,
                    // alignment: Alignment.center,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ThemeApp.blackColor,
                      ),
                    ),
                  )
                      : SizedBox()
                ],
              );
            },
          )),
    );
  }

}
