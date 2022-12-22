import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';

import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/CartModels/CartCreateRetrieveModel.dart';
import '../Model/CartModels/updateCartModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

class CartRepository {
  BaseApiServices _apiServices = NetworkApiServices();
  CartCreateRetrieveModel modelResponse = CartCreateRetrieveModel();

  Future<CartCreateRetrieveModel> cartPostRequest(
      Map jsonMap, BuildContext context) async {
    dynamic responseJson;
    var url = ApiMapping.getURI(apiEndPoint.cart_create_retrive);
    print(url);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    print("Cart response" + request.toString());

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

    print(userData.payload!.id.toString());
    Prefs.instance.setToken(Prefs.prefCartId, userData.payload!.id.toString());

    print("userData.payload!.id");

    var payload = map['payload'];

    int age = map['age'];

    var id = map["id"];
    var prod_items_for_purchase = map["prod_items_for_purchase"];
    var service_items_for_purchase = map["service_items_for_purchase"];
    var orders_for_purchase = map["orders_for_purchase"];
    var orders_saved_later = map["orders_saved_later"];
    var tempUserId = map["tempUserId"];
    var scratched_total = map["scratched_total"];
    var mrp_total = map["mrp_total"];
    var total_discount = map["total_discount"];
    var total_delivery_charges = map["total_delivery_charges"];
    var cart_type = map["cart_type"];
    var is_open = map["is_open"];
    var user = map["user"];

    CartCreateRetrieveModel person = CartCreateRetrieveModel(payload: payload);

    if (response.statusCode == 200) {
      print(responseJson.toString());
    } else {
      Utils.errorToast("System is busy, Please try after sometime.");
    }

    httpClient.close();
    return responseJson;
  }


  Future<UpdateCartModel> updateCartPostRequest(
      Map jsonMap, BuildContext context) async {
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

    print(userData.payload!.id.toString());

    print("userData.payload!.id");

    var payload = map['payload'];

    int age = map['age'];

    var id = map["id"];
    var prod_items_for_purchase = map["prod_items_for_purchase"];
    var service_items_for_purchase = map["service_items_for_purchase"];
    var orders_for_purchase = map["orders_for_purchase"];
    var orders_saved_later = map["orders_saved_later"];
    var tempUserId = map["tempUserId"];
    var scratched_total = map["scratched_total"];
    var mrp_total = map["mrp_total"];
    var total_discount = map["total_discount"];
    var total_delivery_charges = map["total_delivery_charges"];
    var cart_type = map["cart_type"];
    var is_open = map["is_open"];
    var user = map["user"];

    CartCreateRetrieveModel person = CartCreateRetrieveModel(payload: payload);

    if (response.statusCode == 200) {
      print(responseJson.toString());
    } else {
      Utils.errorToast("System is busy, Please try after sometime.");
    }

    httpClient.close();
    return responseJson;
  }
}
