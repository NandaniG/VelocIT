import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';

import '../../services/providers/Products_provider.dart';
import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/CartModels/CartCreateRetrieveModel.dart';
import '../Model/CartModels/CartSpecificIdModel.dart';
import '../Model/CartModels/updateCartModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

class CartRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  CartCreateRetrieveModel modelResponse = CartCreateRetrieveModel();

  Future<CartCreateRetrieveModel> cartPostRequest(
      Map jsonMap, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.getURI(apiEndPoint.cart_create_retrive);
    print(url);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));

    request.headers.set("Content-Type", "application/json; charset=UTF-8");

    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();
    String rawJson = responseJson.toString();
    print("Cart response11");
    print(responseJson.toString());

    Map<String, dynamic> map = jsonDecode(rawJson);

    var userData = CartCreateRetrieveModel.fromJson(map);
    prefs.setString('CartIdPref', userData.payload!.id.toString());
    print(userData.payload!.id.toString());
    Prefs.instance.setToken(Prefs.prefCartId, userData.payload!.id.toString());

    print("userData.payload!.id");

    // if (response.statusCode == 200) {
    //   print(responseJson.toString());
    // } else {
    //   Utils.errorToast("System is busy, Please try after sometime.");
    // }

    httpClient.close();
    return userData;
  }

  int badgeLength = 0;

  Future<UpdateCartModel> updateCartPostRequest(
      Map jsonMap, BuildContext context) async {
    SessionManager prefs = SessionManager();

    dynamic responseJson;
    var url = ApiMapping.getURI(apiEndPoint.cart_update);
    print(url);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));

    request.headers.set("Content-Type", "application/json; charset=UTF-8");

    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();
    String rawJson = responseJson.toString();
    print("Cart response11");
    print(responseJson.toString());

    Map<String, dynamic> map = jsonDecode(rawJson);

    var userData = UpdateCartModel.fromJson(map);

    // if (response.statusCode == 200) {
    print(userData.payload!.id.toString());

    print(userData.payload!.ordersForPurchase![0].itemQuantity);
    badgeLength = userData.payload!.ordersForPurchase![0].itemQuantity!;

    print("userData.payload!.id");
    print(responseJson.toString());
    Provider.of<ProductProvider>(context, listen: false);
    final preference = await SharedPreferences.getInstance();

    prefs.setBadgeToken(badgeLength.toString());

    // } else {
    //   Utils.errorToast("System is busy, Please try after sometime.");
    // }

    httpClient.close();
    return responseJson = UpdateCartModel.fromJson(map);
  }

  Future<CartSpecificIdModel> getCartSpecificIDList(String id) async {
    var url = ApiMapping.getURI(apiEndPoint.cart_by_ID);
    final prefs = await SharedPreferences.getInstance();

    try {
      dynamic response = await _apiServices.getGetApiResponse(url + id);
      print("Cart Specific Id : " + response.toString());

      prefs.setString(
        'setBadgeCountPrefs',
        response['payload']['total_item_count'].toString(),
      );

      return response = CartSpecificIdModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
