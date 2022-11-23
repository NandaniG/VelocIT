import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/widgets/global/toastMessage.dart';

import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../Enum/viewState.dart';
import '../Model/authenticateModel.dart';
import '../Model/authenticateWithUIDModel.dart';

class AuthenticateService extends ChangeNotifier {
  ViewState _state = ViewState.IDLE;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
  var auth;
  var Otp;
  Map<String, dynamic>? authenticateModel;

  Future<Map<String, dynamic>?> getAuthentication() async {
    var URI = ApiMapping.getURI(apiEndPoint.signIn_authenticate_get);
    var client = http.Client();
    var response = await client.get(Uri.parse(URI));
    print("AuthenticateModel json");

    if (response.statusCode == 200) {
      setState(ViewState.IDLE);
      auth = jsonDecode(response.body);
      authenticateModel = auth;
      print("AuthenticateModel json${auth}");
      successToast(authenticateModel!["payload"]["otp"].toString());
      await Prefs().setToken("otpKey", auth["payload"]["otp"].toString());

      Otp = auth["payload"]["otp"].toString();
    } else {
      errorToast("API Error");
    }
    setState(ViewState.BUSY);
    return authenticateModel;
  }
}

class AuthenticateWithUIDService extends ChangeNotifier {
  ViewState _state = ViewState.IDLE;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  var authWithUID;
  var Otp;
  AuthenticateWithUIDModel? authWithUIDModel;
  Future<AuthenticateWithUIDModel?> getAuthenticationWithUID(String userName) async {
    try {
      Map<String, String> body = {'username': 'testuser@test.com'};
      var URI = ApiMapping.getURI(apiEndPoint.signIn_authenticateWithUID_post);
      var client = http.Client();
      var response = await client.post(
        Uri.parse(URI),
        body: body,
      );
      if (response.statusCode == 200) {
        setState(ViewState.IDLE);
        authWithUID = jsonDecode(response.body);
        authWithUIDModel=authWithUID;
        print("AuthenticateWithUIDModel json${authWithUID}");

        Otp = authWithUID["payload"]["otp"].toString();
      } else {
        errorToast("API Error");

      }
      setState(ViewState.BUSY);
      return authWithUIDModel;
    } catch (e) {
      throw Exception(e);
    }
  }

}
