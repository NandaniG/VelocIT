import 'dart:convert';
import 'dart:io';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/Saved_address/saved_address_detailed_screen.dart';
import 'package:velocit/utils/StringUtils.dart';
import 'package:http/http.dart' as http;
import '../../../Core/AppConstant/apiMapping.dart';
import '../../../Core/Model/CartModels/SendCartForPaymentModel.dart';
import '../../../Core/Model/CityModel.dart';
import '../../../Core/Model/StateModel.dart';
import '../../../Core/ViewModel/cart_view_model.dart';
import '../../../Core/data/responses/status.dart';
import '../../../Core/repository/cart_repository.dart';
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

  // final CartForPaymentPayload cartForPaymentPayload;

  const AddNewDeliveryAddress({
    Key? key,
    required this.isSavedAddress,
/*      required this.cartForPaymentPayload*/
  }) : super(key: key);

  @override
  State<AddNewDeliveryAddress> createState() => _AddNewDeliveryAddressState();
}

class _AddNewDeliveryAddressState extends State<AddNewDeliveryAddress> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController houseBuildingController = TextEditingController();
  TextEditingController areaColonyController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  bool _validateFullName = false;
  bool _validateMobile = false;
  bool _validateEmail = false;

  final _formKey = GlobalKey<FormState>();
  CartViewModel cartViewModel = CartViewModel();
  CartRepository cartRepository = CartRepository();
  StateModel stateModel = StateModel();

  CityModel cityData = CityModel();
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isHome = false;
    cartViewModel.getStateAddressWithGet(context);
    cartViewModel.getCityAddressWithGet(context);
    data = cartRepository.getCityAddressList();

    print(data);
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
            child:AppBar_BackWidget(
                context: context,titleWidget: appTitle(context,"Add New Delivery Address"), location: SizedBox()),
          ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 40),
            child: Container(
                width: width,
                // alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ThemeApp.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(20),
                child: ChangeNotifierProvider<CartViewModel>.value(
                    value: cartViewModel,
                    child: Consumer<CartViewModel>(
                        builder: (context, cartData, child) {
                      switch (cartData.getState.status) {
                        case Status.LOADING:
                          print("Api load");

                          return TextFieldUtils().circularBar(context);
                        case Status.ERROR:
                          print("Api error");

                          return Text(cartData.getState.message.toString());
                        case Status.COMPLETED:
                          print("Api calll");
                          // List<StatePayload>? statePayloadList=   cartData.getState.data!.payload;

                          return mainUi(cartData.getState.data!.payload!);
                      }
                      return Container(
                        height: height * .8,
                        alignment: Alignment.center,
                        child: TextFieldUtils().dynamicText(
                            'No Match found!',
                            context,
                            TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.blackColor,
                                fontSize: height * .03,
                                fontWeight: FontWeight.bold)),
                      );
                    }))),
          ),
        ),
      ),
    );
  }

  var selectedStateId;

  var selectedIndexOfState;

  Widget mainUi(List<StatePayload> stateDetailList) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Full Name
              TextFieldUtils().asteriskTextField(StringUtils.fullName, context),
              CharacterTextFormFieldsWidget(
                  errorText: StringUtils.enterFullName,
                  textInputType: TextInputType.name,
                  controller: fullNameController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: 'Type your name',
                  onChange: (val) {},
                  validator: (value) {
                    return null;
                  }),
              //Mobile Number
              TextFieldUtils()
                  .asteriskTextField(StringUtils.mobileNumber, context),
              MobileNumberTextFormField(
                  controller: mobileController,
                  enable: true,
                  onChanged: (phone) {
                    print(phone.completeNumber);
                    if (phone.countryCode == "IN") {
                      print("india selected");
                      print(phone.completeNumber);
                    } else {
                      print("india not selected");
                    }
                  },
                  validator: (value) {
                    if (value == '' && mobileController.text.isEmpty) {
                      _validateMobile = true;
                      return StringUtils.enterMobileNumber;
                    } else if (mobileController.text.length < 10) {
                      _validateMobile = true;
                      return StringUtils.enterMobileNumber;
                    } else {
                      _validateMobile = false;
                    }
                    return null;
                  }),
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
                            fontFamily: 'Roboto',
                            color: ThemeApp.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                  InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => AddNewCardScreen(),
                        //   ),
                        // );
                      },
                      child: Container(
                        // height: height * 0.05,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(color: ThemeApp.appColor)),
                        padding: const EdgeInsets.fromLTRB(13, 5, 13, 5),
                        child: TextFieldUtils().dynamicText(
                            StringUtils.useMyLocation,
                            context,
                            TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.appColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      )),
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              TextFieldUtils()
                  .asteriskTextField(StringUtils.houseBuildingNo, context),
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
              TextFieldUtils()
                  .asteriskTextField(StringUtils.areaColonyName, context),
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

              TextFieldUtils().asteriskTextField(StringUtils.state, context),
              /*       TextFormFieldsWidget(
                  errorText: StringUtils.state,
                  textInputType: TextInputType.text,
                  controller: stateController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: 'State',
                  onChange: (val) {},
                  validator: (value) {
                    return null;
                  }),*/
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<StatePayload>(
                  //value: _companyDataResponseModel,
                  isDense: true,
                  onChanged: (StatePayload? newValue) {
                    //   for(int i =0; i<stateDetailList.length; i++){
                    //
                    //   selectedState = newValue!.cities??[];
                    // }
                    setState(() {
                      print("selected state" + newValue!.name.toString());
                      selectedStateId = newValue.id;
                      print(selectedStateId);
stateController.text=newValue.name!;

                    });
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    hintText: 'State',
                    errorStyle: TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.redColor,
                        fontSize: MediaQuery.of(context).size.height * 0.020),
                    errorMaxLines: 2,
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 12.0, 11.0, 12.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: ThemeApp.separatedLineColor,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeApp.separatedLineColor, width: 1)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeApp.separatedLineColor, width: 1)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeApp.redColor, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeApp.separatedLineColor, width: 1)),
                  ),
                  items: stateDetailList.map((StatePayload map) {
                    return DropdownMenuItem<StatePayload>(
                      value: map,
                      child: Text(
                        map.name.toString(),
                        style: TextStyle(
                          fontFamily: 'SegoeUi',
                        ),
                      ),
                    );
                  }).toList(),
                )),
              ),

