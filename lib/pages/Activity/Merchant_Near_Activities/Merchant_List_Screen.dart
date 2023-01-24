import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Model/ServiceModels/FindServicesBySubCategory.dart';
import 'package:velocit/Core/ViewModel/product_listing_view_model.dart';
import 'package:velocit/pages/Activity/DashBoard_DetailScreens_Activities/service_ui/ServiceDetails_activity.dart';
import 'package:velocit/pages/Activity/Product_Activities/ProductDetails_activity.dart';
import 'package:velocit/utils/constants.dart';
import '../../../../Core/Model/FindProductBySubCategoryModel.dart';
import '../../../../Core/Model/ServiceModels/ServiceCategoryAndSubCategoriesModel.dart';
import '../../../../Core/data/responses/status.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../../Core/Model/MerchantModel/MerchantListByIdModel.dart';
import '../../../Core/Model/MerchantModel/MerchantListModel.dart';
import '../../../Core/ViewModel/Merchant_viewModel.dart';
import 'FilterScreen_Merchant.dart';

class MerchantListByIdActivity extends StatefulWidget {
  MerchantPayload? merchant;

  MerchantListByIdActivity({Key? key, this.merchant}) : super(key: key);

  @override
  State<MerchantListByIdActivity> createState() =>
      _MerchantListByIdActivityState();
}

class _MerchantListByIdActivityState extends State<MerchantListByIdActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  late ScrollController scrollController = ScrollController();
  double height = 0.0;
  double width = 0.0;

  var categoryCode;
  MerchantViewModel merchantViewModel = MerchantViewModel();

  bool isLoading = false;
  int pageCount = 1;
  int size = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    merchantViewModel.merchantByIdWithGet(
      0,
      10,
      widget.merchant!.id!,
    );
    print("subProduct.............${widget.merchant!.id}");
