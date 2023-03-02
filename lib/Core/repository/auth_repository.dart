import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/Core/repository/cart_repository.dart';
import 'package:velocit/pages/auth/sign_in.dart';
import 'package:velocit/pages/screens/cartDetail_Activity.dart';

import '../../pages/Activity/Order_CheckOut_Activities/OrderReviewScreen.dart';
import '../../pages/auth/OTP_Screen.dart';
import '../../pages/auth/forgot_password.dart';
import '../../pages/screens/dashBoard.dart';
import '../../utils/constants.dart';
import '../../utils/routes/routes.dart';
import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/userModel.dart';
import '../ViewModel/cart_view_model.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'dart:convert';
class AuthRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  /// FINAL API FOR LOGIN USING EMAIL AND PASSWORD

  Future postApiUsingEmailPasswordRequest(
      Map jsonMap,String fcmToken, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.loginViaEmailPassword;

    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(responseJson.toString(), 'Login Response:');

    if (jsonData['status'].toString() == 'OK') {
      AuthRepository()
          .getUserDetailsById(jsonData['payload']['body']['id'].toString());
//api for passing fcm token
      passFCMToken(jsonData['payload']['body']['id'].toString(), fcmToken);


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
          StringConstant.isUserNavigateFromDetailScreen.toString());
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
      } else if (StringConstant.isUserNavigateFromDetailScreen == 'IsGuest') {
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
      }
      // 259745353
      else if (StringConstant.isUserNavigateFromDetailScreen == 'BN') {
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

  Future postApiForMobileOTPRequest(
      Map jsonMap, bool isForgotPass, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.loginViaMobileOTP;
    print(url);
    print(jsonMap['mobile']);
    HttpClient httpClient = HttpClient();
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
      prefs.setString(
          'userIdFromOtp', jsonData['payload']['user_id'].toString());
      prefs.setString(
          'userNameFromOtp', jsonData['payload']['username'].toString());
      String mobile = jsonMap['email'].toString();
      Utils.successToast(jsonData['payload']['otp'].toString());

      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => OTPScreen(
      //           mobileNumber: mobile.toString(),
      //           OTP: jsonData['payload']['otp'].toString(),
      //           Uname: jsonData['payload']['username'].toString(),
      //           UID: jsonData['payload']['user_id'].toString(),
      //           isForgotPass: isForgotPass,
      //         )));
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

  /// FINAL API FOR LOGIN USING EMAIL AND OTP

  Future postApiForEmailOTPRequest(
      Map jsonMap, bool isForgotPass, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.loginViaEmailOTP;
    print(url);
    print(jsonMap['email']);
    HttpClient httpClient = HttpClient();
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
      prefs.setString(
          'userIdFromOtp', jsonData['payload']['user_id'].toString());
      prefs.setString(
          'userNameFromOtp', jsonData['payload']['username'].toString());
      String mobile = jsonMap['email'].toString();
      Utils.successToast(jsonData['payload']['otp'].toString());
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => OTPScreen(
      //           mobileNumber: mobile.toString(),
      //           OTP: jsonData['payload']['otp'].toString(),
      //           Uname: jsonData['payload']['username'].toString(),
      //           UID: jsonData['payload']['user_id'].toString(),
      //           isForgotPass: isForgotPass,
      //         )));
    } else {
      Utils.errorToast("Please enter valid details.");

      httpClient.close();
      return responseJson;
    }
  }

  /// FINAL API FOR VALIDATING OTP

  Future postApiForValidateOTP(
      Map jsonMap, bool isForgotPass,String fcmToken, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.BASEAPI + ApiMapping.validateOTP;
    print(url);
    print(jsonMap);
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'Validate OTP Response:');
    if (jsonData['status'].toString() == 'OK') {
      AuthRepository().getUserDetailsById(jsonData['payload']['id'].toString());
      //api for passing fcm token
      passFCMToken(jsonData['payload']['id'].toString(), fcmToken);

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
      print("Cart Id From Login usinh Email " + StringConstant.UserCartID);
      print("StringConstant.isUserNavigateFromDetailScreen" +
          StringConstant.isUserNavigateFromDetailScreen.toString());
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
      } else if (StringConstant.isUserNavigateFromDetailScreen == 'IsGuest') {
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
      }
      // 259745353
      else if (StringConstant.isUserNavigateFromDetailScreen == 'BN') {
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

//get user details
  Future<UserModel> getUserDetailsById(String id) async {
    var url = ApiMapping.getURI(apiEndPoint.user_get);
    print("user specific ID : " + url + id.toString());
    final prefs = await SharedPreferences.getInstance();

    try {
      dynamic response = await _apiServices.getGetApiResponse(url + id);
      print("user Specific Id : " + response.toString());
      print("user Specific email : " + response['payload']['email']);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
          'userProfileNamePrefs', response['payload']['username'].toString());
      await prefs.setString(
          'userProfileEmailPrefs', response['payload']['email'].toString());
      await prefs.setString(
          'userProfileMobilePrefs', response['payload']['mobile'].toString());
      await prefs.setString(
          'userProfileImagePrefs', response['payload']['image_url'].toString());

      return response = UserModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  //Forgot password
  Future forgotPassRequest(Map jsonMap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic responseJson;
    var url = ApiMapping.BaseAPI + ApiMapping.forgotPasswordGenOtp;
    print(url);
    print(jsonMap);
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    StringConstant.prettyPrintJson(
        responseJson.toString(), 'Forgot Password Response:');

    if (jsonData['status'].toString() == 'OK') {
      String mobile = jsonMap['cred'].toString();

      String result = jsonData['payload'].toString().replaceAll("'", "");
      String result1 = result.toString().replaceAll("{", "");
      String result2 = result1.toString().replaceAll("}", "");
      String OTP = result2.toString().replaceAll("newOtp:", "");
      print(mobile);
      print(OTP);
      // var jsonOtp = json.decode(result3);

      Utils.successToast(OTP.toString());
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ForgotPassOTP(
                mobileNumber: mobile.toString(),
                OTP: OTP.toString(),
              )));
    } else {
      Utils.errorToast("Please enter valid details.");
      httpClient.close();
      return responseJson;
    }
  }

//Reset Password
  Future resetPassRequest(
      Map jsonMap, bool isFromForgotPass, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic responseJson;
    var url = ApiMapping.BaseAPI + ApiMapping.resetPassword;
    print(url);
    print(jsonMap);
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();

    var jsonData = json.decode(responseJson);

    if (jsonData['status'].toString() == 'OK') {
      StringConstant.prettyPrintJson(
          responseJson.toString(), 'Reset Password Response:');
      if (isFromForgotPass == true) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SignIn_Screen()));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(),
            ),
            (route) => false);
      }
    } else {
      Utils.errorToast("Please enter valid details.");
      httpClient.close();
      return responseJson;
    }
  }

  //update profile image
  updateProfileImageApi(File imageFile,String userId, BuildContext context) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var url =
        ApiMapping.BASEAPI + '/user/' + userId + ApiMapping.changeImageWithFile;
    print(url);
    var uri = Uri.parse(url);

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('imageFile', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print("response Image "+response.statusCode.toString());
    response.stream.transform(utf8.decoder).listen((value) {
      print("Image response "+value);
    });
  }

