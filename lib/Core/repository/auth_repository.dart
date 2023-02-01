import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/repository/cart_repository.dart';
import 'package:velocit/pages/screens/cartDetail_Activity.dart';

import '../../pages/Activity/Order_CheckOut_Activities/OrderReviewScreen.dart';
import '../../pages/auth/OTP_Screen.dart';
import '../../pages/screens/dashBoard.dart';
import '../../utils/constants.dart';
import '../../utils/routes/routes.dart';
import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../ViewModel/cart_view_model.dart';

class AuthRepository {
  /// FINAL API FOR LOGIN USING EMAIL AND PASSWORD

  Future postApiUsingEmailPasswordRequest(
      Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.loginViaEmailPassword;

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(responseJson.toString(), 'Login Response:');

    if (jsonData['status'].toString() == 'OK') {
      prefs.setString(
          StringConstant.testId, jsonData['payload']['body']['id'].toString());
      // Prefs.instance.setToken(StringConstant.userId, id.toString());

      var loginId = await Prefs.instance.getToken(StringConstant.userId);
      final preferences = await SharedPreferences.getInstance();
      preferences.setInt('isUserLoggedIn', 1);
      preferences.setString(
          'isUserId', jsonData['payload']['body']['id'].toString());
      preferences.setString(
          'usernameLogin', jsonData['payload']['body']['username'].toString());
      preferences.setString(
          'emailLogin', jsonData['payload']['body']['email'].toString());

      print("LoginId : .. " + loginId.toString());

      StringConstant.isLogIn = true;
      Utils.successToast('User login successfully');

      StringConstant.isUserNavigateFromDetailScreen =
          (prefs.getString('isUserNavigateFromDetailScreen')) ?? "";
      StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
      print("Cart Id From Login usinh Email " + StringConstant.UserCartID);
      print("StringConstant.isUserNavigateFromDetailScreen" +
          StringConstant.isUserNavigateFromDetailScreen);
      var userId = preferences.getString('isUserId');
      if (StringConstant.isUserNavigateFromDetailScreen == 'Yes') {
        var cartUserId = prefs.getString('CartSpecificUserIdPref');
        var itemCode = prefs.getString('CartSpecificItem_codePref');
        var itemQuanity = prefs.getString('CartSpecificItemQuantityPref');
        StringConstant.RandomUserLoginId =
            (prefs.getString('RandomUserId')) ?? '';
        Map data = {
          'user_id': jsonData['payload']['body']['id'],
          'item_code': itemCode,
          'qty': itemQuanity
        };

        data = {'userId': jsonData['payload']['body']['id'].toString()};
        print('login user is NOT GUEST');

        print("create cart data pass : " + data.toString());
        //create cart
        CartRepository().cartPostRequest(data, context);
        //merge cart
        print("Random ID : " + StringConstant.RandomUserLoginId);

        CartRepository().mergeCartList(
            StringConstant.RandomUserLoginId, userId.toString(), data, context);
      } else if (StringConstant.isUserNavigateFromDetailScreen == 'BN') {
 /*       Map data = {'userId': jsonData['payload']['body']['id'].toString()};
        print("create cart data pass for Direct buy now: " + data.toString());
        CartRepository()
            .mergeCartList(StringConstant.RandomUserLoginId, userId.toString(),
                data, context)
            .then((value) {
          CartRepository().buyNowGetRequest(userId.toString(), context);
        });*/
        CartRepository().buyNowGetRequest(userId.toString(), context);

      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

  /// FINAL API FOR LOGIN USING MOBILE AND OTP

  Future postApiForMobileOTPRequest(Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.loginViaMobileOTP;
    print(url);
    print(jsonMap['mobile']);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'Login Using Mobile OTP Response:');
    if (jsonData['status'].toString() == 'OK') {
      prefs.setString(
          StringConstant.setOtp, jsonData['payload']['otp'].toString());
      String mobile = jsonMap['mobile'].toString();
      Utils.successToast(jsonData['payload']['otp'].toString());

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OTPScreen(
                mobileNumber: mobile.toString(),
                OTP: jsonData['payload']['otp'].toString(),
                Uname: jsonData['payload']['username'].toString(),
                UID: jsonData['payload']['user_id'].toString(),
              )));
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

  /// FINAL API FOR LOGIN USING EMAIL AND OTP

  Future postApiForEmailOTPRequest(Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.loginViaEmailOTP;
    print(url);
    print(jsonMap['email']);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'Login Using Email OTP Response:');

    if (jsonData['status'].toString() == 'OK') {
      prefs.setString(
          StringConstant.setOtp, jsonData['payload']['otp'].toString());
      String mobile = jsonMap['email'].toString();
      Utils.successToast(jsonData['payload']['otp'].toString());
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OTPScreen(
                mobileNumber: mobile.toString(),
                OTP: jsonData['payload']['otp'].toString(),
                Uname: jsonData['payload']['username'].toString(),
                UID: jsonData['payload']['user_id'].toString(),
              )));
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

  /// FINAL API FOR VALIDATING OTP

  Future postApiForValidateOTP(Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.validateOTP;
    print(url);
    print(jsonMap);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'Validate OTP Response:');
    if(response.statusCode == 200){

    if (jsonData['status'].toString() == 'OK') {

      prefs.setString(
          StringConstant.testId, jsonData['payload']['id'].toString());
      // Prefs.instance.setToken(StringConstant.userId, id.toString());

      var loginId = await Prefs.instance.getToken(StringConstant.userId);
      final preferences = await SharedPreferences.getInstance();
      preferences.setInt('isUserLoggedIn', 1);
      preferences.setString(
          'isUserId', jsonData['payload']['id'].toString());
      preferences.setString(
          'usernameLogin', jsonData['payload']['username'].toString());
      preferences.setString(
          'emailLogin', jsonData['payload']['email'].toString());

      print("LoginId : .. " + loginId.toString());

      StringConstant.isLogIn = true;
      Utils.successToast('User login successfully');

      StringConstant.isUserNavigateFromDetailScreen =
          (prefs.getString('isUserNavigateFromDetailScreen')) ?? "";
      StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
      print("Cart Id From Login usinh Email " + StringConstant.UserCartID);
      print("StringConstant.isUserNavigateFromDetailScreen" +
          StringConstant.isUserNavigateFromDetailScreen);
      var userId = preferences.getString('isUserId');
      if (StringConstant.isUserNavigateFromDetailScreen == 'Yes') {
        var cartUserId = prefs.getString('CartSpecificUserIdPref');
        var itemCode = prefs.getString('CartSpecificItem_codePref');
        var itemQuanity = prefs.getString('CartSpecificItemQuantityPref');
        StringConstant.RandomUserLoginId =
            (prefs.getString('RandomUserId')) ?? '';
        Map data = {
          'user_id': jsonData['payload']['id'],
          'item_code': itemCode,
          'qty': itemQuanity
        };

        data = {'userId': jsonData['payload']['id'].toString()};
        print('login user is NOT GUEST');

        print("create cart data pass : " + data.toString());
        //create cart
        CartRepository().cartPostRequest(data, context);
        //merge cart
        print("Random ID : " + StringConstant.RandomUserLoginId);

        CartRepository().mergeCartList(
            StringConstant.RandomUserLoginId, userId.toString(), data, context);
      } else if (StringConstant.isUserNavigateFromDetailScreen == 'BN') {
        /*       Map data = {'userId': jsonData['payload']['body']['id'].toString()};
        print("create cart data pass for Direct buy now: " + data.toString());
        CartRepository()
            .mergeCartList(StringConstant.RandomUserLoginId, userId.toString(),
                data, context)
            .then((value) {
          CartRepository().buyNowGetRequest(userId.toString(), context);
        });*/
        CartRepository().buyNowGetRequest(userId.toString(), context);

      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(RoutesName.dashboardRoute, (route) => false).then((value) {

        });      }
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }}else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
 /*   if (jsonData['status'].toString() == 'OK') {
      prefs.setString(
          StringConstant.testId, jsonData['payload']['id'].toString());
      // Prefs.instance.setToken(StringConstant.userId, id.toString());

      var loginId = await Prefs.instance.getToken(StringConstant.userId);
      final preferences = await SharedPreferences.getInstance();
      preferences.setInt('isUserLoggedIn', 1);
      preferences.setString('isUserId', jsonData['payload']['id'].toString());
      preferences.setString(
          'usernameLogin', jsonData['payload']['username'].toString());
      preferences.setString(
          'emailLogin', jsonData['payload']['email'].toString());

      print("LoginId : .. " + loginId.toString());

      StringConstant.isLogIn = true;
      Utils.successToast('User login successfully');

      StringConstant.isUserNavigateFromDetailScreen =
          (prefs.getString('isUserNavigateFromDetailScreen')) ?? "";
      StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
      print("Cart Id From OTP verify API  " + StringConstant.UserCartID);
      print("StringConstant.isUserNavigateFromDetailScreen" +
          StringConstant.isUserNavigateFromDetailScreen);

      if (StringConstant.isUserNavigateFromDetailScreen == 'Yes') {
        var cartUserId = prefs.getString('CartSpecificUserIdPref');
        var itemCode = prefs.getString('CartSpecificItem_codePref');
        var itemQuanity = prefs.getString('CartSpecificItemQuantityPref');

        Map data = {
          'user_id': jsonData['payload']['id'].toString(),
          'item_code': itemCode,
          'qty': itemQuanity
        };

        StringConstant.RandomUserLoginId =
            (prefs.getString('RandomUserId')) ?? '';
        print("Random ID : " + StringConstant.RandomUserLoginId);

        CartRepository().mergeCartList(StringConstant.RandomUserLoginId,
            jsonData['payload']['id'].toString(), data, context);
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => CartDetailsActivity()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }*/
  }
}
