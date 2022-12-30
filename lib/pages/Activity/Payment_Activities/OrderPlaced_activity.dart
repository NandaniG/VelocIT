import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocit/pages/screens/dashBoard.dart';

import '../../../services/providers/Home_Provider.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../homePage.dart';
import '../Order_CheckOut_Activities/OrderReviewScreen.dart';

class OrderPlaceActivity extends StatefulWidget {
  final dynamic orderReview;

  const OrderPlaceActivity({Key? key, this.orderReview, }) : super(key: key);

  @override
  State<OrderPlaceActivity> createState() => _OrderPlaceActivityState();
}

class _OrderPlaceActivityState extends State<OrderPlaceActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

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
      body: SafeArea(
        child:Consumer<HomeProvider>(builder: (context, value, child) {
            return Container(
    color: ThemeApp.appColor,
    width: width,
    child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                stepperWidget(),
                Icon(
                  Icons.check_circle_outlined,
                  size: 100,                        color: ThemeApp.whiteColor,

                ),
                SizedBox(
                  height: height * 0.02,
                ),

                TextFieldUtils().dynamicText(
                    StringUtils.orderPlacedSuccessfully,
                    context,
                    TextStyle(
                        color: ThemeApp.whiteColor,
                        fontSize: height * .035,
                        fontWeight: FontWeight.w500)),   SizedBox(
                  height: height * 0.02,
                ),

                TextFieldUtils().dynamicText(
                    StringUtils.thankyouForOrderingWithUs,
                    context,
                    TextStyle(
                        color: ThemeApp.whiteColor,
                        fontSize: height * .022,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: height * 0.04,
                ),

                TextFieldUtils().dynamicText(
                    '${StringUtils.orderId + ": ${value.orderCheckOutList[0]['orderCheckOutOrderID']}"}',
                    context,
                    TextStyle(
                        color: ThemeApp.whiteColor,
                        fontSize: height * .025,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  height: height * 0.04,
                ),
                Image.asset(
                  value.orderCheckOutList[0]["orderCheckOutQRCode"],
                  scale: 2,
                ),
                SizedBox(
                  height: height * 0.05,
                ),

                buttonsForOrderAndShipping(),
              ]),
            );
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
            TextStyle(
                color: ThemeApp.blackColor,
                fontSize: height * .018,
                fontWeight: FontWeight.w400))
            : TextFieldUtils().dynamicText(
            text,
            context,
            TextStyle(
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
      child: Row(children: [
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => OrderReviewSubActivity(productList: widget.productList),
              //   ),
              // );
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: ThemeApp.tealButtonColor,
                ),
                child: TextFieldUtils().usingPassTextFields(
                    "View My Orders", ThemeApp.whiteColor, context)),
          ),
        ),
        SizedBox(
          width: width * 0.03,
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              // Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(
              //     builder: (context) => DashboardScreen(),
              //   ),
              // );
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen(),), (route) => false);
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: ThemeApp.whiteColor,
                ),
                child: TextFieldUtils().usingPassTextFields(
                    "Continue Shopping ", ThemeApp.tealButtonColor, context)),
          ),
        )
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
