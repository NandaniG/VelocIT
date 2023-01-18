import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/Core/Model/CartModels/CartSpecificIDForEmbeddedModel.dart';
import 'package:velocit/Core/ViewModel/cart_view_model.dart';
import 'package:velocit/utils/constants.dart';

import '../../pages/screens/cartDetail_Activity.dart';
import '../../services/providers/Products_provider.dart';
import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/CartModels/AddressListModel.dart';
import '../Model/CartModels/CartCreateRetrieveModel.dart';
import '../Model/CartModels/CartSpecificIdModel.dart';
import '../Model/CartModels/MergeCartModel.dart';
import '../Model/CartModels/SendCartForPaymentModel.dart';
import '../Model/CartModels/updateCartModel.dart';
import '../Model/CityModel.dart';
import '../Model/StateModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import 'package:http/http.dart'as http;

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
    print("Cart Created : "+responseJson.toString());

    Map<String, dynamic> map = jsonDecode(rawJson);

    var userData = CartCreateRetrieveModel.fromJson(map);
    prefs.setString('CartIdPref', (userData.payload?.id ?? 0).toString());
    print(userData.payload?.id.toString());
    Prefs.instance.setToken(Prefs.prefCartId, (userData.payload?.id ?? 0).toString());


    // if (response.statusCode == 200) {
    //   print(responseJson.toString());
    // } else {
    //   Utils.errorToast("System is busy, Please try after sometime.");
    // }

    httpClient.close();
    return userData;
  }

  // int badgeLength = 0;

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
    print("Cart response11 map : "+jsonMap.toString());
    print(responseJson.toString());

    Map<String, dynamic> map = jsonDecode(rawJson);

    var userData = UpdateCartModel.fromJson(map);

    // if (response.statusCode == 200) {
    print(userData.payload!.id.toString());

    print("userData.payload!.id");
    print(responseJson.toString());
    Provider.of<ProductProvider>(context, listen: false);

    await  getCartSpecificIDList(userData.payload!.id.toString());


    httpClient.close();
    return responseJson = UpdateCartModel.fromJson(map);
  }

  Future<CartSpecificIdModel> getCartSpecificIDList(String id) async {
    var url = ApiMapping.getURI(apiEndPoint.cart_by_ID);
    print("Cart specific ID : "+id.toString());
    final prefs = await SharedPreferences.getInstance();

    try {
      dynamic response = await _apiServices.getGetApiResponse(url + id);
      print("Cart Specific Id : " + response.toString());
      
      if (response['status'] != "EXCEPTION") {
       StringConstant.BadgeCounterValue = response['payload']['total_item_count'].toString();
      prefs.setString(
        'setBadgeCountPrefs',
        response['payload']['total_item_count'].toString(),
      );


      return response = CartSpecificIdModel.fromJson(response); 
      }
      var cart = CartSpecificIdModel();
      cart.status = "ERROR";
      return cart;
    } catch (e) {
      throw e;
    }
  }

  Future<CartSpecificIDforEmbeddedModel> getCartSpecificIDEmbeddedList(String id) async {
    var url = ApiMapping.getURI(apiEndPoint.cart_by_Embedded_ID);
    final prefs = await SharedPreferences.getInstance();

    try {
      dynamic response = await _apiServices.getGetApiResponse(url + id);
      print("Cart cart_by_Embedded_ID Id : " + response.toString());
      print("Cart cart_by_Embedded_ID Id orders_for_purchase: " + response['orders_for_purchase'].toString());
      await prefs.setString('CartIdPref',response);
      return response = CartSpecificIDforEmbeddedModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<MergeCartModel> mergeCartList(String oldId,String newId,Map json,BuildContext context) async {

    // var url = ApiMapping.getURI(apiEndPoint.cart_by_Embedded_ID);
    var url = ApiMapping.BaseAPI+'/cart/merge_cart/$oldId?newid=$newId';
    print(url);
    print(json);
    final prefs = await SharedPreferences.getInstance();

    try {
      dynamic response = await _apiServices.getPutApiResponse(url, json);
      print("Cart Merge CartModel Id : " + response.toString());
      await prefs.setString('CartIdPref',response);
      if (response['status'].toString() == 'OK') {

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CartDetailsActivity()));
      }

        return response = MergeCartModel.fromJson(response);
    } catch (e) {
      print("Merge car error: "+e.toString());
      throw e;
    }
  }

  Future<SendCartForPaymentModel> getSendCartForPaymentList(String id) async {
    var url = ApiMapping.getURI(apiEndPoint.send_Cart_For_Payment);
    final prefs = await SharedPreferences.getInstance();
    print(" SendCartForPaymentModel url: " + url + id.toString());
    print(" SendCartForPaymentModel id: " + id.toString());

    try {
      dynamic response = await _apiServices.getGetApiResponse(url + id);
      print(" SendCartForPaymentModel : " + response.toString());

      // prefs.setString(
      //   'setBadgeCountPrefs',
      //   response['payload']['total_item_count'].toString(),
      // );

      return response = SendCartForPaymentModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future getSendCartForPaymentLists(String id) async {
    var url = ApiMapping.getURI(apiEndPoint.send_Cart_For_Payment);
    final prefs = await SharedPreferences.getInstance();

    try {
      dynamic response = await _apiServices.getGetApiResponse(url + id);
      print(" SendCartForPaymentModel : " + response.toString());

      // prefs.setString(
      //   'setBadgeCountPrefs',
      //   response['payload']['total_item_count'].toString(),
      // );

      return response = SendCartForPaymentModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future<AddressListModel> getAddressList(String id) async {
    // var url = ApiMapping.getURI(apiEndPoint.address_list);
    https://velocitapiqa.fulgorithmapi.com:443/api/v1/user/130/address?page=0&size=10

    var requestUrl = ApiMapping.BaseAPI +'/user/'+id + '/address?page=0&size=10';

    print(requestUrl.toString());
    print( 'https://velocitapiqa.fulgorithmapi.com:443/api/v1/user/130/address?page=0&size=10');
    print(id.toString());
    final prefs = await SharedPreferences.getInstance();

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print(" AddressListModel : " + response.toString());

      return response = AddressListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<StateModel> getStateAddressList() async {
    // var url = ApiMapping.getURI(apiEndPoint.address_list);
    https://velocitapiqa.fulgorithmapi.com:443/api/v1/user/130/address?page=0&size=10

    var requestUrl = ApiMapping.BaseAPI +ApiMapping.StateAddress;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print(" State AddressListModel : " + response.toString());

      return response = StateModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<CityModel> getCityAddressList() async {
    // var url = ApiMapping.getURI(apiEndPoint.address_list);
    https://velocitapiqa.fulgorithmapi.com:443/api/v1/user/130/address?page=0&size=10

    var requestUrl = ApiMapping.BaseAPI +ApiMapping.CityAddress;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print(" CityModel AddressListModel : " + response.toString());

      return response = CityModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }


/*
  Future createAddressApi(Map<String, dynamic> jsonMap, BuildContext context, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic responseJson;
    // var url = ApiMapping.getURI(apiEndPoint.add_address);


    print("jsonMap"+jsonMap.toString());
    print("userId"+userId.toString());
    var url = '/address/user/' + userId.toString();
    String queryString = Uri(queryParameters: jsonMap).query;

    var requestUrl = ApiMapping.baseAPI +url + '?' + queryString!;



    print("address url"+requestUrl.toString());
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(requestUrl));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();
    String rawJson = responseJson.toString();
    print('createAddressApi');
    print(responseJson.toString());




    httpClient.close();
    return responseJson;
  }
*/

  Future createAddressPostAPI(Map data,  String userId) async {

    print("userId"+userId.toString());
    var url = '/address/user/' + userId.toString();
    var requestUrl = ApiMapping.BaseAPI +url;

    String body = json.encode(data);
    print("jsonMap"+body.toString());

    dynamic reply;
    http.Response response = await http.post(Uri.parse(requestUrl)  ,body:body,headers: {'content-type': 'application/json'}) ;
    print("response post"+response.body.toString());
    // Utils.successToast(response.body.toString());
    return reply;

  }

  Future putCartForPayment(dynamic data,int orderBasketID) async {
    // var url = ApiMapping.getURI(apiEndPoint.put_carts);

    print("userId"+orderBasketID.toString());
    var url = '/order-basket/$orderBasketID/attempt_payment';

    var requestUrl = ApiMapping.BaseAPI +url;
    print(requestUrl.toString());

    String body = json.encode(data);
    print("jsonMap"+body.toString());


    try {
      dynamic reply;
      http.Response response = await http.put(Uri.parse(requestUrl)  ,body:body,headers: {'content-type': 'application/json'}) ;
      print("response post"+response.body.toString());
      // Utils.successToast(response.body.toString());
      return reply;

      return response ;
    } catch (e) {
      throw e;
    }
  }
  Map<dynamic, dynamic> orderDetails = {};

  Future putCartForPaymentUpdate(dynamic data,int orderBasketID) async {
    // var url = ApiMapping.getURI(apiEndPoint.put_carts);

    print("userId"+orderBasketID.toString());
    var url = '/order-basket/$orderBasketID/update_payment';

    var requestUrl = ApiMapping.BaseAPI +url;
    print(requestUrl.toString());

    String body = json.encode(data);
    print("jsonMap"+body.toString());


    try {
      dynamic reply;
      http.Response response = await http.put(Uri.parse(requestUrl)  ,body:body,headers: {'content-type': 'application/json'}) ;
      print("response postputCartForPaymentUpdate"+response.body.toString());
      // Utils.successToast(response.body.toString());
      return reply;

      return response ;
    } catch (e) {
      throw e;
    }
  }

}
