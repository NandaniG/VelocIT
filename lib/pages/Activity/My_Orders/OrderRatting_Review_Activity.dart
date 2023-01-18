import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';

import '../../../services/models/MyOrdersModel.dart';
import '../../../services/providers/Home_Provider.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';
import 'MyOrderDetails.dart';

class OrderRatingReviewActivity extends StatefulWidget {
  // final MyOrdersModel values;
  final dynamic values;

  OrderRatingReviewActivity({Key? key, required this.values}) : super(key: key);

  @override
  State<OrderRatingReviewActivity> createState() =>
      _OrderRatingReviewActivityState();
}

class _OrderRatingReviewActivityState extends State<OrderRatingReviewActivity> {
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    DateFormat format = DateFormat('dd MMM yyyy hh:mm aaa');
    DateTime date =
    DateTime.parse( widget.values['earliest_delivery_date']);
    var earliest_delivery_date = format.format(date);

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(
            context, appTitle(context, "Review and Rating"), SizedBox(),setState),
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
                                  widget.values["id"].toString(),
                                  context,
                                  TextStyle(fontFamily: 'Roboto',
                                    color: ThemeApp.blackColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  )),
                            ),
                            // SizedBox(
                            //   height: height * .01,
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: TextFieldUtils().dynamicText(
                                  earliest_delivery_date,
                                  context,
                                  TextStyle(fontFamily: 'Roboto',
                                    color: ThemeApp.darkGreyTab,
                                    fontSize: 12,fontWeight: FontWeight.w400
                                  )),
                            ),
                            mainUI( provider),
                          ],
                        )
                      : provider.jsonData['error'] != null
                          ? Container()
                          : Center(child: CircularProgressIndicator());
                }),
        ),
      ),
    );
  }

  Widget mainUI(HomeProvider value) {
    return  Padding(
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
                              width: width * .85,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height:79,
                                              width: 79,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                child: Image.network(
                                                  orders['image_url']??"",
                                                  fit: BoxFit.fill,  errorBuilder: ((context, error, stackTrace) {
                                                  return Container( height:79,
                                                      width: 79,child: Icon(Icons.image_outlined));
                                                })
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Flexible(
                                              child: Text(
                                                  orders["oneliner"],
                                                  maxLines: 2,
                                                  style: TextStyle(fontFamily: 'Roboto',
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
                                        Row(
                                          children: [
                                            /*      Container(
                                              width: 70.0,
                                              height: 70.0,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(100)),
                                                  child: Icon(
                                                    Icons
                                                        .account_circle_outlined,
                                                    size: 70,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: width * .02,
                                            ),*/
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextFieldUtils().dynamicText(
                                                    'Product Review and Rating',
                                                    context,
                                                    TextStyle(fontFamily: 'Roboto',
                                                        color:
                                                            ThemeApp.blackColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: -0.25)),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                vendorRattingBar(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:16,
                                        ),
                                        TextFormField(
                                          controller: productReviewController,
                                          style: TextStyle(fontFamily: 'Roboto',

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
                                            hintStyle: TextStyle(fontFamily: 'Roboto',
                                                color: ThemeApp.darkGreyTab,
                                                fontSize:12),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                10.0, 10, 10.0, 10),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        ThemeApp.darkGreyTab)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeApp.darkGreyTab,
                                                    width: 1)),
                                            disabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeApp.darkGreyTab,
                                                    width: 1)),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeApp.darkGreyTab,
                                                    width: 1)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeApp.darkGreyTab,
                                                    width: 1)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 23,
                                        ),
                                        Row(
                                          children: [
                                            /*      Container(
                                              width: 70.0,
                                              height: 70.0,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(100)),
                                                  child: Icon(
                                                    Icons
                                                        .account_circle_outlined,
                                                    size: 70,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: width * .02,
                                            ),*/
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextFieldUtils().dynamicText(
                                                    'Merchant Review and Rating',
                                                    context,
                                                    TextStyle(fontFamily: 'Roboto',
                                                        color:
                                                            ThemeApp.blackColor,
                                                        fontSize:12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: -0.25)),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                productRattingBar(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        /*   TextFieldUtils().dynamicText(
                                            'Vendor Review and Rating',
                                            context,
                                            TextStyle(fontFamily: 'Roboto',
                                                color: ThemeApp.blackColor,
                                                fontSize: height * .023,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        rattingBar(),*/
                                        SizedBox(
                                          height: 16,
                                        ),
                                        TextFormField(
                                          controller: vendorReviewController,
                                          style: TextStyle(fontFamily: 'Roboto',

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
                                            hintStyle: TextStyle(fontFamily: 'Roboto',
                                                color: ThemeApp.darkGreyTab,
                                                fontSize: 12),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                10.0, 10, 10.0, 10),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        ThemeApp.darkGreyTab)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeApp.darkGreyTab,
                                                    width: 1)),
                                            disabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeApp.darkGreyTab,
                                                    width: 1)),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeApp.darkGreyTab,
                                                    width: 1)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeApp.darkGreyTab,
                                                    width: 1)),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),SizedBox(height: 20,),
                  proceedButton("Submit", ThemeApp.tealButtonColor, context, false,
                      () async {                        FocusManager.instance.primaryFocus?.unfocus();

                      final prefs = await SharedPreferences.getInstance();

                    StringConstant.UserLoginId =
                        (prefs.getString('isUserId')) ?? '';

                    print("USER LOGIN ID..............." +
                        StringConstant.UserLoginId.toString());
                    Map jsonMap = {
                      "user_id": StringConstant.UserLoginId,
                      "order_id": 45,
                      "product_item_id": 31,
                      "merchant_comments": vendorReviewController.text ?? "",
                      "merchant_rating": vendortRating,
                      "product_comments": productReviewController.text,
                      "product_rating": productRating
                    };
                    value.reviewPostAPI(jsonMap);
                    if (value.jsonData.isNotEmpty &&
                        value.jsonData['error'] == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              MyOrderDetails(values: widget.values),
                        ),
                      );
                    }
                  })
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
