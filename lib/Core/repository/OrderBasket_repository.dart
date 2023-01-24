import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';import '../../pages/Activity/My_Orders/MyOrders_Activity.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';


import '../AppConstant/apiMapping.dart';
import '../Model/CartModel.dart';
import '../Model/Orders/ActiveOrdersBasketModel.dart';
import '../data/app_excaptions.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import 'package:http/http.dart' as http
;import 'package:http/http.dart' as http;import 'dart:convert';
class OrderBasketRepository {

  BaseApiServices _apiServices = NetworkApiServices();
  dynamic orderBasketData;


  Future postApiRequest(Map jsonMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt_token') ?? '';
    print(jsonMap);
    // dynamic responseJson;
    var url = ApiMapping.ConstructURI(ApiMapping.consumerBasket);

    dynamic responseJson = await _apiServices.getGetApiResponseWithBody(url, jsonMap);

    String rawJson = responseJson.toString();
    print("consumerBasket : "+responseJson.toString());
    return responseJson;
  }

  Future merchantPostAPI(Map jsonMap) async {
    var requestUrl = ApiMapping.ConstructURI(ApiMapping.merchantNearMe);
    print(jsonMap);
    // dynamic responseJson;

    dynamic responseJson = await _apiServices.getGetApiResponseWithBody(requestUrl, jsonMap);

    // String rawJson = responseJson.toString();
    print("merchantPostAPI : "+responseJson.toString());
    return responseJson;
  }

  void cancelOrderApiRequest(
     BuildContext context, Map json, String orderId) async {
    // var url = ApiMapping.getURI(apiEndPoint.cart_by_Embedded_ID);
    var url = ApiMapping.BaseAPI + '/order/$orderId/cancel';
    print(url);
    print(json);

    dynamic response = await _apiServices.getPutApiResponse(url, json);
    try {

      if (response['status'].toString() == 'OK') {
        print("Order cancelled list: " + response.toString());

        Utils.successToast(
            'Order cancelled successful');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyOrdersActivity()));

      }
    } catch (e) {
      print("Merge cart error: " + e.toString());
      throw e;
    }
  }

  Future cancelOrderPutApiResponse(
  BuildContext context, dynamic json, String orderId) async {
    dynamic responseJson;
    var url = ApiMapping.BaseAPI + '/order/$orderId/cancel';
    print(url);
    try {
      final client = http.Client();
      String body = json.encode(json);

      http.Response response = await client.put(Uri.parse(url),
          body: body,
          headers: {
            'content-type': 'application/json'
          }).timeout(Duration(seconds: 30));

      if (response.statusCode==200) {
      responseJson = returnResponse(response);
      print("cancelOrderPutApiResponse..$url........" + responseJson['status'].toString());

      if(responseJson['status'] =="OK"){
        Utils.successToast(
            'Order cancelled successful');
      }else{
        Utils.successToast(
            'Something went wrong');
      }
    } } catch (e) {
      print("Error on put: " + e.toString());
    }
    return responseJson;
  }
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }}

  // Future<ActiveOrderBasketModel> getOrderBasketApi(
  //     dynamic data) async {
  //   var url = ApiMapping.BASEAPI +ApiMapping.consumerBasket;
  //     print(url.toString());
  //
  //   try {
  //     dynamic response = await _apiServices.getGetApiResponseWithBody(url,data);
  //     orderBasketData = response.toString();
  //     print("getOrderBasketApi"+response.toString());
  //     return response = ActiveOrderBasketModel.fromJson(response);
  //   } catch (e) {
  //     throw e;
  //   }
  // }
  Future orderBasket_submitRatingsPostApiRequest(Map jsonMap) async {
    // dynamic responseJson;
    var url = ApiMapping.ConstructURI(StringConstant.apiOrderBasket_submitRatings);

    dynamic responseJson = await _apiServices.getPostApiResponse(url, jsonMap);

    String rawJson = responseJson.toString();
    print("orderBasket_submitRatingsPostApiRequest"+responseJson.toString());
    return responseJson;
  }
/*
  Future getGetApiResponseWithBody(jsonMap) async {
    // TODO: implement getGetApiResponseWithBody
    var url = ApiMapping.BASEAPI +ApiMapping.consumerBasket;
    print(url.toString());
    dynamic responseJson;
    try {
      var headers = {
        'Content-Type': 'application/json'
      };
      final request = http.Request('GET', Uri.parse(url));
      request.body = json.encode(jsonMap);
      request.headers.addAll(headers);
      final response = await request.send();
      responseJson =response;

      print("responseJson"+responseJson.toString());
      switch (response.statusCode) {
        case 200:
          var responseJson = await response.stream.bytesToString();
          return responseJson;
        case 400:
          throw Utils.errorToast("System is busy, Please try after sometime.");
        case 500:
        case 404:
          throw Utils.errorToast("System is busy, Please try after sometime.");
        default:
          throw Utils.errorToast("System is busy, Please try after sometime.");
      }
    } on SocketException {
      throw Utils.errorToast("System is busy, Please try after sometime.");
    }
    throw UnimplementedError();
  }
*/

}
