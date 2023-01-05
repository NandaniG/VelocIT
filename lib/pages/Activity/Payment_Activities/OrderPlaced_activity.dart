import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:velocit/Core/Model/CartModels/SendCartForPaymentModel.dart';
import 'package:velocit/pages/screens/dashBoard.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';

import '../../../services/providers/Home_Provider.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../homePage.dart';
import '../Order_CheckOut_Activities/OrderReviewScreen.dart';

class OrderPlaceActivity extends StatefulWidget {
  Map data;
  CartForPaymentPayload cartForPaymentPayload;
   OrderPlaceActivity({Key? key, required this.data,required this.cartForPaymentPayload}) : super(key: key);

  @override
  State<OrderPlaceActivity> createState() => _OrderPlaceActivityState();
}

class _OrderPlaceActivityState extends State<OrderPlaceActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  @override
  void initState() {
    // TODO: implement initState
// print("orderData vdnvkd"+orderData.toString());
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
    preferredSize: Size.fromHeight(height * .09),
    child: appBar_backWidget(
        context, appTitle(context, "Order Checkout"), SizedBox()),
      ),
      body:SafeArea(
        child:Consumer<HomeProvider>(builder: (context, value, child) {
            return  (value.jsonData.isNotEmpty &&
                value.jsonData['error'] == null) ?Container(
    color: ThemeApp.appColor,
    width: width,
    child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                stepperWidget(),
SizedBox(height: 64,),
                SvgPicture.asset(
                  'assets/appImages/successIcon.svg',
                  color: ThemeApp
                      .whiteColor,
                  semanticsLabel:
                  'Acme Logo',

                  height: 68,
                ),
                SizedBox(
                  height: 30,
                ),

                TextFieldUtils().dynamicText(
                    StringUtils.orderPlacedSuccessfully,
                    context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,letterSpacing: -0.25 )),
                SizedBox(
                  height: 5,
                ),

                TextFieldUtils().dynamicText(
                    StringUtils.thankyouForOrderingWithUs,
                    context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.whiteColor,
                        fontSize:14,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 32,
                ),

                TextFieldUtils().dynamicText(
                    '${StringUtils.orderId + ": ${value.jsonData['payload']['invoice_no'].toString()}"}',
                context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                SizedBox(
                  height: height * 0.04,
                ),
                Container(
                  height: 137,
                  width: 137,
                  child: Image.asset(
                    'assets/images/qr_test_image.png',
                    // scale: 2,

                  ),
                ),
                SizedBox(
                  height: 32,
                ),

                buttonsForOrderAndShipping(),
              ]),
            ):SizedBox();
          }
        ),
      ),
    );
  }

  Widget stepperWidget() {
    return Container(
        height: height * .1,
        width: width,
        alignment: Alignment.center,
        color: ThemeApp.appBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: _iconViews(),
              ),
              const SizedBox(
                height: 8,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _titleViews(context),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, icon) {
      var circleColor = (i == 0 || i == 1 || _curStep > i + 1)
          ? ThemeApp.tealButtonColor
          : ThemeApp.appColor;
      var lineColor =
      (i == 0 || i == 1 || _curStep > i + 1) ? ThemeApp.tealButtonColor : ThemeApp.appColor;
      var iconColor = (i == 0 || i == 1 || _curStep > i + 1)
          ? ThemeApp.tealButtonColor
          : ThemeApp.appColor;

      list.add(
        Container(
          width: 23.0,
          height: 23.0,
          padding: const EdgeInsets.all(0),
          // decoration:(i == 0 || _curStep > i + 1) ? new  BoxDecoration(
          //
          // ):BoxDecoration(   /* color: circleColor,*/
          //   borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
          //   border: new Border.all(
          //     color: circleColor,
          //     width: 2.0,
          //   ),),
          child: (i == 0 || _curStep > i + 1)
              ? Icon(
            Icons.circle,
            color: iconColor,
            size: 18.0,
          )
              : Icon(
            Icons.radio_button_checked_outlined,
            color: iconColor,
            size: 18.0,
          ),
        ),
      );

      //line between icons
      if (i != titles.length - 1) {
        list.add(Expanded(
            child: Container(
              height: 3.0,
              color: lineColor,
            )));
      }
    });

    return list;
  }

  List<Widget> _titleViews(BuildContext context) {
    var list = <Widget>[];
    titles.asMap().forEach((i, text) {
      list.add(
        (i == 0 || i == 1 || _curStep > i + 1)
            ? TextFieldUtils().dynamicText(
            text,
            context,
            TextStyle(fontFamily: 'Roboto',
                color: ThemeApp.blackColor,
                fontSize: height * .018,
                fontWeight: FontWeight.w400))
            : TextFieldUtils().dynamicText(
            text,
            context,
            TextStyle(fontFamily: 'Roboto',
                color: ThemeApp.blackColor,
                fontSize: height * .018,
                fontWeight: FontWeight.w400)),
      );
    });
    return list;
  }

  Widget buttonsForOrderAndShipping() {
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20),
      child: Column(children: [
proceedButton("Continue Shopping ", ThemeApp.tealButtonColor, context, false, () {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen(),), (route) => false);

}),
        SizedBox(height: 21,),
        proceedButton("View my orders", ThemeApp.tealButtonColor, context, false, () {  // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => DashboardScreen(),
    //   ),
    // );
    }),


      ]),
    );
  }
}

final List<String> titles = [
  'Order Placed',
  'Payment',
  'Order Completed',
];
int _curStep = 1;
