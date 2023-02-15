import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/pages/Activity/My_Orders/CancelOrderScreen.dart';
import 'package:velocit/services/providers/Home_Provider.dart';

import '../../../Core/repository/cart_repository.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../utils/StringUtils.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes/routes.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';
import 'MyOrderDetails.dart';
import 'OrderRatting_Review_Activity.dart';
import 'ReturnOrderScreen.dart';

class MyOrdersActivity extends StatefulWidget {
  const MyOrdersActivity({Key? key}) : super(key: key);

  @override
  State<MyOrdersActivity> createState() => _MyOrdersActivityState();
}

class _MyOrdersActivityState extends State<MyOrdersActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  late int subIndexOrderList;
  int indexForItems = 0;
  bool viewMore = false;
  var data;
  bool isNewNotifications = false;
  bool isActiveOrders = false;

  @override
  void initState() {
    // TODO: implement initState
    viewMore = false;
    isNewNotifications = true;
    isActiveOrders = false;

    data = Provider.of<HomeProvider>(context, listen: false).loadJson();
    super.initState();
  }

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );

  reOrderMoveCart(String userId, String productId, String serviceId,
      String merchantId, String quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
    print("Cart Id : " + StringConstant.UserCartID);
    String FromType = (prefs.getString('FromType')) ?? '';
    print("FromType : " + FromType.toString());
    Map<String, String> data;
    print('productId' + productId.toString() ?? serviceId);
    print('serviceId' + serviceId.toString());
    if (StringConstant().isNumeric(productId)) {
      FromType = 'FromProduct';
      print("This is Product ");
    } else {
      FromType = 'FromServices';
      print("This is service ");
    }
    print("This is FromType " + FromType.toString());
    if (FromType == 'FromServices') {
      data = {
        // "cartId": StringConstant.UserCartID.toString(),
        "cartId": StringConstant.UserCartID.toString(),
        "userId": userId,
        "serviceId": serviceId,
        "merchantId": merchantId.toString(),
        "qty": quantity.toString(),
        "is_new_order": 'true'
      };
    } else {
      data = {
        // "cartId": StringConstant.UserCartID.toString(),
        "cartId": StringConstant.UserCartID.toString(),
        "userId": userId,
        "productId": productId,
        "merchantId": merchantId.toString(),
        "qty": quantity.toString(),
        "is_new_order": 'true'
      };
    }
    print("update cart DATA" + data.toString());
    CartRepository().updateCartPostRequest(data, context).then((value) {
      setState(() {
        Utils.successToast('Added Successfully!');
      });
      StringConstant.BadgeCounterValue =
          (prefs.getString('setBadgeCountPrefs')) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RoutesName.myAccountRoute, (route) => true)
            .then((value) {
          setState(() {});
        });
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .19),
          child: Container(
            height: height * .21,
            child: Column(
              children: [
                AppBar_BackWidget(
                    context: context,
                    titleWidget: appTitle(context, "My Orders"),
                    location: SizedBox()),
                Consumer<HomeProvider>(builder: (context, value, child) {
                  return Container(
                    height: height * .077,
                    decoration: BoxDecoration(
                        border: Border.all(color: ThemeApp.appColor, width: 1)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () async {
                                // data = Provider.of<HomeProvider>(context, listen: false).loadJson();
                                value.IsActiveOrderList = true;
                                if (value.IsActiveOrderList == true) {
                                  data = await Provider.of<HomeProvider>(
                                          context,
                                          listen: false)
                                      .loadJson();
                                }
                                // data = Provider.of<HomeProvider>(context,
                                //         listen: false)
                                //     .loadJson();
                                // email.clear();
                                // _usingPassVisible==true ? _validateEmail = true:_validateEmail=false;
                                setState(() {
                                  isActiveOrders = true;
                                  isActiveOrders = !isActiveOrders;
                                  data;
                                });
                              },
                              child: Container(
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: isActiveOrders
                                        ? ThemeApp.whiteColor
                                        : ThemeApp.appColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFieldUtils().usingPassTextFields(
                                          'Active Orders',
                                          isActiveOrders
                                              ? ThemeApp.blackColor
                                              : ThemeApp.whiteColor,
                                          context),
                                    ],
                                  ))),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () async {
                                value.IsActiveOrderList = false;
                                if (value.IsActiveOrderList == false) {
                                  data = await Provider.of<HomeProvider>(
                                          context,
                                          listen: false)
                                      .loadJson();
                                }

                                setState(() {
                                  isActiveOrders = true;

                                  data;
                                });
                              },
                              child: Container(
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: isActiveOrders
                                        ? ThemeApp.appColor
                                        : ThemeApp.whiteColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/appImages/emailValidateIcon.svg',
                                        width: 16,
                                        height: 16,
                                        color: ThemeApp.whiteColor,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      TextFieldUtils().usingPassTextFields(
                                          "Past Orders",
                                          isActiveOrders
                                              ? ThemeApp.whiteColor
                                              : ThemeApp.blackColor,
                                          context),
                                    ],
                                  ))),
                        ),
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        ),
        bottomNavigationBar: bottomNavigationBarWidget(context, 0),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: Container(
            color: ThemeApp.appBackgroundColor,
            width: width,
            child: Consumer<HomeProvider>(builder: (context, value, child) {
              return Padding(
                  padding: const EdgeInsets.all(20),
                  child:
                      data == '' ? CircularProgressIndicator() : mainUI(value));
            }),
          ),
        ),
      ),
    );
  }

  Widget mainUI(HomeProvider value) {
    return value.jsonData.isNotEmpty
        ? Stack(
            children: [
              Column(
                children: [
                  !isActiveOrders ? SizedBox() : allOrderDropdownShow(value),
                  SizedBox(
                    height: height * .02,
                  ),
                  isActiveOrders ? pastOrderList(value) : activeOrderList(value)
                ],
              ),
              /*     isNewNotifications == true
              ? Positioned(
            bottom: 0,
            right: 2,
            left: 2,
            child: Container(
              width: width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                color: ThemeApp.primaryNavyBlackColor,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        TextFieldUtils().dynamicText(
                            'New Order',
                            context,
                            TextStyle(fontFamily: 'Roboto',
                                color: ThemeApp.whiteColor,
                                fontSize: height * .032,
                                fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isNewNotifications = false;
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            size: height * .05,
                            color: ThemeApp.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: height * .1,
                      child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (_, index) {
                            return Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                      "${value.myOrdersList[1]["myOrderDetailList"][1]["productDetails"]}",
                                      style: TextStyle(fontFamily: 'Roboto',
                                          color:
                                          ThemeApp.whiteColor,
                                          fontSize: height * .022,
                                          fontWeight:
                                          FontWeight.w300,
                                          overflow: TextOverflow
                                              .ellipsis)),
                                ),
                                TextFieldUtils().dynamicText(
                                    "* 3",
                                    context,
                                    TextStyle(fontFamily: 'Roboto',
                                        color: ThemeApp.blackColor,
                                        fontSize: height * .022,
                                        fontWeight: FontWeight.w400,
                                        overflow:
                                        TextOverflow.ellipsis)),
                              ],
                            );
                          }),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isNewNotifications = false;
                        });
                      },
                      child: Container(
                        width: width * .3,
                        padding: const EdgeInsets.fromLTRB(
                            20.0, 10, 20.0, 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: ThemeApp.whiteColor,
                        ),
                        child: Center(
                          child: TextFieldUtils().dynamicText(
                              "View",
                              context,
                              TextStyle(fontFamily: 'Roboto',
                                  color: ThemeApp
                                      .primaryNavyBlackColor,
                                  fontSize: height * .023,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              : SizedBox()*/
            ],
          )
        : Center(child: CircularProgressIndicator());
  }

  String activeDropdownValue = 'All Orders';

  var activeItems = [
    'All Orders',
    'Acceptance Pending',
    'Packed Orders',
    'Shipped Orders',
  ];
  String allDropdownValue = 'Past 7 Days';

  var allItems = [
    'Past 7 Days',
    'Past 1 Month',
    'Past 3 Months',
    'Past 6 Months',
  ];

