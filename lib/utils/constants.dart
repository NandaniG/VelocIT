import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StringConstant {
  static TextEditingController controllerSpeechToText =
      new TextEditingController();

  static String placesFromCurrentLocation = '';
  static String addressFromCurrentLocation = 'Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India - 380021';
  static var getCartList_FromPref;

  // static String speechToText='';
//user account pref

  static String userAccountNamePref = 'userAccountNamePref';
  static String userAccountEmailPref = 'userAccountEmailPref';
  static String userAccountMobilePref = 'userAccountMobilePref';
  static String userAccountPassPref = 'userAccountPassPref';

  static String userAccountName = 'use name';
  static String userAccountEmail = 'test@gmail.com';
  static String userAccountMobile = '5248632252';
  static String userAccountPass = '';

  //shared preferences
  static String emailPref = 'emailPref';
  static String userNamePref = 'userNamePref';
  static String pinCodePref = 'pinCodePref';
  static String addressPref = 'addressPref';

  //shared preferences productsList
  static String serviceImage = 'serviceImage';
  static String serviceName = 'serviceName';
  static String sellerName = 'sellerName';
  static String ratting = 'ratting';
  static String discountPrice = 'discountPrice';
  static String originalPrice = 'originalPrice';
  static String totalPrice = 'totalPrice';
  static String offerPercent = 'offerPercent';
  static String availableVariants = 'availableVariants';
  static String cartProductsLength = 'cartProductsLength';
  static String serviceDescription = 'serviceDescription';
  static String conterProducts = 'conterProducts';
  static String deliveredBy = 'deliveredBy';
  static String availableCounter = 'availableCounter';

  static String cartListForPreferenceKey = 'cartListForPreferenceKey';

  ///store value of shared preferences productsList
  static String serviceImageGetValues = '';
  static String serviceNameGetValues = '';
  static String sellerNameGetValues = '';
  static String rattingGetValues = '';
  static String discountPriceGetValues = '';
  static String originalPriceGetValues = '';
  static String offerPercentGetValues = '';
  static String availableVariantsGetValues = '';
  static String cartProductsLengthGetValues = '';
  static String serviceDescriptionGetValues = '';
  static String conterProductsGetValues = '';
  static String deliveredByGetValues = '';

  static int availableCounterValues = 0;
  static var rupeesSymbol = '\u20B9';

//cart price
  static String totalOriginalPricePref = 'totalOriginalPricePref';
  static String totalFinalPricePref = 'totalFinalPricePref';
  static String totalDiscountPricePref = 'totalDiscountPricePref';
  static String totalDeliveryChargePricePref = 'totalDeliveryChargePricePref';
  static String totalGrandAmountPref = 'totalGrandAmountPref';

  static double totalOriginalPrice = 0.0;
  static double totalFinalPrice = 0.0;
  static double totalDiscountPrice = 0.0;
  static double totalDeliveryChargePrice = 0.0;
  static double totalGrandAmount = 0.0;

  ///dashboard strings
  static String recommendedForYou = 'Recommended for you';
  static String merchantNearYou = 'Merchant near you';
  static String viewAll = 'View All';
  static String bestDeal = 'Best Deal';
  static String budgetBuys = 'Budget Buys';

  ///auth Strings
  static String signin = 'Sign In';
  static String signinSubTitle =
      'Provide below details to continue your shopping';
  static String usingPass = "Using Password";
  static String usingOTP = "Using OTP";
  static String emailORMobile = "Email Address / Mobile Number";
  static String password = 'Password';
  static String email = 'Email';

  //error text
  static String emailError = 'please enter email';
  static String passwordError = 'please enter password';
  static String validEmailError = 'Please enter a valid email or phone number.';
  static String validPasswordError = 'Please enter a valid password.';
  static String forgotPassword = 'Forgot Password?';
  static String sendOtp = 'Send OTP';

  ///validations
  String emailRegExp =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool isEmail(String input) => RegExp(emailRegExp).hasMatch(input);

  // 10 to 12 digit validation
  // bool isPhone(String input) =>
  //     RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
  //         .hasMatch(input);

  //10digit validation
  bool isPhone(String input) =>
      RegExp(r"^[0-9]{10}$")
          .hasMatch(input);

  bool isPass(String input) => RegExp(
          "^(?=.{6,19}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>]).*")
      .hasMatch(input);

  static JsonDecoder decoder = JsonDecoder();
  static JsonEncoder encoder = JsonEncoder.withIndent('  ');

  static void prettyPrintJson(String input) {
    var object = decoder.convert(input);
    var prettyString = encoder.convert(object);
    print(
        "_______________________________Json Printer_______________________________________");

    prettyString.split('\n').forEach((element) {
      print(element);
    });
  }
  static void printObject(Object object) {
    // Encode your object and then decode your object to Map variable
    Map jsonMapped = json.decode(json.encode(object));

    // Using JsonEncoder for spacing
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');

    // encode it to string
    String prettyPrint = encoder.convert(jsonMapped);

    // print or debugPrint your object
    debugPrint(prettyPrint);
  }
  static var indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹ ',
  );
}

class SizeConfig {
  static MediaQueryData? mediaQueryData;
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double blockSizeHorizontal = 0.0;
  static double blockSizeVertical = 0.0;
  static double? orientations;

  static void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
    blockSizeHorizontal = (screenWidth / 100);
    blockSizeVertical = (screenHeight / 100);
    orientations = (MediaQuery.of(context).orientation == Orientation.landscape)
        as double?;

    double height = 0.0;
    double width = 0.0;

    heightConstant(BuildContext context) {
      height = MediaQuery.of(context).size.height;
    }

    widthConstant(BuildContext context) {
      width = MediaQuery.of(context).size.width;
    }
  }
}
