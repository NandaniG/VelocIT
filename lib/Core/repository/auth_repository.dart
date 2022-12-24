import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/Core/data/network/baseApiServices.dart';
import 'package:velocit/Core/data/network/networkApiServices.dart';

import '../../pages/screens/dashBoard.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../ViewModel/apiCalling_viewmodel.dart';

class AuthRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> loginApiWithGet() async {
    var url = ApiMapping.getURI(apiEndPoint.signIn_authenticate_get);

    try {
      dynamic resposnse = await _apiServices.getGetApiResponse(url);
      return resposnse;
    } catch (e) {
      throw e;
    }
  }

  // Future<dynamic> loginApiWithPost(dynamic data) async {
  //   var url = ApiMapping.getURI(apiEndPoint.signIn_authenticateWithUID_post);
  //
  //   try {
  //     dynamic resposnse = await _apiServices.getPostApiResponse(url, data);
  //     return resposnse;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<dynamic> authSignInUsingPost(dynamic data) async {
    var url = ApiMapping.getURI(apiEndPoint.auth_signIn_using_post);

    try {
      dynamic resposnse = await _apiServices.getPostApiResponse(url, data);
      return resposnse;
    } catch (e) {
      throw e;
    }
  }


  Future postApiUsingEmailRequest(Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.getURI(apiEndPoint.auth_signIn_using_post);

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();
    String rawJson = responseJson.toString();
    print(responseJson.toString());

    Map<String, dynamic> map = jsonDecode(rawJson);
    int id = map['id'];

    if (response.statusCode == 200) {
      print(responseJson.toString());
      String userId = id.toString();
      print("UserId from Api" + userId);
      // prefs.setString(StringConstant.userId, userId);
      prefs.setString(StringConstant.testId, userId);
      // Prefs.instance.setToken(StringConstant.userId, id.toString());

      var loginId = await Prefs.instance.getToken(StringConstant.userId);
      final preferences = await SharedPreferences.getInstance();
      preferences.setInt('isUserLoggedIn',1);
      preferences.setString('isUserId',id.toString());

      print("LoginId : .. " + loginId.toString());
      StringConstant.isLogIn = true;
      Utils.successToast(id.toString());

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardScreen()));
    } else {
      Utils.errorToast("System is busy, Please try after sometime.");
    }

    httpClient.close();
    return responseJson;
  }
/*  Future<void> _loadCounter() async {
    String isUserLoginPref = 'isUserLoginPref';

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      StringConstant.isUserLoggedIn = (prefs.getInt(isUserLoginPref) ?? 0);

    });
  }
  //Incrementing counter after click
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    String isUserLoginPref = 'isUserLoginPref';
    setState(() {
      StringConstant.isUserLoggedIn = (prefs.getInt(isUserLoginPref) ?? 0) + 1;
      prefs.setInt('counter',      StringConstant.isUserLoggedIn);


    });
  }*/
  // I/flutter ( 7520): SignUp Data {username: NandaniTesting, password: Nandani@123, email: nandanig@codeelan.com, mobile: 7878787878}

  // Future postApiUsingMobileRequest(Map jsonMap, BuildContext context) async {
  //   dynamic responseJson;
  //   var url = ApiMapping.getURI(apiEndPoint.auth_signIn_using_post);
  //
  //   HttpClient httpClient = new HttpClient();
  //   HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  //   request.headers.set('content-type', 'application/json');
  //   request.add(utf8.encode(json.encode(jsonMap)));
  //
  //   HttpClientResponse response = await request.close();
  //   // todo - you should check the response.statusCode
  //   responseJson = await response.transform(utf8.decoder).join();
  //   String rawJson = responseJson.toString();
  //   print(responseJson.toString());
  //
  //   Map<String, dynamic> map = jsonDecode(rawJson);
  //   int id = map['id'];
  //
  //   if (response.statusCode == 200) {
  //     Prefs.instance.setToken(StringConstant.userId, id.toString());
  //     StringConstant.isLogIn = true;
  //     print(responseJson.toString());
  //     Utils.successToast(id.toString());
  //
  //     Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => DashboardScreen()));
  //   } else {
  //     Utils.errorToast("System is busy, Please try after sometime.");
  //   }
  //
  //   httpClient.close();
  //   return responseJson;
  // }
}
