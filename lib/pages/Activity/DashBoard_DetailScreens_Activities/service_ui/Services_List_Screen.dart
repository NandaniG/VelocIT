import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:velocit/Core/Model/ServiceModels/FindServicesBySubCategory.dart';
import 'package:velocit/pages/Activity/DashBoard_DetailScreens_Activities/service_ui/ServiceDetails_activity.dart';
import 'package:velocit/utils/constants.dart';
import '../../../../Core/AppConstant/apiMapping.dart';
import '../../../../Core/Model/ServiceModels/ServiceCategoryAndSubCategoriesModel.dart';
import '../../../../utils/ProgressIndicatorLoader.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';
import '../../Product_Activities/FilterScreen_Products.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

class ServiceListByCategoryActivity extends StatefulWidget {
  ServiceSimpleSubCats? serviceList;

  ServiceListByCategoryActivity({Key? key, this.serviceList}) : super(key: key);

  @override
  State<ServiceListByCategoryActivity> createState() =>
      _ServiceListByCategoryActivityState();
}

class _ServiceListByCategoryActivityState
    extends State<ServiceListByCategoryActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  final ScrollController _sc = ScrollController();
  double height = 0.0;
  double width = 0.0;

  //// page for lazy scroll
 int page = 0;
  List<ServiceContent> subServiceList = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getMoreData(
      page,
      10,
      widget.serviceList!.id!,
    );
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        print("page number sc1 " + page.toString());
        page++;
        print("page number sc2 " + page.toString());
        _getMoreData(
          page,
          10,
          widget.serviceList!.id!,
        );
      }
    });
    print("subProduct.............${widget.serviceList!.id}");

    StringConstant.sortByRadio;
    StringConstant.sortedBy;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _sc.dispose();
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
          child: AppBarWidget(
            context: context,
            titleWidget: searchBar(context),
            location: const AddressWidgets(),
          ),
        ),
        bottomNavigationBar: bottomNavigationBarWidget(context, 0),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //

                /* listOfMobileDevices(),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),*/
                filterWidgets(),
                const SizedBox(
                  height: 10,
                ),
                productListView()
              ],
            ),
          ),
        ));
  }

  ///top header list of product
/*
  Widget listOfMobileDevices() {
    return ChangeNotifierProvider<ProductSpecificListViewModel>(
        value:  productSpecificListViewModel,
        child: Consumer<ProductSpecificListViewModel>(
            builder: (context, productSubCategoryProvider, child) {
          switch (productSubCategoryProvider.productSubCategory.status) {
            case Status.LOADING:
              print("Api load");

              return TextFieldUtils().circularBar(context);
            case Status.ERROR:
              print("Api error");

              return Text(productSubCategoryProvider.productSubCategory.message
                  .toString());
            case Status.COMPLETED:
              print("Api calll");
              List<Content>? subProductList = productSubCategoryProvider
                  .productSubCategory.data!.payload!.content;
              return Container(
                height: height * .15,
                child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: subProductList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      print("widget.productList.length");
                      return InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Container(
                                width: width * .27,
                                decoration: const BoxDecoration(
                                    color: ThemeApp.whiteColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50)),
                                      child: Image.network(
                                        // width: double.infinity,
                                        subProductList[index]
                                            .imageUrls![0]
                                            .imageUrl!,
                                        fit: BoxFit.fill,

                                        height:
                                            MediaQuery.of(context).size.height *
                                                .07,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .01,
                                    ),
                                    Center(
                                      child: TextFieldUtils().dynamicText(
                                          subProductList[index].shortName!,
                                          context,
                                          TextStyle(fontFamily: 'Roboto',
                                            color: ThemeApp.darkGreyColor,
                                            // fontWeight: FontWeight.w500,
                                            fontSize: height * .02,
                                          )),
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
          }
          return Container(
            width: width,
            height: height * .8,
            alignment: Alignment.center,
            child: TextFieldUtils().dynamicText(
                'No Match found!',
                context,
                TextStyle(fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .03,
                    fontWeight: FontWeight.bold)),
          );
        }));
  }
*/

  Widget filterWidgets() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextFieldUtils().dynamicText(
                'Sort By  ',
                context,
                const TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.lightFontColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    letterSpacing: -0.08)),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return bottomSheetForPrice();
                    });
              },
              child: TextFieldUtils().dynamicText(
                  StringConstant.sortedBy,
                  context,
                  const TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      letterSpacing: -0.08)),
            ),
            const Icon(Icons.keyboard_arrow_down)
          ]),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FilterScreen()));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: ThemeApp.tealButtonColor)),
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                TextFieldUtils().dynamicText(
                    'Filters',
                    context,
                    const TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    )),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    'assets/appImages/filterIcon.svg',
                    color: ThemeApp.primaryNavyBlackColor,
                    semanticsLabel: 'Acme Logo',
                    theme: const SvgTheme(
                      currentColor: ThemeApp.primaryNavyBlackColor,
                    ),
                    height: height * .02,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(IconData icon, {Color color = ThemeApp.iconColor}) {
    return Container(
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget productListView() {
    return Expanded(
        // width: MediaQuery.of(context).size.width,
        child: subServiceList.isEmpty
            ? const Center(
                child: Text(
                "Match not found",
                style: TextStyle(fontSize: 20),
              ))
            : GridView(
                controller: _sc,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 30,
                  // childAspectRatio: 1.0,
                  childAspectRatio: MediaQuery.of(context).size.height / 900,
                ),
                shrinkWrap: true,
                children: List.generate(subServiceList.length + 1, (index) {
                  if (index == subServiceList.length) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildProgressIndicator(),
                      ],
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        print("Id ........${subServiceList[index].id}");

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailsActivity(
                              id: subServiceList[index].id,
                              // productList: subServiceList[index],
                              // productSpecificListViewModel:
                              //     productSpecificListViewModel,
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
                            /* height: SizeConfig.orientations !=
                                                      Orientation.landscape
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .25
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .1,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,*/
                            decoration: const BoxDecoration(
                              color: ThemeApp.whiteColor,
                            ),
                            child: ClipRRect(
                              child: subServiceList[index]
                                      .imageUrls![0]
                                      .imageUrl!
                                      .isNotEmpty
                                  ? Image.network(
                                      subServiceList[index]
                                          .imageUrls![0]
                                          .imageUrl!,
                                      // fit: BoxFit.fill,
                                      height: (MediaQuery.of(context)
                                                  .orientation ==
                                              Orientation.landscape)
                                          ? MediaQuery.of(context).size.height *
                                              .26
                                          : MediaQuery.of(context).size.height *
                                              .1,
                                    )
                                  : SizedBox(
                                      // height: height * .28,
                                      width: width,
                                      child: const Icon(
                                        Icons.image_outlined,
                                        size: 50,
                                      )),
                            ),
                          ),
                          // ),
                          Container(
                            color: ThemeApp.tealButtonColor,
                            width: 191,
                            height: 66,
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFieldUtils().listNameHeadingTextField(
                                    subServiceList[index].shortName!, context),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextFieldUtils().listPriceHeadingTextField(
                                        indianRupeesFormat.format(
                                            subServiceList[index]
                                                    .defaultSellPrice ??
                                                0.0),
                                        context),
                                    TextFieldUtils()
                                        .listScratchPriceHeadingTextField(
                                            indianRupeesFormat.format(
                                                subServiceList[index]
                                                        .defaultMrp ??
                                                    0.0),
                                            context)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                    );
                    /*else {
                        return  Container(
                          // width: constrains.minWidth,
                          height: 80,
                          // height: MediaQuery.of(context).size.height * .08,
                          // alignment: Alignment.center,
                          child: TextFieldUtils().dynamicText(
                              'Nothing more to load',
                              context,
                              TextStyle(fontFamily: 'Roboto',
                                  color: ThemeApp.blackColor,
                                  fontSize: height * .03,
                                  fontWeight: FontWeight.bold)),
                        );
                      }*/
                  }
                }),
              ));
  }

  void _getMoreData(int page, int size, int subCategoryId) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      Map<String, String> productData = {
        'page': page.toString(),
        'size': size.toString(),
        'sub_category_id': subCategoryId.toString(),
      };
      print("Product Query$productData");
      var url = '/service/findBySubCategoryId';
      String queryString = Uri(queryParameters: productData).query;

      var requestUrl = '${ApiMapping.BaseAPI}$url?$queryString';
      print(requestUrl);

      final client = http.Client();
      final response = await client
          .get(Uri.parse(requestUrl))
          .timeout(const Duration(seconds: 30));
      List<ServiceContent> tList = [];

      final parsedJson = jsonDecode(response.body);
