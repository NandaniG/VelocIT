import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:velocit/pages/Activity/My_Orders/QR_download_popup.dart';
import 'package:velocit/utils/utils.dart';

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
    // totalAmount = 0;
    // for (int i = 0; i < widget.values["myOrderDetailList"].length; i++) {
    //   totalAmount =
    //       int.parse(widget.values["myOrderDetailList"][i]["price"].toString()) +
    //           totalAmount;
    //   print(totalAmount);
    // }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .08),
        child:  AppBar_BackWidget(
            context: context,titleWidget: appTitle(context,"Order Details"), location: SizedBox()),
     ),
      body: SafeArea(child: mainUI()),
    );
  }

  Widget mainUI() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15.0, 10, 15.0, 5.0),
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
                          widget.values["id"].toString(),
                          context,
                          TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(
                            color: ThemeApp.orderStatusColor,
                          ),
                          color: ThemeApp.orderStatusBGColor,
                        ),
                        child: TextFieldUtils().dynamicText(
                            widget.values["overall_status"] ?? "",
                            context,
                            TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.orderStatusColor,
                                fontSize: 10,
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
                            width: 20.0,
                            height: 20.0,
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
                      InkWell(
                        onTap: () async {

                          try {
                            // Saved with this method.
                            var imageId = await ImageDownloader.downloadImage(
                                "http://static.fulgorithmapi.com/invoices/invoice.jpg");
                            if (imageId == null) {
                              return;
                            }
                            // Below is a method of obtaining saved image information.
                            var fileName =
                                await ImageDownloader.findName(imageId);
                            var path = await ImageDownloader.findPath(imageId);
                            var size =
                                await ImageDownloader.findByteSize(imageId);
                            var mimeType =
                                await ImageDownloader.findMimeType(imageId);
                            Navigator.pop(context);
                            Utils.successToast('Image downloaded.');
                          } on PlatformException catch (error) {
                            print(error);
                          }
                        },
                        child: Container(
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
                                height: 16.29,
                                width: 8.77,
                              ),
                              SizedBox(
                                width: width * .02,
                              ),
                              TextFieldUtils().dynamicText(
                                  'Download Invoice',
                                  context,
                                  TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.whiteColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -0.25)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              stepperOfDelivery(),

              // stepperWidget(widget.values),

              SizedBox(
                height: 10,
              ),
              deliveryDetails(),
              SizedBox(
                height: 10,
              ),
              invoiceDetails(),
              SizedBox(
                height: 10,
              ),
              // proofOfDeliverDetails(),
              // SizedBox(
              //   height: 15,
              // ),
            ]),
      ),
    );
  }

  Widget stepperOfDelivery() {
    return Container(
      // height: height * .3,
      height: 195,

      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.values["orders"].length,
          itemBuilder: (BuildContext context, int index) {
            Map orders = widget.values["orders"][index];
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
                            Container(
                              width: 62.0,
                              height: 62.0,
                              decoration: new BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(2)),
                                shape: BoxShape.rectangle,
                              ),
                              child: Image.network(
                                  // width: double.infinity,
                                  orders["image_url"] ?? "",
                                  width: 62.0,
                                  height: 62.0,
                                  errorBuilder: ((context, error, stackTrace) {
                                return Icon(Icons.image_outlined);
                              })),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .03,
                            ),
                            Flexible(
                              child: TextFieldUtils().dynamicText(
                                  orders["oneliner"],
                                  context,
                                  TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.blackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        TextFieldUtils().dynamicText(
                            orders["merchant_name"].toString() ?? "",
                            context,
                            TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.darkGreyTab,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                overflow: TextOverflow.ellipsis)),
                        stepperWidget(orders)
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
              '${widget.values['orders_packed_completed'].toString()}/${widget.values['orders_packed_total'].toString()}',
              context,
              subOrders['is_packed'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              '${widget.values['orders_Shipped_completed'].toString()}/${widget.values['orders_Shipped_total'].toString()}',
              context,
              subOrders['is_shipped'] == true
                  ? ThemeApp.blackColor
                  : ThemeApp.lightFontColor),
        ),
        Container(
          width: 50,
          child: TextFieldUtils().stepperTextFields(
              '${widget.values['orders_Delivered_completed'].toString()}/${widget.values['orders_Delivered_total'].toString()}',
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

  Widget deliveryDetails() {
    return Container(
      // width: 300,
      // width: width * 0.85,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: ThemeApp.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldUtils().dynamicText(
              StringUtils.deliveryDetails,
              context,
              TextStyle(
                  fontFamily: 'Roboto',
                  color: ThemeApp.primaryNavyBlackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.25)),
          SizedBox(
            height: 5,
          ),
          TextFieldUtils().lineHorizontal(),
          SizedBox(
            height: 10,
          ),
          TextFieldUtils().dynamicText(
              widget.values["customer_name"] ?? '',
              context,
              TextStyle(
                  fontFamily: 'Roboto',
                  color: ThemeApp.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          SizedBox(
            height: height * .02,
          ),
          TextFieldUtils().dynamicText(
                  " ${widget.values["delivery_address_line1"] ?? ''} ${widget.values["delivery_address_line2"] ?? ""} ${widget.values["delivery_address_city"] ?? ""}${widget.values["delivery_address_line2"] ?? ""}${widget.values["delivery_address_pincode"] ?? ""}",
                  // "${
                  //        widget.values["delivery_address_line1"]??""} ${widget.values["delivery_address_line2"] ??
                  //            ''} ${widget.values["delivery_address_city"] ??
                  //            ""} ${widget.values["delivery_address_state"] ??
                  //            ""} ${widget.values["delivery_address_pincode"].toString()
                  //      }" ??"",
                  context,
                  TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.25,
                      height: 1.5)) ??
              SizedBox(),
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
                  fontFamily: 'Roboto',
                  color: ThemeApp.primaryNavyBlackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          SizedBox(
            height: 5,
          ),
          TextFieldUtils().lineHorizontal(),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.values["orders"].length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values["orders"][index]['oneliner'],
                          context,
                          TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: -0.25)),
                    ),
                    SizedBox(
                      width: width * .1,
                    ),
                    TextFieldUtils().dynamicText(
                        indianRupeesFormat
                                .format(double.parse(widget.values["orders"]
                                        [index]['mrp']
                                    .toString()))
                                .toString() ??
                            '',
                        context,
                        TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.lightFontColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                );
              }),
          SizedBox(height: 4),
          TextFieldUtils().lineHorizontal(),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFieldUtils().dynamicText(
                  "Total Amount",
                  context,
                  TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2)),
              TextFieldUtils().dynamicText(
                  'total amount',
                  // indianRupeesFormat.format(double.parse(widget.values["orders"][i]['mrp'])).toString()??'',
                  context,
                  TextStyle(
                      fontFamily: 'Roboto',
                      color: ThemeApp.darkGreyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2)),
            ],
          ),
        ],
      ),
    );
  }

