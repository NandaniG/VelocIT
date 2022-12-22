import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';

import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/CartModels/CartCreateRetrieveModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

class CartRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<CartCreateRetrieveModel> cartCreateAndRetrieveUsingPost(
      dynamic data) async {

    var url = ApiMapping.getURI(apiEndPoint.cart_create_retrive);

    try {
      dynamic response = await _apiServices.getPostApiResponse(url, data);
      print("Cart response00");
      print("Cart response00" + response.toString());

      return response = CartCreateRetrieveModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future cartPostRequest(Map jsonMap, BuildContext context) async {

    dynamic responseJson;
    var url = ApiMapping.getURI(apiEndPoint.cart_create_retrive);
    print(url);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    print("Cart response"+request.toString());

    // request.headers.set('Content-type', 'application/json');
    request.headers.set("Content-Type", "application/json; charset=UTF-8");

    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();
    String rawJson = responseJson.toString();
    print("Cart response11");
    print(responseJson.toString());

    if (response.statusCode == 200) {
      print(responseJson.toString());
    } else {
      Utils.errorToast("System is busy, Please try after sometime.");
    }

    httpClient.close();
    return responseJson;
  }

}
