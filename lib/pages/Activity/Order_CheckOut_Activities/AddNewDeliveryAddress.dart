import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/Saved_address/saved_address_detailed_screen.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../../services/models/AddressListModel.dart';
import '../../../services/models/JsonModelForApp/HomeModel.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../utils/utils.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/okPopUp.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'OrderReviewScreen.dart';

class AddNewDeliveryAddress extends StatefulWidget {
  final bool isSavedAddress;

  const AddNewDeliveryAddress({Key? key, required this.isSavedAddress})
      : super(key: key);

  @override
  State<AddNewDeliveryAddress> createState() => _AddNewDeliveryAddressState();
}

class _AddNewDeliveryAddressState extends State<AddNewDeliveryAddress> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

  // TextEditingController fullNameController = TextEditingController();
  // TextEditingController mobileController = TextEditingController();
  // TextEditingController houseBuildingController = TextEditingController();
  // TextEditingController areaColonyController = TextEditingController();
  // TextEditingController stateController = TextEditingController();
  // TextEditingController cityController = TextEditingController();

  bool _validateFullName = false;
  bool _validateMobile = false;
  bool _validateEmail = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isHome = false;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .09),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: ThemeApp.whiteColor,
            child: AppBar(
              centerTitle: false,
              elevation: 0,
              backgroundColor: ThemeApp.appBackgroundColor,
              flexibleSpace: Container(
                height: height * .11,
                width: width,
                decoration: const BoxDecoration(
                  color: ThemeApp.whiteColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              ),
              leading: Transform.scale(
                  scale: 0,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                      })),

              leadingWidth: 10,
              title: Container(
                  alignment: Alignment.centerLeft,
                  child: TextFieldUtils().textFieldHeightThree(
                      "Add New Delivery Address", context)),
              // Row
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: width,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: ThemeApp.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(20),
              // padding: const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 40),
              child: mainUi(),
            ),
          ),
        ),
      ),
    );
  }

  Widget mainUi() {
    return Form(
      key: _formKey,
      child: Consumer<ProductProvider>(builder: (context, value, child) {
        return ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Full Name
            TextFieldUtils().dynamicText(
                StringUtils.fullName,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            CharacterTextFormFieldsWidget(
                errorText: StringUtils.enterFullName,
                textInputType: TextInputType.name,
                controller: value.fullNameController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'David Wong',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            //Mobile Number
            TextFieldUtils().dynamicText(
                StringUtils.mobileNumber,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            MobileNumberTextFormField(
                controller: value.mobileController, enable: true),
            SizedBox(
              height: height * .02,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFieldUtils().dynamicText(
                      StringUtils.addressDetails,
                      context,
                      TextStyle(
                          color: ThemeApp.blackColor,
                          fontSize: height * .025,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => AddNewCardScreen(),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: height * 0.05,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: ThemeApp.blackColor,
                        ),
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextFieldUtils().dynamicText(
                            StringUtils.useMyLocation,
                            context,
                            TextStyle(
                                color: ThemeApp.whiteColor,
                                fontSize: height * .021,
                                fontWeight: FontWeight.w500)),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: height * .02,
            ),
            TextFieldUtils().dynamicText(
                StringUtils.houseBuildingNo,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            TextFormFieldsWidget(
                errorText: StringUtils.houseBuildingNo,
                textInputType: TextInputType.text,
                controller: value.houseBuildingController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: '305, Lokseva Apartments',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            TextFieldUtils().dynamicText(
                StringUtils.areaColonyName,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            TextFormFieldsWidget(
                errorText: StringUtils.areaColonyName,
                textInputType: TextInputType.text,
                controller: value.areaColonyController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'Telecom Housing Society',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            TextFieldUtils().dynamicText(
                StringUtils.state,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            TextFormFieldsWidget(
                errorText: StringUtils.state,
                textInputType: TextInputType.text,
                controller: value.stateController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'State',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            TextFieldUtils().dynamicText(
                StringUtils.city,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            TextFormFieldsWidget(
                errorText: StringUtils.city,
                textInputType: TextInputType.text,
                controller: value.cityController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'Pune',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            SizedBox(
              height: height * .02,
            ),
            TextFieldUtils().dynamicText(
                StringUtils.typeOfAddress,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .025,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: height * .02,
            ),
            typeOfAddress(),
            SizedBox(
              height: height * .02,
            ),
            proceedButton(StringUtils.addDeliveryAddress,
                ThemeApp.blackColor, context, false, () {
              setState(() {
                if (_formKey.currentState!.validate() &&
                    value.fullNameController.text.isNotEmpty &&
                    value.mobileController.text.isNotEmpty &&
                    value.houseBuildingController.text.isNotEmpty &&
                    value.areaColonyController.text.isNotEmpty &&
                    value.stateController.text.isNotEmpty &&
                    value.cityController.text.isNotEmpty) {
                  if (widget.isSavedAddress == true) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SavedAddressDetails(),
                      ),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => OrderReviewSubActivity(
                          value: value,
                        ),
                      ),
                    );
                  } StringConstant.selectedFullAddress =
                  "${value.houseBuildingController.text}, ${value.areaColonyController.text}, ${value.cityController.text},\n ${value.stateController.text}";
                  Prefs.instance.setToken(StringConstant.selectedFullAddressPref,
                      StringConstant.selectedFullAddress);

                  StringConstant.selectedFullName = value.fullNameController.text;
                  Prefs.instance.setToken(StringConstant.selectedFullNamePref,
                      StringConstant.selectedFullName);

                  StringConstant.selectedMobile = value.mobileController.text;
                  Prefs.instance.setToken(StringConstant.selectedMobilePref,
                      StringConstant.selectedMobile);

                  StringConstant.selectedTypeOfAddress = selectedAddressIs;
                  Prefs.instance.setToken(
                      StringConstant.selectedTypeOfAddressPref,
                      StringConstant.selectedTypeOfAddress);
                  value.addAddress(
                      value.fullNameController.text,
                      value.mobileController.text,
                      value.houseBuildingController.text,
                      value.areaColonyController.text,
                      value.stateController.text,
                      value.cityController.text,
                      selectedAddressIs);
                  print("value.addressList" +
                      value.addressList.length.toString());

                  value.fullNameController.clear();
                  value.mobileController.clear();
                  value.houseBuildingController.clear();
                  value.areaColonyController.clear();
                  value.stateController.clear();
                  value.cityController.clear();

                  var copyOfAddressList =
                      value.addressList.map((v) => v).toList();
                  String encodedMap = json.encode(copyOfAddressList);
                  StringConstant.prettyPrintJson(encodedMap.toString());
                } else {
                  Utils.flushBarErrorMessage(
                      "Please enter all details", context);
                }

              });
            })
          ],
        );
      }),
    );
  }

  bool isHome = false;
  var selectedAddressIs = 'Home';

  Widget typeOfAddress() {
    return Container(
      child: Row(children: [
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => OrderReviewSubActivity(),
              //   ),
              // );
              setState(() {
                isHome = true;
                isHome = !isHome;
                selectedAddressIs = StringUtils.home;
              });
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: isHome ? ThemeApp.lightGreyTab : ThemeApp.darkGreyTab,
                ),
                child: TextFieldUtils().usingPassTextFields(
                    StringUtils.home,
                    isHome == true ? ThemeApp.blackColor : ThemeApp.whiteColor,
                    context)),
          ),
        ),
        SizedBox(
          width: width * 0.03,
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              setState(() {
                isHome = true;
                selectedAddressIs = StringUtils.office;
              });
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => Home(),
              //   ),
              // );
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: isHome == true
                      ? ThemeApp.darkGreyTab
                      : ThemeApp.lightGreyTab,
                ),
                child: TextFieldUtils().usingPassTextFields(
                    StringUtils.office,
                    isHome == true ? ThemeApp.whiteColor : ThemeApp.blackColor,
                    context)),
          ),
        )
      ]),
    );
  }
}

