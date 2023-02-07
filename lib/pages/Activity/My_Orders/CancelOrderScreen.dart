import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/repository/OrderBasket_repository.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';

import '../../../services/models/MyOrdersModel.dart';
import '../../../services/providers/Home_Provider.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes/routes.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';
import 'MyOrderDetails.dart';

class CancelOrderActivity extends StatefulWidget {
  // final MyOrdersModel values;
  final dynamic values;
  final dynamic orderList;

  CancelOrderActivity({Key? key, required this.values,required this.orderList}) : super(key: key);

  @override
  State<CancelOrderActivity> createState() => _CancelOrderActivityState();
}

class _CancelOrderActivityState extends State<CancelOrderActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  TextEditingController productReviewController = TextEditingController();
  TextEditingController vendorReviewController = TextEditingController();

  double height = 0.0;
  double width = 0.0;
  var data;

  @override
  void initState() {
    // data = Provider.of<HomeProvider>(context, listen: false).loadJsonss();
    super.initState();
  }

  int? _radioIndex = 5;
  String _radioVal = "";

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
    DateTime date = DateTime.parse(widget.values['earliest_delivery_date']);
    var earliest_delivery_date = format.format(date);

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).popAndPushNamed(RoutesName.orderRoute).then((value) {
          setState(() {

          });
        });
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .09),
          child: AppBar_BackWidget(
              context: context,titleWidget: appTitle(context,"Cancel Order"), location: SizedBox()),

        ),
        body: SafeArea(
          child: Container(
            color: ThemeApp.appBackgroundColor,
            // width: width,
            child: data == ''
                ? CircularProgressIndicator()
                : Consumer<HomeProvider>(builder: (context, provider, child) {
              return (provider.jsonData.isNotEmpty &&
                  provider.jsonData['error'] == null)
                  ? ListView(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20),
                    child: TextFieldUtils().dynamicText(
                        'Cancel Order',
                        context,
                        TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.blackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20),
                    child: TextFieldUtils().dynamicText(
                        'Choose item you want to Cancel',
                        context,
                        TextStyle(
                            fontFamily: 'Roboto',
                            color: ThemeApp.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  mainUI(provider),
                ],
              )
                  : provider.jsonData['error'] != null
                  ? Container()
                  : Center(child: CircularProgressIndicator());
            }),
          ),
        ),
      ),
    );
  }

  Widget mainUI(HomeProvider value) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: /*Column(
        children: [
*/
      SingleChildScrollView(
        child: Container(
          height: height * .75,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(

                    // physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.values["orders"].length,
                      itemBuilder: (_, index) {
                        Map orders = widget.values["orders"][index];

                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: ThemeApp.whiteColor,
                                borderRadius: BorderRadius.circular(8)),
                            width: width * .8,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 79,
                                            width: 79,
                                            child: ClipRRect(
                                              borderRadius:
                                              const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              child: Image.network(
                                                  orders['image_url'] ?? "",
                                                  fit: BoxFit.fill,
                                                  errorBuilder: ((context,
                                                      error, stackTrace) {
                                                    return Container(
                                                        height: 79,
                                                        width: 79,
                                                        child: Icon(
                                                            Icons.image_outlined));
                                                  })),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Flexible(
                                            child: Text(orders["oneliner"],
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    color: ThemeApp
                                                        .primaryNavyBlackColor,
                                                    fontSize: 12,
                                                    letterSpacing: -0.25,
                                                    fontWeight:
                                                    FontWeight.w700)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 17,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            border: Border.all(
                                                color:
                                                ThemeApp.lightBorderColor)),
                                        padding:
                                        EdgeInsets.fromLTRB(10, 20, 10, 20),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 25,
                                                  height: 30,
                                                  child: Radio(
                                                    value: 1,
                                                    groupValue: _radioIndex,
                                                    activeColor:
                                                    ThemeApp.appColor,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _radioIndex =
                                                        value as int;
                                                        _radioVal = 'I have purchased  a product elsewhere';
                                                        print(_radioVal);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: const Text("I have purchased  a product elsewhere",maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color:
                                                        ThemeApp.blackColor,
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 25,
                                                  height: 30,
                                                  child: Radio(
                                                    value: 2,
                                                    groupValue: _radioIndex,
                                                    activeColor:
                                                    ThemeApp.appColor,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _radioIndex =
                                                        value as int;
                                                        _radioVal = 'Price for the product has increased';
                                                        print(_radioVal);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                const Flexible(
                                                  child: const Text(
                                                    "Price for the product has increased",maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color:
                                                      ThemeApp.blackColor,
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    )),)
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 25,
                                                  height: 30,
                                                  child: Radio(
                                                    value: 3,
                                                    groupValue: _radioIndex,
                                                    activeColor:
                                                    ThemeApp.appColor,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _radioIndex =
                                                        value as int;
                                                        _radioVal = 'Expected delivery time is very long';
                                                        print(_radioVal);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: const Text(
                                                      "Expected delivery time is very long",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color:
                                                        ThemeApp.blackColor,
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 25,
                                                  height: 30,
                                                  child: Radio(
                                                    value: 4,
                                                    groupValue: _radioIndex,
                                                    activeColor:
                                                    ThemeApp.appColor,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _radioIndex =
                                                        value as int;
                                                        _radioVal = 'I have changed my mind';
                                                        print(_radioVal);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: const Text(
                                                      "I have changed my mind",

                                                      maxLines: 1,style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color:
                                                        ThemeApp.blackColor,
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 25,
                                                  height: 30,
                                                  child: Radio(
                                                    value: 5,
                                                    groupValue: _radioIndex,
                                                    activeColor:
                                                    ThemeApp.appColor,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _radioIndex =
                                                        value as int;
                                                        _radioVal = 'Added to order by mistake';
                                                        print(_radioVal);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: const Text(
                                                      "Added to order by mistake",
                                                  maxLines: 1,    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color:
                                                        ThemeApp.blackColor,
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      )),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          TextFieldUtils().dynamicText(
                                              'Comment',
                                              context,
                                              TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: ThemeApp.blackColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: -0.25)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      TextFormField(
                                        controller: vendorReviewController,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                          color: ThemeApp.blackColor,
                                        ),
                                        validator: (value) {
                                          return null;
                                        },
                                        maxLines: 4,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: ThemeApp.whiteColor,
                                          hintStyle: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: ThemeApp.lightBorderColor,
                                              fontSize: 12),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10.0, 10, 10.0, 10),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeApp
                                                      .lightBorderColor)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                  ThemeApp.lightBorderColor,
                                                  width: 1)),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                  ThemeApp.lightBorderColor,
                                                  width: 1)),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ThemeApp.redColor,
                                                  width: 1)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                  ThemeApp.lightBorderColor,
                                                  width: 1)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      proceedButton(
                                          "Submit", ThemeApp.tealButtonColor, context, false,
                                              () async {
                                            FocusManager.instance.primaryFocus?.unfocus();

                                            final prefs = await SharedPreferences.getInstance();

                                            StringConstant.UserLoginId =
                                                (prefs.getString('isUserId')) ?? '';

                                            print("USER LOGIN ID..............." +
                                                StringConstant.UserLoginId.toString());
                                            String date = DateTime.now().toUtc().toString().replaceAll(" ", "T");
                                        var success=    OrderBasketRepository().cancelOrderApiRequest(context, {
                                              "cancellation_date": date,
                                              "reason": _radioVal.toString()
                                            }, widget.orderList['order_id'].toString());


                                            Navigator.of(context).popAndPushNamed(RoutesName.orderRoute).then((value) {
                                              setState(() {

                                              });
                                            });
                                          })
                                    ]),
                              ),
                            ),
                          ),
                        );
                      }),
                ),

              ],
            ),
          ),
        ),
      ),
      /*    SizedBox(
              height: height * .03,
            ),
            Container(
                height: kToolbarHeight,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(left: 20,right: 20),
                child: proceedButton(
                    "Submit", ThemeApp.blackColor, context, false,() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyOrderDetails(values: widget.values),
                    ),
                  );
                }))
          ],
        ),*/
    );
  }

  var vendortRating = 0.0;
  var productRating = 0.0;

  Widget vendorRattingBar() {
    return Row(
      children: [
        RatingBar.builder(
          itemSize: height * .04,
          initialRating: vendortRating,
          minRating: 1,
          unratedColor: ThemeApp.appBackgroundColor,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.only(left: 0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          onRatingUpdate: (rating) {
            vendortRating = rating;
            print(rating);
          },
        ),
      ],
    );
  }

  Widget productRattingBar() {
    return Row(
      children: [
        RatingBar.builder(
          itemSize: height * .04,
          initialRating: productRating,
          minRating: 1,
          unratedColor: ThemeApp.appBackgroundColor,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.only(left: 0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          onRatingUpdate: (rating) {
            productRating = rating;
            print(rating);
          },
        ),
      ],
    );
  }
}
