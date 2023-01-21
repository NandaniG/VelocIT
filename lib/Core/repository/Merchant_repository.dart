import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/MerchantModel/MerchantListByIdModel.dart';
import '../Model/MerchantModel/MerchantListModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import 'package:http/http.dart'as http;
class MerchantRepository {

  BaseApiServices _apiServices = NetworkApiServices();
  dynamic orderBasketData;


  Future merchantNearMeRequest(dynamic jsonMap) async {
    // dynamic responseJson;
    var url = ApiMapping.ConstructURI(ApiMapping.merchantNearMe);
print(url);
print(jsonMap);
    dynamic responseJson = await _apiServices.getPostApiResponse(url, jsonMap);

    String rawJson = responseJson.toString();
    print("merchantNearMeRequest"+responseJson.toString());
    return responseJson;
  }

  Future<MerchantListModel> merchantPostAPI(Map data) async {
    var requestUrl = ApiMapping.ConstructURI(ApiMapping.merchantNearMe);

    String body = json.encode(data);
    print("jsonMap" + body.toString());

    dynamic reply;
    http.Response response = await http.post(Uri.parse(requestUrl),
        body: body, headers: {'content-type': 'application/json'});
    print("response post" + response.body.toString());
    var datas= jsonDecode(response.body);
    // Utils.successToast(response.body.toString());
    // return response = MerchantListModel.fromJson(datas);

    return reply= MerchantListModel.fromJson(datas);
  }

  Future<MerchantListByIdModel> getMerchantByMerchantIdList(int page,int size, int merchantId) async {
    Map<String, String> productData = {
      'page': page.toString(),
      'size': size.toString(),
      'merchant_id':merchantId.toString(),
    };
    print("Merchant Query$productData");
    var url = '/product/get_by_merchant';
    String queryString = Uri(queryParameters: productData).query;

    var requestUrl = '${ApiMapping.BaseAPI}$url?$queryString';
print("Merchant Url "+ requestUrl);
    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      if (kDebugMode) {
        print("get Service By SubCategoryList list: $response");
      }
      return response = MerchantListByIdModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

}