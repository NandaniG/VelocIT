import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Model/CartModels/SendCartForPaymentModel.dart';
import 'package:velocit/pages/Activity/My_Orders/MyOrders_Activity.dart';
import 'package:velocit/pages/screens/dashBoard.dart';
import 'package:velocit/utils/routes/routes.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';

import '../../../Core/ViewModel/cart_view_model.dart';
import '../../../Core/ViewModel/dashboard_view_model.dart';
import '../../../Core/repository/cart_repository.dart';
import '../../../services/providers/Home_Provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../homePage.dart';
import '../Order_CheckOut_Activities/OrderReviewScreen.dart';
import '../Order_CheckOut_Activities/confirmationPopUpForNavBack.dart';

class OrderPlaceActivity extends StatefulWidget {
  Map data;
  CartForPaymentPayload cartForPaymentPayload;

  OrderPlaceActivity(
      {Key? key, required this.data, required this.cartForPaymentPayload})
      : super(key: key);

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

  DashboardViewModel dashboardViewModel = DashboardViewModel();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return NavBackConfirmationFromPayment();
            });
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: AppBar(automaticallyImplyLeading: false,
          backgroundColor: ThemeApp.appBackgroundColor,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NavBackConfirmationFromPayment();
                  });

              // Provider.of<ProductProvider>(context, listen: false);
            },
            child: Transform.scale(
              scale: 0.7,
              child: Image.asset(
                'assets/appImages/backArrow.png',
                color: ThemeApp.primaryNavyBlackColor,
                // height: height*.001,
              ),
            ),
          ),
          title: TextFieldUtils().dynamicText(
              'Order Checkout',
              context,
              TextStyle(
                  fontFamily: 'Roboto',
                  color: ThemeApp.blackColor,
                  // fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * .022,
                  fontWeight: FontWeight.w500)),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider<DashboardViewModel>.value(
            value: dashboardViewModel,
            child: Consumer<HomeProvider>(builder: (context, value, child) {
              return Container(
                    color: ThemeApp.appColor,
                    width: width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          stepperWidget(),
                          SizedBox(
                            height: 44,
                          ),
                          SvgPicture.asset(
                            'assets/appImages/successIcon.svg',
                            color: ThemeApp.whiteColor,
                            semanticsLabel: 'Acme Logo',
                            height: 68,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFieldUtils().dynamicText(
                              StringUtils.orderPlacedSuccessfully,
                              context,
                              TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.whiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.25)),
                          SizedBox(
                            height: 5,
                          ),
                          TextFieldUtils().dynamicText(
                              StringUtils.thankyouForOrderingWithUs,
                              context,
                              TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: 32,
                          ),
                          TextFieldUtils().dynamicText(
                              '${StringUtils.orderId + ":"} ${widget.cartForPaymentPayload.orderBasketId.toString()}',
                              // '${StringUtils.orderId + ": ${value.jsonDat
                              // 0a['payload']['order_basket_id'].toStrin/g()??''}"}',

                              context,
                              TextStyle(
                                  fontFamily: 'Roboto',
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
                  ) ??
                  SizedBox();
            }),
          ),
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
      var circleColor = (i == 0 || i == 1 || i == 2||_curStep > i + 1)
          ? ThemeApp.tealButtonColor
          : ThemeApp.appColor;
      var lineColor = (i == 0 || i == 1 || i == 2|| _curStep > i + 1)
          ? ThemeApp.tealButtonColor
          : ThemeApp.appColor;
      var iconColor = (i == 0 || i == 1 ||  i == 2||i==3)
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
          child: (i == 0 || i == 1 ||  i == 2||i==3|| _curStep > i + 1)
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
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .018,
                    fontWeight: FontWeight.w400))
            : TextFieldUtils().dynamicText(
                text,
                context,
                TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .018,
                    fontWeight: FontWeight.w400)),
      );
    });
    return list;
  }

  Widget buttonsForOrderAndShipping() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(children: [
        proceedButton(
            "Continue Shopping ", ThemeApp.tealButtonColor, context, false,
            () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('isUserNavigateFromDetailScreen', '');
          prefs.setString('directCartIdPref', '');
          prefs.setString('directCartIdIsTrue', '');
    prefs.setString(
              'isBuyNow', 'false');
          StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
          var userLoginId = StringConstant.UserLoginId;
          Map data = {'userId': userLoginId};
          print("cart data passOrderPlaced : " + data.toString());

          CartRepository().cartPostRequest(data, context).then((value) {
            StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
            print("Cart Id From OrderPlaced Activity " + StringConstant.UserCartID);
            // print("cartId from Pref" + CARTID.toString());
            CartViewModel()
                .cartSpecificIDWithGet(context, StringConstant.UserCartID).then((value) {


              Navigator.of(context).pushNamedAndRemoveUntil(RoutesName.dashboardRoute, (route) => false).then((value) {
                setState(() {

                });
              });
            });
          });





        }),
        SizedBox(
          height: 21,
        ),
        proceedButton(
            "View my orders", ThemeApp.tealButtonColor, context, false, () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyOrdersActivity(),
            ),
          );
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
