import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  //set Preferences
  Future<void> setDoubleToken(String key, double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

//get Preferences
  Future<double?> getDoubleToken(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    double? Key;
    Key = pref.getDouble(key) ?? 0.0;
    return Key;
  }
//get Preferences
  clear() async {
     SharedPreferences pref = await SharedPreferences.getInstance();
   pref.clear();
  }
  //set Preferences
  Future<void> setToken(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

//get Preferences
  Future<String?> getToken(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? Key;
    Key = pref.getString(key) ?? '';
    return Key;
  }


  //set Preferences
  Future<void> setTokenList(String key, List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

//get Preferences
  Future<List<String>> getTokenList(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? Key;
    Key = pref.getStringList(key) ?? [];
    return Key;
  }

  getRupeesString(String value) {
    return Text("${'\u20A8' +value}");
  }


}
