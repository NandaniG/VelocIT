import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:velocit/pages/Activity/My_Orders/QR_download_popup.dart';

import '../../../services/models/MyOrdersModel.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

class MyOrderDetails extends StatefulWidget {
  final dynamic values;

  MyOrderDetails({Key? key, required this.values}) : super(key: key);

  @override
  State<MyOrderDetails> createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
@override
  void initState() {
    // TODO: implement initState
  totalAmount;
  super.initState();
  totalAmount = 0;
  for (int i = 0; i < widget.values["myOrderDetailList"].length; i++) {
    totalAmount = int.parse(
        widget.values["myOrderDetailList"][i]["price"].toString()) +
        totalAmount;
    print(totalAmount);
  }

  }
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
            context, appTitle(context, "Order Details"),SizedBox()),
      ),
      body: SafeArea(child: mainUI()),
    );
  }

  Widget mainUI() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFieldUtils().dynamicText(
                          widget.values["myOrderId"],
                          context,
                          TextStyle(
                              color: ThemeApp.blackColor,
                              fontSize: height * .023,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: height * .01,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),border: Border.all( color: ThemeApp.blackColor,),
                          color: ThemeApp.whiteColor,
                        ),
                        child: TextFieldUtils().dynamicText(
                            widget.values["myOrderStatus"],
                            context,
                            TextStyle(
                                color: ThemeApp.blackColor,
                                fontSize: height * .018,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return QRDialog();
                              });
                        },
                        child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new AssetImage(
                                      'assets/images/qr_test_image.png',
                                    )))),
                      ),
                      SizedBox(
                        width: width * .03,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 7.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: ThemeApp.appColor,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/appImages/downloadIcon.svg',
                              color: ThemeApp.whiteColor,
                              semanticsLabel: 'Acme Logo',

                              height: height * .03,
                            ),
                            SizedBox(
                              width: width * .02,
                            ),
                            TextFieldUtils().dynamicText(
                                'Download Invoice',
                                context,
                                TextStyle(
                                    color: ThemeApp.whiteColor,
                                    fontSize: height * .018,
                                    fontWeight: FontWeight.w400,letterSpacing: -0.25

                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              stepperOfDelivery(),
              SizedBox(
                height: height * .02,
              ),
              deliveryDetails(),
              SizedBox(
                height: height * .02,
              ),
              invoiceDetails(),
              SizedBox(
                height: height * .02,
              ),
              proofOfDeliverDetails(),
              SizedBox(
                height: height * .02,
              ),
              cancelReturnOrdersWidget()
            ]),
      ),
    );
  }

  Widget stepperOfDelivery() {
    return Container(
      height: height * .26,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.values["myOrderDetailList"].length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Container(
                    // width: 300,
                    width: width * 0.85,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: ThemeApp.whiteColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Flexible(
                              child: TextFieldUtils().dynamicText(
                                  widget.values["myOrderDetailList"][index]
                                      ["productDetails"],
                                  context,
                                  TextStyle(
                                      color: ThemeApp.blackColor,
                                      fontSize: height * .023,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .03,
                            ),
                            Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new AssetImage(
                                          widget.values["myOrderDetailList"][index]
                                          ["productImage"],
                                        )))),
                          ],
                        ),
                        TextFieldUtils().dynamicText(
                            widget.values["myOrderDetailList"][index]
                            ["vendorDetails"],
                            context,
                            TextStyle(
                                color: ThemeApp.darkGreyTab,
                                fontSize: height * .02,
                                fontWeight: FontWeight.w400,
                                overflow: TextOverflow.ellipsis)),
                        StepperGlobalWidget()
                        // stepperWidget(),
                      ],
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .03,
                )
              ],
            );
          }),
    );
  }

  Widget deliveryDetails() {
    return Container(
      // width: 300,
      // width: width * 0.85,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: ThemeApp.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldUtils().dynamicText(
              StringUtils.deliveryDetails,
              context,
              TextStyle(
                  color: ThemeApp.darkGreyTab,
                  fontSize: height * .028,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: height * .02,
          ),
          TextFieldUtils().lineHorizontal(),
          SizedBox(
            height: height * .02,
          ),
          TextFieldUtils().dynamicText(
              widget.values["myOrderPerson"],
              context,
              TextStyle(
                  color: ThemeApp.blackColor,
                  fontSize: height * .024,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: height * .02,
          ),
          TextFieldUtils().dynamicText(
              widget.values["myOrderDeliveryAddress"],
              context,
              TextStyle(
                  color: ThemeApp.darkGreyColor,
                  fontSize: height * .021,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  int totalAmount = 0;

  Widget invoiceDetails() {
    return Container(
      // width: 300,
      // width: width * 0.88,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: ThemeApp.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldUtils().dynamicText(
              StringUtils.invoice,
              context,
              TextStyle(
                  color: ThemeApp.darkGreyTab,
                  fontSize: height * .028,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: height * .02,
          ),
          TextFieldUtils().lineHorizontal(),
          SizedBox(
            height: height * .02,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.values["myOrderDetailList"].length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values["myOrderDetailList"][index]["productDetails"],
                          context,
                          TextStyle(
                              color: ThemeApp.darkGreyColor,
                              fontSize: height * .02,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis)),
                    ),
                    SizedBox(
                      width: width * .1,
                    ),
                    TextFieldUtils().dynamicText(
                        indianRupeesFormat.format(int.parse(
                            widget.values["myOrderDetailList"][index]["price"])),
                        context,
                        TextStyle(
                            color: ThemeApp.darkGreyColor,
                            fontSize: height * .02,
                            fontWeight: FontWeight.w400)),
                  ],
                );
              }),
          SizedBox(
            height: height * .02,
          ),
          TextFieldUtils().lineHorizontal(),
          SizedBox(
            height: height * .02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFieldUtils().dynamicText(
                  "Total Amount",
                  context,
                  TextStyle(
                      color: ThemeApp.darkGreyColor,
                      fontSize: height * .021,
                      fontWeight: FontWeight.bold)),
              TextFieldUtils().dynamicText(
                  indianRupeesFormat.format(int.parse(totalAmount.toString())),
                  context,
                  TextStyle(
                      color: ThemeApp.darkGreyColor,
                      fontSize: height * .021,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget proofOfDeliverDetails() {
    return Container(
      height: height * .2,
      // width: width * 0.88,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: ThemeApp.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldUtils().dynamicText(
              StringUtils.proofOfDelivery,
              context,
              TextStyle(
                  color: ThemeApp.darkGreyTab,
                  fontSize: height * .028,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: height * .02,
          ),
          TextFieldUtils().lineHorizontal(),
          SizedBox(
            height: height * .02,
          ),
        ],
      ),
    );
  }

  Widget cancelReturnOrdersWidget() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return ReturnOrderBottomSheet(values: widget.values);
                });
          },
          child: TextFieldUtils().dynamicText(
              StringUtils.returnItems,
              context,
              TextStyle(
                  color: ThemeApp.blackColor,
                  fontSize: height * .021,
                  fontWeight: FontWeight.w400)),
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return CancelOrderBottomSheet(values: widget.values);
                });
          },
          child: TextFieldUtils().dynamicText(
              StringUtils.cancelOrder,
              context,
              TextStyle(
                  color: ThemeApp.blackColor,
                  fontSize: height * .021,
                  fontWeight: FontWeight.w400)),
        ),
      ]),
    );
  }

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );
}

