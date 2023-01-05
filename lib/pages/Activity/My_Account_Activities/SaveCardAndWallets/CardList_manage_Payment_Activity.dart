import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'AddNewCard.dart';
import 'delete_payment_method_dialog.dart';

class CardListManagePayments extends StatefulWidget {
  const CardListManagePayments({Key? key}) : super(key: key);

  @override
  State<CardListManagePayments> createState() => _CardListManagePaymentsState();
}

class _CardListManagePaymentsState extends State<CardListManagePayments> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

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
            context, appTitle(context, "Manage Payment Methods"), SizedBox()),
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
      return Stack(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                value.creditCardList.length > 0
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: value.creditCardList.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                    // height: height * 0.12,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      color: ThemeApp.whiteColor,
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextFieldUtils().dynamicText(
                                                    value.creditCardList[index]
                                                        .myCardFullName!,
                                                    context,
                                                    TextStyle(fontFamily: 'Roboto',
                                                      color:
                                                          ThemeApp.blackColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: height * .022,
                                                    )),
                                                SizedBox(
                                                  height: height * .01,
                                                ),
                                                TextFieldUtils().dynamicText(
                                                    value.creditCardList[index]
                                                        .myCardType!,
                                                    context,
                                                    TextStyle(fontFamily: 'Roboto',
                                                      color:
                                                          ThemeApp.darkGreyTab,
                                                      fontSize: height * .018,
                                                    )),
                                                SizedBox(
                                                  height: height * .01,
                                                ),
                                                TextFieldUtils().dynamicText(
                                                    value.creditCardList[index]
                                                        .myCardNumber!,
                                                    context,
                                                    TextStyle(fontFamily: 'Roboto',
                                                      color:
                                                          ThemeApp.darkGreyTab,
                                                      fontSize: height * .018,
                                                    )),
                                              ],
                                            ),
                                            Expanded(
                                                flex: 3,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 15,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                          width: 40.0,
                                                          height: 40.0,
                                                          decoration: new BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              image: new DecorationImage(
                                                                  fit: BoxFit.fill,
                                                                  image: new AssetImage(
                                                                    'assets/images/laptopImage.jpg',
                                                                  )))),
                                                      SizedBox(
                                                        height: height * .02,
                                                      ),
                                                      TextFieldUtils()
                                                          .dynamicText(
                                                              'Expires Feb 2027',
                                                              context,
                                                              TextStyle(fontFamily: 'Roboto',
                                                                color: ThemeApp
                                                                    .darkGreyTab,
                                                                fontSize:
                                                                    height *
                                                                        .018,
                                                              )),
                                                    ],
                                                  ),
                                                )),
                                            SizedBox(
                                              height: height * .01,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        Container(
                                          width: width,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5,
                                              ),
                                              bottom: BorderSide(
                                                  color: ThemeApp.darkGreyTab,
                                                  width: 0.5),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextFieldUtils().dynamicText(
                                                'Primary method payment',
                                                context,
                                                TextStyle(fontFamily: 'Roboto',
                                                    color: ThemeApp.darkGreyTab,
                                                    fontSize: height * .02,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      // value.creditCardList
                                                      //     .removeAt(index);
                                                    });
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return DeletePaymentMethodDialog(
                                                            index: index,
                                                            cardList: value
                                                                .creditCardList,
                                                          );
                                                        });
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: ThemeApp.darkGreyTab,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * .02,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditCardListScreen(
                                                                cardList: value
                                                                        .creditCardList[
                                                                    index]),
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: ThemeApp.darkGreyTab,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                              );
                            }),
                      )
                    : Container(
                        // height: height * 0.12,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: ThemeApp.whiteColor,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFieldUtils().dynamicText(
                                        'Kotak Mahindra',
                                        context,
                                        TextStyle(fontFamily: 'Roboto',
                                          color: ThemeApp.blackColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * .022,
                                        )),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        'Credit Card',
                                        context,
                                        TextStyle(fontFamily: 'Roboto',
                                          color: ThemeApp.darkGreyTab,
                                          fontSize: height * .018,
                                        )),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        '**** **** **** 2531',
                                        context,
                                        TextStyle(fontFamily: 'Roboto',
                                          color: ThemeApp.darkGreyTab,
                                          fontSize: height * .018,
                                        )),
                                  ],
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      // padding: const EdgeInsets.only(
                                      //   right: 15,
                                      // ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: new AssetImage(
                                                        'assets/images/laptopImage.jpg',
                                                      )))),
                                          SizedBox(
                                            height: height * .02,
                                          ),
                                          TextFieldUtils().dynamicText(
                                              'Expires Feb 2027',
                                              context,
                                              TextStyle(fontFamily: 'Roboto',
                                                color: ThemeApp.darkGreyTab,
                                                fontSize: height * .018,
                                              )),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  height: height * .01,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            Container(
                              width: width,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                  bottom: BorderSide(
                                      color: ThemeApp.darkGreyTab, width: 0.5),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFieldUtils().dynamicText(
                                    'Primary method payment',
                                    context,
                                    TextStyle(fontFamily: 'Roboto',
                                        color: ThemeApp.darkGreyTab,
                                        fontSize: height * .02,
                                        fontWeight: FontWeight.w400)),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          // value.creditCardList.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: ThemeApp.darkGreyTab,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * .02,
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.edit,
                                        color: ThemeApp.darkGreyTab,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        )),
                SizedBox(
                  height: height * .02,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: ThemeApp.whiteColor,
                  ),
                  child: InkWell(
                    onTap: () {
                      value.cardHolderNameController.clear();
                      value.cardNumberController.clear();
                      value.ExpiryDateController.clear();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddNewCardScreen(),
                        ),
                      );
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      color: ThemeApp.textFieldBorderColor,
                      dashPattern: [5, 5],
                      strokeWidth: 1.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Row(
                          children: [
                            Icon(Icons.add_circle_outlined,
                                size: 40, color: ThemeApp.darkGreyTab),
                            SizedBox(
                              width: width * .02,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: TextFieldUtils().dynamicText(
                                  StringUtils.addNewCard,
                                  context,
                                  TextStyle(fontFamily: 'Roboto',
                                      color: ThemeApp.blackColor,
                                      fontSize: height * .023,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Container(
                  // height: height * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: ThemeApp.whiteColor,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFieldUtils().dynamicText(
                            StringUtils.upi,
                            context,
                            TextStyle(fontFamily: 'Roboto',
                                color: ThemeApp.blackColor,
                                fontSize: height * .02,
                                fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  border:
                                      Border.all(color: ThemeApp.darkGreyTab),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new AssetImage(
                                                  'assets/icons/payment_google_pay_circle.png',
                                                )))),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        StringUtils.googlePay,
                                        context,
                                        TextStyle(fontFamily: 'Roboto',
                                            color: ThemeApp.blackColor,
                                            fontSize: height * .018,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: width * .03),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  border:
                                      Border.all(color: ThemeApp.darkGreyTab),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new AssetImage(
                                                  'assets/icons/paytm_icon-icons.com_62778.png',
                                                )))),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        StringUtils.payTm,
                                        context,
                                        TextStyle(fontFamily: 'Roboto',
                                            color: ThemeApp.blackColor,
                                            fontSize: height * .018,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: width * .03),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  border:
                                      Border.all(color: ThemeApp.darkGreyTab),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new AssetImage(
                                                  'assets/icons/payment_phonepe.png',
                                                )))),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        StringUtils.phonePay,
                                        context,
                                        TextStyle(fontFamily: 'Roboto',
                                            color: ThemeApp.blackColor,
                                            fontSize: height * .018,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              ]),
        ],
      );
    });
  }

