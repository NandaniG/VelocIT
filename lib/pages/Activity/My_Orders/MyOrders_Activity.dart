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

  bool viewMore = false;

  @override
  void initState() {
    // TODO: implement initState
    viewMore = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.backgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(
            context, appTitle(context, "My Orders"), '/myAccountActivity',SizedBox()),
      ),
      body: SafeArea(
        child: Container(
          color: ThemeApp.backgroundColor,
          width: width,
          child: Padding(padding: const EdgeInsets.all(20), child: mainUI()),
        ),
      ),
    );
  }

  Widget mainUI() {
    return Consumer<HomeProvider>(builder: (context, value, child) {
      return Column(
        children: [
          value.myOrdersList.length > 0
              ? Expanded(
                  child: ListView.builder(
                      itemCount: value.myOrdersList.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderRatingReviewActivity(
                                    values: value.myOrdersList[index])));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                                // height: height * 0.12,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: ThemeApp.whiteColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        color: ThemeApp.textFieldBorderColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextFieldUtils().dynamicText(
                                                  value.myOrdersList[index]["myOrderId"],
                                                  context,
                                                  TextStyle(
                                                    color: ThemeApp.blackColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: height * .022,
                                                  )),
                                              // SizedBox(
                                              //   height: height * .01,
                                              // ),
                                              TextFieldUtils().dynamicText(
                                                  value.myOrdersList[index]["myOrderDate"],
                                                  context,
                                                  TextStyle(
                                                    color: ThemeApp.darkGreyTab,
                                                    fontSize: height * .018,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            width: width * .01,
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15.0, 5.0, 15.0, 5.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    color: ThemeApp.whiteColor,
                                                  ),
                                                  child: TextFieldUtils()
                                                      .dynamicText(
                                                      value.myOrdersList[index]["myOrderStatus"],
                                                          context,
                                                          TextStyle(
                                                              color: ThemeApp
                                                                  .darkGreyTab,
                                                              fontSize:
                                                                  height * .018,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ),
                                                SizedBox(
                                                  width: width * .02,
                                                ),
                                                TextFieldUtils().dynamicText(
                                                    indianRupeesFormat.format(
                                                        int.parse(value
                                                            .myOrdersList[index]["myOrderPrice"])),
                                                    context,
                                                    TextStyle(
                                                        color:
                                                            ThemeApp.blackColor,
                                                        fontSize: height * .02,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: height * .08,
                                            width: width * .15,
                                            decoration: BoxDecoration(
                                                /* borderRadius: const BorderRadius.all(
                                                 Radius.circular(8),
                                              ),*/
                                                ),
                                            child: GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing: 0,
                                                crossAxisCount: 2,
                                                // childAspectRatio: 4/7
                                              ),
                                              itemCount: value
                                                  .myOrdersList[index]
                                                  ["myOrderDetailList"]
                                                  .length,
                                              itemBuilder:
                                                  (context, indexOrderList) {
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
                                                      child: FittedBox(
                                                        child: Image(
                                                          image: AssetImage(
                                                            value
                                                                .myOrdersList[
                                                                    index]
                                                                ["myOrderDetailList"][
                                                                    indexOrderList]["productImage"],
                                                          ),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )),
                                                );

                                                // Item rendering
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .03,
                                          ),
                                          Container(
                                              height: height * .12,
                                              width: width * .63,
                                              child: ListView.builder(
                                                itemCount: value
                                                            .myOrdersList[index]
                                                            ["myOrderDetailList"]
                                                            .length >
                                                        4
                                                    ? !viewMore
                                                        ? 4
                                                        : value
                                                            .myOrdersList[index]
                                                            ["myOrderDetailList"]
                                                            .length
                                                    : value.myOrdersList[index]
                                                        ["myOrderDetailList"].length,
                                                itemBuilder: (context,
                                                    indexOrderDetails) {
                                                  return (value
                                                              .myOrdersList[
                                                                  index]
                                                              ["myOrderDetailList"]
                                                              .length >=
                                                          4)
                                                      ? !viewMore
                                                          ? Container(
                                                              child: InkWell(
                                                              child: TextFieldUtils().dynamicText(
                                                                  "- ${value.myOrdersList[index]["myOrderDetailList"][indexOrderDetails]["productDetails"]}",
                                                                  context,
                                                                  TextStyle(
                                                                      color: ThemeApp
                                                                          .darkGreyTab,
                                                                      fontSize:
                                                                          height *
                                                                              .02,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis)),
                                                              onTap: () {},
                                                            ))
                                                          : Container(
                                                              child: InkWell(
                                                              child: TextFieldUtils().dynamicText(
                                                                  "- ${value.myOrdersList[index]["myOrderDetailList"][indexOrderDetails]["productDetails"]}",
                                                                  context,
                                                                  TextStyle(
                                                                      color: ThemeApp
                                                                          .darkGreyTab,
                                                                      fontSize:
                                                                          height *
                                                                              .02,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis)),
                                                              onTap: () {},
                                                            ))
                                                      : Container(
                                                          child: InkWell(
                                                          child: TextFieldUtils().dynamicText(
                                                              "- ${value.myOrdersList[index]["myOrderDetailList"][indexOrderDetails]["productDetails"]}",
                                                              context,
                                                              TextStyle(
                                                                  color: ThemeApp
                                                                      .darkGreyTab,
                                                                  fontSize:
                                                                      height *
                                                                          .02,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis)),
                                                          onTap: () {},
                                                        ));
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: width * .15,
                                          ),
                                          SizedBox(
                                            width: width * .03,
                                          ),
                                          value.myOrdersList[index]
                                                      ["myOrderDetailList"].length >
                                                  4
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
                                                              TextStyle(
                                                                  color: ThemeApp
                                                                      .blackColor,
                                                                  fontSize:
                                                                      height *
                                                                          .02,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
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
                                                              TextStyle(
                                                                  color: ThemeApp
                                                                      .blackColor,
                                                                  fontSize:
                                                                      height *
                                                                          .02,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                    )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: Container(
                                        width: width,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: ThemeApp.darkGreyTab,
                                              width: 0.5,
                                            ),
                                            bottom: BorderSide(
                                                color: ThemeApp.darkGreyTab,
                                                width: 0.01),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: StepperGlobalWidget(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: Container(
                                        width: width,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: ThemeApp.darkGreyTab,
                                              width: 0.5,
                                            ),
                                            bottom: BorderSide(
                                                color: ThemeApp.darkGreyTab,
                                                width: 0.01),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10, bottom: 20),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextFieldUtils().dynamicText(
                                                value.myOrdersList[index]
                                                    ["myOrderProgress"],
                                                context,
                                                TextStyle(
                                                    color: ThemeApp.darkGreyTab,
                                                    fontSize: height * .02,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            value.myOrdersList[index]
                                                        ["myOrderStatus"] ==
                                                    'Delivered'
                                                ? InkWell(
                                                    onTap: () {
                                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrderRatingReviewActivity(values:  value.myOrderList[index])));
                                                    },
                                                    child: rattingBar())
                                                : SizedBox(),
                                            value.myOrdersList[index]
                                                        ["myOrderStatus"] ==
                                                    'Delivered'
                                                ? Container(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15.0, 5.0, 15.0, 5.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(5),
                                                      ),
                                                      color:
                                                          ThemeApp.darkGreyTab,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons.refresh_sharp,
                                                            color: ThemeApp
                                                                .whiteColor,
                                                            size: height * .02),
                                                        SizedBox(
                                                          width: width * .01,
                                                        ),
                                                        TextFieldUtils().dynamicText(
                                                            "Reorder",
                                                            context,
                                                            TextStyle(
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
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      }),
                )
              : Container(
                  // height: height * 0.12,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: ThemeApp.whiteColor,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldUtils().dynamicText(
                                  'Kotak Mahindra',
                                  context,
                                  TextStyle(
                                    color: ThemeApp.blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: height * .022,
                                  )),
                              SizedBox(
                                height: height * .01,
                              ),
                              TextFieldUtils().dynamicText(
                                  'Credit Card',
                                  context,
                                  TextStyle(
                                    color: ThemeApp.darkGreyTab,
                                    fontSize: height * .018,
                                  )),
                              SizedBox(
                                height: height * .01,
                              ),
                              TextFieldUtils().dynamicText(
                                  '**** **** **** 2531',
                                  context,
                                  TextStyle(
                                    color: ThemeApp.darkGreyTab,
                                    fontSize: height * .018,
                                  )),
                            ],
                          ),
                          Expanded(
                              flex: 3,
                              child: Container(
                                // padding: const EdgeInsets.only(
                                //   right: 15,
                                // ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new AssetImage(
                                                  'assets/images/laptopImage.jpg',
                                                )))),
                                    SizedBox(
                                      height: height * .02,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        'Expires Feb 2027',
                                        context,
                                        TextStyle(
                                          color: ThemeApp.darkGreyTab,
                                          fontSize: height * .018,
                                        )),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: height * .01,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Container(
                        width: width,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            bottom: BorderSide(
                                color: ThemeApp.darkGreyTab, width: 0.5),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFieldUtils().dynamicText(
                              'Primary method payment',
                              context,
                              TextStyle(
                                  color: ThemeApp.darkGreyTab,
                                  fontSize: height * .02,
                                  fontWeight: FontWeight.w400)),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    // value.creditCardList.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: ThemeApp.darkGreyTab,
                                ),
                              ),
                              SizedBox(
                                width: width * .02,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.edit,
                                  color: ThemeApp.darkGreyTab,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )),
        ],
      );
    });
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
            unratedColor: ThemeApp.backgroundColor,
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

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );
}
