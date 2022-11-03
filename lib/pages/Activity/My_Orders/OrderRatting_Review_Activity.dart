import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';

import '../../../services/models/MyOrdersModel.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';
import 'MyOrderDetails.dart';

class OrderRatingReviewActivity extends StatefulWidget {
 final MyOrdersModel values;

  OrderRatingReviewActivity({Key? key, required this.values}) : super(key: key);

  @override
  State<OrderRatingReviewActivity> createState() =>
      _OrderRatingReviewActivityState();
}

class _OrderRatingReviewActivityState extends State<OrderRatingReviewActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.backgroundColor,
      key: scaffoldGlobalKey,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(height * .09),
      //   child: appBar_backWidget(
      //       context, appTitle(context, "Review and Rating"), SizedBox()),
      // ),
      body: SafeArea(
        child: Container(
          color: ThemeApp.backgroundColor,
          // width: width,
          child: mainUI(),
        ),
      ),
    );
  }

  Widget mainUI() {
    return Consumer<ProductProvider>(builder: (context, value, child) {
      return Container(
        width: width,
        // padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ThemeApp.whiteColor,
          border: Border(
            top: BorderSide(
              color: ThemeApp.darkGreyTab,
              width: 0.5,
            ),
            bottom: BorderSide(color: ThemeApp.darkGreyTab, width: 0.5),
          ),
        ),
        child: ListView(
          // physics: NeverScrollableScrollPhysics(),
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFieldUtils().dynamicText(
                      "Review and Rating",
                      context,
                      TextStyle(
                        color: ThemeApp.blackColor,
                        fontSize: height * .028,
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.clear))
                ],
              ),
            ),
            TextFieldUtils().lineHorizontal(),
            SizedBox(
              height: height * .01,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFieldUtils().dynamicText(
                  widget.values.orderId,
                  context,
                  TextStyle(
                    color: ThemeApp.blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: height * .022,
                  )),
            ),
            // SizedBox(
            //   height: height * .01,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFieldUtils().dynamicText(
                  widget.values.orderDate,
                  context,
                  TextStyle(
                    color: ThemeApp.darkGreyTab,
                    fontSize: height * .018,
                  )),
            ),
            SizedBox(
              height: height * .01,
            ),
            TextFieldUtils().lineHorizontal(),
            SizedBox(
              height: height * .01,
            ),
            Container(
              height: height * .65,
              child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.values.orderDetailList.length,
                  itemBuilder: (_, index) {
                    return SingleChildScrollView(
                      child: Container(
                        width: width,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height: height * .15,
                                  width: width * .3,
                                  child: Image(
                                    image: AssetImage(
                                      widget.values.orderDetailList[index]
                                          .ProductImage,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: TextFieldUtils().dynamicText(
                                    widget.values.orderDetailList[index]
                                        .productDetails,
                                    context,
                                    TextStyle(
                                      color: ThemeApp.darkGreyColor,
                                      fontSize: height * .023,
                                    )),
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: TextFieldUtils().dynamicText(
                                    'Product Review and Rating',
                                    context,
                                    TextStyle(
                                        color: ThemeApp.blackColor,
                                        fontSize: height * .023,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: height * .01,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: rattingBar(),
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                width: width,
                                child: TextFormField(
                                  // controller: doctoreNotesController,
                                  style: TextStyle(
                                    fontFamily: 'SegoeUi',
                                    fontSize: height * .022,
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
                                        color: ThemeApp.darkGreyTab,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ThemeApp.darkGreyTab)),
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
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: TextFieldUtils().dynamicText(
                                    'Vendor Review and Rating',
                                    context,
                                    TextStyle(
                                        color: ThemeApp.blackColor,
                                        fontSize: height * .023,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: height * .01,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: rattingBar(),
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                width: width,
                                child: TextFormField(
                                  // controller: doctoreNotesController,
                                  style: TextStyle(
                                    fontFamily: 'SegoeUi',
                                    fontSize: height * .022,
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
                                        color: ThemeApp.darkGreyTab,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ThemeApp.darkGreyTab)),
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
                              ),
                            ]),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: height * .03,
            ),
            Container(
                height: kToolbarHeight,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(left: 20,right: 20),
                child: proceedButton(
                    "Submit", ThemeApp.blackColor, context, () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyOrderDetails(values: widget.values),
                    ),
                  );
                }))
          ],
        ),
      );
    });
  }

  Widget rattingBar() {
    return Row(
      children: [
        RatingBar.builder(
          itemSize: height * .04,
          initialRating: 0,
          minRating: 1,
          unratedColor: ThemeApp.backgroundColor,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.only(left: 0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
      ],
    );
  }
}
