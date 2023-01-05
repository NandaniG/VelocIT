import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../../../services/models/CreditCardModel.dart';
import '../../../../services/models/JsonModelForApp/HomeModel.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Payment_Activities/payments_Activity.dart';
import 'CardList_manage_Payment_Activity.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  bool validateCardNumber = false;

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
            context, appTitle(context, "Add New Card"), SizedBox()),
      ),
      body: SafeArea(
        child: Container(
          color: ThemeApp.appBackgroundColor,
          width: width,
          child: Padding(padding: const EdgeInsets.all(20), child: mainUI()),
        ),
      ),
    );
  }

  Widget mainUI() {
    return Consumer<ProductProvider>(builder: (context, value, child) {
      return SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: ThemeApp.whiteColor,
          ),
          // height: height * .5,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldUtils().dynamicText(
                    StringUtils.cardHolderName,
                    context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w500)),
                TextFormFieldsWidget(
                    errorText: StringUtils.cardHolderName,
                    textInputType: TextInputType.text,
                    controller: value.cardHolderNameController,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: 'David Wong',
                    onChange: (val) {},
                    validator: (value) {
                      return null;
                    }),
                SizedBox(
                  height: height * .01,
                ),
                TextFieldUtils().dynamicText(
                    StringUtils.cardNumber,
                    context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w500)),
                CardNumberTextFormFieldsWidget(
                    errorText: StringUtils.cardNumber,
                    textInputType: TextInputType.number,
                    controller: value.cardNumberController,
                    maxLength: 19,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: '1234 2345 5678 5553',
                    onFieldSubmit: (v) {
                      FocusScope.of(context)
                          .requestFocus(value.focusNodeExpiryDate);
                    },
                    onChange: (val) {
                      setState(() {
                        if (val.isEmpty &&
                            value.cardNumberController.text.length < 19) {
                          validateCardNumber = true;
                        } else {
                          validateCardNumber = false;
                        }
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty && value.length < 19) {
                        validateCardNumber = true;
                      } else {
                        validateCardNumber = false;
                      }
                      return null;
                    }),
                SizedBox(
                  height: height * .01,
                ),
                TextFieldUtils().dynamicText(
                    StringUtils.expiryDate,
                    context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w500)),
                Container(
                  width: width / 3,
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: TextFormField(
                    maxLength: 5,
                    controller: value.ExpiryDateController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CardExpirationFormatter(),
                    ],
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(value.focusNodeCvv);
                    },
                    focusNode: value.focusNodeExpiryDate,
                    autofocus: false,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'MM / YY',
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(fontFamily: 'Roboto',
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.height * 0.020),
                      errorStyle: TextStyle(fontFamily: 'Roboto',
                          color: ThemeApp.redColor,
                          fontSize: MediaQuery.of(context).size.height * 0.020),
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: ThemeApp.textFieldBorderColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ThemeApp.textFieldBorderColor, width: 1)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ThemeApp.textFieldBorderColor, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: ThemeApp.redColor, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ThemeApp.textFieldBorderColor, width: 1)),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .04,
                ),
                proceedButton("Save", ThemeApp.tealButtonColor, context, false, () {                        FocusManager.instance.primaryFocus?.unfocus();

                value.creditCardList.add(MyCardList(
                    myCardBankName: 'Kotak Mahindra',
                    myCardType: 'Credit Card',
                    myCardFullName: value.cardHolderNameController.text,
                    myCardNumber: value.cardNumberController.text,
                    myCardExpiryDate: value.ExpiryDateController.text,
                  ));

                  print("value.creditCardList__________" +
                      value.creditCardList.length.toString());
                  value.cardHolderNameController.clear();
                  value.cardNumberController.clear();
                  value.ExpiryDateController.clear();

                  var copyOfAddressList =
                      value.creditCardList.map((v) => v).toList();
                  String encodedMap = json.encode(copyOfAddressList);
                  StringConstant.prettyPrintJson(encodedMap.toString());

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CardListManagePayments(),
                    ),
                  );
                  Utils.successToast('Card added successfully!');
                })
              ],
            ),
          ),
        ),
      );
    });
  }
}

class EditCardListScreen extends StatefulWidget {
  MyCardList cardList;

  EditCardListScreen({Key? key, required this.cardList}) : super(key: key);

  @override
  State<EditCardListScreen> createState() => _EditCardListScreenState();
}

