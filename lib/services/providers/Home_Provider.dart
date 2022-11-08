import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';

import '../../utils/constants.dart';
import '../models/JsonModelForApp/HomeModel.dart';

class HomeProvider with ChangeNotifier {
  Map<dynamic, dynamic> jsonData = {};

  //---------------------------------------------------------
  //--------------------load json file------------------------
  //----------------------------------------------------------
  loadJson() async {
    String jsonContent = await rootBundle.loadString("assets/jsonData.json");
    jsonData = json.decode(jsonContent);
    print("____________loadJson______________________");
    print(jsonData["stepperOfDeliveryList"]);
    StringConstant.printObject(jsonData);

    homeImageSliderService();
    shopByCategoryService();
    bookOurServicesService();
    recommendedListService();
    merchantNearYouListService();
    bestDealListService();
  }

  //---------------------------------------------------------
  //----------------- home slider service--------------------
  var homeSliderList;

  Future<List<HomeImageSlider>> homeImageSliderService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    homeSliderList = json.decode(jsondata);
    print("-------------homeImageSliderService Data-------------");
    // homeSliderList = homeImageSliderFromJson(homeSliderList);
    print(homeSliderList["homeImageSlider"]);
    return homeSliderList.map((e) => HomeImageSlider.fromJson(e)).toList();
  }

  //---------------------------------------------------------
  //----------------- shopByCategoryService--------------------

  var shopByCategoryList;
  var subProductList;

  Future<List<ShopByCategoryList>> shopByCategoryService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    shopByCategoryList = json.decode(jsondata);
    shopByCategoryList = shopByCategoryList["shopByCategoryList"];

    for (int i = 0;
        i <= shopByCategoryList["shopByCategoryList"].length;
        i++) {
      subProductList =shopByCategoryList["shopByCategoryList"][i]["subShopByCategoryList"];

    }
    print("-------------shopByCategoryList Data-------------");
    print(shopByCategoryList.toString());
    return shopByCategoryList
        .map((e) => ShopByCategoryList.fromJson(e))
        .toList();
  }

  //---------------------------------------------------------
  //----------------- bookOurServicesService--------------------

  var bookOurServicesList;

  Future<List<BookOurServicesList>> bookOurServicesService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    bookOurServicesList = json.decode(jsondata);
    bookOurServicesList = bookOurServicesList["bookOurServicesList"];
    print("-------------bookOurServicesList Data-------------");
    print(bookOurServicesList.toString());
    return bookOurServicesList
        .map((e) => BookOurServicesList.fromJson(e))
        .toList();
  }

  //---------------------------------------------------------
  //----------------- recommendedListService--------------------

  var recommendedList;

  Future<List<RecommendedForYouList>> recommendedListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    recommendedList = json.decode(jsondata);
    recommendedList = recommendedList["recommendedForYouList"];
    print("-------------recommendedForYouList Data-------------");
    print(recommendedList.toString());
    return recommendedList
        .map((e) => RecommendedForYouList.fromJson(e))
        .toList();
  }

  //---------------------------------------------------------
  //----------------- recommendedListService--------------------

  var merchantNearYouList;

  Future<List<MerchantNearYouList>> merchantNearYouListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    merchantNearYouList = json.decode(jsondata);
    merchantNearYouList = merchantNearYouList["merchantNearYouList"];
    print("-------------MerchantNearYouList Data-------------");
    print(merchantNearYouList.toString());
    return merchantNearYouList
        .map((e) => MerchantNearYouList.fromJson(e))
        .toList();
  }

  //---------------------------------------------------------
  //----------------- bestDealListService--------------------

  var bestDealList;

  Future<List<BestDealList>> bestDealListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    bestDealList = json.decode(jsondata);
    bestDealList = bestDealList["bestDealList"];
    print("-------------BestDealList Data-------------");
    print(bestDealList.toString());
    return bestDealList.map((e) => BestDealList.fromJson(e)).toList();
  }

  //---------------------------------------------------------
  //----------------- bestDealListService--------------------

  var budgetBuyList;

  Future<List<BudgetBuyList>> budgetBuyListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    budgetBuyList = json.decode(jsondata);
    budgetBuyList = budgetBuyList["budgetBuyList"];
    print("-------------BestDealList Data-------------");
    print(budgetBuyList.toString());
    return budgetBuyList.map((e) => BudgetBuyList.fromJson(e)).toList();
  }
}
