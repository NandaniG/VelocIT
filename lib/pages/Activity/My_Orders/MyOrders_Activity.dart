import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocit/services/providers/Home_Provider.dart';

import '../../../services/providers/Products_provider.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';
import 'OrderRatting_Review_Activity.dart';

class MyOrdersActivity extends StatefulWidget {
  const MyOrdersActivity({Key? key}) : super(key: key);

  @override
  State<MyOrdersActivity> createState() => _MyOrdersActivityState();
}

class _MyOrdersActivityState extends State<MyOrdersActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  int subIndexOrderList = 0;
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(
            context, appTitle(context, "My Orders"), SizedBox()),
      ),
      body: SafeArea(
        child: Container(
          color: ThemeApp.appBackgroundColor,
          width: width,
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: data == '' ? CircularProgressIndicator() : mainUI()),
        ),
      ),
    );
  }

  Widget mainUI() {
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return value.jsonData.isNotEmpty
          ? Stack(
              children: [
                Column(
                  children: [activeOrderList(value)],
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
    });
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

  Widget dropdownShow() {
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
            style: TextStyle(fontFamily: 'Roboto',
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
                    TextStyle(fontFamily: 'Roboto',
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
  }

  Widget allOrderDropdownShow() {
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
            style: TextStyle(fontFamily: 'Roboto',
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
                    TextStyle(fontFamily: 'Roboto',
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
              });
            },
          ),
        ),
      ],
    );
  }

