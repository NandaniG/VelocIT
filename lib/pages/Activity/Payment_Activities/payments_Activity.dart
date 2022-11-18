import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocit/services/providers/Home_Provider.dart';

import '../../../services/providers/Products_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Order_CheckOut_Activities/OrderReviewScreen.dart';
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

  const Payment_Creditcard_debitcardScreen( {Key? key, this.orderReview, }) : super(key: key);

  @override
  State<Payment_Creditcard_debitcardScreen> createState() => _Payment_Creditcard_debitcardScreenState();
}

class _Payment_Creditcard_debitcardScreenState extends State<Payment_Creditcard_debitcardScreen> {

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

    return Scaffold(
      backgroundColor: ThemeApp.backgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(
            context, appTitle(context, "Order Checkout"),'/orderReviewSubActivity', SizedBox()),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ThemeApp.backgroundColor,
        elevation: 0,
        child: Consumer<HomeProvider>(builder: (context, value, child) {
          return Container(
            height: height * .09,
            width: width,
            decoration: BoxDecoration(
              color: ThemeApp.whiteColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15)),
            ),
            padding: const EdgeInsets.only(left: 15, right: 15),
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
                              color: ThemeApp.blackColor,
                              fontSize: height * .025,
                              fontWeight: FontWeight.bold)),
                      TextFieldUtils().dynamicText(
                          'View Price Details',
                          context,
                          TextStyle(
                            color: ThemeApp.darkGreyTab,
                            fontSize: height * .018,
                          ))
                    ]),
                InkWell(
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => OrderPlaceActivity(productList: widget.productList),
                      //   ),
                      // );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderPlaceActivity(orderReview:  value.orderCheckOutDetails),
                        ),
                      );
                    },
                    child: Container(
                      height: height * 0.05,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: ThemeApp.blackColor,
                      ),
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: TextFieldUtils().dynamicText(
                          'Place Order',
                          context,
                          TextStyle(
                              color: ThemeApp.whiteColor,
                              fontSize: height * .022,
                              fontWeight: FontWeight.w500)),
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
                              AppLocalizations.of(context).allOtherOptions,
                              context,
                              TextStyle(
                                  color: ThemeApp.blackColor,
                                  fontSize: height * .025,
                                  fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _radioSelected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _radioSelected = value as int;
                                    _radioVal = 'UPI';
                                    print(_radioVal);
                                  });
                                },
                              ),
                              const Text("UPI"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: _radioSelected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _radioSelected = value as int;
                                    _radioVal = 'Wallets';
                                    print(_radioVal);
                                  });
                                },
                              ),
                              const Text("Wallets"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: _radioSelected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _radioSelected = value as int;
                                    _radioVal = 'Credit / Debit / ATM Card';
                                    print(_radioVal);
                                  });
                                },
                              ),
                              const Text("Credit / Debit / ATM Card"),
                            ],
                          ),
                          // _radioSelected==3? SizedBox(
                          //   height: MediaQuery.of(context).size.height * .02,
                          // ):SizedBox(height: 0,),
                          _radioSelected == 3
                              ? TextFieldUtils().dynamicText(
                                  AppLocalizations.of(context).cardNumber,
                                  context,
                                  TextStyle(
                                      color: ThemeApp.blackColor,
                                      fontSize: height * .02,
                                      fontWeight: FontWeight.w500))
                              : SizedBox(
                                  height: 0,
                                ),
                          _radioSelected == 3
                              ? CardNumberTextFormFieldsWidget(
                                  errorText:
                                      AppLocalizations.of(context).emailError,
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
                                    });},
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
                                          AppLocalizations.of(context)
                                              .expiryDate,
                                          context,
                                          TextStyle(
                                              color: ThemeApp.blackColor,
                                              fontSize: height * .02,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    Expanded(
                                      child: TextFieldUtils().dynamicText(
                                          AppLocalizations.of(context).cvv,
                                          context,
                                          TextStyle(
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
                                    //             AppLocalizations.of(context)
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
                                                color: Colors.grey,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.020),
                                            errorStyle: TextStyle(
                                                color: ThemeApp
                                                    .innerTextFieldErrorColor,
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
                                                    color: ThemeApp
                                                        .innerTextFieldErrorColor,
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
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _radioSelected = value as int;
                                    _radioVal = 'Cash on Delivery';
                                    print(_radioVal);
                                  });
                                },
                              ),
                              const Text("Cash on Delivery"),
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
    );
  }

  Widget stepperWidget() {
    return Container(
        height: height * .1,
        width: width,
        alignment: Alignment.center,
        color: ThemeApp.whiteColor,
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
          ? ThemeApp.darkGreyTab
          : ThemeApp.lightGreyTab;
      var lineColor =
          _curStep > i + 1 ? ThemeApp.darkGreyTab : ThemeApp.lightGreyTab;
      var iconColor = (i == 0 || i == 1 || _curStep > i + 1)
          ? ThemeApp.darkGreyTab
          : ThemeApp.lightGreyTab;

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
                    color: ThemeApp.darkGreyTab,
                    fontSize: height * .018,
                    fontWeight: FontWeight.bold))
            : TextFieldUtils().dynamicText(
                text,
                context,
                TextStyle(
                    color: ThemeApp.darkGreyTab,
                    fontSize: height * .018,
                    fontWeight: FontWeight.w400)),
      );
    });
    return list;
  }
}

final List<String> titles = [
  'Order Placed',
  'Payment',
  'Order Completed',
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
