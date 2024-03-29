import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/utils/ProgressIndicatorLoader.dart';
import '../../Core/AppConstant/apiMapping.dart';
import '../../Core/Model/Orders/ActiveOrdersBasketModel.dart';
import '../../Core/Model/ProductAllPaginatedModel.dart';
import '../../Core/Model/ProductCategoryModel.dart';
import '../../Core/Model/ProductListingModel.dart';
import '../../Core/Model/servicesModel.dart';
import '../../Core/ViewModel/OrderBasket_viewmodel.dart';
import '../../Core/ViewModel/cart_view_model.dart';
import '../../Core/ViewModel/dashboard_view_model.dart';
import '../../Core/ViewModel/product_listing_view_model.dart';
import '../../Core/data/responses/status.dart';
import '../../Core/repository/OrderBasket_repository.dart';
import '../../Core/repository/cart_repository.dart';
import '../../services/models/JsonModelForApp/HomeModel.dart';
import '../../services/models/demoModel.dart';
import '../../services/providers/Home_Provider.dart';
import '../../services/providers/Products_provider.dart';
import '../../utils/StringUtils.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';
import '../../widgets/global/appBar.dart';
import '../../widgets/global/proceedButtons.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/global/textFormFields.dart';
import '../Activity/CRMFormScreen.dart';
import '../Activity/DashBoard_DetailScreens_Activities/BookService_Activity.dart';
import '../Activity/Merchant_Near_Activities/merchant_Activity.dart';
import '../Activity/DashBoard_DetailScreens_Activities/Categories_Activity.dart';
import '../Activity/Product_Activities/ProductDetails_activity.dart';
import '../Activity/Product_Activities/Products_List.dart';
import '../Activity/ServicesFormScreen.dart';
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
  DashboardViewModel productListView = DashboardViewModel();
  OrderBasketViewModel basketViewModel = OrderBasketViewModel();
  final CarouselController _carouselController = CarouselController();
  OrderBasketRepository basketRepo = OrderBasketRepository();

  double height = 0.0;
  double width = 0.0;

  // String location = 'Null, Press Button';
  // String Address = 'search';
  var homeData;
  bool _isProductListChip = false;
  bool _isServiceListChip = false;
  bool _isCRMListChip = false;
  late Random rnd;
  var min = 100000000;
  int max = 1000000000;
  CartViewModel cartViewModel = CartViewModel();
  var ID;
  var url = ApiMapping.BASEAPI + ApiMapping.consumerBasket;

  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // addCartList();
    getCartDetailsFromPref();

    data = Provider.of<HomeProvider>(context, listen: false).loadJson();

    print(url.toString());
    print('datassss.toString()');
    print(basketRepo.orderBasketData.toString());
    // getCurrentLocation();