class _EditCardListScreenState extends State<EditCardListScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  bool validateCardNumber = false;

  TextEditingController cardHolderNameController = new TextEditingController();
  TextEditingController cardNumberController = new TextEditingController();
  TextEditingController ExpiryDateController = new TextEditingController();

  @override
  void initState() {
    cardHolderNameController = TextEditingController();
    cardNumberController = TextEditingController();
    ExpiryDateController = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    cardHolderNameController.text = widget.cardList.myCardFullName!;
    cardNumberController.text = widget.cardList.myCardNumber!;
    ExpiryDateController.text = widget.cardList.myCardExpiryDate!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    cardHolderNameController.dispose();
    cardNumberController.dispose();
    ExpiryDateController.dispose();
    super.dispose();
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
            context, appTitle(context, "Add New Card"), SizedBox()),
      ),
      body: SafeArea(
        child: Container(
          color: ThemeApp.appBackgroundColor,
          width: width,
          child: Padding(padding: const EdgeInsets.all(20), child: mainUI()),
        ),
      ),
    );
  }

  Widget mainUI() {
    return Consumer<ProductProvider>(builder: (context, value, child) {
      return SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: ThemeApp.whiteColor,
          ),
          // height: height * .5,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldUtils().dynamicText(
                    StringUtils.cardHolderName,
                    context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w500)),
                CharacterTextFormFieldsWidget(
                    errorText: StringUtils.cardHolderName,
                    textInputType: TextInputType.text,
                    controller: cardHolderNameController,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: 'David Wong',
                    onChange: (val) {},
                    validator: (value) {
                      return null;
                    }),
                SizedBox(
                  height: height * .01,
                ),
                TextFieldUtils().dynamicText(
                    StringUtils.cardNumber,
                    context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w500)),
                CardNumberTextFormFieldsWidget(
                    errorText: StringUtils.cardNumber,
                    textInputType: TextInputType.number,
                    controller: cardNumberController,
                    maxLength: 19,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: '1234 2345 5678 5553',
                    onFieldSubmit: (v) {
                      FocusScope.of(context)
                          .requestFocus(value.focusNodeExpiryDate);
                    },
                    onChange: (val) {
                      setState(() {
                        if (val.isEmpty &&
                            cardNumberController.text.length < 19) {
                          validateCardNumber = true;
                        } else {
                          validateCardNumber = false;
                        }
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty && value.length < 19) {
                        validateCardNumber = true;
                      } else {
                        validateCardNumber = false;
                      }
                      return null;
                    }),
                SizedBox(
                  height: height * .01,
                ),
                TextFieldUtils().dynamicText(
                    StringUtils.expiryDate,
                    context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w500)),
                Container(
                  width: width / 3,
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: TextFormField(
                    maxLength: 5,
                    controller: ExpiryDateController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CardExpirationFormatter(),
                    ],
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(value.focusNodeCvv);
                    },
                    focusNode: value.focusNodeExpiryDate,
                    autofocus: false,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'MM / YY',
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(fontFamily: 'Roboto',
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.height * 0.020),
                      errorStyle: TextStyle(fontFamily: 'Roboto',
                          color: ThemeApp.redColor,
                          fontSize: MediaQuery.of(context).size.height * 0.020),
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: ThemeApp.textFieldBorderColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ThemeApp.textFieldBorderColor, width: 1)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ThemeApp.textFieldBorderColor, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: ThemeApp.redColor, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ThemeApp.textFieldBorderColor, width: 1)),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .04,
                ),
                proceedButton("Save", ThemeApp.tealButtonColor, context, false, () {                        FocusManager.instance.primaryFocus?.unfocus();

                widget.cardList.myCardFullName =
                      cardHolderNameController.text.toString();
                  widget.cardList.myCardNumber =
                      cardNumberController.text.toString();
                  widget.cardList.myCardExpiryDate =
                      ExpiryDateController.text.toString();

                  print(cardHolderNameController.text);
                  print(value.cardHolderNameController.text);

                  print("value.creditCardList__________" +
                      value.creditCardList.length.toString());

                  var copyOfAddressList =
                      value.creditCardList.map((v) => v).toList();
                  String encodedMap = json.encode(copyOfAddressList);
                  StringConstant.prettyPrintJson(encodedMap.toString());

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CardListManagePayments(),
                    ),
                  );
                  Utils.successToast('Card update successfully!');
                })
              ],
            ),
          ),
        ),
      );
    });
  }
}
