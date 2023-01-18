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
    } catch (e) {
      print("Error on Get : " + e.toString());
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final client = http.Client();
      var headers = {'Content-Type': 'application/json'};

      Response response = await client.post(Uri.parse(url),
          body: data,
          headers:headers).timeout(Duration(seconds: 30));

      responseJson = returnResponse(response);
      print("get data");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print("Error on post: " + e.toString());
    }
    return responseJson;
  }

  @override
  Future getPutApiResponse(String url, data) async {
    dynamic responseJson;
    try {
      final client = http.Client();
      String body = json.encode(data);

      Response response = await client.put(Uri.parse(url),
          body: body,
          headers: {
            'content-type': 'application/json'
          }).timeout(Duration(seconds: 30));

      responseJson = returnResponse(response);
      print("responseJson..$url........" + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
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
/*  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw  Utils.errorToast("System is busy, Please try after sometime.");
      case 500:
      // case 404:
      throw  Utils.errorToast("System is busy, Please try after sometime.");

      default:
        throw Utils.errorToast("System is busy, Please try after sometime.");
    }
  }*/

  @override
  Future getGetApiResponseWithBody(String url, jsonMap) async {
    // TODO: implement getGetApiResponseWithBody

    dynamic responseJson;
    try {
      var headers = {'Content-Type': 'application/json'};
      final request = http.Request('GET', Uri.parse(url));
      request.body = json.encode(jsonMap);
      request.headers.addAll(headers);
      final response = await request.send();
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
}
