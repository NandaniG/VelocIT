import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocit/pages/Activity/My_Orders/QR_download_popup.dart';

import '../../../services/models/MyOrdersModel.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyOrderDetails extends StatefulWidget {
  final MyOrdersModel values;

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
  for (int i = 0; i < widget.values.orderDetailList.length; i++) {
    totalAmount = int.parse(
        widget.values.orderDetailList[i].price.toString()) +
        totalAmount;
    print(totalAmount);
  }

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
            context, appTitle(context, "Order Details"), SizedBox()),
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
                          widget.values.orderId,
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
                          ),
                          color: ThemeApp.whiteColor,
                        ),
                        child: TextFieldUtils().dynamicText(
                            widget.values.orderStatus,
                            context,
                            TextStyle(
                                color: ThemeApp.blackColor,
                                fontSize: height * .023,
                                fontWeight: FontWeight.bold)),
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
                            const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          color: ThemeApp.whiteColor,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.my_library_books_rounded,
                              size: height * .02,
                            ),
                            SizedBox(
                              width: width * .02,
                            ),
                            TextFieldUtils().dynamicText(
                                'Download Invoice',
                                context,
                                TextStyle(
                                    color: ThemeApp.blackColor,
                                    fontSize: height * .018,
                                    fontWeight: FontWeight.w500)),
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
          itemCount: widget.values.orderDetailList.length,
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
                          children: [
                            Flexible(
                              child: TextFieldUtils().dynamicText(
                                  widget.values.orderDetailList[index]
                                      .productDetails,
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
                                          widget.values.orderDetailList[index]
                                              .ProductImage,
                                        )))),
                          ],
                        ),
                        TextFieldUtils().dynamicText(
                            widget.values.orderDetailList[index].venderDetails,
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
              AppLocalizations.of(context).deliveryDetails,
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
              widget.values.orderPerson,
              context,
              TextStyle(
                  color: ThemeApp.blackColor,
                  fontSize: height * .024,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: height * .02,
          ),
          TextFieldUtils().dynamicText(
              widget.values.orderDeliveryAddress,
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
              AppLocalizations.of(context).invoice,
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
              itemCount: widget.values.orderDetailList.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values.orderDetailList[index].productDetails,
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
                            widget.values.orderDetailList[index].price)),
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
              AppLocalizations.of(context).proofOfDelivery,
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
              AppLocalizations.of(context).returnItems,
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
              AppLocalizations.of(context).cancelOrder,
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
  final MyOrdersModel values;

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
        AppLocalizations.of(context).cancelOrder,
        context,
        TextStyle(
            color: ThemeApp.blackColor,
            fontSize: height * .03,
            fontWeight: FontWeight.bold));
  }

  Widget chooseProductToReturn() {
    return TextFieldUtils().dynamicText(
        AppLocalizations.of(context).chooseItemYouWantToCancel,
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
            itemCount: widget.values.orderDetailList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: height * .035,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value:
                          widget.values.orderDetailList[index].isOrderCanceled,
                      onChanged: (values) {
                        setState(() {
                          widget.values.orderDetailList[index].isOrderCanceled =
                              values!;
                        });
                      },
                    ),
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values.orderDetailList[index].productDetails,
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
        AppLocalizations.of(context).whyYouWantToCancel,
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
            itemCount: widget.values.orderCancelList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: height * .035,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value:
                          widget.values.orderCancelList[index].whyCancelProduct,
                      groupValue: valuesGroup,
                      onChanged: (d) {
                        setState(() {
                          valuesGroup = widget
                              .values.orderCancelList[index].whyCancelProduct;
                        });
                        print("-----tapped canceled reason-----------" +
                            widget.values.orderCancelList[index]
                                .whyCancelProduct);
                      },
                      toggleable: true,
                    ),
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values.orderCancelList[index].whyCancelProduct,
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
        child: proceedButton(AppLocalizations.of(context).cancelOrder,
            ThemeApp.blackColor, context, () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyOrderDetails(values: widget.values),
            ),
          );
        }));
  }
}

class ReturnOrderBottomSheet extends StatefulWidget {
  final MyOrdersModel values;

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
        AppLocalizations.of(context).returnOrder,
        context,
        TextStyle(
            color: ThemeApp.blackColor,
            fontSize: height * .03,
            fontWeight: FontWeight.bold));
  }

  Widget chooseProductToReturn() {
    return TextFieldUtils().dynamicText(
        AppLocalizations.of(context).chooseItemYouWantToReturn,
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
            itemCount: widget.values.orderDetailList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: height * .035,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value:
                          widget.values.orderDetailList[index].isOrderReturned,
                      onChanged: (values) {
                        setState(() {
                          widget.values.orderDetailList[index].isOrderReturned =
                              values!;
                        });
                      },
                    ),
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values.orderDetailList[index].productDetails,
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
        AppLocalizations.of(context).whyYouWantToReturn,
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
            itemCount: widget.values.orderReturnList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: height * .035,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value:
                      widget.values.orderReturnList[index].whyReturnProduct,
                      groupValue: valuesGroup,
                      onChanged: (d) {
                        setState(() {
                          valuesGroup = widget
                              .values.orderReturnList[index].whyReturnProduct;
                        });
                        print("-----tapped canceled reason-----------" +
                            widget.values.orderReturnList[index]
                                .whyReturnProduct);
                      },
                      toggleable: true,
                    ),
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values.orderReturnList[index].whyReturnProduct,
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
        child: proceedButton(AppLocalizations.of(context).returnnn,
            ThemeApp.blackColor, context, () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MyOrderDetails(values: widget.values),
                ),
              );
            }));
  }

}
