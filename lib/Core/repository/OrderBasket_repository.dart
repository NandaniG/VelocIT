import 'dart:convert';
import 'dart:io';

import 'package:velocit/Core/Enum/apiEndPointEnums.dart';import '../../utils/constants.dart';
import '../../utils/utils.dart';


import '../AppConstant/apiMapping.dart';
import '../Model/Orders/ActiveOrdersBasketModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import 'package:http/http.dart' as http
;
class OrderBasketRepository {

  BaseApiServices _apiServices = NetworkApiServices();
  dynamic orderBasketData;

  Future<ActiveOrderBasketModel> getOrderBasketApi(
      dynamic data) async {
    var url = ApiMapping.BASEAPI +ApiMapping.consumerBasket;
      print(url.toString());

    try {
      dynamic response = await _apiServices.getGetApiResponseWithBody(url,data);
      orderBasketData = response.toString();
      print("getOrderBasketApi"+response.toString());
      return response = ActiveOrderBasketModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
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