/*  Widget dropdownShow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // TextFieldUtils().dynamicText(
        //     "Show",
        //     context,
        //     TextStyle(fontFamily: 'Roboto',
        //         color: ThemeApp.blackColor,
        //         fontSize: height * .022,
        //         fontWeight: FontWeight.w500,
        //         overflow: TextOverflow.ellipsis)),
        // SizedBox(
        //   width: width * .03,
        // ),
        Container(
          decoration: BoxDecoration(
            color: ThemeApp.whiteColor, //<-- SEE HERE
          ),
          width: MediaQuery.of(context).size.width * .51,
          // height: 35,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              fillColor: ThemeApp.whiteColor,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            style: TextStyle(
                fontFamily: 'Roboto',
                color: ThemeApp.lightFontColor,
                fontSize: height * .02,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis),

            value: activeDropdownValue,

            // Down Arrow Icon
            // icon: const Icon(Icons.arrow_drop_down,size: 30),

            // Array list of items
            items: activeItems.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: TextFieldUtils().dynamicText(
                    items,
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis)),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                activeDropdownValue = newValue!;

              });
            },
          ),
        ),
      ],
    );
  }*/

  Widget allOrderDropdownShow(HomeProvider value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // TextFieldUtils().dynamicText(
        //     "Show",
        //     context,
        //     TextStyle(fontFamily: 'Roboto',
        //         color: ThemeApp.blackColor,
        //         fontSize: height * .022,
        //         fontWeight: FontWeight.w500,
        //         overflow: TextOverflow.ellipsis)),
        // SizedBox(
        //   width: width * .03,
        // ),
        Container(
          decoration: BoxDecoration(
            color: ThemeApp.whiteColor, //<-- SEE HERE
          ),
          width: MediaQuery.of(context).size.width * .51,
          // height: 35,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              fillColor: ThemeApp.whiteColor,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: ThemeApp.whiteColor)),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            style: TextStyle(
                fontFamily: 'Roboto',
                color: ThemeApp.lightFontColor,
                fontSize: height * .02,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis),

            value: allDropdownValue,

            // Down Arrow Icon
            // icon: const Icon(Icons.arrow_drop_down,size: 30),

            // Array list of items
            items: allItems.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: TextFieldUtils().dynamicText(
                    items,
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.lightFontColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis)),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                allDropdownValue = newValue!;
                print(newValue);

                if (newValue == 'Past 7 Days') {
                  value.PastDays = 7;
                }
                if (newValue == 'Past 1 Month') {
                  value.PastDays = 30;
                }
                if (newValue == 'Past 3 Months') {
                  value.PastDays = 90;
                }
                if (newValue == 'Past 6 Months') {
                  value.PastDays = 180;
                }

                data = Provider.of<HomeProvider>(context, listen: false)
                    .loadJson();
              });
            },
          ),
        ),
      ],
    );
  }

  int indexOfOrders = 0;

  Widget activeOrderList(HomeProvider value) {
    return Expanded(
      child: value.jsonData['status'] == "EXCEPTION"
          ? Text("")
          : ListView.builder(
              itemCount: value.jsonData['payload']['consumer_baskets'].length,
              itemBuilder: (_, index) {
                Map order =
                    value.jsonData['payload']['consumer_baskets'][index];
                DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
                DateTime date = DateTime.parse(order['earliest_delivery_date']);
                var earliest_delivery_date = format.format(date);

                Color colorsStatus = ThemeApp.activeOrderColor;
                /*      for (var i = 0;
                    i <
                        value
                            .jsonData['payload']['consumer_baskets'][index]
                                ['orders']
                            .length;
                    i++) {
                  print("order['orders'][i]['cancelled']" +
                      order['orders'][i]['cancelled'].toString());
                  if (order['orders'][i]['cancelled'] == true) {
                    colorsStatus = ThemeApp.separatedLineColor;
                  }
                }*/
                if (order["overall_status"] == "Acceptance Pending") {
                  colorsStatus = ThemeApp.redColor;
                }
                if (order["overall_status"] == "Shipped") {
                  colorsStatus = ThemeApp.shippedOrderColor;
                }
                if (order["overall_status"] == "Completed") {
                  colorsStatus = ThemeApp.lightFontColor;
                }
                if (order["overall_status"] == "Canceled") {
                  colorsStatus = ThemeApp.lightFontColor;
                }

                return value
                                .jsonData['payload']['consumer_baskets'][index]
                                    ['orders']
                                .length -
                            1 <
                        0
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 20),
                        child: Container(
                            padding: EdgeInsets.only(
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: colorsStatus,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(15),

                              // height: height * 0.12,
                              // width: width * .8,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                color: ThemeApp.whiteColor,
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //image grid
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        color: ThemeApp.whiteColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 44,
                                            width: 45,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing: 0,
                                                crossAxisCount: 2,
                                                // childAspectRatio: 4/7
                                              ),
                                              itemCount: order['orders'].length,
                                              itemBuilder:
                                                  (context, indexOrderList) {
                                                subIndexOrderList =
                                                    indexOrderList;
                                                return order['orders']
                                                                [indexOrderList]
                                                            ['cancelled'] ==
                                                        'true'
                                                    ? SizedBox()
                                                    : Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: ThemeApp
                                                                    .whiteColor)),
                                                        child: FittedBox(
                                                          child: Image.network(
                                                                  // width: double.infinity,
                                                                  order['orders']
                                                                              [
                                                                              indexOrderList]
                                                                          [
                                                                          "image_url"] ??
                                                                      "",
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  height: 22,
                                                                  width: 21,
                                                                  errorBuilder:
                                                                      ((context,
                                                                          error,
                                                                          stackTrace) {
                                                                return Icon(Icons
                                                                    .image_outlined);
                                                              })) ??
                                                              SizedBox(),
                                                        ),
                                                      );

                                                // Item rendering
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .03,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextFieldUtils().dynamicText(
                                                  order['id'].toString(),
                                                  context,
                                                  TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: ThemeApp
                                                        .primaryNavyBlackColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  )),
                                              SizedBox(
                                                height: height * .01,
                                              ),
                                              TextFieldUtils().dynamicText(
                                                  earliest_delivery_date,
                                                  context,
                                                  TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: ThemeApp
                                                          .lightFontColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
/*  Padding(
                                    padding:
                                        const EdgeInsets.only(right: 10),
                                    child: Container(
                                      height: height * .1,
                                      width: width * .75,
                                      child: ListView.builder(
                                        itemCount: value
                                            .myOrdersList[index]
                                                ["myOrderDetailList"]
                                            .length,
                                        itemBuilder:
                                            (context, indexOrderDetails) {
                                          indexForItems = indexOrderDetails;
                                          return Container(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    "${value.myOrdersList[index]["myOrderDetailList"][indexOrderDetails]["productDetails"]}",
                                                    style: TextStyle(fontFamily: 'Roboto',
                                                        color: ThemeApp
                                                            .blackColor,
                                                        fontSize:
                                                            height * .024,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis)),
                                              ),
                                              SizedBox(
                                                width: width * .005,
                                              ),
                                              TextFieldUtils().dynamicText(
                                                  "* 3",
                                                  context,
                                                  TextStyle(fontFamily: 'Roboto',
                                                      color: ThemeApp
                                                          .blackColor,
                                                      fontSize:
                                                          height * .022,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ],
                                          ));
                                        },
                                      ),
                                    ),
                                  ),*/

                                    Container(
                                        height: order['orders'].length > 2
                                            ? !viewMore
                                                ? 50
                                                : 80
                                            : 30,
                                        // width: width * .63,
                                        child: ListView.builder(
                                          physics: order['orders'].length > 2
                                              ? ScrollPhysics()
                                              : NeverScrollableScrollPhysics(),
                                          itemCount: order['orders'].length > 2
                                              ? !viewMore
                                                  ? 2
                                                  : order['orders'].length
                                              : order['orders'].length,
                                          itemBuilder:
                                              (context, indexOrderDetails) {
                                            indexOfOrders == 0
                                                ? indexOfOrders - 1
                                                : indexOfOrders =
                                                    indexOrderDetails;
                                            print("Order Id : " +
                                                order['orders'][indexOfOrders]
                                                        ['order_id']
                                                    .toString());
                                            return (order['orders'].length > 2)
                                                ? !viewMore
                                                    ? order['orders'][
                                                                    indexOrderDetails]
                                                                ['cancelled'] ==
                                                            'true'
                                                        ? SizedBox()
                                                        : Container(
                                                            child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  // width: 280,
                                                                  child: Text(
                                                                      "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          color: ThemeApp
                                                                              .blackColor,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          letterSpacing:
                                                                              -0.25,
                                                                          overflow:
                                                                              TextOverflow.ellipsis)),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    "* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        letterSpacing:
                                                                            -0.25,
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              ],
                                                            ),
                                                          ))
                                                    : order['orders'][
                                                                    indexOrderDetails]
                                                                ['cancelled'] ==
                                                            'true'
                                                        ? SizedBox()
                                                        : Container(
                                                            child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  // width: 280,
                                                                  child: Text(
                                                                      "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          color: ThemeApp
                                                                              .blackColor,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          letterSpacing:
                                                                              -0.25,
                                                                          overflow:
                                                                              TextOverflow.ellipsis)),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    "* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        letterSpacing:
                                                                            -0.25,
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              ],
                                                            ),
                                                          ))
                                                : order['orders'][
                                                                indexOrderDetails]
                                                            ['cancelled'] ==
                                                        'true'
                                                    ? SizedBox()
                                                    : Container(
                                                        child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              // width: 280,
                                                              child: Text(
                                                                  "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      color: ThemeApp
                                                                          .blackColor,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      letterSpacing:
                                                                          -0.25,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis)),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text("* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: ThemeApp
                                                                        .blackColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    letterSpacing:
                                                                        -0.25,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis)),
                                                          ],
                                                        ),
                                                      ));
                                          },
                                        )),

                                    order['orders'].length < 2
                                        ? SizedBox()
                                        : Row(
                                            children: [
                                              order['orders'].length > 2
                                                  ? !viewMore
                                                      ? InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              viewMore =
                                                                  !viewMore;
                                                            });
                                                          },
                                                          child: TextFieldUtils().dynamicText(
                                                              '+ View More',
                                                              context,
                                                              TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: ThemeApp
                                                                      .tealButtonColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              viewMore =
                                                                  !viewMore;
                                                            });
                                                          },
                                                          child: TextFieldUtils().dynamicText(
                                                              '- View Less',
                                                              context,
                                                              TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: ThemeApp
                                                                      .tealButtonColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        )
                                                  : SizedBox(),
                                            ],
                                          ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //tootal amount
                                          TextFieldUtils().dynamicText(
                                              indianRupeesFormat
                                                  .format(double.parse(
                                                      order['offer']
                                                              .toString() ??
                                                          ""))
                                                  .toString(),
                                              context,
                                              TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: ThemeApp.blackColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.2)),
                                          Row(
                                            children: [
                                              /* value.myOrdersList[index]
                                                        ["myOrderStatus"] ==
                                                    "Acceptance Pending"
                                                ? SizedBox()
                                                : Container(
                                                    child: TextFieldUtils().dynamicText(
                                                        "Change Status to:",
                                                        context,
                                                        TextStyle(fontFamily: 'Roboto',
                                                            color: ThemeApp
                                                                .blackColor,
                                                            fontSize:
                                                                height *
                                                                    .018,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),*/
                                              //order status whith dynamic color

                                              /*  SizedBox(
                                        width: width * .02,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 10, 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          border: Border.all(
                                              color: colorsStatus),
                                          color: ThemeApp.whiteColor,
                                        ),
                                        child: TextFieldUtils().dynamicText(
                                            order['overall_status'],
                                            context,
                                            TextStyle(
                                                fontFamily: 'Roboto',
                                                color: colorsStatus,
                                                fontSize: 10,
                                                fontWeight:
                                                    FontWeight.w500)),
                                      ),*/
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 19,
                                    ),
                                    TextFieldUtils().lineHorizontal(),
                                    // stepperWidget(),
                                    /*         stepperWidget(*/ /*
                                        order['orders'][subIndexOrderList]*/ /*subIndexOrderList, order),
*/
                                    stepperWidget(
                                        value.jsonData['payload']
                                                ['consumer_baskets'][index]
                                            ['orders'][0],
                                        value.jsonData['payload']
                                            ['consumer_baskets'][index]),
                                    TextFieldUtils().lineHorizontal(),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            order['overall_status'] ==
                                                    'Delivered'
                                                ? InkWell(
                                                    onTap: () {
                                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrderRatingReviewActivity(values:  value.myOrderList[index])));
                                                    },
                                                    child: rattingBar())
                                                : SizedBox(),
                                            /*TextFieldUtils().dynamicText(
                                              'Item Return Inprogress',
                                                  context,
                                                  TextStyle(fontFamily: 'Roboto',
                                                      color: ThemeApp
                                                          .blackColor,
                                                      fontSize:
                                                          12,
                                                      fontWeight:
                                                          FontWeight.w400)),*/

                                            order['overall_status'] ==
                                                    'Canceled'
                                                ? Container(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15.0, 7.0, 15.0, 7.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(20),
                                                      ),
                                                      color: ThemeApp.redColor,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        TextFieldUtils().dynamicText(
                                                            "Order Canceled",
                                                            context,
                                                            TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: ThemeApp
                                                                    .whiteColor,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                      ],
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => CancelOrderActivity(
                                                              values: value.jsonData[
                                                                          'payload']
                                                                      [
                                                                      'consumer_baskets']
                                                                  [index],
                                                              orderList: order[
                                                                      'orders'][
                                                                  indexOfOrders])));
                                                    },
                                                    child: Container(
                                                        padding: const EdgeInsets
                                                                .fromLTRB(
                                                            11, 5, 11, 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                100),
                                                          ),
                                                          border: Border.all(
                                                              color: ThemeApp
                                                                  .tealButtonColor),
                                                          color: ThemeApp
                                                              .tealButtonColor,
                                                        ),
                                                        child: TextFieldUtils().dynamicText(
                                                            'Cancel Order',
                                                            context,
                                                            TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: ThemeApp
                                                                    .whiteColor,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                letterSpacing:
                                                                    -0.08))),
                                                  ),
                                          ],
                                        )),
                                  ]),
                            )));
              }),
    );
    /* : Center(
            child: TextFieldUtils().dynamicText(
                'No data found',
                context,
                TextStyle(fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis)),
          );*/
  }

  Widget pastOrderList(HomeProvider value) {
    return Expanded(
      child: value.jsonData['status'] == "EXCEPTION"
          ? Text("")
          : value.jsonData['payload']['consumer_baskets'].length - 1 <= 0
              ? Center(
                  child: TextFieldUtils().dynamicText(
                      'No past orders',
                      context,
                      TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.primaryNavyBlackColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      )),
                )
              : ListView.builder(
                  itemCount:
                      value.jsonData['payload']['consumer_baskets'].length,
                  itemBuilder: (_, index) {
                    Map order =
                        value.jsonData['payload']['consumer_baskets'][index];

                    DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
                    DateTime date =
                        DateTime.parse(order['earliest_delivery_date']);
                    var earliest_delivery_date = format.format(date);

                    Color colorsStatus = ThemeApp.activeOrderColor;
                    if (order["overall_status"] == "Acceptance Pending") {
                      colorsStatus = ThemeApp.redColor;
                    }
                    if (order["overall_status"] == "Shipped") {
                      colorsStatus = ThemeApp.shippedOrderColor;
                    }
                    if (order["overall_status"] == "Completed") {
                      colorsStatus = ThemeApp.lightFontColor;
                    }

                    return value
                                    .jsonData['payload']['consumer_baskets']
                                        [index]['orders']
                                    .length -
                                1 <
                            0
                        ? SizedBox()
                        : Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 20),
                            child: Container(
                                padding: EdgeInsets.only(
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: colorsStatus,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(15),

                                  // height: height * 0.12,
                                  // width: width * .8,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                    color: ThemeApp.whiteColor,
                                  ),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //image grid
                                        //image grid
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                            color: ThemeApp.whiteColor,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 44,
                                                width: 45,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing: 0,
                                                    mainAxisSpacing: 0,
                                                    crossAxisCount: 2,
                                                    // childAspectRatio: 4/7
                                                  ),
                                                  itemCount:
                                                      order['orders'].length,
                                                  itemBuilder: (context,
                                                      indexOrderList) {
                                                    subIndexOrderList =
                                                        indexOrderList;
                                                    return order['orders'][
                                                                    indexOrderList]
                                                                ['cancelled'] ==
                                                            'true'
                                                        ? SizedBox()
                                                        : Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: ThemeApp
                                                                        .whiteColor)),
                                                            child: FittedBox(
                                                              child: Image
                                                                      .network(
                                                                          // width: double.infinity,
                                                                          order['orders'][indexOrderList]["image_url"] ??
                                                                              "",
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          height:
                                                                              22,
                                                                          width:
                                                                              21,
                                                                          errorBuilder: ((context,
                                                                              error,
                                                                              stackTrace) {
                                                                    return Icon(
                                                                        Icons
                                                                            .image_outlined);
                                                                  })) ??
                                                                  SizedBox(),
                                                            ),
                                                          );

                                                    // Item rendering
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * .03,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextFieldUtils().dynamicText(
                                                      order['id'].toString(),
                                                      context,
                                                      TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color: ThemeApp
                                                            .primaryNavyBlackColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12,
                                                      )),
                                                  SizedBox(
                                                    height: height * .01,
                                                  ),
                                                  TextFieldUtils().dynamicText(
                                                      earliest_delivery_date,
                                                      context,
                                                      TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color: ThemeApp
                                                              .lightFontColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
/*  Padding(
                                    padding:
                                        const EdgeInsets.only(right: 10),
                                    child: Container(
                                      height: height * .1,
                                      width: width * .75,
                                      child: ListView.builder(
                                        itemCount: value
                                            .myOrdersList[index]
                                                ["myOrderDetailList"]
                                            .length,
                                        itemBuilder:
                                            (context, indexOrderDetails) {
                                          indexForItems = indexOrderDetails;
                                          return Container(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    "${value.myOrdersList[index]["myOrderDetailList"][indexOrderDetails]["productDetails"]}",
                                                    style: TextStyle(fontFamily: 'Roboto',
                                                        color: ThemeApp
                                                            .blackColor,
                                                        fontSize:
                                                            height * .024,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis)),
                                              ),
                                              SizedBox(
                                                width: width * .005,
                                              ),
                                              TextFieldUtils().dynamicText(
                                                  "* 3",
                                                  context,
                                                  TextStyle(fontFamily: 'Roboto',
                                                      color: ThemeApp
                                                          .blackColor,
                                                      fontSize:
                                                          height * .022,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ],
                                          ));
                                        },
                                      ),
                                    ),
                                  ),*/

                                        Container(
                                            height: order['orders'].length > 2
                                                ? !viewMore
                                                    ? 50
                                                    : 80
                                                : 30,
                                            // width: width * .63,
                                            child: ListView.builder(
                                              physics: order['orders'].length >
                                                      2
                                                  ? ScrollPhysics()
                                                  : NeverScrollableScrollPhysics(),
                                              itemCount: order['orders']
                                                          .length >
                                                      2
                                                  ? !viewMore
                                                      ? 2
                                                      : order['orders'].length
                                                  : order['orders'].length,
                                              itemBuilder:
                                                  (context, indexOrderDetails) {
                                                indexOfOrders == 0
                                                    ? indexOfOrders - 1
                                                    : indexOfOrders =
                                                        indexOrderDetails;
                                                print("Order Id : " +
                                                    order['orders']
                                                                [indexOfOrders]
                                                            ['order_id']
                                                        .toString());
                                                return (order['orders'].length >
                                                        2)
                                                    ? !viewMore
                                                        ? order['orders'][
                                                                        indexOrderDetails]
                                                                    [
                                                                    'cancelled'] ==
                                                                'true'
                                                            ? SizedBox()
                                                            : Container(
                                                                child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Flexible(
                                                                      // width: 280,
                                                                      child: Text(
                                                                          "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              color: ThemeApp.blackColor,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              letterSpacing: -0.25,
                                                                              overflow: TextOverflow.ellipsis)),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                        "* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            color: ThemeApp
                                                                                .blackColor,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .w700,
                                                                            letterSpacing:
                                                                                -0.25,
                                                                            overflow:
                                                                                TextOverflow.ellipsis)),
                                                                  ],
                                                                ),
                                                              ))
                                                        : order['orders'][
                                                                        indexOrderDetails]
                                                                    [
                                                                    'cancelled'] ==
                                                                'true'
                                                            ? SizedBox()
                                                            : Container(
                                                                child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Flexible(
                                                                      // width: 280,
                                                                      child: Text(
                                                                          "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              color: ThemeApp.blackColor,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              letterSpacing: -0.25,
                                                                              overflow: TextOverflow.ellipsis)),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                        "* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            color: ThemeApp
                                                                                .blackColor,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight: FontWeight
                                                                                .w700,
                                                                            letterSpacing:
                                                                                -0.25,
                                                                            overflow:
                                                                                TextOverflow.ellipsis)),
                                                                  ],
                                                                ),
                                                              ))
                                                    : order['orders'][
                                                                    indexOrderDetails]
                                                                ['cancelled'] ==
                                                            'true'
                                                        ? SizedBox()
                                                        : Container(
                                                            child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  // width: 280,
                                                                  child: Text(
                                                                      "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          color: ThemeApp
                                                                              .blackColor,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          letterSpacing:
                                                                              -0.25,
                                                                          overflow:
                                                                              TextOverflow.ellipsis)),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    "* ${order['orders'][indexOrderDetails]["item_qty"]}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: ThemeApp
                                                                            .blackColor,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        letterSpacing:
                                                                            -0.25,
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              ],
                                                            ),
                                                          ));
                                              },
                                            )),

                                        order['orders'].length < 2
                                            ? SizedBox()
                                            : Row(
                                                children: [
                                                  order['orders'].length > 2
                                                      ? !viewMore
                                                          ? InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  viewMore =
                                                                      !viewMore;
                                                                });
                                                              },
                                                              child: TextFieldUtils().dynamicText(
                                                                  '+ View More',
                                                                  context,
                                                                  TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      color: ThemeApp
                                                                          .tealButtonColor,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  viewMore =
                                                                      !viewMore;
                                                                });
                                                              },
                                                              child: TextFieldUtils().dynamicText(
                                                                  '- View Less',
                                                                  context,
                                                                  TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      color: ThemeApp
                                                                          .tealButtonColor,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                            )
                                                      : SizedBox(),
                                                ],
                                              ),

                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //tootal amount
                                              TextFieldUtils().dynamicText(
                                                  indianRupeesFormat
                                                      .format(double.parse(
                                                          order['offer']
                                                                  .toString() ??
                                                              ""))
                                                      .toString(),
                                                  context,
                                                  TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color:
                                                          ThemeApp.blackColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 0.2)),
                                              Row(
                                                children: [
                                                  /* value.myOrdersList[index]
                                                        ["myOrderStatus"] ==
                                                    "Acceptance Pending"
                                                ? SizedBox()
                                                : Container(
                                                    child: TextFieldUtils().dynamicText(
                                                        "Change Status to:",
                                                        context,
                                                        TextStyle(fontFamily: 'Roboto',
                                                            color: ThemeApp
                                                                .blackColor,
                                                            fontSize:
                                                                height *
                                                                    .018,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                  ),*/
                                                  //order status whith dynamic color

                                                  /*  SizedBox(
                                        width: width * .02,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 10, 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          border: Border.all(
                                              color: colorsStatus),
                                          color: ThemeApp.whiteColor,
                                        ),
                                        child: TextFieldUtils().dynamicText(
                                            order['overall_status'],
                                            context,
                                            TextStyle(
                                                fontFamily: 'Roboto',
                                                color: colorsStatus,
                                                fontSize: 10,
                                                fontWeight:
                                                    FontWeight.w500)),
                                      ),*/
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 19,
                                        ),
                                        TextFieldUtils().lineHorizontal(),
                                        // stepperWidget(),
                                        // stepperWidget(
                                        //     order['orders'][subIndexOrderList]),
                                        // TextFieldUtils().lineHorizontal(),
                                        SizedBox(
                                          height: 6,
                                        ),

                                        Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrderRatingReviewActivity(values:  value.myOrderList[index])));
                                                  },
                                                  child: Row(children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                OrderRatingReviewActivity(
                                                                    values: value.jsonData['payload']
                                                                            [
                                                                            'consumer_baskets']
                                                                        [
                                                                        index])));
                                                      },
                                                      child: Container(
                                                          padding: const EdgeInsets
                                                                  .fromLTRB(
                                                              11, 5, 11, 5),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  100),
                                                            ),
                                                          ),
                                                          child: TextFieldUtils().dynamicText(
                                                              'Review and Rating',
                                                              context,
                                                              TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: ThemeApp
                                                                      .tealButtonColor,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  letterSpacing:
                                                                      -0.08))),
                                                    ),
                                                  ]), /*rattingBar()*/
                                                ),
                                                /* order['overall_status'] == 'Delivered'
                                        ? InkWell(
                                        onTap: () {
                                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrderRatingReviewActivity(values:  value.myOrderList[index])));
                                        },
                                        child: rattingBar())
                                        : SizedBox(),*/
                                                /*TextFieldUtils().dynamicText(
                                              'Item Return Inprogress',
                                                  context,
                                                  TextStyle(fontFamily: 'Roboto',
                                                      color: ThemeApp
                                                          .blackColor,
                                                      fontSize:
                                                          12,
                                                      fontWeight:
                                                          FontWeight.w400)),*/

                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ReturnOrderActivity(
                                                              values: value
                                                                          .jsonData[
                                                                      'payload']
                                                                  [
                                                                  'consumer_baskets'][index],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15.0,
                                                                7.0,
                                                                15.0,
                                                                7.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(20),
                                                          ),
                                                          border: Border.all(
                                                            color: ThemeApp
                                                                .tealButtonColor,
                                                          ),
                                                          color: ThemeApp
                                                              .containerColor,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            /*    Icon(Icons.refresh_sharp,
                                                    color:
                                                    ThemeApp.whiteColor,
                                                    size: height * .02),
                                                SizedBox(
                                                  width: width * .01,
                                                ),*/
                                                            TextFieldUtils().dynamicText(
                                                                "Return",
                                                                context,
                                                                TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: ThemeApp
                                                                        .tealButtonColor,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        for (int i = 0;
                                                            i <=
                                                                value
                                                                        .jsonData[
                                                                            'payload']
                                                                            [
                                                                            'consumer_baskets']
                                                                            [
                                                                            index]
                                                                            [
                                                                            'orders']
                                                                        .length -
                                                                    1;
                                                            i++) {
                                                          print("Merchant id : " +
                                                              value.jsonData[
                                                                      'payload']
                                                                      [
                                                                      'consumer_baskets']
                                                                      [index]
                                                                      ['orders']
                                                                      [i][
                                                                      'merchant_id']
                                                                  .toString());

                                                          reOrderMoveCart(
                                                              order['user_id']
                                                                  .toString(),
                                                              order['orders'][i]
                                                                      [
                                                                      'product_id']
                                                                  .toString(),
                                                              order['orders'][i]
                                                                      [
                                                                      'service_id']
                                                                  .toString(),
                                                              order['orders'][i]
                                                                      [
                                                                      'merchant_id']
                                                                  .toString(),
                                                              order['orders'][i]
                                                                      [
                                                                      'item_qty']
                                                                  .toString());
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15.0,
                                                                7.0,
                                                                15.0,
                                                                7.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(20),
                                                          ),
                                                          border: Border.all(
                                                            color: ThemeApp
                                                                .tealButtonColor,
                                                          ),
                                                          color: ThemeApp
                                                              .tealButtonColor,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            /*    Icon(Icons.refresh_sharp,
                                              color:
                                              ThemeApp.whiteColor,
                                              size: height * .02),
                                          SizedBox(
                                            width: width * .01,
                                          ),*/
                                                            TextFieldUtils().dynamicText(
                                                                "Reorder",
                                                                context,
                                                                TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: ThemeApp
                                                                        .whiteColor,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                /*  order['overall_status'] == 'Delivered'
                                        ? Container(
                                      padding:
                                      const EdgeInsets.fromLTRB(
                                          15.0, 7.0, 15.0, 7.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        color:
                                        ThemeApp.tealButtonColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.refresh_sharp,
                                              color:
                                              ThemeApp.whiteColor,
                                              size: height * .02),
                                          SizedBox(
                                            width: width * .01,
                                          ),
                                          TextFieldUtils()
                                              .dynamicText(
                                              "Reorder",
                                              context,
                                              TextStyle(
                                                  fontFamily:
                                                  'Roboto',
                                                  color: ThemeApp
                                                      .whiteColor,
                                                  fontSize: 10,
                                                  fontWeight:
                                                  FontWeight
                                                      .w700)),
                                        ],
                                      ),
                                    )
                                        : InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => CancelOrderActivity(
                                                values: value.jsonData['payload']['consumer_baskets']
                                                [index], orderList:  order['orders'][indexOfOrders])));
                                      },
                                      child: Container(
                                          padding:
                                          const EdgeInsets.fromLTRB(
                                              11, 5, 11, 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(
                                              Radius.circular(100),
                                            ),
                                            border: Border.all(
                                                color: ThemeApp
                                                    .tealButtonColor),
                                            color: ThemeApp
                                                .tealButtonColor,
                                          ),
                                          child:
                                          TextFieldUtils().dynamicText(
                                              'Cancel Order',
                                              context,
                                              TextStyle(
                                                  fontFamily:
                                                  'Roboto',
                                                  color: ThemeApp
                                                      .whiteColor,
                                                  fontSize: 10,
                                                  fontWeight:
                                                  FontWeight
                                                      .w700,
                                                  letterSpacing:
                                                  -0.08))),
                                    ),*/
                                              ],
                                            )),
                                      ]),
                                )));
                  }),
    );
    /* : Center(
            child: TextFieldUtils().dynamicText(
                'No data found',
                context,
                TextStyle(fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis)),
          );*/
  }

  Widget rattingBar() {
    return Container(
      // width: width * .7,
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      child: Row(
        children: [
          RatingBar.builder(
            itemSize: height * .03,
            initialRating: 0,
            minRating: 1,
            unratedColor: ThemeApp.buttonBorderLightGreyColor,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
        ],
      ),
    );
  }

  Widget stepperWidget(
    Map subOrders,
    dynamic jsonData,
  ) {
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
            Flexible(child: _stepsViews(context, subOrders, jsonData)),
            /*  Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _stepsViews(context),
              ),
            ),*/
          ],
        ));
  }

  Widget _iconViews(
    BuildContext context,
    dynamic subOrders,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Icon(
          Icons.circle,
          color: ThemeApp.appColor,
          size: 20,
        )),
        Expanded(
            child: Container(
          height: 3.0,
          color: ThemeApp.appColor,
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
    dynamic jsonData,
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
              '${jsonData['orders_packed_completed'].toString()}/${jsonData['orders_packed_total'].toString()}',
              context,
              subOrders['is_packed'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              '${jsonData['orders_Shipped_completed'].toString()}/${jsonData['orders_Shipped_total'].toString()}',
              context,
              subOrders['is_shipped'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              '${jsonData['orders_Delivered_completed'].toString()}/${jsonData['orders_Delivered_total'].toString()}',
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
}