/*    scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);*/

    StringConstant.sortByRadio;
    StringConstant.sortedBy;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        print("comes to bottom $isLoading");
        isLoading = true;

        if (isLoading) {
          print("RUNNING LOAD MORE");

          pageCount = pageCount + 1;

          //// CALL YOUR API HERE FOR THE NEXT FUNCTIONALITY
          merchantViewModel.merchantByIdWithGet(
              pageCount, 10, widget.merchant!.id!);
        }
      });
    }
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
    // final availableProducts = Provider.of<ProductProvider>(context);

    // final productsList = availableProducts.getProductsLists();

    return Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .12),
          child: AppBarWidget(
            context: context,
            titleWidget: searchBar(context),
            location: addressWidget(
                context, StringConstant.placesFromCurrentLocation),
          ),
        ),
        bottomNavigationBar: bottomNavigationBarWidget(context),
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
                SizedBox(
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
      decoration: const BoxDecoration(
          // border: Border(
          //   top: BorderSide(color: Colors.grey, width: 1),
          //   bottom: BorderSide(color: Colors.grey, width: 1),
          // ),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextFieldUtils().dynamicText(
                'Sort By  ',
                context,
                TextStyle(
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
                  TextStyle(
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
                  builder: (context) => const Merchant_FilterScreen()));
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
                    TextStyle(
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
                    theme: SvgTheme(
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
    return /* LayoutBuilder(builder: (context, constrains) {
      return*/
        ChangeNotifierProvider<MerchantViewModel>.value(
            value: merchantViewModel,
            child: Consumer<MerchantViewModel>(
                builder: (context, merchantProvider, child) {
              switch (merchantProvider.merchantListByIdResponse.status) {
                case Status.LOADING:
                  print("Api load");

                  return TextFieldUtils().circularBar(context);
                case Status.ERROR:
                  print("Api error" +
                      merchantProvider.merchantListByIdResponse.message
                          .toString());

                  return Text('Something went wrong');
                case Status.COMPLETED:
                  print("Api calll");
                  List<MerchantIdContent>? merchantList = merchantProvider
                      .merchantListByIdResponse.data!.payload!.content;
                  print("merchantList length.......${merchantList!.length}");
                  return Expanded(
                    // width: MediaQuery.of(context).size.width,
                    child: merchantList.length == 0
                        ? Center(child: Text('No match found'))
                        : GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 30,
                              // childAspectRatio: 1.0,
                              childAspectRatio:
                                  MediaQuery.of(context).size.height / 900,
                            ),
                            shrinkWrap: true,
                            children: List.generate(
                              merchantList.length,
                              (index) {
                                return Stack(
                                  children: [
                                    index == merchantList.length
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
                                                  "Id ........${merchantList[index].id}");

                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailsActivity(
                                                    id: merchantList[index].id,
                                                    // productList: subProductList[index],
                                                    // productSpecificListViewModel:
                                                    //     productSpecificListViewModel,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
// height: 205,
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: ThemeApp.whiteColor,
                                                  ),
                                                  child: ClipRRect(
                                                    child: Image.network(
                                                          merchantList[index]
                                                                  .imageUrls![0]
                                                                  .imageUrl!
                                                                  .toString() ??
                                                              "",
                                                          // fit: BoxFit.fill,
                                                          height: (MediaQuery.of(
                                                                          context)
                                                                      .orientation ==
                                                                  Orientation
                                                                      .landscape)
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .26
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .1,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Icon(
                                                              Icons.image,
                                                              color: ThemeApp
                                                                  .appColor,
                                                            );
                                                          },
                                                        ) ??
                                                        SizedBox(
                                                            // height: height * .28,
                                                            width: width,
                                                            child: Icon(
                                                              Icons
                                                                  .image_outlined,
                                                              size: 50,
                                                            )),
                                                  ),
                                                ),
                                                // ),
                                                Container(
                                                  color:
                                                      ThemeApp.tealButtonColor,
                                                  width: 191,
                                                  height: 66,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 12,
                                                    right: 12,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextFieldUtils()
                                                          .listNameHeadingTextField(
                                                              merchantList[
                                                                      index]
                                                                  .shortName!,
                                                              context),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          TextFieldUtils().listPriceHeadingTextField(
                                                              indianRupeesFormat
                                                                  .format(merchantList[
                                                                              index]
                                                                          .defaultSellPrice ??
                                                                      0.0),
                                                              context),
                                                          TextFieldUtils().listScratchPriceHeadingTextField(
                                                              indianRupeesFormat
                                                                  .format(merchantList[
                                                                              index]
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
                                          ),
                                    index == merchantList!.length
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
                              },
                            )),
                  );
              }
              return Container(
                height: height * .08,
                alignment: Alignment.center,
                child: TextFieldUtils().dynamicText(
                    'No Match found!',
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: height * .03,
                        fontWeight: FontWeight.bold)),
              );
            }));
    // });
  }

/*
  Widget productListView() {
    return*/
/* LayoutBuilder(builder: (context, constrains) {
      return*/ /*
 ChangeNotifierProvider<ProductSpecificListViewModel>.value(
          value:  productSpecificListViewModel,
          child: Consumer<ProductSpecificListViewModel>(
              builder: (context, productSubCategoryProvider, child) {
            switch (productSubCategoryProvider.productSubCategory.status) {
              case Status.LOADING:
                print("Api load");

                return TextFieldUtils().circularBar(context);
              case Status.ERROR:
                print("Api error");

                return Text(productSubCategoryProvider
                    .productSubCategory.message
                    .toString());
              case Status.COMPLETED:
                print("Api calll");
                List<Content>? subProductList = productSubCategoryProvider
                    .productSubCategory.data!.payload!.content;
                print("subProductList length.......${subProductList!.length}");
                return Expanded(

                  // width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                    controller: scrollController,
                    itemCount: subProductList!.length,
                    physics:  AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 0.5,
                          crossAxisSpacing: 0.5,
                          // width / height: fixed for *all* items
                          childAspectRatio: 0.85,

                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          index == subProductList!.length
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
                                        "Id ........${subProductList[index].id}");

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsActivity(
                                          id: subProductList[index].id,
                                          // productList: subProductList[index],
                                          // productSpecificListViewModel:
                                          //     productSpecificListViewModel,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(

                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                       */
/*   Expanded(
                                            flex: 2,
                                            child:*/ /*
 Container(
                                              height: 163,
                                              width: 191, */
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
                                                  .width,*/ /*

                                              decoration: const BoxDecoration(
                                                  color: ThemeApp.whiteColor,
                                                 ),
                                              child: ClipRRect(

                                                child: subProductList[index]
                          .imageUrls![0]
                          .imageUrl!.isNotEmpty?Image.network(
                                                  subProductList[index]
                                                      .imageUrls![0]
                                                      .imageUrl!,
                                                  fit: BoxFit.fill,
                                                  height: (MediaQuery.of(
                                                                  context)
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
                                                ) :SizedBox(
                                                  // height: height * .28,
                                                    width: width,
                                                    child: Icon(
                                                      Icons.image_outlined,
                                                      size: 50,
                                                    )),
                                              ),
                                            ),
                                          // ),
                                         Container(      color: ThemeApp.tealButtonColor,
                                           width: 191,
                                           height: 65,
                                              padding: const EdgeInsets.only(
                                                  left: 12, right: 12),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextFieldUtils()
                                                      .listNameHeadingTextField(
                                                      subProductList[index]
                                                          .shortName!,context),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextFieldUtils().listPriceHeadingTextField(
                                                          indianRupeesFormat
                                                              .format(subProductList[
                                                                          index]
                                                                      .defaultSellPrice ??
                                                                  0.0),
                                                          context),
                                                      TextFieldUtils().listScratchPriceHeadingTextField(
                                                          indianRupeesFormat.format(
                                                              subProductList[
                                                                          index]
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
                                ),
                          index == subProductList!.length
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
                      */
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
                      }*/ /*

                    },
                  ),
                );
            }
            return Container(
              height: height * .08,
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
    // });
  }
*/

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