/*              Column(
                children: [
                  ///Adding CSC Picker Widget in app
                  CSCPicker(
                    ///Enable disable state dropdown [OPTIONAL PARAMETER]
                    showStates: true,

                    /// Enable disable city drop down [OPTIONAL PARAMETER]
                    showCities: true,

                    ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                    flagState: CountryFlag.DISABLE,

                    ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                    dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border:
                        Border.all(color: Colors.grey.shade300, width: 1)),

                    ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                    disabledDropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.shade300,
                        border:
                        Border.all(color: Colors.grey.shade300, width: 1)),

                    ///placeholders for dropdown search field
                    countrySearchPlaceholder: "Country",
                    stateSearchPlaceholder: "State",
                    citySearchPlaceholder: "City",

                    ///labels for dropdown
                    countryDropdownLabel: "*Country",
                    stateDropdownLabel: "*State",
                    cityDropdownLabel: "*City",

                    ///Default Country
                    //defaultCountry: DefaultCountry.India,

                    ///Disable country dropdown (Note: use it with default country)
                    //disableCountry: true,

                    ///selected item style [OPTIONAL PARAMETER]
                    selectedItemStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),

                    ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                    dropdownHeadingStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),

                    ///DropdownDialog Item style [OPTIONAL PARAMETER]
                    dropdownItemStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),

                    ///Dialog box radius [OPTIONAL PARAMETER]
                    dropdownDialogRadius: 10.0,

                    ///Search bar radius [OPTIONAL PARAMETER]
                    searchBarRadius: 10.0,

                    ///triggers once country selected in dropdown
                    onCountryChanged: (value) {
                      setState(() {
                        ///store value in country variable
                        countryValue = value;
                      });
                    },

                    ///triggers once state selected in dropdown
                    onStateChanged: (value) {
                      setState(() {
                        ///store value in state variable
                        stateValue = value??"";
                      });
                    },

                    ///triggers once city selected in dropdown
                    onCityChanged: (value) {
                      setState(() {
                        ///store value in city variable
                        cityValue = value??"";
                      });
                    },
                  ),

                  ///print newly selected country state and city in Text Widget
                  TextButton(
                      onPressed: () {
                        setState(() {
                          address = "$cityValue, $stateValue, $countryValue";
                        });
                      },
                      child: Text("Print Data")),
                  Text(address)
                ],
              )*/
              TextFieldUtils().asteriskTextField(StringUtils.city, context),
              /*    TextFormFieldsWidget(
                  errorText: StringUtils.city,
                  textInputType: TextInputType.text,
                  controller: cityController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: 'Pune',
                  onChange: (val) {},
                  validator: (value) {
                    return null;
                  }),*/
              ChangeNotifierProvider<CartViewModel>.value(
                  value: cartViewModel,
                  child: Consumer<CartViewModel>(
                      builder: (context, cartData, child) {
                        switch (cartData.getCity.status) {
                          case Status.LOADING:
                            print("Api load");

                            return SizedBox();
                          case Status.ERROR:
                            print("Api error");

                            return Text(cartData.getCity.message.toString());
                          case Status.COMPLETED:
                            print("Api calll");
                            var citySelectedId;
                            cartData.getCity.data!.payload!
                                .map((CityPayloadData map) {
                              citySelectedId = map.id;
                            });
                            // List<StatePayload>? statePayloadList=   cartData.getState.data!.payload;
                            return     Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),

                              child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<CityPayloadData>(
                                    isDense: true,
                                    isExpanded: false,

                                    onChanged: (CityPayloadData? newValue) {
                                      setState(() {}
                                      );
                                      cityController.text = newValue!.name!;

                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintStyle: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      hintText: 'City',
                                      errorStyle: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: ThemeApp.redColor,
                                          fontSize:
                                          MediaQuery.of(context).size.height * 0.020),
                                      errorMaxLines: 2,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 12.0, 11.0, 12.0),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            color: ThemeApp.separatedLineColor,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: ThemeApp.separatedLineColor,
                                              width: 1)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: ThemeApp.separatedLineColor,
                                              width: 1)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: ThemeApp.redColor, width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: ThemeApp.separatedLineColor,
                                              width: 1)),
                                    ),
                                    items: cartData.getCity.data!.payload!
                                        .map((CityPayloadData map) {
                                      return DropdownMenuItem<CityPayloadData>(
                                        value: map,
                                        child:  Text(
                                          map.name.toString() ?? "",
                                          style: TextStyle(
                                            fontFamily: 'SegoeUi',
                                          ),
                                        )
                                         ,
                                      );
                                    }).toList() ??
                                        [],
                                    // items: [],
                                  )),
                            );
                        }
                        return Container(
                          height: height * .8,
                          alignment: Alignment.center,
                          child: TextFieldUtils().dynamicText(
                              'No Match found!',
                              context,
                              TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.blackColor,
                                  fontSize: height * .03,
                                  fontWeight: FontWeight.bold)),
                        );
                      })),



              TextFieldUtils().asteriskTextField(StringUtils.pincode, context),
              TextFormFieldsWidget(
                  errorText: StringUtils.pincode,
                  textInputType: TextInputType.text,
                  controller: pincodeController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: '365214',
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
                      fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.25)),
              SizedBox(
                height: height * .02,
              ),
              typeOfAddress(),
              SizedBox(
                height: height * .02,
              ),
              proceedButton(StringUtils.addDeliveryAddress,
                  ThemeApp.tealButtonColor, context, false, () async {
                FocusManager.instance.primaryFocus?.unfocus();
                final prefs = await SharedPreferences.getInstance();

                setState(() {
                  StringConstant.UserLoginId =
                      (prefs.getString('isUserId')) ?? '';
                  StringConstant.UserCartID =
                      (prefs.getString('CartIdPref')) ?? '';

                  var userId;
                  if (StringConstant.UserLoginId.toString() == '' ||
                      StringConstant.UserLoginId.toString() == null) {
                    userId = StringConstant.RandomUserLoginId;
                  } else {
                    userId = StringConstant.UserLoginId;
                  }

                  print("USER LOGIN ID..............." +
                      StringConstant.UserLoginId.toString());
                  if (_formKey.currentState!.validate() &&
                      fullNameController.text.isNotEmpty &&
                      mobileController.text.isNotEmpty &&
                      houseBuildingController.text.isNotEmpty &&
                      areaColonyController.text.isNotEmpty &&
                      // stateController.text.isNotEmpty &&
                      // cityController.text.isNotEmpty &&
                      pincodeController.text.isNotEmpty) {
                    if (widget.isSavedAddress == true) {
                      Map data = {
                        "name": fullNameController.text,
                        "address_line_1": houseBuildingController.text,
                        "address_line_2": areaColonyController.text,
                        "city_name": cityController.text,
                        "state_name": stateController.text,
                        "address_type": selectedAddressIs,
                        "pincode": pincodeController.text,
                        "contact_number": "+91 " + mobileController.text,
                        "latitude": 24.2342525,
                        "longitude": 52.2342523
                      };
                      print("map address" + data.toString());

                      CartRepository()
                          .createAddressPostAPI(data, userId.toString()).then((value) {
                            setState(() {

                            });
                        Utils.successToast("New Address added successfully");
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SavedAddressDetails(
                              /*      cartForPaymentPayload:
                                  widget.cartForPaymentPayload*/
                            ),
                          ),
                        );
                      });


                    } else {
                      Map data = {
                        "name": fullNameController.text,
                        "address_line_1": houseBuildingController.text,
                        "address_line_2": areaColonyController.text,
                        "city_name": cityController.text,
                        "state_name": stateController.text,
                        "address_type": selectedAddressIs,
                        "pincode": pincodeController.text,
                        "contact_number": "+91 " + mobileController.text,
                        "latitude": 24.2342525,
                        "longitude": 52.2342523
                      };
                      print("map address" + data.toString());
                      print("widget.cartForPaymentPayload.userId!" +
                          userId.toString());

                      CartRepository()
                          .createAddressPostAPI(data, userId.toString());

                      Utils.successToast("New Address added successfully");
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => OrderReviewActivity(
                            cartId: int.parse(StringConstant.UserCartID),
                          ),
                        ),
                      );
                    }
                    Prefs.instance.setToken(
                        StringConstant.selectedFullAddressPref,
                        StringConstant.selectedFullAddress);

                    Prefs.instance.setToken(StringConstant.selectedFullNamePref,
                        StringConstant.selectedFullName);

                    Prefs.instance.setToken(StringConstant.selectedMobilePref,
                        StringConstant.selectedMobile);

                    StringConstant.selectedTypeOfAddress = selectedAddressIs;
                    Prefs.instance.setToken(
                        StringConstant.selectedTypeOfAddressPref,
                        StringConstant.selectedTypeOfAddress);

                    fullNameController.clear();
                    mobileController.clear();
                    houseBuildingController.clear();
                    areaColonyController.clear();
                    stateController.clear();
                    cityController.clear();
                    pincodeController.clear();
                  } else {
                    Utils.flushBarErrorMessage(
                        "Please enter all details", context);
                  }
                });
              })
            ],
          ),
        ));
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
                      Radius.circular(40),
                    ),
                    border: Border.all(color: ThemeApp.tealButtonColor),
                    color:
                        isHome ? ThemeApp.whiteColor : ThemeApp.tealButtonColor,
                  ),
                  child: Text(
                    StringUtils.home,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                        color: isHome == true
                            ? ThemeApp.blackColor
                            : ThemeApp.whiteColor,
                        letterSpacing: -0.25),
                  ))),
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
                    Radius.circular(40),
                  ),
                  border: Border.all(color: ThemeApp.tealButtonColor),
                  color: isHome == true
                      ? ThemeApp.tealButtonColor
                      : ThemeApp.whiteColor,
                ),
                child: Text(
                  StringUtils.office,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis,
                      color: isHome == true
                          ? ThemeApp.whiteColor
                          : ThemeApp.blackColor,
                      letterSpacing: -0.25),
                )),
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

  // CartForPaymentPayload? cartForPaymentPayload;

  EditDeliveryAddress({
    Key? key,
    required this.isSavedAddress,
    required this.model,
    /* required this.cartForPaymentPayload*/
  }) : super(key: key);

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
  TextEditingController pincodeController = new TextEditingController();

  @override
  void initState() {
    fullNameController = TextEditingController();
    mobileController = TextEditingController();
    houseBuildingController = TextEditingController();
    areaColonyController = TextEditingController();
    stateController = TextEditingController();
    cityController = TextEditingController();
    pincodeController = TextEditingController();

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
    pincodeController.text = widget.model.myAddressPincode!;
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
    pincodeController.dispose();
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
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 10),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    })),

            title: Container(
                alignment: Alignment.centerLeft,
                child: TextFieldUtils()
                    .textFieldHeightThree("Edit Delivery Address", context)),
            // Row
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: width,
            // alignment: Alignment.center,
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
        return SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Full Name
            TextFieldUtils().dynamicText(
                StringUtils.fullName,
                context,
                TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),

            CharacterTextFormFieldsWidget(
                errorText: StringUtils.enterFullName,
                textInputType: TextInputType.name,
                controller: fullNameController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: 'Type your name',
                onChange: (val) {},
                validator: (value) {
                  return null;
                }),
            //Mobile Number
            TextFieldUtils().dynamicText(
                StringUtils.mobileNumber,
                context,
                TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            MobileNumberTextFormField(
                controller: mobileController,
                enable: true,
                onChanged: (phone) {
                  print(phone.completeNumber);
                  if (phone.countryCode == "IN") {
                    print("india selected");
                    print(phone.completeNumber);
                  } else {
                    print("india not selected");
                  }
                },
                validator: (value) {
                  // if (value.isEmpty && mobileController.text.isEmpty) {
                  //   _validateMobile = true;
                  //   return StringUtils.enterMobileNumber;
                  // } else if (mobileController.text.length < 10) {
                  //   _validateMobile = true;
                  //   return StringUtils.enterMobileNumber;
                  // } else {
                  //   _validateMobile = false;
                  // }
                  return null;
                }),

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
                          fontFamily: 'Roboto',
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
                                fontFamily: 'Roboto',
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
                    fontFamily: 'Roboto',
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
                    fontFamily: 'Roboto',
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
                    fontFamily: 'Roboto',
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
                    fontFamily: 'Roboto',
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
                StringUtils.pincode,
                context,
                TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            TextFormFieldsWidget(
                errorText: StringUtils.pincode,
                textInputType: TextInputType.text,
                controller: pincodeController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: '365214',
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
                    fontFamily: 'Roboto',
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
                ThemeApp.tealButtonColor, context, false, () async {
              final prefs = await SharedPreferences.getInstance();

              StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
              StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';

              var userId;
              if (StringConstant.UserLoginId.toString() == '' ||
                  StringConstant.UserLoginId.toString() == null) {
                userId = StringConstant.RandomUserLoginId;
              } else {
                userId = StringConstant.UserLoginId;
              }

              FocusManager.instance.primaryFocus?.unfocus();

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
              widget.model.myAddressPincode = pincodeController.text.toString();
              print(fullNameController.text);
              print(value.fullNameController.text);
              //
              // print("value.addressList" + value.addressList.length.toString());
              //
              // var copyOfAddressList = value.addressList.map((v) => v).toList();
              // String encodedMap = json.encode(copyOfAddressList);
              // StringConstant.prettyPrintJson(encodedMap.toString());

              if (widget.isSavedAddress == true) {
                Map data = {
                  "name": fullNameController.text,
                  "address_line_1": houseBuildingController.text,
                  "address_line_2": areaColonyController.text,
                  "city_name": cityController.text,
                  "state_name": stateController.text,
                  "address_type": selectedAddressIs,
                  "pincode": pincodeController.text,
                  "contact_number": "+91 " + mobileController.text,
                  "latitude": 24.2342525,
                  "longitude": 52.2342523
                };
                print("map address" + data.toString());

                CartRepository().createAddressPostAPI(data, userId.toString());

                Utils.successToast("New Address added successfully");
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SavedAddressDetails(
                        /*   cartForPaymentPayload: widget.cartForPaymentPayload!*/),
                  ),
                );
                Utils.successToast('Address update successfully!');
              } else {
                Map data = {
                  "name": fullNameController.text,
                  "address_line_1": houseBuildingController.text,
                  "address_line_2": areaColonyController.text,
                  "city_name": cityController.text,
                  "state_name": stateController.text,
                  "address_type": selectedAddressIs,
                  "pincode": pincodeController.text,
                  "contact_number": "+91 " + mobileController.text,
                  "latitude": 24.2342525,
                  "longitude": 52.2342523
                };
                print("map address" + data.toString());

                CartRepository().createAddressPostAPI(data, userId.toString());

                Utils.successToast("New Address added successfully");
                //comment because need to manage apis

                /*       Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderReviewSubActivity(cartPayLoad: value),
                  ),
                );*/
              }
            })
          ],
        ));
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
