import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Core/Model/CartModels/AddressListModel.dart';
import '../../../../Core/Model/CartModels/SendCartForPaymentModel.dart';
import '../../../../Core/ViewModel/cart_view_model.dart';
import '../../../../Core/data/responses/status.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../Order_CheckOut_Activities/AddNewDeliveryAddress.dart';
import 'delete_Address_dialog.dart';

class SavedAddressDetails extends StatefulWidget {
  // final CartForPaymentPayload cartForPaymentPayload;

  SavedAddressDetails({Key? key, /*required this.cartForPaymentPayload*/})
      : super(key: key);

  @override
  _SavedAddressDetailsState createState() => _SavedAddressDetailsState();
}

class _SavedAddressDetailsState extends State<SavedAddressDetails> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  List<String> allAddress = [];
  bool isSavedAddress = true;
  TextEditingController _textEditingController = TextEditingController();
  var address =
      'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India - 380021';

  @override
  void initState() {
    // TODO: implement initState
    cartforPayments();

    super.initState();
  }

  cartforPayments() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {

      StringConstant.UserLoginId =
          (prefs.getString('isUserId')) ?? '';
      StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
      cartViewModel.sendAddressWithGet(
          context, StringConstant.UserLoginId.toString());
  });

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .09),
          child: appBar_backWidget(
              context, appTitle(context, "Address"), SizedBox()),
        ),
        body: SafeArea(child: deliveryAddress()));
  }

  CartViewModel cartViewModel = CartViewModel();

