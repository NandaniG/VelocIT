import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:http/http.dart' as http;
import '../../widgets/global/toastMessage.dart';
import '../AppConstant/apiMapping.dart';
import '../Enum/viewState.dart';

class UserService extends ChangeNotifier {
  ViewState _state = ViewState.IDLE;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Map<String, dynamic>? userModel;

  Future<Map<String, dynamic>?> getUser() async {
    var URI = ApiMapping.getURI(apiEndPoint.user_get);
    print("User URI: https://velocitapiqa.fulgorithmapi.com:443/v1/users");
    print("User URI: " + URI);

    var client = http.Client();
    var response = await client.get(Uri.parse(URI));
    print("User json");

    if (response.statusCode == 200) {
      setState(ViewState.IDLE);
      userModel = jsonDecode(response.body);
      print("User json${userModel}");
    } else {
      errorToast("API Error");
    }
    setState(ViewState.BUSY);
    return userModel;
  }
}

class PostUserService extends ChangeNotifier {
  ViewState _state = ViewState.IDLE;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  var userData;

  Future<void> postUserData() async {
    try {
      Map<String, String> body = {
        'displayName': 'Samual Hardy',
        'email': 'Samual@test.com',
        'mobile': '2131113'
      };

      var URI = ApiMapping.getURI(apiEndPoint.user_post);
      // print(
      //     "User post URI: https://velocitapiqa.fulgorithmapi.com:443/v1/users");
      print("User post URI: " + URI);
      var client = http.Client();
      var response = await client.post(
        Uri.parse(URI),
        body: body,
      );
      userData = jsonDecode(response.body);
      print("userData post json${userData}");
      // if (response.statusCode == 200) {
      //   setState(ViewState.IDLE);
      //   userData = jsonDecode(response.body);
      //   print("userData post json${userData}");
      // } else {
      //   errorToast("API Error");
      // }
      setState(ViewState.BUSY);
    } catch (e) {
      throw Exception(e);
    }
  }
}