/*  Future updateProfileImageApi(
      dynamic data, String userId, var ImageUrl) async {
    // var url = ApiMapping.getURI(apiEndPoint.put_carts);
    final prefs = await SharedPreferences.getInstance();

    print("userId ID" + userId.toString());
    print("userId ID" + data.toString());

    var url = '/user/$userId/changeimagewithfile';

    Map<String, dynamic> imageMap = {
      "imgUrl": ImageUrl,
    };
    String queryString = Uri(queryParameters: imageMap).query;

    var requestUrl = ApiMapping.BaseAPI + url + '?' + queryString;
    // var requestUrl = ApiMapping.BaseAPI + url;
    print(requestUrl.toString());

    String body = json.encode(data);
    print("updateProfileImageApi Body" + body.toString());

    try {
      dynamic reply;
      http.Response response = await http.put(Uri.parse(requestUrl),
          body: body, headers: {'content-type': 'application/json'});
      print("response update ProfileImage " + response.body.toString());
      var jsonData = json.decode(response.body);
      print("response  update ProfileImage" + jsonData['status'].toString());

      // Utils.successToast(response.body.toString());
      return reply;

      return response;
    } catch (e) {
      throw e;
    }
  }*/

  // update user profile
  Future editUserInfoApi(dynamic data, String userId) async {
    // var url = ApiMapping.getURI(apiEndPoint.put_carts);
    final prefs = await SharedPreferences.getInstance();

    print("userId ID" + userId.toString());

    var url = '/user/$userId/updatebasicinfo';

    var requestUrl = ApiMapping.BaseAPI + url;
    print(requestUrl.toString());

    String body = json.encode(data);
    print("editUserInfoApi jsonMap" + body.toString());

    try {
      dynamic reply;
      http.Response response = await http.post(Uri.parse(requestUrl),
          body: body, headers: {'content-type': 'application/json'});
      print("response update user info " + response.body.toString());
      var jsonData = json.decode(response.body);
      print("response  update user info" + jsonData['status'].toString());

      Utils.successToast('Profile updated successfully');
      return reply;

      return response;
    } catch (e) {
      throw e;
    }
  }

  ///firebase fcm token
  Future passFCMToken(String userId, String fcmToken) async {
    Map<String, String> queryParams = {
      'fcm_token': fcmToken,
    };
    var url = ApiMapping.BaseAPI + '/user/$userId/setfcmtoken';
    String queryString = Uri(queryParameters: queryParams).query;

    var requestUrl = '$url?$queryString';
    print(requestUrl.toString());
    print("response url : " + requestUrl.toString());

    try {
      dynamic reply;
      http.Response response = await http.put(Uri.parse(requestUrl),
          headers: {'content-type': 'application/json'});
      print("response passFCMToken : " + response.body.toString());
      var jsonData = json.decode(response.body);
      print("response  passFCMToken status : " + jsonData['status'].toString());

      // Utils.successToast(response.body.toString());
      return reply;

      return response;
    } catch (e) {
      throw e;
    }
  }
}
