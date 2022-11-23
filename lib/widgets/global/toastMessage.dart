import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void errorToast(String msg,) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1000,
      backgroundColor: Colors.red,
      fontSize: 20,
      textColor: Colors.white);
  print("errorToast");
}
void successToast(String msg,) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10000*5,
      fontSize: 20,
      backgroundColor: Colors.green,
      textColor: Colors.white);
  print("succesToast");

}