class CancelOrderBottomSheet extends StatefulWidget {
  final dynamic values;

  const CancelOrderBottomSheet({Key? key, required this.values})
      : super(key: key);

  @override
  State<CancelOrderBottomSheet> createState() => _CancelOrderBottomSheetState();
}

class _CancelOrderBottomSheetState extends State<CancelOrderBottomSheet> {
  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Wrap(children: [mainUI()]);
  }

  Widget mainUI() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: width,
        padding: EdgeInsets.all(20),
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cancelOrderTitle(),
            SizedBox(
              height: height * .02,
            ),
            chooseProductToReturn(),
            SizedBox(
              height: height * .01,
            ),
            itemCancelDetails(),
            SizedBox(
              height: height * .02,
            ),
            cancelText(),
            SizedBox(
              height: height * .01,
            ),
            whyItemCancelDetails(),
            SizedBox(
              height: height * .02,
            ),
            commentOrderCancel(),
            SizedBox(
              height: height * .02,
            ),
            cancelOrderButton()
          ],
        ),
      ),
    );
  }

  Widget cancelOrderTitle() {
    return TextFieldUtils().dynamicText(
        StringUtils.cancelOrder,
        context,
        TextStyle(
            color: ThemeApp.blackColor,
            fontSize: height * .03,
            fontWeight: FontWeight.bold));
  }

  Widget chooseProductToReturn() {
    return TextFieldUtils().dynamicText(
        StringUtils.chooseItemYouWantToCancel,
        context,
        TextStyle(
            color: ThemeApp.blackColor,
            fontSize: height * .025,
            fontWeight: FontWeight.w500));
  }

  Widget itemCancelDetails() {
    return Expanded(
      child: Container(
        // width: width * .4,
        height: height * .04,
        color: ThemeApp.whiteColor,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.values["myOrderCancelList"].length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: height * .035,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value:
                      widget.values["myOrderCancelList"][index]["isCancelProductFor"],
                      onChanged: (values) {
                        setState(() {
                          widget.values["myOrderCancelList"][index]["isCancelProductFor"] =
                              values!;
                        });
                      },
                    ),
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values["myOrderCancelList"][index]["whyCancelProduct"],
                          context,
                          TextStyle(
                              color: ThemeApp.darkGreyColor,
                              fontSize: height * .02,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget cancelText() {
    return TextFieldUtils().dynamicText(
        StringUtils.whyYouWantToCancel,
        context,
        TextStyle(
            color: ThemeApp.blackColor,
            fontSize: height * .025,
            fontWeight: FontWeight.w500));
  }

  int? _radioValue = 0;
  String valuesGroup = '';

  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value;
    });
    print("first" + value.toString() + "radiovalue" + _radioValue.toString());
  }

  Widget whyItemCancelDetails() {
    return Expanded(
      child: Container(
        height: height * .04,
        color: ThemeApp.whiteColor,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.values["myOrderCancelList"].length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: height * .035,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value:
                      widget.values["myOrderCancelList"][index]["whyCancelProduct"],
                      groupValue: valuesGroup,
                      onChanged: (d) {
                        setState(() {
                          valuesGroup = widget.values["myOrderCancelList"][index]["whyCancelProduct"];
                        });
                        print("-----tapped canceled reason-----------" +
                            widget.values["myOrderCancelList"][index]["whyCancelProduct"]);
                      },
                      toggleable: true,
                    ),
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values["myOrderCancelList"][index]["whyCancelProduct"],
                          context,
                          TextStyle(
                              color: ThemeApp.darkGreyColor,
                              fontSize: height * .02,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget commentOrderCancel() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
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
              fontSize: MediaQuery.of(context).size.height * 0.02),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.darkGreyTab)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.darkGreyTab, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.darkGreyTab, width: 1)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.darkGreyTab, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.darkGreyTab, width: 1)),
        ),
      ),
    );
  }

  Widget cancelOrderButton() {
    return Container(
        height: kToolbarHeight,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: proceedButton(StringUtils.cancelOrder,
            ThemeApp.blackColor, context,false, () {                        FocusManager.instance.primaryFocus?.unfocus();

            Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyOrderDetails(values: widget.values),
            ),
          );
        }));
  }
}