// if()

    productCategories.productCategoryListingWithGet();

    Map<String, String> productListingData = {
      'page': '0',
      'size': '10',
    };
    print("getProductListing Query" + productListingData.toString());
    productListView.productListingWithGet(0, 10);
    _isProductListChip = true;
    getPincode();
    StringConstant.controllerSpeechToText.clear();
    Provider.of<HomeProvider>(context, listen: false).loadJson();
  }

  String finalId = '';

  Future<void> getCartDetailsFromPref() async {
    String isUserLoginPref = 'isUserLoginPref';

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // StringConstant.CurrentPinCode = (prefs.getString('CurrentPinCodePref') ?? '');

      print("StringConstant.CurrentPinCode");
      StringConstant.isUserLoggedIn = (prefs.getInt(isUserLoginPref) ?? 0);

      StringConstant.isUserLoggedIn = (prefs.getInt('isUserLoggedIn')) ?? 0;

      StringConstant.RandomUserLoginId =
          (prefs.getString('RandomUserId')) ?? '';

      print("IS USER LOG-IN ..............." +
          StringConstant.isUserLoggedIn.toString());
      print("ISRANDOM ID............" +
          StringConstant.RandomUserLoginId.toString());

      StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
var userLoginId=StringConstant.UserLoginId;

var userRandomId=StringConstant.RandomUserLoginId;

      print("USER LOGIN ID..............." +
          StringConstant.UserLoginId.toString());
      // if ((StringConstant.RandomUserLoginId == '' ||
      //         StringConstant.RandomUserLoginId == null||StringConstant.RandomUserLoginId.isEmpty) &&
      //     (StringConstant.UserLoginId == '' ||
      //         StringConstant.UserLoginId == null)) {
      //   print("RandomUserLoginId empty");
      //   rnd = new Random();
      //   var r = min + rnd.nextInt(max - min);
      //
      //   print("$r is in the range of $min and $max");
      //   ID = r;
      //   print("cartId empty" + ID.toString());
      // } else {
      //   print("RandomUserLoginId empty");
      //   // ID = StringConstant.UserLoginId;
      //   ID = StringConstant.UserLoginId;
      // }
      // // 715223688
      // finalId = ID.toString();
      // prefs.setString('RandomUserId', finalId.toString());
      //
      // print('finalId  RandomUserLoginId' + finalId);
      Map<String, String> dat;
      if (StringConstant.UserLoginId=='') {
data = {
          'userId': userRandomId
        };
      } else {
 data = {
          'userId': userLoginId
        };
      }

      print("cart data pass : " + data.toString());
      CartRepository().cartPostRequest(data, context);

      var CARTID = prefs.getString('CartIdPref');

      print("cartId from Pref" + CARTID.toString());
    });
  }

  var finalPINCODE = '';

  getPincode() async {
    var loginId = await Prefs.instance.getToken(StringConstant.userId);
    setState(() {});
    await Prefs.instance.getToken(StringConstant.pinCodePref);
    StringConstant.placesFromCurrentLocation =
        (await Prefs.instance.getToken(StringConstant.pinCodePref))!;
    final prefs = await SharedPreferences.getInstance();

    StringConstant.CurrentPinCode =
        (prefs.getString('CurrentPinCodePref') ?? '');

    if (StringConstant.placesFromCurrentLocation != null ||
        StringConstant.placesFromCurrentLocation != '' ||
        StringConstant.placesFromCurrentLocation.isNotEmpty) {
      StringConstant.FINALPINCODE = StringConstant.placesFromCurrentLocation;
    } else {
      StringConstant.FINALPINCODE = StringConstant.CurrentPinCode;
    }
    // StringConstant.FINALPINCODE = StringConstant.CurrentPinCode;

    print(
        "placesFromCurrentLocation pref...${StringConstant.CurrentPinCode.toString()}");
  }

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );
  var locationMessage = "";
  String addressPincode = "";

  Future getCurrentLocation() async {
    LocationPermission? permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lastPosition = await Geolocator.getLastKnownPosition();
    print("lastPosition" + lastPosition.toString());

    setState(() {
      locationMessage = "${position.latitude}, ${position.longitude}";
      // getAddressFromLatLong(
      //     position.latitude, position.longitude);
    });

    _getAddress(position.latitude, position.longitude);
  }

  Future<String> _getAddress(double? lat, double? lang) async {
    print("address.streetAddress");
    if (lat == null || lang == null) return "";
    GeoCode geoCode = GeoCode();
    Address address =
        await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    print("address.streetAddress" + address.streetAddress.toString());
    addressPincode = address.postal!.toString();
    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
  }

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
              searchBarWidget(),
              addressWidget(context, StringConstant.placesFromCurrentLocation),
              setState(() {})),
        ),
        bottomNavigationBar: bottomNavigationBarWidget(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: ChangeNotifierProvider<DashboardViewModel>.value(
          value: dashboardViewModel,
          child: Consumer<DashboardViewModel>(
              builder: (context, dashboardProvider, child) {
            // print('object-------------' + provider.jsonData.toString());
            return data == ''
                ? CircularProgressIndicator()
                : Consumer<HomeProvider>(builder: (context, provider, child) {
                    return (provider.jsonData.isNotEmpty &&
                            provider.jsonData['error'] == null)
                        ? SafeArea(
                            child: Container(
                                // height: MediaQuery.of(context).size.height,
                                // padding: const EdgeInsets.only(
                                //   left: 20,
                                //   right: 20,
                                // ),
                                padding: const EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      productServiceChip(),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      /*  productList(),
                                      SizedBox(
                                        height: height * .02,
                                      ),*/
                                      imageLists(provider),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      stepperOfDelivery(provider),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      productDetailsUI(),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      /*    listOfShopByCategories(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),

                                listOfBookOurServices(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),*/

                                      TextFieldUtils().headingTextField(
                                          StringUtils.recommendedForYou,
                                          context),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      recommendedList(),

                                      /*     Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextFieldUtils().listHeadingTextField(
                                        StringUtils.merchantNearYou, context),
                                    viewMoreButton(StringUtils.viewAll, context,
                                        () {
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
                                ),      merchantList(),*/

                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFieldUtils().headingTextField(
                                          StringUtils.bestDeal, context),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      bestDealList(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFieldUtils().headingTextField(
                                          StringUtils.budgetBuys, context),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      budgetBuyList(),
                                    ],
                                  ),
                                )))
                        : /*provider.jsonData['error'] != null
                            ? Container()
                            :*/
                        Center(child: CircularProgressIndicator());
                  });
          }),
        ));
  }

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
                onTap: () {
                  setState(() {
                    _isProductListChip = true;

                    _isServiceListChip = false;
                    _isCRMListChip = false;
                    // _isProductListChip = !_isProductListChip;
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
                onTap: () {
                  setState(() {
                    _isServiceListChip = true;
                    _isCRMListChip = false;
                    _isProductListChip = false;
                    // _isProductListChip = !_isProductListChip;
                    print(
                        "_isProductListChip 2" + _isServiceListChip.toString());
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ServicesFormScreen(),
                      ),
                    );
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
                onTap: () {
                  setState(() {
                    // _isProductListChip = true;
                    _isCRMListChip = true;
                    _isServiceListChip = false;
                    _isProductListChip = false;
                    print("_isProductListChip 3" + _isCRMListChip.toString());
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CRMFormScreen(),
                      ),
                    );
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

  Widget productList() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: productCategories,
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

              return _isProductListChip
                  ? Container(
                      height: 40,
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
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                  // height: 40,

                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 5, 15.0, 5),
                                  decoration: BoxDecoration(
                                    color: ThemeApp.containerColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: TextFieldUtils().dynamicText(
                                        serviceList[index].name!,
                                        context,
                                        TextStyle(
                                          fontFamily: 'Roboto',
                                          color: ThemeApp.blackColor,
                                          // fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        )),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : SizedBox();
            default:
              return Text("No Data found!");
          }
          return Text("No Data found!");
        }));

    return Container(
      // height: 40,

      padding: const EdgeInsets.fromLTRB(15.0, 10, 15.0, 10),
      decoration: BoxDecoration(
        color: ThemeApp.containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("sakdjsak"),
    );
  }

  int selected = 0;

  Widget productDetailsUI() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: productCategories,
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

              return Container(
                // padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldUtils()
                          .headingTextField('Shop by Categories', context),
                      SizedBox(
                        height: height * .02,
                      ),
                      ListView.builder(
                        key: Key('builder ${selected.toString()}'),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: serviceList!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ExpansionTile(
                                    key: Key(index.toString()),
                                    onExpansionChanged: ((newState) {
                                      if (newState) {
                                        setState(() {
                                          const Duration(seconds: 20000);
                                          selected = index;
                                        });
                                      } else {
                                        setState(() {
                                          selected = -1;
                                        });
                                      }
                                    }),
                                    initiallyExpanded: index == selected,
                                    trailing: index == selected
                                        ? Icon(
                                            Icons.arrow_drop_up,
                                            color:
                                                ThemeApp.textFieldBorderColor,
                                            size: height * .05,
                                          )
                                        : Icon(
                                            Icons.arrow_drop_down,
                                            color:
                                                ThemeApp.textFieldBorderColor,
                                            size: height * .05,
                                          ),
                                    tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    childrenPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    textColor: Colors.black,
                                    title: Row(
                                      children: [
                                        CircleAvatar(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50)),
                                            child: Image.network(
                                              serviceList[index]
                                                  .productCategoryImageId!,
                                              fit: BoxFit.fill,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .07,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * .03,
                                        ),
                                        categoryListFont(
                                            serviceList[index].name!, context)
                                      ],
                                    ),
                                    expandedAlignment: Alignment.centerLeft,
                                    expandedCrossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      subListOfCategories(serviceList[index])
                                    ],
                                  ),
                                ]),
                          );
                        },
                      )
                    ]),
              );
            default:
              return Text("No Data found!");
          }
          return Text("No Data found!");
        }));
  }

  Widget categoryListFont(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w700,
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
          fontWeight: FontWeight.w500,
          letterSpacing: -0.25,
          color: ThemeApp.primaryNavyBlackColor),
    );
  }

  Widget subListOfCategories(ProductList productList) {
    return Container(
        height: 200,
        // height: 200,
        width: double.infinity,
        alignment: Alignment.center,
        color: ThemeApp.whiteColor,
        child: /*ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: productList!.simpleSubCats!.length,*/
            GridView.builder(
          itemCount: productList!.simpleSubCats!.length,
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 3 / 2.5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductListByCategoryActivity(
                      productList: productList!.simpleSubCats![index]),
                ));
              },
              // child: Padding(
              // padding: const EdgeInsets.only(right: 8.0, bottom: 8),
              child: Container(
                  // width: width * .25,
                  width: 98,
                  height: 59,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: ThemeApp.containerColor, width: 1.5),
                      color: ThemeApp.containerColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  productList.simpleSubCats![index].imageUrl!),
                            ) ??
                            SizedBox(),
                        /* ClipRRect(
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
                        ),*/
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: subCategoryListFont(
                              productList.simpleSubCats![index].name!, context),
                        ),
                      )
                    ],
                  )),
              // ),
            );
          },
        ));

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

  Widget serviceList() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: productCategories,
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

              return Container(
                height: 40,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: serviceList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ShopByCategoryActivity(
                                  shopByCategoryList: serviceList!,
                                  shopByCategorySelected: index),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            // height: 40,

                            padding:
                                const EdgeInsets.fromLTRB(15.0, 5, 15.0, 5),
                            decoration: BoxDecoration(
                              color: ThemeApp.containerColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: TextFieldUtils().dynamicText(
                                  serviceList[index].name!,
                                  context,
                                  TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.blackColor,
                                    // fontWeight: FontWeight.w500,
                                    fontSize: height * .02,
                                  )),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            default:
              return Text("No Data found!");
          }
          return Text("No Data found!");
        }));

    return Container(
      // height: 40,

      padding: const EdgeInsets.fromLTRB(15.0, 10, 15.0, 10),
      decoration: BoxDecoration(
        color: ThemeApp.containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("sakdjsak"),
    );
  }

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
                                    color: ThemeApp.whiteColor,
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Container(
                                          width: width,
                                          color: Colors.white,
                                          child: Image.asset(
                                            e["homeSliderImage"],
                                            fit: BoxFit.fill,
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
                                autoPlay: false,
                                viewportFraction: 1,
                                height: height * .3),
                          ),
                        ],
                      ))
                  : SizedBox();
            });
  }

