import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:velocit/Core/data/app_excaptions.dart';
import 'package:velocit/Core/data/network/baseApiServices.dart';
import 'package:http/http.dart' as http;

import '../../../utils/utils.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final client = http.Client();
      final response =
      await client.get(Uri.parse(url)).timeout(Duration(seconds: 30));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }catch(e){
      print("Error on Get : " + e.toString());
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final client = http.Client();
       const Map<String, String> _JSON_HEADERS = {
        "content-type": "application/json"
      };
      Response response = await client.post(Uri.parse(url), body: data, headers: _JSON_HEADERS).timeout(
          Duration(seconds: 30));

      responseJson = returnResponse(response);
      print("get data");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }catch(e){
      print("Error on post: " + e.toString());
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      // case 400:
      //   throw  Utils.errorToast("System is busy, Please try after sometime.");
      case 500:
      // case 404:
      // throw  Utils.errorToast("System is busy, Please try after sometime.");

      default:
        throw  Utils.errorToast("System is busy, Please try after sometime.");

    }
  }

  @override
  Future getPutApiResponse(String url, data) async {
    dynamic responseJson;
    try {
      final client = http.Client();

      Response response = await client.put(Uri.parse(url), body: data).timeout(
          Duration(seconds: 30));

      responseJson = returnResponse(response);
      print("responseJson..........");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }catch(e){
      print("Error on put: " + e.toString());
    }
    return responseJson;
  }
}