class ReturnOrderBottomSheet extends StatefulWidget {
  final dynamic values;

  const ReturnOrderBottomSheet({Key? key, required this.values})
      : super(key: key);

  @override
  State<ReturnOrderBottomSheet> createState() => _ReturnOrderBottomSheetState();
}

class _ReturnOrderBottomSheetState extends State<ReturnOrderBottomSheet> {
  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Wrap(children: [mainUI()]);
  }

  Widget mainUI() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: width,
        padding: EdgeInsets.all(20),
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            returnOrderTitle(),
            SizedBox(
              height: height * .02,
            ),
            chooseProductToReturn(),
            SizedBox(
              height: height * .01,
            ),
            itemCancelDetails(),
            SizedBox(
              height: height * .02,
            ),
            cancelText(),
            SizedBox(
              height: height * .01,
            ),
            whyItemCancelDetails(),
            SizedBox(
              height: height * .02,
            ),
            commentOrderReturn(),
            SizedBox(
              height: height * .02,
            ),returnOrderButton()
          ],
        ),
      ),
    );
  }

  Widget returnOrderTitle() {
    return TextFieldUtils().dynamicText(
        StringUtils.returnOrder,
        context,
        TextStyle(
            color: ThemeApp.blackColor,
            fontSize: height * .03,
            fontWeight: FontWeight.bold));
  }

  Widget chooseProductToReturn() {
    return TextFieldUtils().dynamicText(
        StringUtils.chooseItemYouWantToReturn,
        context,
        TextStyle(
            color: ThemeApp.blackColor,
            fontSize: height * .025,
            fontWeight: FontWeight.w500));
  }

  Widget itemCancelDetails() {
    return Expanded(
      child: Container(
        // width: width * .4,
        height: height * .04,
        color: ThemeApp.whiteColor,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.values["myOrderReturnList"].length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: height * .035,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value:
                      widget.values["myOrderReturnList"][index]["isReturnProductFor"],
                      onChanged: (values) {
                        setState(() {
                          widget.values["myOrderReturnList"][index]["isReturnProductFor"] =
                              values!;
                        });
                      },
                    ),
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values["myOrderReturnList"][index]["whyReturnProduct"],
                          context,
                          TextStyle(
                              color: ThemeApp.darkGreyColor,
                              fontSize: height * .02,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget cancelText() {
    return TextFieldUtils().dynamicText(
        StringUtils.whyYouWantToReturn,
        context,
        TextStyle(
            color: ThemeApp.blackColor,
            fontSize: height * .025,
            fontWeight: FontWeight.w500));
  }
var valuesGroup='';
  Widget whyItemCancelDetails() {
    return Expanded(
      child: Container(
        // width: width * .4,
        height: height * .04,
        color: ThemeApp.whiteColor,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.values["myOrderReturnList"].length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: height * .035,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value:
                      widget.values["myOrderReturnList"][index]["whyReturnProduct"],
                      groupValue: valuesGroup,
                      onChanged: (d) {
                        setState(() {
                          valuesGroup = widget.values["myOrderReturnList"][index]["whyReturnProduct"];
                        });
                        print("-----tapped canceled reason-----------" +
                            widget.values["myOrderReturnList"][index]["whyReturnProduct"]);
                      },
                      toggleable: true,
                    ),
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values["myOrderReturnList"][index]["whyReturnProduct"],
                          context,
                          TextStyle(
                              color: ThemeApp.darkGreyColor,
                              fontSize: height * .02,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget commentOrderReturn() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
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
              fontSize: MediaQuery.of(context).size.height * 0.02),
          contentPadding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.darkGreyTab)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.darkGreyTab, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.darkGreyTab, width: 1)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.darkGreyTab, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeApp.darkGreyTab, width: 1)),
        ),
      ),
    );
  }
  Widget returnOrderButton() {
    return Container(
        height: kToolbarHeight,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: proceedButton(StringUtils.returnnn,
            ThemeApp.blackColor, context,false, () {                        FocusManager.instance.primaryFocus?.unfocus();

            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MyOrderDetails(values: widget.values),
                ),
              );
            }));
  }

}
