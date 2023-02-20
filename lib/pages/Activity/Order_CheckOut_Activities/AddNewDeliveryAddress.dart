import 'dart:convert';
import 'dart:io';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Model/CartModels/AddressListModel.dart';
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
import '../../../utils/routes/routes.dart';
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

  bool _isfullNameValidate = false;
  bool _validateMobile = false;
  bool _ishouseBuildingValidate = false;
  bool _isareaColonyValidate = false;
  bool _isstateValidate = false;
  bool _iscityValidate = false;
  bool _ispincodeValidate = false;

  final _formKey = GlobalKey<FormState>();
  CartViewModel cartViewModel = CartViewModel();
  CartRepository cartRepository = CartRepository();
  StateModel stateModel = StateModel();

  CityModel cityData = CityModel();
  var data;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getLocation(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  _getLocation(Position position) async {
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("address.streetAddress" + first.postalCode.toString());
    print("${first.featureName} : ${first.addressLine}");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('CurrentPinCodePrefs', first.postalCode.toString());

    var splitag = first.addressLine.split(",");
    var houseBuilding = splitag[0] + ', ' + splitag[1];
    var areaColony = splitag[2];
    var state = splitag[3];
    var city = splitag[4];
    var pincode = first.postalCode;

    setState(() {
      houseBuildingController = TextEditingController(text: houseBuilding);
      areaColonyController = TextEditingController(text: areaColony);
      stateController = TextEditingController(text: state);
      cityController = TextEditingController(text: city);
      pincodeController = TextEditingController(text: pincode);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isHome = 0;
    cartViewModel.getStateAddressWithGet(context);
    cartViewModel.getCityAddressWithGet(context);
    getPrefs();
  }

  getPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      StringConstant.userProfileName =
          prefs.getString('userProfileNamePrefs') ?? "";
      StringConstant.userProfileMobile =
          prefs.getString('userProfileMobilePrefs') ?? "";
      fullNameController =
          TextEditingController(text: StringConstant.userProfileName);
      mobileController =
          TextEditingController(text: StringConstant.userProfileMobile);
    });
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
          child: AppBar_BackWidget(
              context: context,
              titleWidget: appTitle(context, "Add New Delivery Address"),
              location: SizedBox()),
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
                        child: Center(
                            child: Text(
                              "Match not found",
                              style: TextStyle(fontSize: 20),
                            )),
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
                  onChange: (val) {
                    setState(() {
                      if (val.isEmpty && fullNameController.text.isEmpty) {
                        _isfullNameValidate = true;
                      } else if (fullNameController.text.length <= 4) {
                        _isfullNameValidate = true;
                      } else {
                        _isfullNameValidate = false;
                      }
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty && fullNameController.text.isEmpty) {
                      _isfullNameValidate = true;
                      return StringUtils.enterFullName;
                    } else if (fullNameController.text.length < 4) {
                      _isfullNameValidate = true;
                      return StringUtils.enterFullName;
                    } else {
                      _isfullNameValidate = false;
                    }
                    return null;
                  }),
              //Mobile Number
              TextFieldUtils()
                  .asteriskTextField(StringUtils.mobileNumber, context),
              MobileNumberTextFormField(
                  errorText: StringUtils.enterMobileNumber,
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
                    if (mobileController.text.isEmpty) {
                      _validateMobile = true;
                      return StringUtils.mobileError;
                    } else if (!StringConstant()
                        .isPhone(mobileController.text)) {
                      _validateMobile = true;
                      return StringUtils.mobileError;
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
                        _getCurrentPosition();
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
                  errorText: StringUtils.enterhouseBuildingNo,
                  textInputType: TextInputType.text,
                  controller: houseBuildingController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: '305, Lokseva Apartments',
                  onChange: (val) {
                    setState(() {
                      if (val.isEmpty && houseBuildingController.text.isEmpty) {
                        _ishouseBuildingValidate = true;
                      } else if (houseBuildingController.text.length < 5) {
                        _ishouseBuildingValidate = true;
                      } else {
                        _ishouseBuildingValidate = false;
                      }
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty && houseBuildingController.text.isEmpty) {
                      _ishouseBuildingValidate = true;
                      return StringUtils.enterhouseBuildingNo;
                    } else if (houseBuildingController.text.length < 5) {
                      _ishouseBuildingValidate = true;
                      return StringUtils.enterhouseBuildingNo;
                    } else {
                      _ishouseBuildingValidate = false;
                    }
                    return null;
                  }),
              TextFieldUtils()
                  .asteriskTextField(StringUtils.areaColonyName, context),
              TextFormFieldsWidget(
                  errorText: StringUtils.enterAreaName,
                  textInputType: TextInputType.text,
                  controller: areaColonyController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: 'Telecom Housing Society',
                  onChange: (val) {
                    setState(() {
                      if (val.isEmpty && areaColonyController.text.isEmpty) {
                        _isareaColonyValidate = true;
                      } else if (areaColonyController.text.length < 5) {
                        _isareaColonyValidate = true;
                      } else {
                        _isareaColonyValidate = false;
                      }
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty && areaColonyController.text.isEmpty) {
                      _isareaColonyValidate = true;
                      return StringUtils.enterAreaName;
                    } else if (areaColonyController.text.length < 5) {
                      _isareaColonyValidate = true;
                      return StringUtils.enterAreaName;
                    } else {
                      _isareaColonyValidate = false;
                    }
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
                  hint: Text(stateController.text.toString()),
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
                      stateController.text = newValue.name!;
                      if (stateController.text.isEmpty) {
                        _isstateValidate = true;
                      } else {
                        _isstateValidate = false;
                      }
                    });
                  },
                  validator: (value) {
                    if (stateController.text.isEmpty) {
                      _isstateValidate = true;
                      return StringUtils.enterState;
                    } else {
                      _isstateValidate = false;
                    }
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                        fontFamily: 'Roboto',
                        color: stateController.text.toString().isNotEmpty
                            ? Colors.black
                            : Colors.grey,
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
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<CityPayloadData>(
                            isDense: true,
                            isExpanded: false,
                            hint: Text(cityController.text),
                            onChanged: (CityPayloadData? newValue) {
                              cityController.text = newValue!.name!;

                              if (cityController.text.isEmpty) {
                                _iscityValidate = true;
                              } else {
                                _iscityValidate = false;
                              }
                            },
                            validator: (value) {
                              if (cityController.text.isEmpty) {
                                _iscityValidate = true;
                                return StringUtils.enterCity;
                              } else {
                                _iscityValidate = false;
                              }
                            },
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: cityController.text == ''
                                      ? ThemeApp.blackColor
                                      : ThemeApp.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              hintText: 'City',
                              labelStyle: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: cityController.text == ''
                                      ? ThemeApp.blackColor
                                      : ThemeApp.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              errorStyle: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.redColor,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.020),
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
                                    child: Text(
                                      map.name.toString() ?? "",
                                      style: TextStyle(
                                        fontFamily: 'SegoeUi',
                                      ),
                                    ),
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
                      child: Center(
                          child: Text(
                            "Match not found",
                            style: TextStyle(fontSize: 20),
                          )),
                    );
                  })),

              TextFieldUtils().asteriskTextField(StringUtils.pincode, context),
              TextFormFieldsWidget(
                  errorText: StringUtils.enterPincode,
                  maxLength: 6,
                  textInputType: TextInputType.number,
                  controller: pincodeController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: '365214',
                  onChange: (val) {
                    setState(() {
                      if (val.isEmpty && pincodeController.text.isEmpty) {
                        _ispincodeValidate = true;
                      } else if (pincodeController.text.length < 6) {
                        _ispincodeValidate = true;
                      } else {
                        _ispincodeValidate = false;
                      }
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty && pincodeController.text.isEmpty) {
                      _ispincodeValidate = true;
                      return StringUtils.enterPincode;
                    } else if (pincodeController.text.length < 6) {
                      _ispincodeValidate = true;
                      return StringUtils.enterPincode;
                    } else {
                      _ispincodeValidate = false;
                    }
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
                      stateController.text.isNotEmpty &&
                      cityController.text.isNotEmpty &&
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
                        "contact_number": mobileController.text,
                        "latitude": 24.2342525,
                        "longitude": 52.2342523
                      };
                      print("map address" + data.toString());

                      CartRepository()
                          .createAddressPostAPI(data, userId.toString())
                          .then((value) {
                        setState(() {});
                        // fullNameController.clear();
                        // mobileController.clear();
                        // houseBuildingController.clear();
                        // areaColonyController.clear();
                        // stateController.clear();
                        // cityController.clear();
                        // pincodeController.clear();
                        Utils.successToast("New Address added successfully");
                        Navigator.of(context)
                            .pushNamed(RoutesName.saveAddressRoute)
                            .then((value) => setState(() {}));

                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         SavedAddressDetails(
                        //           /* cartForPaymentPayload:
                        //       widget.cartForPaymentPayload*/
                        //         ),
                        //   ),
                        // );
                      }).then((value) {});
                    } else {
                      Map data = {
                        "name": fullNameController.text,
                        "address_line_1": houseBuildingController.text,
                        "address_line_2": areaColonyController.text,
                        "city_name": cityController.text,
                        "state_name": stateController.text,
                        "address_type": selectedAddressIs,
                        "pincode": pincodeController.text,
                        "contact_number": mobileController.text,
                        "latitude": 24.2342525,
                        "longitude": 52.2342523
                      };
                      print("map address" + data.toString());
                      print("widget.cartForPaymentPayload.userId!" +
                          userId.toString());

                      CartRepository()
                          .createAddressPostAPI(data, userId.toString())
                          .then((value) {
                        Utils.successToast("New Address added successfully");
                      });
                      // Navigator.of(context).pushNamed(RoutesName.saveAddressRoute);

                      var isBuyNow = prefs.getString('isBuyNow');
                      var directCartId = prefs.getString('directCartIdPref');
                      if (isBuyNow == 'true') {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => OrderReviewActivity(
                              cartId: int.parse(directCartId.toString()),
                            ),
                          ),
                        );
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => OrderReviewActivity(
                              cartId: int.parse(StringConstant.UserCartID),
                            ),
                          ),
                        );
                      }

                      // Navigator.pop(context);
                      // Navigator.pop(context);
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

  int isHome = 0;
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
                  isHome = 0;
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
                    color: isHome == 0
                        ? ThemeApp.tealButtonColor
                        : ThemeApp.whiteColor,
                  ),
                  child: Text(
                    StringUtils.home,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                        color: isHome == 0
                            ? ThemeApp.whiteColor
                            : ThemeApp.blackColor,
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
                isHome = 1;
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
                  color: isHome == 1
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
                      color: isHome == 1
                          ? ThemeApp.whiteColor
                          : ThemeApp.blackColor,
                      letterSpacing: -0.25),
                )),
          ),
        ),
        SizedBox(
          width: width * 0.03,
        ),
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
                  isHome = 2;
                  selectedAddressIs = StringUtils.other;
                });
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40),
                    ),
                    border: Border.all(color: ThemeApp.tealButtonColor),
                    color: isHome == 2
                        ? ThemeApp.tealButtonColor
                        : ThemeApp.whiteColor,
                  ),
                  child: Text(
                    StringUtils.other,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                        color: isHome == 2
                            ? ThemeApp.whiteColor
                            : ThemeApp.blackColor,
                        letterSpacing: -0.25),
                  ))),
        ),
      ]),
    );
  }