/*  Widget proofOfDeliverDetails() {
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
                  fontFamily: 'Roboto',
                  color: ThemeApp.darkGreyTab,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.25)),
          SizedBox(
            height: 5,
          ),
          TextFieldUtils().lineHorizontal(),
          SizedBox(
            height: 15,
          ),
          cancelReturnOrdersWidget()
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
                  fontFamily: 'Roboto',
                  color: ThemeApp.blackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
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
                  fontFamily: 'Roboto',
                  color: ThemeApp.blackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }*/

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
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: width,
      padding: EdgeInsets.all(20),
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            returnOrderTitle(),
            SizedBox(
              height: height * .02,
            ),
            /*   chooseProductToReturn(),
              SizedBox(
                height: height * .01,
              ),*/
            Container(
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeApp.lightBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    chooseProductToReturn(),
                    SizedBox(
                      height: height * .01,
                    ),
                    itemCancelDetails(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            Container(
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeApp.lightBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cancelText(),
                      SizedBox(
                        height: height * .01,
                      ),
                      whyItemCancelDetails(),
                    ],
                  ),
                )),
            SizedBox(
              height: 5,
            ),
            commentText(),
            SizedBox(
              height: height * .02,
            ),
            commentOrderReturn(),
            SizedBox(
              height: height * .02,
            ),
            returnOrderButton()
          ],
        ),
      ),
    );
  }

  Widget returnOrderTitle() {
    return TextFieldUtils().dynamicText(
        StringUtils.cancelOrder,
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.primaryNavyBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w700));
  }

  Widget chooseProductToReturn() {
    return TextFieldUtils().dynamicText(
        StringUtils.chooseItemYouWantToCancel,
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w400));
  }

  Widget itemCancelDetails() {
    return Container(
      // width: width * .4,
      height: 150,
      color: ThemeApp.whiteColor,
      child: ListView.builder(
          // physics: NeverScrollableScrollPhysics(),
          itemCount: widget.values["myOrderCancelList"].length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: height * .034,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: widget.values["myOrderCancelList"][index]
                        ["isCancelProductFor"],
                    onChanged: (values) {
                      setState(() {
                        widget.values["myOrderCancelList"][index]
                            ["isCancelProductFor"] = values!;
                      });
                    },
                  ),
                  Flexible(
                    child: TextFieldUtils().dynamicText(
                        widget.values["myOrderCancelList"][index]
                            ["whyCancelProduct"],
                        context,
                        TextStyle(
                            fontFamily: 'Roboto',
                            color: ThemeApp.blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis)),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget cancelText() {
    return TextFieldUtils().dynamicText(
        StringUtils.whyYouWantToCancel,
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w400));
  }

  var valuesGroup = '';

  Widget whyItemCancelDetails() {
    return Container(
      // width: width * .4,
      height: 150,
      color: ThemeApp.whiteColor,
      child: ListView.builder(
          // physics: NeverScrollableScrollPhysics(),
          itemCount: widget.values["myOrderCancelList"].length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: height * .032,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                    value: widget.values["myOrderCancelList"][index]
                        ["whyCancelProduct"],
                    groupValue: valuesGroup,
                    onChanged: (d) {
                      setState(() {
                        valuesGroup = widget.values["myOrderCancelList"][index]
                            ["whyCancelProduct"];
                      });
                      print("-----tapped canceled reason-----------" +
                          widget.values["myOrderCancelList"][index]
                              ["whyCancelProduct"]);
                    },
                    toggleable: true,
                  ),
                  Flexible(
                    child: TextFieldUtils().dynamicText(
                        widget.values["myOrderCancelList"][index]
                            ["whyCancelProduct"],
                        context,
                        TextStyle(
                            fontFamily: 'Roboto',
                            color: ThemeApp.blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis)),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget commentText() {
    return TextFieldUtils().dynamicText(
        'Comments',
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w400));
  }

  Widget commentOrderReturn() {
    return Container(
      width: width,
      child: TextFormField(
        // controller: doctoreNotesController,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: height * .022,
          color: ThemeApp.blackColor,
        ),
        validator: (value) {
          return null;
        },
        maxLines: 3,

        decoration: InputDecoration(
          filled: true,
          fillColor: ThemeApp.whiteColor,
          hintStyle: TextStyle(
              fontFamily: 'Roboto',
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
        child: proceedButton(
            StringUtils.returnnn, ThemeApp.tealButtonColor, context, false, () {
          FocusManager.instance.primaryFocus?.unfocus();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyOrderDetails(values: widget.values),
            ),
          );
        }));
  }
/* Widget mainUI() {
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
        TextStyle(fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            fontSize: height * .03,
            fontWeight: FontWeight.bold));
  }

  Widget chooseProductToReturn() {
    return TextFieldUtils().dynamicText(
        StringUtils.chooseItemYouWantToCancel,
        context,
        TextStyle(fontFamily: 'Roboto',
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
                      value: widget.values["myOrderCancelList"][index]
                          ["isCancelProductFor"],
                      onChanged: (values) {
                        setState(() {
                          widget.values["myOrderCancelList"][index]
                              ["isCancelProductFor"] = values!;
                        });
                      },
                    ),
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values["myOrderCancelList"][index]
                              ["whyCancelProduct"],
                          context,
                          TextStyle(fontFamily: 'Roboto',
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
        TextStyle(fontFamily: 'Roboto',
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
                      value: widget.values["myOrderCancelList"][index]
                          ["whyCancelProduct"],
                      groupValue: valuesGroup,
                      onChanged: (d) {
                        setState(() {
                          valuesGroup = widget.values["myOrderCancelList"]
                              [index]["whyCancelProduct"];
                        });
                        print("-----tapped canceled reason-----------" +
                            widget.values["myOrderCancelList"][index]
                                ["whyCancelProduct"]);
                      },
                      toggleable: true,
                    ),
                    Flexible(
                      child: TextFieldUtils().dynamicText(
                          widget.values["myOrderCancelList"][index]
                              ["whyCancelProduct"],
                          context,
                          TextStyle(fontFamily: 'Roboto',
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
        style: TextStyle(fontFamily: 'Roboto',
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
          hintStyle: TextStyle(fontFamily: 'Roboto',
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
        child: proceedButton(
            StringUtils.cancelOrder, ThemeApp.blackColor, context, false, () {
          FocusManager.instance.primaryFocus?.unfocus();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyOrderDetails(values: widget.values),
            ),
          );
        }));
  }*/
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: width,
      padding: EdgeInsets.all(20),
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            returnOrderTitle(),
            SizedBox(
              height: height * .02,
            ),
            /*   chooseProductToReturn(),
            SizedBox(
              height: height * .01,
            ),*/
            Container(
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeApp.lightBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    chooseProductToReturn(),
                    SizedBox(
                      height: height * .01,
                    ),
                    itemCancelDetails(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            Container(
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeApp.lightBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cancelText(),
                      SizedBox(
                        height: height * .01,
                      ),
                      whyItemCancelDetails(),
                    ],
                  ),
                )),
            SizedBox(
              height: 5,
            ),
            commentText(),
            SizedBox(
              height: height * .02,
            ),
            commentOrderReturn(),
            SizedBox(
              height: height * .02,
            ),
            returnOrderButton()
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
            fontFamily: 'Roboto',
            color: ThemeApp.primaryNavyBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w700));
  }

  Widget chooseProductToReturn() {
    return TextFieldUtils().dynamicText(
        StringUtils.chooseItemYouWantToReturn,
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w400));
  }

  Widget itemCancelDetails() {
    return Container(
      // width: width * .4,
      height: 150,
      color: ThemeApp.whiteColor,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.values["myOrderReturnList"].length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: height * .034,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: widget.values["myOrderReturnList"][index]
                        ["isReturnProductFor"],
                    onChanged: (values) {
                      setState(() {
                        widget.values["myOrderReturnList"][index]
                            ["isReturnProductFor"] = values!;
                      });
                    },
                  ),
                  Flexible(
                    child: TextFieldUtils().dynamicText(
                        widget.values["myOrderReturnList"][index]
                            ["whyReturnProduct"],
                        context,
                        TextStyle(
                            fontFamily: 'Roboto',
                            color: ThemeApp.blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis)),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget cancelText() {
    return TextFieldUtils().dynamicText(
        StringUtils.whyYouWantToReturn,
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w400));
  }

  var valuesGroup = '';

  Widget whyItemCancelDetails() {
    return Container(
      // width: width * .4,
      height: 150,
      color: ThemeApp.whiteColor,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.values["myOrderReturnList"].length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: height * .034,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                    value: widget.values["myOrderReturnList"][index]
                        ["whyReturnProduct"],
                    groupValue: valuesGroup,
                    onChanged: (d) {
                      setState(() {
                        valuesGroup = widget.values["myOrderReturnList"][index]
                            ["whyReturnProduct"];
                      });
                      print("-----tapped canceled reason-----------" +
                          widget.values["myOrderReturnList"][index]
                              ["whyReturnProduct"]);
                    },
                    toggleable: true,
                  ),
                  Flexible(
                    child: TextFieldUtils().dynamicText(
                        widget.values["myOrderReturnList"][index]
                            ["whyReturnProduct"],
                        context,
                        TextStyle(
                            fontFamily: 'Roboto',
                            color: ThemeApp.blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis)),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget commentText() {
    return TextFieldUtils().dynamicText(
        'Comments',
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w400));
  }

  Widget commentOrderReturn() {
    return Container(
      width: width,
      child: TextFormField(
        // controller: doctoreNotesController,
        style: TextStyle(
          fontSize: height * .022,
          color: ThemeApp.blackColor,
        ),
        validator: (value) {
          return null;
        },
        maxLines: 3,

        decoration: InputDecoration(
          filled: true,
          fillColor: ThemeApp.whiteColor,
          hintStyle: TextStyle(
              fontFamily: 'Roboto',
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
        child: proceedButton(
            StringUtils.returnnn, ThemeApp.tealButtonColor, context, false, () {
          FocusManager.instance.primaryFocus?.unfocus();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyOrderDetails(values: widget.values),
            ),
          );
        }));
  }
}
