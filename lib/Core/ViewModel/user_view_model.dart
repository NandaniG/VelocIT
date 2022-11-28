import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Model/authenticateModel.dart';

class UserViewModel with ChangeNotifier {
  Future<bool> saveUser(AuthenticateModel authModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('token', authModel.payload!.otp!);
    notifyListeners();
    return true;
  }

  Future<Payload> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? otp = prefs.getInt('token');
    return Payload(otp: otp);
  }

  Future<bool> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