/*
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
  }*/
}

//////////edit address

class EditDeliveryAddress extends StatefulWidget {
  final bool isSavedAddress;
  AddressContent addressList;

  // CartForPaymentPayload? cartForPaymentPayload;

  EditDeliveryAddress({
    Key? key,
    required this.isSavedAddress,
    required this.addressList,
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

  bool _isfullNameValidate = false;
  bool _ismobileValidate = false;
  bool _ishouseBuildingValidate = false;
  bool _isareaColonyValidate = false;
  bool _isstateValidate = false;
  bool _iscityValidate = false;
  bool _ispincodeValidate = false;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getLocation(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  _getLocation(Position position) async {
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("address.streetAddress" + first.postalCode.toString());
    print("${first.featureName} : ${first.addressLine}");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('CurrentPinCodePrefs', first.postalCode.toString());

    var splitag = first.addressLine.split(",");
    var houseBuilding = splitag[0] + ', ' + splitag[1];
    var areaColony = splitag[2];
    var state = splitag[3];
    var city = splitag[4];
    var pincode = first.postalCode;

    setState(() {
      houseBuildingController = TextEditingController(text: houseBuilding);
      areaColonyController = TextEditingController(text: areaColony);
      stateController = TextEditingController(text: state);
      cityController = TextEditingController(text: city);
      pincodeController = TextEditingController(text: pincode);
    });
  }

  CartViewModel cartViewModel = CartViewModel();

  @override
  void initState() {
    cartViewModel.getStateAddressWithGet(context);
    cartViewModel.getCityAddressWithGet(context);

    fullNameController = TextEditingController();
    mobileController = TextEditingController();
    houseBuildingController = TextEditingController();
    areaColonyController = TextEditingController();
    stateController = TextEditingController();
    cityController = TextEditingController();
    pincodeController = TextEditingController();
    selectedAddressIs;
    // if (isHome == 0) {
    //   selectedAddressIs = 'Home';
    // } else if (isHome == 1) {
    //   selectedAddressIs = 'Office';
    // } else if (isHome == 2) {
    //   selectedAddressIs = 'Other';
    // }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    fullNameController.text = widget.addressList.name ?? "";
    mobileController.text = widget.addressList.contactNumber ?? "";
    houseBuildingController.text = widget.addressList.addressLine1 ?? "";
    areaColonyController.text = widget.addressList.addressLine2 ?? "";
    stateController.text = widget.addressList.stateName ?? "";
    cityController.text = widget.addressList.cityName ?? "";
    pincodeController.text = widget.addressList.pincode ?? "";
    selectedAddressIs = widget.addressList.addressType ?? "Home";
    print("selectedAddressIs : " + selectedAddressIs.toString());
    if (selectedAddressIs == 'Home') {
      isHome = 0;
    } else if (selectedAddressIs == 'Office') {
      isHome = 1;
    } else if (selectedAddressIs == 'Other') {
      isHome = 2;
    }
    // isHome ==true?selectedAddressIs = 'Home':'Office';
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
        child: AppBar_BackWidget(
            context: context,
            titleWidget: appTitle(context, "Edit New Delivery Address"),
            location: SizedBox()),
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
                      child: Center(
                          child: Text(
                            "Match not found",
                            style: TextStyle(fontSize: 20),
                          )),
                    );
                  }))),
        ),
      ),
    );
  }

  Widget mainUi(List<StatePayload> stateDetailList) {
    return Form(
      key: _formKey,
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
                onChange: (val) {
                  setState(() {
                    if (val.isEmpty && fullNameController.text.isEmpty) {
                      _isfullNameValidate = true;
                    } else if (fullNameController.text.length <= 4) {
                      _isfullNameValidate = true;
                    } else {
                      _isfullNameValidate = false;
                    }
                  });
                },
                validator: (value) {
                  if (value.isEmpty && fullNameController.text.isEmpty) {
                    _isfullNameValidate = true;
                    return StringUtils.enterFullName;
                  } else if (fullNameController.text.length < 4) {
                    _isfullNameValidate = true;
                    return StringUtils.enterFullName;
                  } else {
                    _isfullNameValidate = false;
                  }
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
                  if (value == '' && mobileController.text.isEmpty) {
                    _ismobileValidate = true;
                    return StringUtils.enterMobileNumber;
                  } else if (mobileController.text.length < 10) {
                    _ismobileValidate = true;
                    return StringUtils.enterMobileNumber;
                  } else {
                    _ismobileValidate = false;
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
                          fontSize: height * .025,
                          fontWeight: FontWeight.bold)),
                ),
                InkWell(
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => AddNewCardScreen(),
                      //   ),
                      // );
                      _getCurrentPosition();
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
                hint: Text(stateController.text.toString()),
                isDense: true,
                onChanged: (StatePayload? newValue) {
                  //   for(int i =0; i<stateDetailList.length; i++){
                  //
                  //   selectedState = newValue!.cities??[];
                  // }
                  setState(() {
                    print("selected state" + newValue!.name.toString());

                    stateController.text = newValue.name!;
                    if (stateController.text.isEmpty) {
                      _isstateValidate = true;
                    } else {
                      _isstateValidate = false;
                    }
                  });
                },
                validator: (value) {
                  if (stateController.text.isEmpty) {
                    _isstateValidate = true;
                    return StringUtils.enterState;
                  } else {
                    _isstateValidate = false;
                  }
                },
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: TextStyle(
                      fontFamily: 'Roboto',
                      color: stateController.text.toString().isNotEmpty
                          ? Colors.black
                          : Colors.grey,
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
                      borderSide:
                          const BorderSide(color: ThemeApp.redColor, width: 1)),
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
            TextFieldUtils().dynamicText(
                StringUtils.city,
                context,
                TextStyle(
                    fontFamily: 'Roboto',
                    color: ThemeApp.blackColor,
                    fontSize: height * .02,
                    fontWeight: FontWeight.w500)),
            /*      TextFormFieldsWidget(
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
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<CityPayloadData>(
                          isDense: true,
                          isExpanded: false,
                          hint: Text(cityController.text),
                          onChanged: (CityPayloadData? newValue) {
                            cityController.text = newValue!.name!;

                            if (cityController.text.isEmpty) {
                              _iscityValidate = true;
                            } else {
                              _iscityValidate = false;
                            }
                          },
                          validator: (value) {
                            if (cityController.text.isEmpty) {
                              _iscityValidate = true;
                              return StringUtils.enterCity;
                            } else {
                              _iscityValidate = false;
                            }
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                color: cityController.text == ''
                                    ? ThemeApp.blackColor
                                    : ThemeApp.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            hintText: 'City',
                            labelStyle: TextStyle(
                                fontFamily: 'Roboto',
                                color: cityController.text == ''
                                    ? ThemeApp.blackColor
                                    : ThemeApp.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
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
                                  child: Text(
                                    map.name.toString() ?? "",
                                    style: TextStyle(
                                      fontFamily: 'SegoeUi',
                                    ),
                                  ),
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
                    child: Center(
                        child: Text(
                          "Match not found",
                          style: TextStyle(fontSize: 20),
                        )),
                  );
                })),

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
              // final prefs = await SharedPreferences.getInstance();
              //
              // StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
              // StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
              // if (_formKey.currentState!.validate() &&
              //     fullNameController.text.isNotEmpty &&
              //     mobileController.text.isNotEmpty &&
              //     houseBuildingController.text.isNotEmpty &&
              //     areaColonyController.text.isNotEmpty &&
              //     stateController.text.isNotEmpty &&
              //     cityController.text.isNotEmpty &&
              //     pincodeController.text.isNotEmpty) {
              //   var userId;
              //   if (StringConstant.UserLoginId.toString() == '' ||
              //       StringConstant.UserLoginId.toString() == null) {
              //     userId = StringConstant.RandomUserLoginId;
              //   } else {
              //     userId = StringConstant.UserLoginId;
              //   }
              //
              //   FocusManager.instance.primaryFocus?.unfocus();
              //
              //   widget.addressList.name = fullNameController.text.toString();
              //   widget.addressList.contactNumber =
              //       mobileController.text.toString();
              //   widget.addressList.addressLine1 =
              //       houseBuildingController.text.toString();
              //   widget.addressList.addressLine2 =
              //       areaColonyController.text.toString();
              //   widget.addressList.stateName = stateController.text.toString();
              //   widget.addressList.cityName = cityController.text.toString();
              //   widget.addressList.pincode = pincodeController.text.toString();
              //   widget.addressList.addressType = selectedAddressIs;
              //   print(fullNameController.text);
              //   print(widget.addressList.name);
              //   //
              //   // print("value.addressList" + value.addressList.length.toString());
              //   //
              //   // var copyOfAddressList = value.addressList.map((v) => v).toList();
              //   // String encodedMap = json.encode(copyOfAddressList);
              //   // StringConstant.prettyPrintJson(encodedMap.toString());
              //
              //   if (widget.isSavedAddress == true) {
              //     Map data = {
              //       "name": fullNameController.text,
              //       "address_line_1": houseBuildingController.text,
              //       "address_line_2": areaColonyController.text,
              //       "city_name": cityController.text,
              //       "state_name": stateController.text,
              //       "address_type": selectedAddressIs,
              //       "pincode": pincodeController.text,
              //       "contact_number": mobileController.text,
              //       "latitude": 24.2342525,
              //       "longitude": 52.2342523
              //     };
              //     print("map address" + data.toString());
              //
              //     CartRepository()
              //         .putAddressApi(data, widget.addressList.id!)
              //         .then((value) {
              //       Navigator.of(context).pushReplacement(
              //         MaterialPageRoute(
              //           builder: (context) => SavedAddressDetails(
              //               /*   cartForPaymentPayload: widget.cartForPaymentPayload!*/),
              //         ),
              //       );
              //       Utils.successToast('Address update successfully!');
              //     });
              //
              //     // Utils.successToast("New Address added successfully");
              //
              //   } else {
              //     Map data = {
              //       "name": fullNameController.text,
              //       "address_line_1": houseBuildingController.text,
              //       "address_line_2": areaColonyController.text,
              //       "city_name": cityController.text,
              //       "state_name": stateController.text,
              //       "address_type": selectedAddressIs,
              //       "pincode": pincodeController.text,
              //       "contact_number": "+91 " + mobileController.text,
              //       "latitude": 24.2342525,
              //       "longitude": 52.2342523
              //     };
              //     print("map address" + data.toString());
              //
              //     CartRepository()
              //         .putAddressApi(data, widget.addressList.id!)
              //         .then((value) {
              //       Navigator.of(context).pushReplacement(
              //         MaterialPageRoute(
              //           builder: (context) => SavedAddressDetails(
              //               /*   cartForPaymentPayload: widget.cartForPaymentPayload!*/),
              //         ),
              //       );
              //       Utils.successToast('Address update successfully!');
              //     });
              //   }
              //
              //   var userId;
              //   if (StringConstant.UserLoginId.toString() == '' ||
              //       StringConstant.UserLoginId.toString() == null) {
              //     userId = StringConstant.RandomUserLoginId;
              //   } else {
              //     userId = StringConstant.UserLoginId;
              //   }
              //
              //   print("USER LOGIN ID..............." +
              //       StringConstant.UserLoginId.toString());
              //   if (_formKey.currentState!.validate() &&
              //       fullNameController.text.isNotEmpty &&
              //       mobileController.text.isNotEmpty &&
              //       houseBuildingController.text.isNotEmpty &&
              //       areaColonyController.text.isNotEmpty &&
              //       stateController.text.isNotEmpty &&
              //       cityController.text.isNotEmpty &&
              //       pincodeController.text.isNotEmpty) {
              //     if (widget.isSavedAddress == true) {
              //       Map data = {
              //         "name": fullNameController.text,
              //         "address_line_1": houseBuildingController.text,
              //         "address_line_2": areaColonyController.text,
              //         "city_name": cityController.text,
              //         "state_name": stateController.text,
              //         "address_type": selectedAddressIs,
              //         "pincode": pincodeController.text,
              //         "contact_number": "+91 " + mobileController.text,
              //         "latitude": 24.2342525,
              //         "longitude": 52.2342523
              //       };
              //       print("map address" + data.toString());
              //
              //       CartRepository()
              //           .createAddressPostAPI(data, userId.toString())
              //           .then((value) {
              //         setState(() {});
              //         // fullNameController.clear();
              //         // mobileController.clear();
              //         // houseBuildingController.clear();
              //         // areaColonyController.clear();
              //         // stateController.clear();
              //         // cityController.clear();
              //         // pincodeController.clear();
              //         Utils.successToast("New Address added successfully");
              //         Navigator.of(context)
              //             .pushNamed(RoutesName.saveAddressRoute)
              //             .then((value) => setState(() {}));
              //
              //         // Navigator.of(context).pushReplacement(
              //         //   MaterialPageRoute(
              //         //     builder: (context) =>
              //         //         SavedAddressDetails(
              //         //           /* cartForPaymentPayload:
              //         //       widget.cartForPaymentPayload*/
              //         //         ),
              //         //   ),
              //         // );
              //       }).then((value) {});
              //     } else {
              //       Map data = {
              //         "name": fullNameController.text,
              //         "address_line_1": houseBuildingController.text,
              //         "address_line_2": areaColonyController.text,
              //         "city_name": cityController.text,
              //         "state_name": stateController.text,
              //         "address_type": selectedAddressIs,
              //         "pincode": pincodeController.text,
              //         "contact_number": "+91 " + mobileController.text,
              //         "latitude": 24.2342525,
              //         "longitude": 52.2342523
              //       };
              //       print("map address" + data.toString());
              //       print("widget.cartForPaymentPayload.userId!" +
              //           userId.toString());
              //
              //       CartRepository()
              //           .createAddressPostAPI(data, userId.toString())
              //           .then((value) {
              //         Utils.successToast("New Address added successfully");
              //       });
              //     }
              //   }
              //   //comment because need to manage apis
              //
              //   /*       Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => OrderReviewSubActivity(cartPayLoad: value),
              //     ),
              //   );*/
              // }

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
                    stateController.text.isNotEmpty &&
                    cityController.text.isNotEmpty &&
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
                      "contact_number": mobileController.text,
                      "latitude": 24.2342525,
                      "longitude": 52.2342523
                    };
                    print("map address" + data.toString());

                    CartRepository()
                        .putAddressApi(data, widget.addressList.id!)
                        .then((value) {
                      setState(() {});
                      // fullNameController.clear();
                      // mobileController.clear();
                      // houseBuildingController.clear();
                      // areaColonyController.clear();
                      // stateController.clear();
                      // cityController.clear();
                      // pincodeController.clear();
                      Utils.successToast("Address updated successfully");
                      Navigator.of(context)
                          .pushNamed(RoutesName.saveAddressRoute)
                          .then((value) => setState(() {}));

                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         SavedAddressDetails(
                      //           /* cartForPaymentPayload:
                      //       widget.cartForPaymentPayload*/
                      //         ),
                      //   ),
                      // );
                    }).then((value) {});
                  } else {
                    Map data = {
                      "name": fullNameController.text,
                      "address_line_1": houseBuildingController.text,
                      "address_line_2": areaColonyController.text,
                      "city_name": cityController.text,
                      "state_name": stateController.text,
                      "address_type": selectedAddressIs,
                      "pincode": pincodeController.text,
                      "contact_number": mobileController.text,
                      "latitude": 24.2342525,
                      "longitude": 52.2342523
                    };
                    print("map address" + data.toString());
                    print("widget.cartForPaymentPayload.userId!" +
                        userId.toString());

                    CartRepository()
                        .putAddressApi(data, widget.addressList.id!)
                        .then((value) {
                      Utils.successToast("Address updated successfully");
                    }).then((value) {
                      var isBuyNow = prefs.getString('isBuyNow');
                      var directCartId = prefs.getString('directCartIdPref');
                      if (isBuyNow == 'true') {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => OrderReviewActivity(
                              cartId: int.parse(directCartId.toString()),
                            ),
                          ),
                        );
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => OrderReviewActivity(
                              cartId: int.parse(StringConstant.UserCartID),
                            ),
                          ),
                        );
                      }
                    });
                    // Navigator.of(context).pushNamed(RoutesName.saveAddressRoute);

                    // Navigator.pop(context);
                    // Navigator.pop(context);
                  }
                  /*                Prefs.instance.setToken(
                              StringConstant.selectedFullAddressPref,
                              StringConstant.selectedFullAddress);

                          Prefs.instance.setToken(StringConstant
                              .selectedFullNamePref,
                              StringConstant.selectedFullName);

                          Prefs.instance.setToken(StringConstant
                              .selectedMobilePref,
                              StringConstant.selectedMobile);

                          StringConstant.selectedTypeOfAddress =
                              selectedAddressIs;
                          Prefs.instance.setToken(
                              StringConstant.selectedTypeOfAddressPref,
                              StringConstant.selectedTypeOfAddress);*/
                } else {
                  Utils.flushBarErrorMessage(
                      "Please enter all details", context);
                }
              });
            })
          ],
        ));
      }),
    );
  }

  int isHome = 0;
  String selectedAddressIs = "";

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
                  isHome = 0;
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
                    color: isHome == 0
                        ? ThemeApp.tealButtonColor
                        : ThemeApp.whiteColor,
                  ),
                  child: Text(
                    StringUtils.home,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                        color: isHome == 0
                            ? ThemeApp.whiteColor
                            : ThemeApp.blackColor,
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
                isHome = 1;
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
                  color: isHome == 1
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
                      color: isHome == 1
                          ? ThemeApp.whiteColor
                          : ThemeApp.blackColor,
                      letterSpacing: -0.25),
                )),
          ),
        ),
        SizedBox(
          width: width * 0.03,
        ),
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
                  isHome = 2;
                  selectedAddressIs = StringUtils.other;
                });
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40),
                    ),
                    border: Border.all(color: ThemeApp.tealButtonColor),
                    color: isHome == 2
                        ? ThemeApp.tealButtonColor
                        : ThemeApp.whiteColor,
                  ),
                  child: Text(
                    StringUtils.other,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                        color: isHome == 2
                            ? ThemeApp.whiteColor
                            : ThemeApp.blackColor,
                        letterSpacing: -0.25),
                  ))),
        ),
      ]),
    );
  }

/*
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
*/
}