/*
  Widget listOfShopByCategories() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value:  productCategories,
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
                          StringUtils.shopByCategories, context),
                      viewMoreButton(StringUtils.viewAll, context, () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ShopByCategoryActivity(
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
                    height: MediaQuery.of(context).size.height * .11,
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
                                  builder: (context) => ShopByCategoryActivity(
                                      shopByCategoryList: serviceList!,
                                      shopByCategorySelected: index),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: width * 0.3,
                                    decoration: const BoxDecoration(
                                        color: ThemeApp.containerColor,
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
                                            child: serviceList[index]
                                                    .productCategoryImageId!
                                                    .isNotEmpty
                                                ? Image.network(
                                                    // width: double.infinity,
                                                    serviceList[index]
                                                        .productCategoryImageId!,
                                                    fit: BoxFit.fill,

                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .055,
                                                  )
                                                : SizedBox(
                                                    // height: height * .28,
                                                    width: width,
                                                    child: Icon(
                                                      Icons.image_outlined,
                                                      size: 50,
                                                    )),
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
                                                TextStyle(fontFamily: 'Roboto',
                                                  color: ThemeApp.blackColor,
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
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value:  productCategories,
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
                          StringUtils.bookOurServices, context),
                      viewMoreButton(StringUtils.viewAll, context, () {
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
                    height: MediaQuery.of(context).size.height * .11,
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
                                    width: width * 0.3,
                                    decoration: const BoxDecoration(
                                        color: ThemeApp.containerColor,
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
                                            child: serviceList[index]
                                                    .productCategoryImageId!
                                                    .isNotEmpty
                                                ? Image.network(
                                                    // width: double.infinity,
                                                    serviceList[index]
                                                        .productCategoryImageId!,
                                                    fit: BoxFit.fill,

                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .055,
                                                  )
                                                : SizedBox(
                                                    // height: height * .28,
                                                    width: width,
                                                    child: Icon(
                                                      Icons.image_outlined,
                                                      size: 50,
                                                    )),
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
                                                TextStyle(fontFamily: 'Roboto',
                                                  color: ThemeApp.blackColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: height * .021,
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
  }*/
  int indexForItems = 0;

  Widget stepperOfDelivery(HomeProvider value) {
    return (value.jsonData.length > 0 && value.jsonData['status'] == 'OK' ||
            value.jsonData.isNotEmpty)
        ? Container(
            // height: 300,
            height: 161,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: value.jsonData['payload']['consumer_baskets'].length,
                itemBuilder: (_, index) {
                  //
                  // List orderList = value
                  //     .jsonData['payload']['consumer_baskets'].values
                  //     .toList();
                  // Map order = orderList[index];
                  // DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
                  // DateTime date =
                  // DateTime.parse(order['earliest_delivery_date']);
                  // var earliest_delivery_date = format.format(date);

                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: value
                          .jsonData['payload']['consumer_baskets'][index]
                              ['orders']
                          .length,
                      itemBuilder: (context, indexOrderDetails) {
                        indexForItems = indexOrderDetails;

                        Map subOrders = value.jsonData['payload']
                                ['consumer_baskets'][index]['orders']
                            [indexForItems];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Container(
                              // width: 300,
                              width: width * 0.85,
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                  color: ThemeApp.whiteColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          child: Image.network(
                                            // width: double.infinity,
                                            subOrders['image_url'] ?? "",
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                ((context, error, stackTrace) {
                                              return Icon(Icons.image_outlined);
                                            }),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .055,
                                          )),
                                      SizedBox(
                                        width: 9,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${subOrders["short_name"]}",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              letterSpacing: -0.25,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  stepperWidget(subOrders),
                                ],
                              )),
                        );
                      });
                }),
          )
        : value.jsonData['error'] != null
            ? Container()
            : Center(child: CircularProgressIndicator());
  }

  Widget stepperWidget(Map subOrders) {
    return Container(
        height: height * .1,
        width: width,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: _iconViews(context, subOrders)),
            const SizedBox(
              height: 8,
            ),
            Flexible(child: _titleViews(context, subOrders)),
            Flexible(child: _stepsViews(context, subOrders)),
            /*  Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _stepsViews(context),
              ),
            ),*/
          ],
        ));
  }

  Widget recommendedList() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: productListView,
        child: Consumer<DashboardViewModel>(
            builder: (context, productCategories, child) {
          switch (productCategories.productListingResponse.status) {
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
                  productCategories.productListingResponse.message.toString());

            case Status.COMPLETED:
              if (kDebugMode) {
                print("Api calll");
              }

              List<Content>? serviceList = productCategories
                  .productListingResponse.data!.payload!.content;

              return Container(
                height: 228,
                child: serviceList!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: serviceList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsActivity(
                                            id: serviceList[index].id,
                                            // productList: subProductList[index],
                                            // productSpecificListViewModel:
                                            //     productSpecificListViewModel,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 163,
                                          width: 191,
                                          decoration: const BoxDecoration(
                                              color: ThemeApp.whiteColor,
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
                                                    .toString() ??
                                                "",
                                            fit: BoxFit.scaleDown,
                                            errorBuilder:
                                                ((context, error, stackTrace) {
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        21, 9, 21, 4),
                                                child: TextFieldUtils()
                                                    .listNameHeadingTextField(
                                                        serviceList[index]
                                                            .shortName!,
                                                        context) /*Text(
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
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        21, 0, 21, 9),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    //discount
                                                    TextFieldUtils()
                                                        .listPriceHeadingTextField(
                                                            indianRupeesFormat
                                                                .format(serviceList[
                                                                            index]
                                                                        .defaultSellPrice ??
                                                                    0.0),
                                                            context),

                                                    TextFieldUtils()
                                                        .listScratchPriceHeadingTextField(
                                                            indianRupeesFormat
                                                                .format(serviceList[
                                                                            index]
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
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .03,
                                  )
                                ],
                              ) ??
                              SizedBox();
                        })
                    : SizedBox(),
              );
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
                                                TextStyle(fontFamily: 'Roboto',
                                                    color: ThemeApp.primaryNavyBlackColor
                                                    fontSize: height * .022,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextFieldUtils().dynamicText(
                                                indianRupeesFormat.format(
                                                    productListing[index]
                                                            .currentPrice ??
                                                        0.0),
                                                context,
                                                TextStyle(fontFamily: 'Roboto',
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
*/
  }

  Widget merchantList() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: productListView,
        child: Consumer<DashboardViewModel>(
            builder: (context, productCategories, child) {
          switch (productCategories.productListingResponse.status) {
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
                  productCategories.productListingResponse.message.toString());

            case Status.COMPLETED:
              if (kDebugMode) {
                print("Api calll");
              }

              List<Content>? serviceList = productCategories
                  .productListingResponse.data!.payload!.content;

              return Container(
                height: MediaQuery.of(context).size.height * .35,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: serviceList!.length,
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
                                width: MediaQuery.of(context).size.width * .45,
                                decoration: const BoxDecoration(
                                    color: ThemeApp.tealButtonColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                                                serviceList[index]
                                                        .imageUrls![0]
                                                        .imageUrl! ??
                                                    "",
                                                fit: BoxFit.fill,
                                                errorBuilder: ((context, error,
                                                    stackTrace) {
                                                  return Icon(
                                                      Icons.image_outlined);
                                                }),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .07,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, right: 10),
                                          child: kmAwayOnMerchantImage(
                                            '1.2 km Away',
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
                                              serviceList[index].shortName!,
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
        }));

/*
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value:  productCategories,
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

              return Container(
                height: MediaQuery.of(context).size.height * .35,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: serviceList!.length,
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
                                width: MediaQuery.of(context).size.width * .45,
                                decoration: const BoxDecoration(
                                    color: ThemeApp.tealButtonColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                                              serviceList[index]
                                                  .productCategoryImageId!,
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
                                            '1.2 km Away',
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
                                              serviceList[index].name!,
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
        }));
*/

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
*/
  }

  Widget bestDealList() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: productListView,
        child: Consumer<DashboardViewModel>(
            builder: (context, productCategories, child) {
          switch (productCategories.productListingResponse.status) {
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
                  productCategories.productListingResponse.message.toString());

            case Status.COMPLETED:
              if (kDebugMode) {
                print("Api calll");
              }

              List<Content>? serviceList = productCategories
                  .productListingResponse.data!.payload!.content;

              return Container(
                height: 228,
                child: serviceList!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: serviceList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsActivity(
                                            id: serviceList[index].id,
                                            // productList: subProductList[index],
                                            // productSpecificListViewModel:
                                            //     productSpecificListViewModel,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 163,
                                          width: 191,
                                          decoration: const BoxDecoration(
                                              color:
                                                  ThemeApp.textFieldBorderColor,
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
                                            errorBuilder:
                                                ((context, error, stackTrace) {
                                              return Icon(Icons.image_outlined);
                                            }),
                                            fit: BoxFit.fill,
                                          )),
                                        ),
                                        Container(
                                          color: ThemeApp.tealButtonColor,
                                          width: 191,
                                          height: 65,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        21, 9, 21, 4),
                                                child: TextFieldUtils()
                                                    .listNameHeadingTextField(
                                                        serviceList[index]
                                                            .shortName!,
                                                        context) /*Text(
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
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        21, 0, 21, 9),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    //discount
                                                    TextFieldUtils()
                                                        .listPriceHeadingTextField(
                                                            indianRupeesFormat
                                                                .format(serviceList[
                                                                            index]
                                                                        .defaultSellPrice ??
                                                                    0.0),
                                                            context),

                                                    TextFieldUtils()
                                                        .listScratchPriceHeadingTextField(
                                                            indianRupeesFormat
                                                                .format(serviceList[
                                                                            index]
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
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .03,
                                  )
                                ],
                              ) ??
                              SizedBox();
                        })
                    : SizedBox(),
              );
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
                                              TextStyle(fontFamily: 'Roboto',
                                                  color: ThemeApp.primaryNavyBlackColor
                                                  fontSize: height * .022,
                                                  fontWeight: FontWeight.bold)),
                                          TextFieldUtils().dynamicText(
                                              indianRupeesFormat.format(
                                                  productListing[index]
                                                          .currentPrice ??
                                                      0.0),
                                              context,
                                              TextStyle(fontFamily: 'Roboto',
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
*/
  }

  Widget budgetBuyList() {
    return ChangeNotifierProvider<DashboardViewModel>.value(
        value: productListView,
        child: Consumer<DashboardViewModel>(
            builder: (context, productCategories, child) {
          switch (productCategories.productListingResponse.status) {
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
                  productCategories.productListingResponse.message.toString());

            case Status.COMPLETED:
              if (kDebugMode) {
                print("Api calll");
              }

              List<Content>? serviceList = productCategories
                  .productListingResponse.data!.payload!.content;

              return Container(
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
                                              context) /*Text(
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
                          /* Column(
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
                            )*/
                        ),
                      );
                    },
                  ));
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

  // List<Widget> _iconViews() {
  //   var list = <Widget>[];
  //   titles.asMap().forEach((i, icon) {
  //     var circleColor = (i == 0 || i == 1 || _curStep > i + 1)
  //         ? ThemeApp.darkGreyTab
  //         : ThemeApp.lightGreyTab;
  //     var lineColor =
  //         _curStep > i + 1 ? ThemeApp.appColor : ThemeApp.containerColor;
  //     var iconColor = (i == 0 || i == 1 || _curStep > i + 1)
  //         ? ThemeApp.appColor
  //         : ThemeApp.containerColor;
  //
  //     list.add(
  //       Container(
  //         width: 20.0,
  //         height: 20.0,
  //         padding: const EdgeInsets.all(0),
  //         // decoration:(i == 0 || _curStep > i + 1) ? new  BoxDecoration(
  //         //
  //         // ):BoxDecoration(   /* color: circleColor,*/
  //         //   borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
  //         //   border: new Border.all(
  //         //     color: circleColor,
  //         //     width: 2.0,
  //         //   ),),
  //         child: (i == 0 || i == 1 || _curStep > i + 1)
  //             ? Icon(
  //                 Icons.circle,
  //                 color: iconColor,
  //                 size: 15.0,
  //               )
  //             : Icon(
  //                 Icons.radio_button_checked_outlined,
  //                 color: iconColor,
  //                 size: 15.0,
  //               ),
  //       ),
  //     );
  //
  //     //line between icons
  //     if (i != titles.length - 1) {
  //       list.add(Expanded(
  //           child: Container(
  //         height: 3.0,
  //         color: lineColor,
  //       )));
  //     }
  //   });
  //
  //   return list;
  // }

  Widget _iconViews(
    BuildContext context,
    Map subOrders,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: subOrders['is_order_placed'] == true
              ? Icon(
                  Icons.circle,
                  color: subOrders['is_order_placed'] == true
                      ? ThemeApp.appColor
                      : ThemeApp.inactiveStepperColor,
                  size: 20,
                )
              : Icon(
                  Icons.radio_button_checked_outlined,
                  color: subOrders['is_order_placed'] == true
                      ? ThemeApp.appColor
                      : ThemeApp.inactiveStepperColor,
                  size: 20,
                ),
        ),
        Expanded(
            child: Container(
          height: 3.0,
          color: subOrders['is_order_placed'] == true
              ? ThemeApp.appColor
              : ThemeApp.inactiveStepperColor,
        )),
        Container(
          child: subOrders['is_packed'] == true
              ? Icon(
                  Icons.circle,
                  color: subOrders['is_packed'] == true
                      ? ThemeApp.appColor
                      : ThemeApp.inactiveStepperColor,
                  size: 20,
                )
              : Icon(
                  Icons.radio_button_checked_outlined,
                  color: subOrders['is_packed'] == true
                      ? ThemeApp.appColor
                      : ThemeApp.inactiveStepperColor,
                  size: 20,
                ),
        ),
        Expanded(
            child: Container(
          height: 3.0,
          color: subOrders['is_packed'] == true
              ? ThemeApp.appColor
              : ThemeApp.inactiveStepperColor,
        )),
        Container(
          child: subOrders['is_shipped'] == true
              ? Icon(
                  Icons.circle,
                  color: subOrders['is_shipped'] == true
                      ? ThemeApp.appColor
                      : ThemeApp.inactiveStepperColor,
                  size: 20,
                )
              : Icon(
                  Icons.radio_button_checked_outlined,
                  color: subOrders['is_shipped'] == true
                      ? ThemeApp.appColor
                      : ThemeApp.inactiveStepperColor,
                  size: 20,
                ),
        ),
        Expanded(
            child: Container(
          height: 3.0,
          color: subOrders['is_shipped'] == true
              ? ThemeApp.appColor
              : ThemeApp.inactiveStepperColor,
        )),
        Container(
          child: subOrders['is_delivered'] == true
              ? Icon(
                  Icons.circle,
                  color: subOrders['is_delivered'] == true
                      ? ThemeApp.appColor
                      : ThemeApp.inactiveStepperColor,
                  size: 20,
                )
              : Icon(
                  Icons.radio_button_checked_outlined,
                  color: subOrders['is_delivered'] == true
                      ? ThemeApp.appColor
                      : ThemeApp.inactiveStepperColor,
                  size: 20,
                ),
        ),
      ],
    );
/*
    var list = <Widget>[];
    Color color = ThemeApp.darkGreyTab;
    titles.asMap().forEach((i, text) {
      print("is_accepted..." + subOrders['is_order_placed'].toString());
      if (i == 0) {
      } else if (subOrders['is_order_placed'] == true) {
        print("  if (titles[i] == 0) {");

        color = ThemeApp.blackColor;
      } else {
        color = ThemeApp.darkGreyTab;
      }
      TextFieldUtils().stepperTextFields(text, context, color);
      if (text == 'Packed') {
        if (subOrders['is_packed'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }
      if (text == 'Shipped') {
        if (subOrders['is_shipped'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }
      if (text == 'Delivered') {
        if (subOrders['is_delivered'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }

   */
/*   list.add(
        (i == 0 || i == 1 || _curStep > i + 1)
            ?
        TextFieldUtils().stepperTextFields(text, context, color)
            : TextFieldUtils().stepperTextFields(text, context, color),
      );*/ /*

    });
*/
  }

/*
  List<Widget> _titleViews(
    BuildContext context,
    Map subOrders,
  ) {
    var list = <Widget>[];
    Color color = ThemeApp.darkGreyTab;
    titles.asMap().forEach((i, text) {
      print("is_accepted..." + subOrders['is_order_placed'].toString());
      if (i == 0) {
      } else if (subOrders['is_order_placed'] == true) {
        print("  if (titles[i] == 0) {");

        color = ThemeApp.blackColor;
      } else {
        color = ThemeApp.darkGreyTab;
      }
      if (text == 'Packed') {
        if (subOrders['is_packed'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }
      if (text == 'Shipped') {
        if (subOrders['is_shipped'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }
      if (text == 'Delivered') {
        if (subOrders['is_delivered'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }

      list.add(
            (i == 0 || i == 1 || _curStep > i + 1)
            ?
          TextFieldUtils().stepperTextFields(text, context, color)
            : TextFieldUtils().stepperTextFields(text, context, color),
          );
    });
    return list;
  }*/

  Widget _titleViews(
    BuildContext context,
    Map subOrders,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              'Order Placed',
              context,
              subOrders['is_order_placed'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              'Packed',
              context,
              subOrders['is_packed'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              'Shipped',
              context,
              subOrders['is_shipped'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              'Delivered',
              context,
              subOrders['is_delivered'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
      ],
    );
/*
    var list = <Widget>[];
    Color color = ThemeApp.darkGreyTab;
    titles.asMap().forEach((i, text) {
      print("is_accepted..." + subOrders['is_order_placed'].toString());
      if (i == 0) {
      } else if (subOrders['is_order_placed'] == true) {
        print("  if (titles[i] == 0) {");

        color = ThemeApp.blackColor;
      } else {
        color = ThemeApp.darkGreyTab;
      }
      TextFieldUtils().stepperTextFields(text, context, color);
      if (text == 'Packed') {
        if (subOrders['is_packed'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }
      if (text == 'Shipped') {
        if (subOrders['is_shipped'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }
      if (text == 'Delivered') {
        if (subOrders['is_delivered'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }

   */
/*   list.add(
        (i == 0 || i == 1 || _curStep > i + 1)
            ?
        TextFieldUtils().stepperTextFields(text, context, color)
            : TextFieldUtils().stepperTextFields(text, context, color),
      );*/ /*

    });
*/
  }

  Widget _stepsViews(
    BuildContext context,
    Map subOrders,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              '',
              context,
              subOrders['is_order_placed'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              '3/3',
              context,
              subOrders['is_packed'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              '2/3',
              context,
              subOrders['is_shipped'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              '1/3',
              context,
              subOrders['is_delivered'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
      ],
    );
/*
    var list = <Widget>[];
    Color color = ThemeApp.darkGreyTab;
    titles.asMap().forEach((i, text) {
      print("is_accepted..." + subOrders['is_order_placed'].toString());
      if (i == 0) {
      } else if (subOrders['is_order_placed'] == true) {
        print("  if (titles[i] == 0) {");

        color = ThemeApp.blackColor;
      } else {
        color = ThemeApp.darkGreyTab;
      }
      TextFieldUtils().stepperTextFields(text, context, color);
      if (text == 'Packed') {
        if (subOrders['is_packed'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }
      if (text == 'Shipped') {
        if (subOrders['is_shipped'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }
      if (text == 'Delivered') {
        if (subOrders['is_delivered'] == true) {
          color = ThemeApp.blackColor;
        }
      } else {
        color = ThemeApp.darkGreyTab;
      }

   */
/*   list.add(
        (i == 0 || i == 1 || _curStep > i + 1)
            ?
        TextFieldUtils().stepperTextFields(text, context, color)
            : TextFieldUtils().stepperTextFields(text, context, color),
      );*/ /*

    });
*/
  }

/*
  List<Widget> _stepsViews(BuildContext context) {
    var list = <Widget>[];
    titles.asMap().forEach((i, text) {
      var titleLength = 1 + i;

      list.add(
        (i < i + 1)
            ? TextFieldUtils().stepperTextFields(
                titles.length.toString() + '/' + titleLength.toString(),
                context,
                ThemeApp.darkGreyTab)
            : TextFieldUtils()
                .stepperTextFields(text, context, ThemeApp.lightGreyTab),
      );
    });
    return list;
  }
*/

}

class StepperWidget extends StatefulWidget {
  @override
  _StepperWidgetState createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep >= 4) return;
              setState(() {
                _currentStep += 1;
              });
            },
            onStepCancel: () {
              if (_currentStep <= 0) return;
              setState(() {
                _currentStep -= 1;
              });
            },
            steps: const <Step>[
              Step(
                title: Text('Step 1'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              Step(
                title: Text('Step 2'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              Step(
                title: Text('Step 3'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              Step(
                title: Text('Step 4'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              Step(
                title: Text('Step 5'),
                content: SizedBox(
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
