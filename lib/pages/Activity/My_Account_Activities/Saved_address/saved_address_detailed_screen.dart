import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Order_CheckOut_Activities/AddNewDeliveryAddress.dart';
import 'delete_Address_dialog.dart';

class SavedAddressDetails extends StatefulWidget {
  const SavedAddressDetails({super.key});

  @override
  _SavedAddressDetailsState createState() => _SavedAddressDetailsState();
}

class _SavedAddressDetailsState extends State<SavedAddressDetails> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  List<String> allMessages = [];
  bool isSavedAddress = true;
  TextEditingController _textEditingController = TextEditingController();
  var address =
      'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India - 380021';

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: ThemeApp.backgroundColor,
        body: SafeArea(child: deliveryAddress()));
  }

  Widget deliveryAddress() {
    return Consumer<ProductProvider>(builder: (context, value, child) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: TextFieldUtils().dynamicText(
                    AppLocalizations.of(context).deliveryAddress,
                    context,
                    TextStyle(
                        color: ThemeApp.blackColor,
                        fontSize: height * .03,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                width: width,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: ThemeApp.lightGreyTab,
                      width: 0.5,
                    ),
                    bottom: BorderSide(color: ThemeApp.darkGreyTab, width: 0.5),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if(value.addressList.length<=4){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AddNewDeliveryAddress(isSavedAddress: isSavedAddress),
                      ),
                    );
                  }else{
                    final snackBar = SnackBar(
                      content: Text('You can add only 5 addresse'),
                      clipBehavior: Clip.antiAlias,
                      backgroundColor: ThemeApp.innerTextFieldErrorColor,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  }

                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: ThemeApp.darkGreyColor,
                    ),alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFieldUtils().dynamicText(
                        "+ ${AppLocalizations.of(context).addNewAddress}",
                        context,
                        TextStyle(
                            color: ThemeApp.whiteColor,
                            fontSize: height * .023,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
              SizedBox(
                height: height * .02,
              ),
              value.addressList.length > 0
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: value.addressList.length,
                          itemBuilder: (_, index) {
                            var fullAddress =
                                value.addressList[index].myAddressHouseNoBuildingName! +
                                    ", " +
                                    value.addressList[index].myAddressAreaColony! +
                                    ", " +
                                    value.addressList[index].myAddressCity! +
                                    ",\n" +
                                    value.addressList[index].myAddressState!;
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ThemeApp.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: InkWell(
                                  onLongPress: () {
                                    setState(() {
                                      value.addressList.removeAt(index);
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          // padding: const EdgeInsets.fromLTRB(
                                          //     20, 20, 20, 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  TextFieldUtils().dynamicText(
                                                      value.addressList[index]
                                                          .myAddressFullName!,
                                                      context,
                                                      TextStyle(
                                                          color: ThemeApp
                                                              .blackColor,
                                                          fontSize:
                                                              height * .023,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  SizedBox(
                                                    width: width * .02,
                                                  ),
                                                  Container(
                                                    // height: height * 0.05,
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                      color:
                                                          ThemeApp.darkGreyTab,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 5,
                                                            bottom: 5),
                                                    child: TextFieldUtils()
                                                        .dynamicText(
                                                            value
                                                                .addressList[
                                                                    index]
                                                                .myAddressTypeOfAddress!,
                                                            context,
                                                            TextStyle(
                                                                color: ThemeApp
                                                                    .whiteColor,
                                                                fontSize:
                                                                    height *
                                                                        .02,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return DeleteAddressDialog(
                                                              index: index,
                                                              addressList: value
                                                                  .addressList,
                                                            );
                                                          });
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color:
                                                          ThemeApp.darkGreyTab,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * .03,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditDeliveryAddress(
                                                            model: value
                                                                    .addressList[
                                                                index],
                                                            isSavedAddress:
                                                                isSavedAddress,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.edit_note_rounded,
                                                      color:
                                                          ThemeApp.darkGreyTab,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          fullAddress,
                                          context,
                                          TextStyle(
                                              color: ThemeApp.darkGreyTab,
                                              fontSize: height * .021,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          "${AppLocalizations.of(context).contactNumber + ' : ' + value.addressList[index].myAddressPhoneNumber!}",
                                          context,
                                          TextStyle(
                                              color: ThemeApp.blackColor,
                                              fontSize: height * .021,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        TextFieldUtils().dynamicText(
                                            'Test Name',
                                            context,
                                            TextStyle(
                                                color: ThemeApp.blackColor,
                                                fontSize: height * .023,
                                                fontWeight: FontWeight.w400)),
                                        SizedBox(
                                          width: width * .02,
                                        ),
                                        Container(
                                          // height: height * 0.05,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            color: ThemeApp.darkGreyTab,
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: TextFieldUtils().dynamicText(
                                              'Home',
                                              context,
                                              TextStyle(
                                                  color: ThemeApp.whiteColor,
                                                  fontSize: height * .02,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: ThemeApp.darkGreyTab,
                                        ),
                                        SizedBox(
                                          width: width * .03,
                                        ),
                                        Icon(
                                          Icons.edit_note_rounded,
                                          color: ThemeApp.darkGreyTab,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * .02,
                            ),
                            TextFieldUtils().dynamicText(
                                address,
                                context,
                                TextStyle(
                                    color: ThemeApp.darkGreyTab,
                                    fontSize: height * .021,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(
                              height: height * .02,
                            ),
                            TextFieldUtils().dynamicText(
                                "${AppLocalizations.of(context).contactNumber + ' : '}9857436255",
                                context,
                                TextStyle(
                                    color: ThemeApp.blackColor,
                                    fontSize: height * .021,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ],
      );
    });
  }

  Widget checkingData() {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: allMessages.length,
                itemBuilder: (_, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            allMessages.removeAt(index);
                          });
                        },
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green),
                            child: Text(allMessages[index]),
                          ),
                        ),
                      ),
                    ],
                  );
                })),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  onEditingComplete: () {
                    setState(() {
                      allMessages.add(_textEditingController.text);
                      _textEditingController.text = "";
                    });
                  },
                  controller: _textEditingController,
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      allMessages.add(_textEditingController.text);
                      _textEditingController.text = "";
                    });
                  },
                  icon: Icon(Icons.send))
            ],
          ),
        )
      ],
    );
  }
}
