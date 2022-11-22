import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/widgets/global/toastMessage.dart';

import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../Enum/viewState.dart';
import '../Model/authenticateWithUIDModel.dart';

class AuthenticateWithUIDService extends ChangeNotifier{

var authWithUID;
var Otp;

  Future<AuthenticateWithUIDModel> getAuthentication() async {
    var URI = ApiMapping.getURI(apiEndPoint.signIn_authenticate_get);

    var client = http.Client();
    var response = await client.get(Uri.parse(URI));
    print("AuthenticateWithUIDModel json");

    if (response.statusCode == 200) {
      setState(ViewState.IDLE);
      authWithUID = jsonDecode(response.body);
      print("AuthenticateWithUIDModel json${authWithUID}");
      print("AuthenticateWithUIDModel OTP${authWithUID["payload"]["otp"]}");

      successToast(authWithUID["payload"]["otp"].toString());
     await Prefs().setToken("otpKey", authWithUID["payload"]["otp"].toString());

     Otp= authWithUID["payload"]["otp"].toString();


    }else{
      errorToast(authWithUID["message"].toString());
    }
    setState(ViewState.BUSY);
return authWithUID;
  }

  ViewState _state = ViewState.IDLE;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
