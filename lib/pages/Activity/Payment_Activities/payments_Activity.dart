import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Model/CartModels/SendCartForPaymentModel.dart';
import 'package:velocit/services/providers/Home_Provider.dart';

import '../../../Core/repository/cart_repository.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../Order_CheckOut_Activities/OrderReviewScreen.dart';
import '../Order_CheckOut_Activities/confirmationPopUpForNavBack.dart';
import 'OrderPlaced_activity.dart';

enum CardType {
  Master,
  Visa,
  Verve,
  Discover,
  AmericanExpress,
  DinersClub,
  Jcb,
  Others,
  Invalid
}

enum DropSelections { upi, Wallets, creditCard, cashOnDelivery }

class Payment_Creditcard_debitcardScreen extends StatefulWidget {
  final dynamic orderReview;
  CartForPaymentPayload cartForPaymentPayload;

  Payment_Creditcard_debitcardScreen(
      {Key? key, this.orderReview, required this.cartForPaymentPayload})
      : super(key: key);

  @override
  State<Payment_Creditcard_debitcardScreen> createState() =>
      _Payment_Creditcard_debitcardScreenState();
}

class _Payment_Creditcard_debitcardScreenState
    extends State<Payment_Creditcard_debitcardScreen> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cVVController = TextEditingController();
  TextEditingController ExpiryDateController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  final _formKey = GlobalKey<FormState>();
  bool _validateCardNumber = false;
  DropSelections paymentMode = DropSelections.upi;
  final focusNodeExpiryDate = FocusNode();
  final focusNodeCvv = FocusNode();
  late Random rnd;
  var min = 10000000;
  int max = 1000000000;
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );
  int? _radioSelected = 3;
  String _radioVal = "";
  CardType cardType = CardType.Invalid;

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
        appBar: AppBar(
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
        bottomNavigationBar: BottomAppBar(
          color: ThemeApp.appBackgroundColor,
          elevation: 0,
          child: Consumer<HomeProvider>(builder: (context, value, child) {
            return value.jsonData.isEmpty
                ? CircularProgressIndicator()
                : Container(
                    height: 72,
                    // height: height * .09,
                    width: width,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: ThemeApp.tealButtonColor,
                    ),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 15, bottom: 14),
                    // height: height * .09,
                    // width: width,
                    // decoration: BoxDecoration(
                    //   color: ThemeApp.tealButtonColor,
                    //   borderRadius: BorderRadius.only(
                    //       topRight: Radius.circular(15),
                    //       topLeft: Radius.circular(15)),
                    // ),
                    // padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFieldUtils().dynamicText(
                                  '${indianRupeesFormat.format(2530)}',
                                  context,
                                  TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.whiteColor,
                                      fontSize: height * .025,
                                      fontWeight: FontWeight.bold)),
                              TextFieldUtils().dynamicText(
                                  'View Price Details',
                                  context,
                                  TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.whiteColor,
                                    fontSize: height * .018,
                                  ))
                            ]),
                        InkWell(
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();

                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => OrderPlaceActivity(productList: widget.productList),
                              //   ),
                              // );
                              rnd = new Random();

                              var r = min + rnd.nextInt(max - min);

                              print("$r is in the range of $min and $max");
                              int UTRNumber = r;
                              print("UTRNumber " + UTRNumber.toString());
                              // Map data={
                              //           "utr_number":UTRNumber,
                              //           "user_id": widget.cartForPaymentPayload.userId,
                              //           "paid_amount":widget.cartForPaymentPayload.cart!.totalPayable,
                              //           "remark":"OK",
                              //           "is_successful":true
                              //         };
                              var paymentAttemptId =  prefs.getString('payment_attempt_id');
                /*
                              Map data = {
                                "payment_attempt_id":
                                    int.parse(paymentAttemptId.toString()),
                                "order_basket_id":
                                    widget.cartForPaymentPayload.orderBasketId,
                                "utr_number": UTRNumber.toString(),
                                "user_id": widget.cartForPaymentPayload.userId,
                                "paid_amount": widget
                                    .cartForPaymentPayload.cart!.totalPayable,
                                "remark": "yes",
                                "is_successful": true,
                                "error_message": "",
                                "payment_received_from_pg":
                                    DateTime.now().toString(),
                                "payment_sent_to_pg": DateTime.now().toString(),
                                "payment_status": "OK",
                                "pg_selected": "RazorPay"
                              };
*/
                              // DateTime currentDateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(DateTime.now().toString()).toLocal(); // parse String datetime to DateTime and get local date time
                              //2021-05-21T17:33:24.000000Z
print("Current Date Time"+DateTime.now().toUtc().toString());
                              //replace substring of the given string
                              String result = DateTime.now().toUtc().toString().replaceAll(" ", "T");
                              print("Current Date Time "+result.toString());

                              print(result);
                              Map data =   {
                                "payment_attempt_id":paymentAttemptId,
                                "order_basket_id":widget.cartForPaymentPayload.orderBasketId,
                                "utr_number":UTRNumber,
                                "user_id":widget.cartForPaymentPayload.userId,
                                "paid_amount":widget.cartForPaymentPayload.cart!.totalPayable,
                                "remark":"yes",
                                "is_successful":true,
                                "error_message":"",
                                "payment_received_from_pg":result,
                                "payment_sent_to_pg":result,
                                "payment_status":"OK",
                                "pg_selected":"RazorPay"
                              };

                              CartRepository()
                                  .putCartForPaymentUpdate(data,
                                      widget.cartForPaymentPayload.orderBasketId!)
                                  .then((value) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OrderPlaceActivity(
                                      data: data,
                                      cartForPaymentPayload:
                                          widget.cartForPaymentPayload),
                                ));
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 141,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                color: ThemeApp.whiteColor,
                              ),
                              child: TextFieldUtils().dynamicText(
                                  'Proceed to Payment',
                                  context,
                                  TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.tealButtonColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.25)),
                            )),
                      ],
                    ),
                  );
          }),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              stepperWidget(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: MediaQuery.of(context).size.height * .62,
                  decoration: BoxDecoration(
                    color: ThemeApp.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 40),
                    child: Form(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFieldUtils().dynamicText(
                                StringUtils.allOtherOptions,
                                context,
                                TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.blackColor,
                                    fontSize: height * .025,
                                    fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: _radioSelected,
                                  activeColor: ThemeApp.appColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _radioSelected = value as int;
                                      _radioVal = 'UPI';
                                      print(_radioVal);
                                    });
                                  },
                                ),
                                const Text("UPI",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.blackColor,
                                      // fontSize: height * .016,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 2,
                                  groupValue: _radioSelected,
                                  activeColor: ThemeApp.appColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _radioSelected = value as int;
                                      _radioVal = 'Wallets';
                                      print(_radioVal);
                                    });
                                  },
                                ),
                                const Text("Wallets",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.blackColor,
                                      // fontSize: height * .016,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 3,
                                  groupValue: _radioSelected,
                                  activeColor: ThemeApp.appColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _radioSelected = value as int;
                                      _radioVal = 'Credit / Debit / ATM Card';
                                      print(_radioVal);
                                    });
                                  },
                                ),
                                const Text("Credit / Debit / ATM Card",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.blackColor,
                                      // fontSize: height * .016,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ],
                            ),
                            // _radioSelected==3? SizedBox(
                            //   height: MediaQuery.of(context).size.height * .02,
                            // ):SizedBox(height: 0,),
                            _radioSelected == 3
                                ? TextFieldUtils().dynamicText(
                                    StringUtils.cardNumber,
                                    context,
                                    TextStyle(
                                        fontFamily: 'Roboto',
                                        color: ThemeApp.blackColor,
                                        fontSize: height * .02,
                                        fontWeight: FontWeight.w500))
                                : SizedBox(
                                    height: 0,
                                  ),
                            _radioSelected == 3
                                ? CardNumberTextFormFieldsWidget(
                                    errorText: StringUtils.validEmailError,
                                    textInputType: TextInputType.number,
                                    controller: cardNumberController,
                                    maxLength: 19,
                                    autoValidation:
                                        AutovalidateMode.onUserInteraction,
                                    hintText: '1234 2345 5678 5553',
                                    onFieldSubmit: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focusNodeExpiryDate);
                                    },
                                    onChange: (val) {
                                      setState(() {
                                        if (val.isEmpty &&
                                            cardNumberController.text.length <
                                                19) {
                                          _validateCardNumber = true;
                                        } else {
                                          _validateCardNumber = false;
                                        }
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty &&
                                          cardNumberController.text.length < 19) {
                                        _validateCardNumber = true;
                                      } else {
                                        _validateCardNumber = false;
                                      }
                                      return null;
                                    })
                                : SizedBox(
                                    height: 0,
                                  ),
                            _radioSelected == 3
                                ? SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .02,
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            _radioSelected == 3
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextFieldUtils().dynamicText(
                                            StringUtils.expiryDate,
                                            context,
                                            TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ThemeApp.blackColor,
                                                fontSize: height * .02,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      Expanded(
                                        child: TextFieldUtils().dynamicText(
                                            StringUtils.cvv,
                                            context,
                                            TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ThemeApp.blackColor,
                                                fontSize: height * .02,
                                                fontWeight: FontWeight.w500)),
                                      )
                                    ],
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            _radioSelected == 3
                                ? Row(
                                    children: [
                                      // Expanded(
                                      //     child: TextFormFieldsWidget(
                                      //         errorText:
                                      //             StringUtils
                                      //                 .emailError,
                                      //         textInputType:
                                      //             TextInputType.emailAddress,
                                      //         controller: ExpiryDateController,
                                      //         autoValidation: AutovalidateMode
                                      //             .onUserInteraction,
                                      //         hintText: 'MM / YY',
                                      //         onChange: (val) {
                                      //           setState(() {});
                                      //         },
                                      //         validator: (value) {
                                      //           return null;
                                      //         })),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 8.0),
                                          child: TextFormField(
                                            maxLength: 5,
                                            controller: ExpiryDateController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              CardExpirationFormatter(),
                                            ],
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focusNodeCvv);
                                            },
                                            focusNode: focusNodeExpiryDate,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                              counterText: "",
                                              hintText: 'MM / YY',
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintStyle: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.grey,
                                                  fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.020),
                                              errorStyle: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: ThemeApp.redColor,
                                                  fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.020),
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      20.0, 15.0, 20.0, 15.0),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: ThemeApp
                                                        .textFieldBorderColor,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: ThemeApp
                                                          .textFieldBorderColor,
                                                      width: 1)),
                                              disabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: ThemeApp
                                                          .textFieldBorderColor,
                                                      width: 1)),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: ThemeApp.redColor,
                                                      width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: ThemeApp
                                                          .textFieldBorderColor,
                                                      width: 1)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: CardCVVTextFormFieldWidget(
                                            errorText: 'please enter password',
                                            textInputType: TextInputType.number,
                                            controller: cVVController,
                                            autoValidation: AutovalidateMode
                                                .onUserInteraction,
                                            focusNode: focusNodeCvv,
                                            hintText: '***',
                                            onChange: (val) {
                                              setState(() {});
                                            },
                                            validator: (value) {
                                              return null;
                                            }),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            Row(
                              children: [
                                Radio(
                                  value: 4,
                                  groupValue: _radioSelected,
                                  activeColor: ThemeApp.appColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _radioSelected = value as int;
                                      _radioVal = 'Cash on Delivery';
                                      print(_radioVal);
                                    });
                                  },
                                ),
                                const Text("Cash on Delivery",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.blackColor,
                                      // fontSize: height * .016,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget stepperWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 16, 19, 14),
      child: Container(
          height: 78,
          width: width,
          alignment: Alignment.center,
          color: ThemeApp.appBackgroundColor,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _titleViews(context),
              ),
            ],
          )),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, icon) {
      var circleColor = (i == 0 || i == 1||i == 2 || _curStep > i + 1)
          ? ThemeApp.tealButtonColor
          : ThemeApp.appColor;
      var lineColor = (i == 0 || i == 1 || i == 2||_curStep > i + 1)
          ? ThemeApp.tealButtonColor
          : ThemeApp.appColor;
      var iconColor = (i == 0 || i == 1 ||  i == 2||_curStep > i + 1)
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
          child: (i == 0 || i == 1 ||  i == 2|| _curStep > i + 1)
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
//
  List<Widget> _titleViews(BuildContext context) {
    var list = <Widget>[];
    titles.asMap().forEach((i, text) {
      list.add(
        (i == 0 || i == 1 || _curStep > i + 1)
            ? SizedBox(
          // width: 61,
          child: TextFieldUtils().dynamicText(
              text,
              context,
              TextStyle(
                  fontFamily: 'Roboto',
                  color: ThemeApp.blackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400)),
        )
            : Container(
          // color: ThemeApp.whiteColor,
          // width: 61,
          child: TextFieldUtils().dynamicText(
              text,
              context,
              TextStyle(
                  fontFamily: 'Roboto',
                  color: ThemeApp.blackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400)),
        ),
      );
    });
    return list;
  }
}

final List<String> titles = [
  'Order review',
  'Delivery detail',
  'Payment',
  'Order placed',
];
int _curStep = 1;

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = '';

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      var nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r'\/'));
      if (nonZeroIndex % 2 == 0 &&
          nonZeroIndex != newValueString.length &&
          !(contains)) {
        valueToReturn += '/';
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(
        TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}
