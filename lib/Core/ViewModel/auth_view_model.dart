import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:velocit/Core/repository/auth_repository.dart';
import 'package:velocit/utils/routes/routes.dart';

import '../../pages/auth/OTP_Screen.dart';
import '../../pages/screens/dashBoard.dart';
import '../../utils/constants.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();

  String _getOTP = '';

  String get getOTP => _getOTP;

  bool _loadingWithGet = false;

  bool get loadingWithGet => _loadingWithGet;

  bool _loadingWithPost = false;

  bool get loadingWithPost => _loadingWithPost;


  setLoadingWithGet(bool value) {
    _loadingWithGet = value;

    notifyListeners();
  }
  setLoadingWithPost(bool value) {
    _loadingWithPost = value;

    notifyListeners();
  }

  Future<void> loginApiWithGet( BuildContext context) async {
    setLoadingWithGet(true);
    _myRepo.loginApiWithGet().then((value) async {
      setLoadingWithGet(false);
      if (kDebugMode) {
        print("Login Api With Get: $value");
        print("Login Api With Get: ${value!["response"]["body"]["payload"]}");
      }
        _getOTP = value!["response"]["body"]["payload"].toString();
      print("Login Api With Get: $_getOTP");

      Prefs.instance.setToken("otpKey", _getOTP);
        Utils.successToast(value!["response"]["body"]["payload"].toString());

        Navigator.pushNamed(context, RoutesName.otpRoute);
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => OTPScreen(),
        //   ),
        // );

    }).onError((error, stackTrace) {
      setLoadingWithGet(false);

      if (kDebugMode) {
        Utils.flushBarErrorMessage(error.toString(), context);
        print(error.toString());
      }
    });
  }

  Future<void> loginApiWithPost(dynamic data, BuildContext context) async {
    setLoadingWithPost(true);
    _myRepo.loginApiWithPost(data).then((value) {
      setLoadingWithPost(false);
      if (kDebugMode) {
        print("Login Api With Post : $value");
      }

      StringConstant.isLogIn = true;
      Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute);
    }).onError((error, stackTrace) {
      setLoadingWithPost(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(error.toString(), context);

        print(error.toString());
      }
    });
  }
}