//////////edit address

class EditDeliveryAddress extends StatefulWidget {
  final bool isSavedAddress;
  MyAddressList model;

  EditDeliveryAddress(
      {Key? key, required this.isSavedAddress, required this.model})
      : super(key: key);

  @override
  State<EditDeliveryAddress> createState() => _EditDeliveryAddressState();
}

class _EditDeliveryAddressState extends State<EditDeliveryAddress> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController houseBuildingController = new TextEditingController();
  TextEditingController areaColonyController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();

  @override
  void initState() {
    fullNameController = TextEditingController();
    mobileController = TextEditingController();
    houseBuildingController = TextEditingController();
    areaColonyController = TextEditingController();
    stateController = TextEditingController();
    cityController = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    fullNameController.text = widget.model.myAddressFullName!;
    mobileController.text = widget.model.myAddressPhoneNumber!;
    houseBuildingController.text = widget.model.myAddressHouseNoBuildingName!;
    areaColonyController.text = widget.model.myAddressAreaColony!;
    stateController.text = widget.model.myAddressState!;
    cityController.text = widget.model.myAddressCity!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    mobileController.dispose();
    houseBuildingController.dispose();
    areaColonyController.dispose();
    stateController.dispose();
    cityController.dispose();
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: ThemeApp.whiteColor,
          child: AppBar(

            centerTitle: false,
            elevation: 0,
            backgroundColor: ThemeApp.appBackgroundColor,
            flexibleSpace: Container(
              height: height * .11,
              width: width,
              decoration: const BoxDecoration(
                color: ThemeApp.whiteColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
            ),
            titleSpacing: 0,
            leadingWidth: 20,
            leading: Transform.scale(
                scale: 0,
                child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white,size: 10),
                    onPressed: () {
                    })),



            title: Container(
                alignment: Alignment.centerLeft,
                child: TextFieldUtils().textFieldHeightThree(
                    "Edit Delivery Address", context)),
            // Row
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: width,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: ThemeApp.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(20),
            // padding: const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 40),
            child: mainUi(),
          ),
        ),
      ),
    );
  }

  Widget mainUi() {
    return Form(
      child: Consumer<ProductProvider>(builder: (context, value, child) {
        return ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Full Name
            TextFieldUtils().dynamicText(
                StringUtils.fullName,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),

            CharacterTextFormFieldsWidget(
                errorText: StringUtils.enterFullName,
                textInputType: TextInputType.name,
                controller: fullNameController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'David Wong',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            //Mobile Number
            TextFieldUtils().dynamicText(
                StringUtils.mobileNumber,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            MobileNumberTextFormField(
              controller: mobileController,
              enable: true,
            ),
            SizedBox(
              height: height * .02,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFieldUtils().dynamicText(
                      StringUtils.addressDetails,
                      context,
                      TextStyle(
                          color: ThemeApp.blackColor,
                          fontSize: height * .025,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => AddNewCardScreen(),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: height * 0.05,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: ThemeApp.blackColor,
                        ),
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextFieldUtils().dynamicText(
                            StringUtils.useMyLocation,
                            context,
                            TextStyle(
                                color: ThemeApp.whiteColor,
                                fontSize: height * .021,
                                fontWeight: FontWeight.w500)),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: height * .02,
            ),
            TextFieldUtils().dynamicText(
                StringUtils.houseBuildingNo,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            TextFormFieldsWidget(
                errorText: StringUtils.houseBuildingNo,
                textInputType: TextInputType.text,
                controller: houseBuildingController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: '305, Lokseva Apartments',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            TextFieldUtils().dynamicText(
                StringUtils.areaColonyName,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            TextFormFieldsWidget(
                errorText: StringUtils.areaColonyName,
                textInputType: TextInputType.text,
                controller: areaColonyController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'Telecom Housing Society',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            TextFieldUtils().dynamicText(
                StringUtils.state,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            TextFormFieldsWidget(
                errorText: StringUtils.state,
                textInputType: TextInputType.text,
                controller: stateController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'State',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            TextFieldUtils().dynamicText(
                StringUtils.city,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            TextFormFieldsWidget(
                errorText: StringUtils.city,
                textInputType: TextInputType.text,
                controller: cityController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'Pune',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            SizedBox(
              height: height * .02,
            ),
            TextFieldUtils().dynamicText(
                StringUtils.typeOfAddress,
                context,
                TextStyle(
                    color: ThemeApp.blackColor,
                    fontSize: height * .025,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: height * .02,
            ),
            typeOfAddress(),
            SizedBox(
              height: height * .02,
            ),
            proceedButton(StringUtils.addDeliveryAddress,
                ThemeApp.blackColor, context, false, () {
              widget.model.myAddressFullName =
                  fullNameController.text.toString();
              widget.model.myAddressPhoneNumber =
                  mobileController.text.toString();
              widget.model.myAddressHouseNoBuildingName =
                  houseBuildingController.text.toString();
              widget.model.myAddressAreaColony =
                  areaColonyController.text.toString();
              widget.model.myAddressState = stateController.text.toString();
              widget.model.myAddressCity = cityController.text.toString();
              print(fullNameController.text);
              print(value.fullNameController.text);

              print("value.addressList" + value.addressList.length.toString());

              var copyOfAddressList = value.addressList.map((v) => v).toList();
              String encodedMap = json.encode(copyOfAddressList);
              StringConstant.prettyPrintJson(encodedMap.toString());

              if (widget.isSavedAddress == true) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SavedAddressDetails(),
                  ),
                );

                final snackBar = SnackBar(
                  content: Text('Address update successfully!'),
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: ThemeApp.greenappcolor,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderReviewSubActivity(value: value),
                  ),
                );
              }
            })
          ],
        );
      }),
    );
  }

  bool isHome = false;
  var selectedAddressIs = '';

  Widget typeOfAddress() {
    return Container(
      child: Row(children: [
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => OrderReviewSubActivity(),
              //   ),
              // );
              setState(() {
                isHome = true;
                isHome = !isHome;
                selectedAddressIs = StringUtils.home;
              });
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: isHome ? ThemeApp.lightGreyTab : ThemeApp.darkGreyTab,
                ),
                child: TextFieldUtils().usingPassTextFields(
                    StringUtils.home,
                    isHome == true ? ThemeApp.blackColor : ThemeApp.whiteColor,
                    context)),
          ),
        ),
        SizedBox(
          width: width * 0.03,
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              setState(() {
                isHome = true;
                selectedAddressIs = StringUtils.office;
              });
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => Home(),
              //   ),
              // );
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: isHome == true
                      ? ThemeApp.darkGreyTab
                      : ThemeApp.lightGreyTab,
                ),
                child: TextFieldUtils().usingPassTextFields(
                    StringUtils.office,
                    isHome == true ? ThemeApp.whiteColor : ThemeApp.blackColor,
                    context)),
          ),
        )
      ]),
    );
  }
}