/*  Widget mainUI() {
    return Consumer<ProductProvider>(builder: (context, value, child) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: height * 0.12,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                color: ThemeApp.whiteColor,
              ),
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      value.creditCardList.length > 0
                          ? ListView.builder(
                              itemCount: value.creditCardList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (_, index) {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    TextFieldUtils().dynamicText(
                                        value
                                            .creditCardList[index].cardName,
                                        context,
                                        TextStyle(fontFamily: 'Roboto',
                                          color: ThemeApp.blackColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * .022,
                                        )),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        value
                                            .creditCardList[index].cardType,
                                        context,
                                        TextStyle(fontFamily: 'Roboto',
                                          color: ThemeApp.darkGreyTab,
                                          fontSize: height * .018,
                                        )),
                                    SizedBox(
                                      height: height * .01,
                                    ),
                                    TextFieldUtils().dynamicText(
                                        value.creditCardList[index]
                                            .cardNumber,
                                        context,
                                        TextStyle(fontFamily: 'Roboto',
                                          color: ThemeApp.darkGreyTab,
                                          fontSize: height * .018,
                                        )),
                                  ],
                                );
                              })
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFieldUtils().dynamicText(
                                    'Kotak Mahindar Bank',
                                    context,
                                    TextStyle(fontFamily: 'Roboto',
                                      color: ThemeApp.blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * .022,
                                    )),
                                SizedBox(
                                  height: height * .01,
                                ),
                                TextFieldUtils().dynamicText(
                                    'Credit Card',
                                    context,
                                    TextStyle(fontFamily: 'Roboto',
                                      color: ThemeApp.darkGreyTab,
                                      fontSize: height * .018,
                                    )),
                                SizedBox(
                                  height: height * .01,
                                ),
                                TextFieldUtils().dynamicText(
                                    '**** **** **** 6782',
                                    context,
                                    TextStyle(fontFamily: 'Roboto',
                                      color: ThemeApp.blackColor,
                                      fontSize: height * .025,
                                    )),
                              ],
                            ),
                      Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.only(
                              right: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              'assets/images/laptopImage.jpg',
                                            )))),
                                TextFieldUtils().dynamicText(
                                    'Expires Feb 2027',
                                    context,
                                    TextStyle(fontFamily: 'Roboto',
                                      color: ThemeApp.darkGreyTab,
                                      fontSize: height * .018,
                                    )),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: height * .01,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Container(
                    width: width,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                        bottom:
                            BorderSide(color: ThemeApp.darkGreyTab, width: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFieldUtils().dynamicText(
                          'Primary method payment',
                          context,
                          TextStyle(fontFamily: 'Roboto',
                              color: ThemeApp.darkGreyTab,
                              fontSize: height * .02,
                              fontWeight: FontWeight.w400)),
                      Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: ThemeApp.darkGreyTab,
                          ),
                          SizedBox(
                            width: width * .02,
                          ),
                          Icon(
                            Icons.edit,
                            color: ThemeApp.darkGreyTab,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            Container(
              // height: height * 0.12,
              alignment: Alignment.center,
              // padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                color: ThemeApp.whiteColor,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddNewCardScreen(),
                    ),
                  );
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  color: ThemeApp.textFieldBorderColor,
                  dashPattern: [5, 5],
                  strokeWidth: 1.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outlined,
                            size: 40, color: ThemeApp.darkGreyTab),
                        SizedBox(
                          width: width * .02,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: TextFieldUtils().dynamicText(
                              StringUtils.addNewAddress,
                              context,
                              TextStyle(fontFamily: 'Roboto',
                                  color: ThemeApp.blackColor,
                                  fontSize: height * .023,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]);
    });
  }*/
}