/*
  Widget activeOrderList(HomeProvider value) {
    return (value.jsonData.length > 0 && value.jsonData['status'] == 'OK')
        ? Expanded(
            child: ListView.builder(
                itemCount: value.jsonData['payload']['consumer_baskets'].length,
                itemBuilder: (_, index) {
                  // List orderList = value
                  //     .jsonData['payload']['consumer_baskets'].values
                  //     .toList();
                  // Map order = orderList[index];
                  var order =
                      value.jsonData['payload']['consumer_baskets'][index];
                  DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
                  DateTime date =
                      DateTime.parse(order['earliest_delivery_date']);
                  var earliest_delivery_date = format.format(date);
                  Color colorsStatus = ThemeApp.appColor;
                  if (order["overall_status"] == "Acceptance Pending") {
                    colorsStatus = ThemeApp.redColor;
                  }
                  if (order["overall_status"] == "Shipped") {
                    colorsStatus = ThemeApp.shippedOrderColor;
                  }
                  if (order["overall_status"] == "Completed") {
                    colorsStatus = ThemeApp.activeOrderColor;
                  }

                  return Container( height: height * .05,
                    width: width * .55,
                    child: ListView.builder(
                        itemCount: order['orders'].length,
                        itemBuilder: (_, index) {

                          var subOrders= order['orders'][index];
                        return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OrderRatingReviewActivity(
                                      values: value.myOrdersList[index])));
                            },
                            child: Builder(
                              builder: (context) {
                                return Padding(
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
                                                        height: height * .08,
                                                        width: width * .15,
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
                                                                indexForItems = indexOrderList;
                                                                // Map subOrders = (order['orders'][indexForItems]);

                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: ThemeApp
                                                                          .darkGreyTab)),
                                                              child: FractionallySizedBox(
                                                                // width: 50.0,
                                                                // height: 50.0,
                                                                  widthFactor:
                                                                  width * .0025,
                                                                  heightFactor:
                                                                  height * .0018,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: ThemeApp.darkGreyTab)),
                                                                    child: FittedBox(
                                                                      child: Image(
                                                                        image: NetworkImage(
                                                                            subOrders['image_url'] ?? ''),
                                                                        fit: BoxFit.fill,
                                                                        height: 50,
                                                                        width: 50,   errorBuilder: (context, error, stackTrace) {
                                                                        return Icon(Icons.image_outlined);
                                                                      },
                                                                      ),
                                                                    ),
                                                                  ),),
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
                                                              TextStyle(fontFamily: 'Roboto',
                                                                color: ThemeApp
                                                                    .primaryNavyBlackColor,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                fontSize: height * .025,
                                                              )),
                                                          SizedBox(
                                                            height: height * .01,
                                                          ),
                                                          TextFieldUtils().dynamicText(
                                                              earliest_delivery_date,
                                                              context,
                                                              TextStyle(fontFamily: 'Roboto',
                                                                color: ThemeApp
                                                                    .lightFontColor,
                                                                fontSize: height * .022,
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
*/
/*
                                                Container(
                                                    height: height * .08,
                                                    // width: width * .63,
                                                    child: ListView.builder(
                                                      physics:
                                                      NeverScrollableScrollPhysics(),
                                                      itemCount: value
                                                          .myOrdersList[index][
                                                      "myOrderDetailList"]
                                                          .length >
                                                          2
                                                          ? !viewMore
                                                          ? 2
                                                          : value
                                                          .myOrdersList[index][
                                                      "myOrderDetailList"]
                                                          .length
                                                          : value
                                                          .myOrdersList[index]
                                                      ["myOrderDetailList"]
                                                          .length,
                                                      itemBuilder:
                                                          (context, indexOrderDetails) {
                                                        return (value
                                                            .myOrdersList[index][
                                                        "myOrderDetailList"]
                                                            .length >=
                                                            2)
                                                            ? !viewMore
                                                            ? Container(
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                              child: Text(
                                                                  "${value.myOrdersList[index]["myOrderDetailList"][indexOrderDetails]["productDetails"]}",
                                                                  style: TextStyle(fontFamily: 'Roboto',
                                                                      color: ThemeApp
                                                                          .blackColor,
                                                                      fontSize:
                                                                      height *
                                                                          .02,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                      letterSpacing:
                                                                      -0.25,
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis)),
                                                            ))
                                                            : Container(
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                              child: Text(
                                                                  "${value.myOrdersList[index]["myOrderDetailList"][indexOrderDetails]["productDetails"]}",
                                                                  style: TextStyle(fontFamily: 'Roboto',
                                                                      color: ThemeApp
                                                                          .blackColor,
                                                                      fontSize:
                                                                      height *
                                                                          .02,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                      letterSpacing:
                                                                      -0.25,
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis)),
                                                            ))
                                                            :  Container(
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                              child: Text(
                                                                  "${value.myOrdersList[index]["myOrderDetailList"][indexOrderDetails]["productDetails"]}",
                                                                  style: TextStyle(fontFamily: 'Roboto',
                                                                      color: ThemeApp
                                                                          .blackColor,
                                                                      fontSize:
                                                                      height *
                                                                          .02,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                      letterSpacing:
                                                                      -0.25,
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis)),
                                                            ));
                                                      },
                                                    )),

                                                Row(
                                                  children: [

                                                    value
                                                        .myOrdersList[index]
                                                    ["myOrderDetailList"]
                                                        .length >
                                                        2
                                                        ? !viewMore
                                                        ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          viewMore = !viewMore;
                                                        });
                                                      },
                                                      child: TextFieldUtils()
                                                          .dynamicText(
                                                          '+ View More',
                                                          context,
                                                          TextStyle(fontFamily: 'Roboto',
                                                              color: ThemeApp
                                                                  .tealButtonColor,
                                                              fontSize:
                                                              height *
                                                                  .02,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400)),
                                                    )
                                                        : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          viewMore = !viewMore;
                                                        });
                                                      },
                                                      child: TextFieldUtils()
                                                          .dynamicText(
                                                          '- View Less',
                                                          context,
                                                          TextStyle(fontFamily: 'Roboto',
                                                              color: ThemeApp
                                                                  .tealButtonColor,
                                                              fontSize:
                                                              height *
                                                                  .02,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400)),
                                                    )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * .02,
                                                ),
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextFieldUtils().dynamicText(
                                                          indianRupeesFormat.format(
                                                              int.parse(value
                                                                  .myOrdersList[
                                                              index]
                                                              ["myOrderPrice"])),
                                                          context,
                                                          TextStyle(fontFamily: 'Roboto',
                                                              color:
                                                              ThemeApp.blackColor,
                                                              fontSize: height * .024,
                                                              fontWeight:
                                                              FontWeight.w700,
                                                              letterSpacing: 0.2
                                                          )),
                                                      Row(
                                                        children: [
                                                          value.myOrdersList[index]
                                                          ["myOrderStatus"] ==
                                                              "Acceptance Pending"
                                                              ? SizedBox()
                                                              : Container(
                                                            child: TextFieldUtils()
                                                                .dynamicText(
                                                                "Change Status to:",
                                                                context,
                                                                TextStyle(fontFamily: 'Roboto',
                                                                    color:
                                                                    ThemeApp
                                                                        .blackColor,
                                                                    fontSize:
                                                                    height *
                                                                        .018,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                          ),
                                                          SizedBox(
                                                            width: width * .02,
                                                          ),

                                                          Container(
                                                            padding: const EdgeInsets
                                                                .fromLTRB(10, 8, 10, 8),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(30),
                                                              ),
                                                              // border: Border.all(
                                                              //     color: colorsStatus),
                                                              color:
                                                              ThemeApp.whiteColor,
                                                            ),
                                                            child: TextFieldUtils()
                                                                .dynamicText(
                                                                value.myOrdersList[
                                                                index][
                                                                "myOrderStatus"],
                                                                context,
                                                                TextStyle(fontFamily: 'Roboto',
                                                                    color:
                                                                    colorsStatus,
                                                                    fontSize:
                                                                    height *
                                                                        .02,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height * .01,
                                                ),
                                                TextFieldUtils().lineHorizontal(),
                                                stepperWidget(),
                                                TextFieldUtils().lineHorizontal(),
                                                SizedBox(
                                                  height: height * .02,
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

                                                        value.myOrdersList[index]
                                                        ["myOrderStatus"] !=
                                                            'Delivered'
                                                            ? InkWell(
                                                            onTap: () {
                                                              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrderRatingReviewActivity(values:  value.myOrderList[index])));
                                                            },
                                                            child: rattingBar())
                                                            :   TextFieldUtils().dynamicText(
                                                            value.myOrdersList[index]
                                                            ["myOrderProgress"],
                                                            context,
                                                            TextStyle(fontFamily: 'Roboto',
                                                                color: ThemeApp
                                                                    .darkGreyTab,
                                                                fontSize: height * .02,
                                                                fontWeight:
                                                                FontWeight.w400)),
                                                        value.myOrdersList[index]
                                                        ["myOrderStatus"] !=
                                                            'Delivered'
                                                            ? Container(
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
                                                            color: ThemeApp
                                                                .tealButtonColor,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .refresh_sharp,
                                                                  color: ThemeApp
                                                                      .whiteColor,
                                                                  size: height *
                                                                      .02),
                                                              SizedBox(
                                                                width:
                                                                width * .01,
                                                              ),
                                                              TextFieldUtils().dynamicText(
                                                                  "Reorder",
                                                                  context,
                                                                  TextStyle(fontFamily: 'Roboto',
                                                                      color: ThemeApp
                                                                          .whiteColor,
                                                                      fontSize:
                                                                      height *
                                                                          .018,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                            ],
                                                          ),
                                                        )
                                                            : SizedBox(),
                                                      ],
                                                    )),*/ /*

                                              ]),
                                        )));
                              }
                            ));
                      }
                    ),
                  );
                }),
          )
        : Center(
            child: TextFieldUtils().dynamicText(
                'No data found',
                context,
                TextStyle(fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis)),
          );
  }
*/

  Widget activeOrderList(HomeProvider value) {
    return Expanded(
            child: ListView.builder(
                itemCount: value.jsonData['payload']['consumer_baskets'].length,
                itemBuilder: (_, index) {

                  Map order = value
                      .jsonData['payload']['consumer_baskets'][index];
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

                  return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OrderRatingReviewActivity(
                                values: value.jsonData['payload']['consumer_baskets'][index])));
                      },
                      child: Padding(
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
                                              height:44,
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
                                                itemCount: order['orders']
                                                    .length,
                                                itemBuilder:
                                                    (context, indexOrderList) {
                                                  subIndexOrderList =
                                                      indexOrderList;
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: ThemeApp
                                                                .whiteColor)),
                                                    child: FittedBox(
                                                      child:  Image.network(
                                                        // width: double.infinity,
                                                          order['orders'][indexOrderList]
                                                          ["image_url"] ?? "",
                                                          fit: BoxFit.fill,
                                                          height:22,
                                                          width: 21,
                                                          errorBuilder: ((context, error, stackTrace) {
                                                            return Icon(Icons.image_outlined);
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
                                                    TextStyle(fontFamily: 'Roboto',
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
                                                    TextStyle(fontFamily: 'Roboto',
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
                                          height:  order['orders']
                                              .length >
                                              1
                                              ? !viewMore
                                              ? 30
                                              :  59
                                              :  30,
                                          // width: width * .63,
                                          child: ListView.builder(
                                            physics:order['orders']
                                                .length >1?ScrollPhysics():
                                                NeverScrollableScrollPhysics(),
                                            itemCount:  order['orders']
                                                        .length >
                                                    1
                                                ? !viewMore
                                                    ? 1
                                                    :  order['orders']
                                                        .length
                                                :  order['orders']
                                                    .length,
                                            itemBuilder:
                                                (context, indexOrderDetails) {
                                              return ( order['orders']
                                                          .length >=
                                                     1)
                                                  ? !viewMore
                                                      ? Container(
                                                          child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: Text(
                                                              "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                              style: TextStyle(fontFamily: 'Roboto',
                                                                  color: ThemeApp
                                                                      .blackColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      -0.25,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis)),
                                                        ))
                                                      : Container(
                                                          child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: Text(
                                                              "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                              style: TextStyle(fontFamily: 'Roboto',
                                                                  color: ThemeApp
                                                                      .blackColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      -0.25,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis)),
                                                        ))
                                                  : Container(
                                                      child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Text(
                                                          "${order['orders'][indexOrderDetails]["oneliner"]}",
                                                          style: TextStyle(fontFamily: 'Roboto',
                                                              color: ThemeApp
                                                                  .blackColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              letterSpacing:
                                                                  -0.25,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)),
                                                    ));
                                            },
                                          )),


                                      Row(
                                        children: [

                                          order['orders'][subIndexOrderList].length >
                                                  1
                                              ? !viewMore
                                                  ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          viewMore = !viewMore;
                                                        });
                                                      },
                                                      child: TextFieldUtils()
                                                          .dynamicText(
                                                              '+ View More',
                                                              context,
                                                              TextStyle(fontFamily: 'Roboto',
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
                                                          viewMore = !viewMore;
                                                        });
                                                      },
                                                      child: TextFieldUtils()
                                                          .dynamicText(
                                                              '- View Less',
                                                              context,
                                                              TextStyle(fontFamily: 'Roboto',
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
                                            TextFieldUtils().dynamicText(
                                                indianRupeesFormat.format(
                                                    double.parse(order['orders'][subIndexOrderList]['mrp'].toString())).toString(),
                                                context,
                                                TextStyle(fontFamily: 'Roboto',
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
                                                SizedBox(
                                                  width: width * .02,
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 8, 10, 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
                                                    border: Border.all(
                                                        color: colorsStatus),
                                                    color: ThemeApp.whiteColor,
                                                  ),
                                                  child: TextFieldUtils()
                                                      .dynamicText(
                                                      order['overall_status'],
                                                          context,
                                                          TextStyle(fontFamily: 'Roboto',
                                                              color:
                                                                  colorsStatus,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ),
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

                                      stepperWidget( order['orders'][subIndexOrderList]),
                                      TextFieldUtils().lineHorizontal(),
                                      SizedBox(
                                        height: 19,
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
                                                  : TextFieldUtils().dynamicText(
                                                  'Item Return Inprogress',
                                                      context,
                                                      TextStyle(fontFamily: 'Roboto',
                                                          color: ThemeApp
                                                              .blackColor,
                                                          fontSize:
                                                              12,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                              order['overall_status'] ==
                                                      'Delivered'
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
                                                        color: ThemeApp
                                                            .tealButtonColor,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .refresh_sharp,
                                                              color: ThemeApp
                                                                  .whiteColor,
                                                              size:
                                                                  height * .02),
                                                          SizedBox(
                                                            width: width * .01,
                                                          ),
                                                          TextFieldUtils().dynamicText(
                                                              "Reorder",
                                                              context,
                                                              TextStyle(fontFamily: 'Roboto',
                                                                  color: ThemeApp
                                                                      .whiteColor,
                                                                  fontSize:10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          )),
                                    ]),
                              ))));
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
              subOrders['item_qty'].toString()+ ' Items',
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

  // Widget stepperWidgetss() {
  //   return Container(
  //     height: height * .1,
  //     width: width,
  //     alignment: Alignment.center,
  //     color: ThemeApp.whiteColor,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Row(
  //           children: _iconViews(),
  //         ),
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         Flexible(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: _titleViews(context),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // List<Widget> _iconViews() {
  //   var list = <Widget>[];
  //   titles.asMap().forEach((i, icon) {
  //     var circleColor = (i == 0 || i == 1 || _curStep > i + 1)
  //         ? ThemeApp.tealButtonColor
  //         : ThemeApp.appColor;
  //     var lineColor = (i == 0 || i == 1 || _curStep > i + 1)
  //         ? ThemeApp.tealButtonColor
  //         : ThemeApp.appColor;
  //     var iconColor = (i == 0 || i == 1 || _curStep > i + 1)
  //         ? ThemeApp.tealButtonColor
  //         : ThemeApp.appColor;
  //
  //     list.add(
  //       Container(
  //         width: 23.0,
  //         height: 23.0,
  //         padding: const EdgeInsets.all(0),
  //         // decoration:(i == 0 || _curStep > i + 1) ? new  BoxDecoration(
  //         //
  //         // ):BoxDecoration(   /* color: circleColor,*/
  //         //   borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
  //         //   border: new Border.all(
  //         //     color: circleColor,
  //         //     width: 2.0,
  //         //   ),),
  //         child: (i == 0 || _curStep > i + 1)
  //             ? Icon(
  //                 Icons.circle,
  //                 color: iconColor,
  //                 size: 18.0,
  //               )
  //             : Icon(
  //                 Icons.radio_button_checked_outlined,
  //                 color: iconColor,
  //                 size: 18.0,
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

  // List<Widget> _titleViews(BuildContext context) {
  //   var list = <Widget>[];
  //   titles.asMap().forEach((i, text) {
  //     list.add(
  //       (i == 0 || i == 1 || _curStep > i + 1)
  //           ? TextFieldUtils().dynamicText(
  //               text,
  //               context,
  //               TextStyle(fontFamily: 'Roboto',
  //                   color: ThemeApp.blackColor,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w400))
  //           : TextFieldUtils().dynamicText(
  //               text,
  //               context,
  //               TextStyle(fontFamily: 'Roboto',
  //                   color: ThemeApp.blackColor,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w400)),
  //     );
  //   });
  //   return list;
  // }
}

final List<String> titles = [
  'Order Placed',
  'Packed',
  'Shipped',
  'Delivered',
];
int _curStep = 1;