// type: Restaurant
      final serviceBySubCategory =
          FindServicesbySUbCategoriesModel.fromJson(parsedJson);
      for (int i = 0; i < serviceBySubCategory.payload!.content!.length; i++) {
        tList.add(serviceBySubCategory.payload!.content![i]);
      }
      print("tList number " +
          serviceBySubCategory.payload!.content!.length.toString());

      setState(() {
        isLoading = false;
        subServiceList.addAll(tList);
        // page++;
        print("page number " + page.toString());
      });
    }
  }

  Widget _buildProgressIndicator() {
    return Container(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: ProgressIndicatorLoader(isLoading),
        ),
      ),
    );
  }

  int? _radioValue = 0;

  Widget bottomSheetForPrice() {
    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return Container(
        margin: const EdgeInsets.all(10.0),
        child: Wrap(
          children: <Widget>[
            Center(
                child: Container(
                    height: 3.0, width: 40.0, color: const Color(0xFF32335C))),
            const SizedBox(
              height: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldUtils().dynamicText(
                    StringUtils.sortByPrice,
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: MediaQuery.of(context).size.height * .025,
                        fontWeight: FontWeight.w600)),
                RadioListTile(
                  activeColor: ThemeApp.appColor,
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: (value) {
                    setState(() {
                      _radioValue = value;
                      StringConstant.sortByRadio = _radioValue!;
                      print(StringConstant.sortedBy);
                    });
                  },
                  title: Text("Low to High",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery.of(context).size.height * .02,
                          fontWeight: FontWeight.w400)),
                ),
                RadioListTile(
                  activeColor: ThemeApp.appColor,
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: (value) {
                    setState(() {
                      _radioValue = value;
                      StringConstant.sortByRadio = _radioValue!;
                      print(StringConstant.sortedBy);
                    });
                  },
                  title: Text("High to Low",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.darkGreyColor,
                          fontSize: MediaQuery.of(context).size.height * .02,
                          fontWeight: FontWeight.w400)),
                ),
                proceedButton(
                    "Sort Now", ThemeApp.tealButtonColor, context, false, () {
                  setState(() {
                    FocusManager.instance.primaryFocus?.unfocus();

                    StringConstant.sortByRadio == 1
                        ? StringConstant.sortedBy = "High to Low"
                        : 'Low to High';

                    onChangeText(StringConstant.sortByRadio);
                  });
                  Navigator.pop(context);
                })
              ],
            ),
          ],
        ),
      );
    });
  }

  void onChangeText(int sortByRadio) {
    setState(() {});
    if (StringConstant.sortByRadio == 1) {
      StringConstant.sortedBy = "High to Low";
    } else {
      StringConstant.sortedBy = "Low to High";
    }
  }
}
