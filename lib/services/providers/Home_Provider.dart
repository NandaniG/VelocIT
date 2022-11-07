import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants.dart';
import '../models/JsonModelForApp/HomeModel.dart';

class HomeProvider with ChangeNotifier {
  static JsonDecoder decoder = JsonDecoder();
  static JsonEncoder encoder = JsonEncoder.withIndent('  ');
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/jsonData.json');
    final data = await json.decode(response);
// ...
  }
  // List<HomeModel> homeDataList = [
  //   HomeModel(
  //       homeImageSlider: [
  //     HomeImageSlider(homeSliderImage: 'assets/images/laptopImage.jpg'),
  //     HomeImageSlider(homeSliderImage: 'assets/images/iphones_Image.jpg'),
  //     HomeImageSlider(homeSliderImage: 'assets/images/laptopImage2.jpg'),
  //   ], shopByCategoryList: [
  //     ShopByCategoryList(
  //         shopCategoryName: 'Appliances',
  //         shopCategoryImage: 'assets/images/laptopImage.jpg',
  //         shopCategoryDescription:
  //             'Dell ZX3 108CM (44 inch) ultra HD(4k) LED Smart Android TV')
  //   ]),
  // ];
  late List categorydata;

   Map<dynamic, dynamic> jsonData ={};
  loadJson() async {
    String jsonContent = await rootBundle.loadString("assets/jsonData.json");
    jsonData = json.decode(jsonContent);

    // print("jsonData");
    // print("${jsonData}       \n");
    // print(jsonData["budgetBuyList"].length);
    printObject(jsonData);
  }







  ///print json in listview

  void printObject(Object object) {
    // Encode your object and then decode your object to Map variable
    Map jsonMapped = json.decode(json.encode(object));

    // Using JsonEncoder for spacing
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');

    // encode it to string
    String prettyPrint = encoder.convert(jsonMapped);

    // print or debugPrint your object
    debugPrint(prettyPrint);
  }
}