/*  Widget deliveryAddress() {
    return Consumer<ProductProvider>(builder: (context, value, child) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: TextFieldUtils().dynamicText(
                    StringUtils.deliveryAddress,
                    context,
                    TextStyle(fontFamily: 'Roboto',
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            AddNewDeliveryAddress(isSavedAddress: isSavedAddress,cartForPaymentPayload: widget.cartForPaymentPayload),
                      ),
                    );
                  }else{
                    Utils.errorToast('You can add only 5 addresse');


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
                        "+ ${StringUtils.addNewAddress}",
                        context,
                        TextStyle(fontFamily: 'Roboto',
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
                                                      TextStyle(fontFamily: 'Roboto',
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
                                                            TextStyle(fontFamily: 'Roboto',
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
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditDeliveryAddress(
                                                            model: value
                                                                    .addressList[
                                                                index],
                                                            isSavedAddress:
                                                                isSavedAddress, cartForPaymentPayload: null,
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
                                          TextStyle(fontFamily: 'Roboto',
                                              color: ThemeApp.darkGreyTab,
                                              fontSize: height * .021,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          "${StringUtils.contactNumber + ' : ' + value.addressList[index].myAddressPhoneNumber!}",
                                          context,
                                          TextStyle(fontFamily: 'Roboto',
                                              color: ThemeApp.blackColor,
                                              fontSize: height * .021,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }))
                  :   Center(
                    child: TextFieldUtils().dynamicText(
                    'No data found',
                    context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.darkGreyTab,
                        fontSize: height * .03,
                        fontWeight: FontWeight.w400)),
                  ),
            ],
          ),
        ],
      );
    });
  }*/
  int _value2 = 0;

  Widget deliveryAddress() {
    return ChangeNotifierProvider<CartViewModel>.value(
        value: cartViewModel,
        child: Consumer<CartViewModel>(builder: (context, cartProvider, child) {
          switch (cartProvider.getAddress.status) {
            case Status.LOADING:
              print("Api load");

              return TextFieldUtils().circularBar(context);
            case Status.ERROR:
              print("Api error");

              return Text(cartProvider.getAddress.message.toString());
            case Status.COMPLETED:
              print("Api calll");
              List<AddressContent>? addressList =
                  cartProvider.getAddress.data!.payload!.content;

              print("addressList" + addressList!.length.toString());
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  // decoration: const BoxDecoration(
                  //     color: ThemeApp.whiteColor,
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddNewDeliveryAddress(
                                      isSavedAddress: isSavedAddress,
                                     /* cartForPaymentPayload:
                                          widget.cartForPaymentPayload!*/),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10.0, 7, 15, 7),
                              decoration: BoxDecoration(
                                color: ThemeApp.appColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: ThemeApp.whiteColor,
                                  ),
                                  Text(StringUtils.addNewAddress,
                                      style: TextStyle(fontFamily: 'Roboto',
                                          color: ThemeApp.whiteColor,
                                          // fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      addressList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount: addressList.length,
                                  itemBuilder: (_, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {});
                                        StringConstant.selectedFullName =
                                            addressList[index].name!;
                                        StringConstant.selectedFullAddress =
                                            "${addressList[index].addressLine1!}, ${addressList[index].addressLine2}, ${addressList[index].stateName},\n ${addressList[index].cityName}, ${addressList[index].pincode}";
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: ThemeApp.appColor,
                                              ),
                                              color: ThemeApp.whiteColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 20, 20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Container(
                                                    // padding: const EdgeInsets
                                                    //         .fromLTRB(
                                                    //     20, 0, 20, 0),

                                                    // padding: EdgeInsets.symmetric(
                                                    //     horizontal: 10, vertical: 7),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        TextFieldUtils().dynamicText(
                                                            addressList[index]
                                                                .name!,
                                                            context,
                                                            TextStyle(fontFamily: 'Roboto',
                                                                color: ThemeApp
                                                                    .blackColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        Container(
                                                          // height: height * 0.05,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  100),
                                                            ),
                                                            border: Border.all(
                                                              color: ThemeApp
                                                                  .packedButtonColor,
                                                            ),
                                                            color: ThemeApp
                                                                .whiteColor,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  12, 4, 12, 4),
                                                          child: TextFieldUtils().dynamicText(
                                                              addressList[index]
                                                                  .addressType!,
                                                              context,
                                                              TextStyle(fontFamily: 'Roboto',
                                                                  color: ThemeApp
                                                                      .packedButtonColor,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                TextFieldUtils().dynamicText(
                                                    "${addressList[index].addressLine1!}, ${addressList[index].addressLine2}, ${addressList[index].stateName},\n ${addressList[index].cityName}, ${addressList[index].pincode}",
                                                    context,
                                                    TextStyle(fontFamily: 'Roboto',
                                                        color:
                                                            ThemeApp.blackColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.5,
                                                        letterSpacing: -0.25)),SizedBox(height: 9,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/appImages/callIcon.svg',
                                                      color: ThemeApp.appColor,
                                                      semanticsLabel:
                                                          'Acme Logo',
                                                      theme: SvgTheme(
                                                        currentColor:
                                                            ThemeApp.appColor,
                                                      ),
                                                      height: 12,width: 12,
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    TextFieldUtils().dynamicText(
                                                        "${addressList[index].contactNumber}",
                                                        context,
                                                        TextStyle(fontFamily: 'Roboto',
                                                            color: ThemeApp
                                                                .blackColor,
                                                            fontSize:12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                        letterSpacing: 0.2 )),
                                                  ],
                                                ),
                                                SizedBox(height: 9),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          addressList
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/appImages/deleteIcon.svg',
                                                        color: ThemeApp
                                                            .lightFontColor,
                                                        semanticsLabel:
                                                            'Acme Logo',
                                                        theme: SvgTheme(
                                                          currentColor:
                                                              ThemeApp.appColor,
                                                        ),
                                                        height: height * .03,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * .03,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        // Navigator.of(context).push(
                                                        //   MaterialPageRoute(
                                                        //     builder: (context) =>
                                                        //         EditDeliveryAddress(
                                                        //           cartForPaymentPayload: widget.cartForPaymentPayload,
                                                        //           model: addressList,isSavedAddress: ture,
                                                        //         ),
                                                        //   ),
                                                        // );
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/appImages/editIcon.svg',
                                                        color:
                                                            ThemeApp.appColor,
                                                        semanticsLabel:
                                                            'Acme Logo',
                                                        theme: SvgTheme(
                                                          currentColor:
                                                              ThemeApp.appColor,
                                                        ),
                                                        height: height * .03,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }))
                          : TextFieldUtils().dynamicText(
                              'No Address found',
                              context,
                              TextStyle(fontFamily: 'Roboto',
                                  color: ThemeApp.whiteColor,
                                  fontSize: height * .02,
                                  fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              );
          }
          return Container(
            height: height * .8,
            alignment: Alignment.center,
            child: TextFieldUtils().dynamicText(
                'No Match found!',
                context,
                TextStyle(fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .03,
                    fontWeight: FontWeight.bold)),
          );
        }));

/*
    return Consumer<ProductProvider>(builder: (context, value, child) {
    return Stack(
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Padding(
    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
    child: TextFieldUtils().dynamicText(
    StringUtils.deliveryAddress,
    context,
    TextStyle(fontFamily: 'Roboto',
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
    Navigator.of(context).push(
    MaterialPageRoute(
    builder: (context) => AddNewDeliveryAddress(
    isSavedAddress: false,
    ),
    ),
    );
    },
    child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
    child: DottedBorder(
    borderType: BorderType.RRect,
    radius: Radius.circular(10),
    padding: EdgeInsets.all(12),
    color: ThemeApp.textFieldBorderColor,
    dashPattern: [5, 5],
    strokeWidth: 1,
    child: ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    child: Container(
    width: width,
    alignment: Alignment.center,
    child: TextFieldUtils().dynamicText(
    StringUtils.addNewAddress,
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.blackColor,
    fontSize: height * .023,
    fontWeight: FontWeight.w400)),
    ),
    ),
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
    return InkWell(
    onLongPress: () {
    setState(() {
    value.addressList.removeAt(index);
    });
    },
    onTap: () {
    setState(() {});
    StringConstant.selectedFullAddress =
    "${value.addressList[index].myAddressHouseNoBuildingName!}, ${value.addressList[index].myAddressAreaColony}, ${value.addressList[index].myAddressCity},\n ${value.addressList[index].myAddressState}";
    },
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Center(
    child: Container(
    padding: const EdgeInsets.fromLTRB(
    20, 0, 20, 0),

    // padding: EdgeInsets.symmetric(
    //     horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
    children: [
    Radio(
    value: index,
    groupValue: _value2,
    onChanged: (int? value) {
    setState(() {
    _value2 = value!;
    _selectedIndex = index;
    print(
    "Radio index is  $value");
    Prefs.instance.setToken(
    StringConstant
        .selectedFullAddressPref,
    StringConstant
        .selectedFullAddress);

    print("selected Address " +
    StringConstant
        .selectedFullAddress);
    });
    }),
    Row(
    children: [
    TextFieldUtils().dynamicText(
    value.addressList[index]
        .myAddressFullName!,
    context,
    TextStyle(fontFamily: 'Roboto',
    color:
    ThemeApp.blackColor,
    fontSize: height * .023,
    fontWeight:
    FontWeight.w400)),
    SizedBox(
    width: width * .02,
    ),
    Container(
    // height: height * 0.05,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
    borderRadius:
    BorderRadius.all(
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
    value.addressList[index]
        .myAddressTypeOfAddress!,
    context,
    TextStyle(fontFamily: 'Roboto',
    color:
    ThemeApp.whiteColor,
    fontSize: height * .02,
    fontWeight:
    FontWeight.w400)),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(
    left: 70, right: 20),
    child: TextFieldUtils().dynamicText(
    "${value.addressList[index].myAddressHouseNoBuildingName!}, ${value.addressList[index].myAddressAreaColony}, ${value.addressList[index].myAddressCity},\n ${value.addressList[index].myAddressState}",
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.darkGreyTab,
    fontSize: height * .021,
    fontWeight: FontWeight.w400)),
    ),
    Padding(
    padding: const EdgeInsets.only(
    left: 70, right: 20, top: 10),
    child: TextFieldUtils().dynamicText(
    "${'${StringUtils.contactNumber} : ' + StringConstant.selectedMobile}",
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.blackColor,
    fontSize: height * .021,
    fontWeight: FontWeight.w400)),
    ),
    ],
    ),
    );
    }))
        : Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Center(
    child: Container(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

    // padding: EdgeInsets.symmetric(
    //     horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
    children: [
    Radio(
    value: 1,
    groupValue: _value2,
    onChanged: (int? value) {
    setState(() {
    _value2 = value!;
    print("Radio index is  $value");
    });
    }),
    Row(
    children: [
    TextFieldUtils().dynamicText(
    StringConstant.selectedFullName,
    context,
    TextStyle(fontFamily: 'Roboto',
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
    StringConstant.selectedTypeOfAddress,
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.whiteColor,
    fontSize: height * .02,
    fontWeight: FontWeight.w400)),
    ),
    ],
    ),
    ],
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(left: 70, right: 20),
    child: TextFieldUtils().dynamicText(
    'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India - 380021',
    context,
    TextStyle(fontFamily: 'Roboto',
    overflow: TextOverflow.ellipsis,
    color: ThemeApp.darkGreyTab,
    fontSize: height * .021,
    fontWeight: FontWeight.w400)),
    ),
    Padding(
    padding: const EdgeInsets.only(
    left: 70, right: 20, top: 10),
    child: TextFieldUtils().dynamicText(
    "${'${StringUtils.contactNumber} : ${StringConstant.selectedMobile}'}",
    context,
    TextStyle(fontFamily: 'Roboto',
    color: ThemeApp.blackColor,
    fontSize: height * .021,
    fontWeight: FontWeight.w400)),
    ),
    ],
    ),
    Container(
    alignment: FractionalOffset.bottomCenter,
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
    child: proceedButton(StringUtils.deliverHere,
    ThemeApp.blackColor, context, false, () {
    setState(() {
    StringConstant.selectedFullAddress =
    "${value.addressList[_value2].myAddressHouseNoBuildingName!}, ${value.addressList[_value2].myAddressAreaColony}, ${value.addressList[_value2].myAddressCity},\n ${value.addressList[_value2].myAddressState}";
    Prefs.instance.setToken(
    StringConstant.selectedFullAddressPref,
    StringConstant.selectedFullAddress);

    StringConstant.selectedFullName =
    value.addressList[_value2].myAddressFullName!;
    Prefs.instance.setToken(StringConstant.selectedFullNamePref,
    StringConstant.selectedFullName);

    StringConstant.selectedMobile =
    value.addressList[_value2].myAddressPhoneNumber!;
    Prefs.instance.setToken(StringConstant.selectedMobilePref,
    StringConstant.selectedMobile);

    StringConstant.selectedTypeOfAddress =
    value.addressList[_value2].myAddressTypeOfAddress!;
    Prefs.instance.setToken(
    StringConstant.selectedTypeOfAddressPref,
    StringConstant.selectedTypeOfAddress);
    });
    */
/*  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => OrderReviewSubActivity(
                       cartPayLoad: null,),
                    ),
                  );*/ /*

    }),
    )
    ],
    ),
    ],
    );
    });
*/
  }

  Widget checkingData() {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: allAddress.length,
                itemBuilder: (_, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            allAddress.removeAt(index);
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
                            child: Text(allAddress[index]),
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
                      allAddress.add(_textEditingController.text);
                      _textEditingController.text = "";
                    });
                  },
                  controller: _textEditingController,
                ),
              ),
              IconButton(
                  onPressed: () {                        FocusManager.instance.primaryFocus?.unfocus();

                  setState(() {
                      allAddress.add(_textEditingController.text);
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
