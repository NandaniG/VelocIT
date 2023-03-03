import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/Core/Model/CartModels/CartSpecificIDForEmbeddedModel.dart';
import 'package:velocit/Core/ViewModel/cart_view_model.dart';
import 'package:velocit/utils/constants.dart';

import '../../pages/Activity/My_Account_Activities/Saved_address/saved_address_detailed_screen.dart';
import '../../pages/Activity/Order_CheckOut_Activities/OrderReviewScreen.dart';
import '../../pages/screens/cartDetail_Activity.dart';
import '../../pages/screens/dashBoard.dart';
import '../../services/providers/Products_provider.dart';
import '../../utils/routes/routes.dart';
import '../../utils/utils.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/CartModels/AddressListModel.dart';
import '../Model/CartModels/CartCreateRetrieveModel.dart';
import '../Model/CartModels/CartSpecificIdModel.dart';
import '../Model/CartModels/GetDefaultAddressModel.dart';
import '../Model/CartModels/MergeCartModel.dart';
import '../Model/CartModels/SendCartForPaymentModel.dart';
import '../Model/CartModels/updateCartModel.dart';
import '../Model/CityModel.dart';
import '../Model/StateModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import 'package:http/http.dart' as http;

class CartRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  CartCreateRetrieveModel modelResponse = CartCreateRetrieveModel();

  Future<CartCreateRetrieveModel> cartPostRequest(
      Map jsonMap, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    dynamic responseJson;
    var url = ApiMapping.getURI(apiEndPoint.cart_create_retrive);
    print(url);
    print(jsonMap);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));

    request.headers.set("Content-Type", "application/json; charset=UTF-8");

    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    responseJson = await response.transform(utf8.decoder).join();
    String rawJson = responseJson.toString();
    print("Cart Created : " + responseJson.toString());

    Map<String, dynamic> map = jsonDecode(rawJson);

    var userData = CartCreateRetrieveModel.fromJson(map);
    prefs.setString('CartIdPref', userData.payload!.id.toString());
    print("Cart Id From Cart Create and retrieve " +
        userData.payload!.id.toString());
    print(userData.payload!.id.toString());

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
    final prefs = await SharedPreferences.getInstance();

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
    print("updateCartPostRequest response11" + rawJson.toString());
    print("updateCartPostRequest map : " + jsonMap.toString());

    Map<String, dynamic> map = jsonDecode(rawJson);

    if (response.statusCode == 200) {
      if (map['status'] == 'OK') {
        var userData = UpdateCartModel.fromJson(map);

        print(userData.payload!.id.toString());

        print("userData.payload!.id");
        print(responseJson.toString());
        Provider.of<ProductProvider>(context, listen: false);

        await getCartSpecificIDList(userData.payload!.id.toString());
      } else {
        Utils.successToast('Please try again');
        print("Status not ok");
      }
    } else {
      print("Status not ok out side");
    }
    httpClient.close();
    return responseJson = UpdateCartModel.fromJson(map);
  }

  Future<CartSpecificIdModel> getCartSpecificIDList(String id) async {
    var url = ApiMapping.getURI(apiEndPoint.cart_by_ID);
    print("Cart specific ID : " + url + id.toString());
    final prefs = await SharedPreferences.getInstance();

    var isNavFromBuyNow = prefs.getString('isBuyNow');
    try {
      dynamic response = await _apiServices.getGetApiResponse(url + id);
      print("Cart Specific Id : " + response.toString());
      
      if (response != null) {
        if (response['status'] != "EXCEPTION") {
       StringConstant.BadgeCounterValue = response['payload']['total_item_count'].toString();
      prefs.setString(
        'setBadgeCountPrefs',
        response['payload']['total_item_count'].toString(),
      );}
print(" total_item_count Badge"+response['payload']['total_item_count'].toString());


      return response = CartSpecificIdModel.fromJson(response); 
      }
      var cart = CartSpecificIdModel();
      cart.status = "ERROR";
      return cart;
    } catch (e) {
      throw e;
    }
  }

  void buyNowGetRequest(String userId, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic responseJson;
    var urldata = ApiMapping.BaseAPI + ApiMapping.GetCartForDirectBuy;
    print(urldata);

    Map<String, String> jsonMap = {"userId": userId};
    String queryString = Uri(queryParameters: jsonMap).query;
    print(queryString);

    var requestUrl = urldata + '?' + queryString;
    print(requestUrl);

    var response = await http.get(Uri.parse(requestUrl), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    });

    print('---- status code: ${response.statusCode}');
    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      prefs.setString('isUserNavigateFromDetailScreen', '1');
      print('---- slot: ${jsonData['payload']['id']}');
      var merchanId = prefs.getString('selectedMerchantId');
      var ProductId = prefs.getString('selectedProductId');
      var CounterPrice = prefs.getString('selectedCounterPrice');
      Map<String, String> data;
      String FromType = (prefs.getString('FromType')) ?? '';
      print("FromType : " + FromType.toString());

      // if (StringConstant().isNumeric(ProductId!)) {
      //   FromType = 'FromProduct';
      //   print("This is Product ");
      // } else {
      //   FromType = 'FromServices';
      //   print("This is service ");
      // }
      // print("This is FromType "+FromType.toString());

      if (FromType == 'FromServices') {
        data = {
          "cartId": jsonData['payload']['id'].toString(),
          "userId": userId,
          "serviceId": ProductId.toString(),
          "merchantId": merchanId.toString(),
          "qty": CounterPrice.toString(),
          "is_new_order": 'true'
        };
      } else {
        data = {
          "cartId": jsonData['payload']['id'].toString(),
          "userId": userId,
          "productId": ProductId.toString(),
          "merchantId": merchanId.toString(),
          "qty": CounterPrice.toString(),
          "is_new_order": 'true'
        };
      }

      print("update cart DATA buyNowGetRequest" + data.toString());

      CartRepository().updateCartPostRequest(data, context).then((value) {
        prefs.setString(
            'directCartIdPref', jsonData['payload']['id'].toString());
        var directCartId = prefs.getString('directCartIdPref');
        print("directCartId" + directCartId.toString());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => OrderReviewActivity(
                cartId: int.parse(jsonData['payload']['id'].toString()))));
      });
    } else {
      print("error in direct buy now");
    }
  }

  Future<CartSpecificIDforEmbeddedModel> getCartSpecificIDEmbeddedList(
      String id) async {
    var url = ApiMapping.getURI(apiEndPoint.cart_by_Embedded_ID);
    final prefs = await SharedPreferences.getInstance();

    try {
      dynamic response = await _apiServices.getGetApiResponse(url + id);
      print("Cart cart_by_Embedded_ID Id : " + response.toString());
      print("Cart cart_by_Embedded_ID Id orders_for_purchase: " +
          response['orders_for_purchase'].toString());
      await prefs.setString('CartIdPref', response);
      return response = CartSpecificIDforEmbeddedModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<MergeCartModel> mergeCartList(
      String oldId, String newId, Map json, BuildContext context) async {
    // var url = ApiMapping.getURI(apiEndPoint.cart_by_Embedded_ID);
    var url = ApiMapping.BaseAPI + '/cart/merge_cart/$oldId?newid=$newId';
    print(url);
    print(json);
    final prefs = await SharedPreferences.getInstance();

    dynamic response = await _apiServices.getPutApiResponse(url, json);

    print("Cart Merge CartModel Id : " + response.toString());
    try {
      await prefs.setString('CartIdPref', response['payload']['id'].toString());
      print("Cart Id From Merge Cart " + StringConstant.UserCartID);

      if (response['status'].toString() == 'OK') {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => CartDetailsActivity(),
        //     ));
        StringConstant.isUserNavigateFromDetailScreen =
            (prefs.getString('isUserNavigateFromDetailScreen')) ?? "";

        if (StringConstant.isUserNavigateFromDetailScreen == 'IsGuest') {
          getCartSpecificIDList(response['payload']['id'].toString()).then((value)
          { Navigator.of(context)
              .pushNamedAndRemoveUntil(
              RoutesName.dashboardRoute, (route) => false);});
        } else {
          await prefs.setString('isRandomUser', 'Yes').then((value) {
            Navigator.of(context)
                .pushReplacementNamed(RoutesName.cartScreenRoute);
          });
        }
      }
      return response = MergeCartModel.fromJson(response);
    } catch (e) {
      print("Merge cart error: " + e.toString());
      throw e;
    }
  }

  Future<SendCartForPaymentModel> getSendCartForPaymentList(String id) async {
    var url = ApiMapping.getURI(apiEndPoint.send_Cart_For_Payment);
    final prefs = await SharedPreferences.getInstance();
    print(" SendCartForPaymentModel url: " + url + id.toString());
    print(" SendCartForPaymentModel id: " + id.toString());
    //   2191
    try {
      dynamic response = await _apiServices.getGetApiResponse(url + id);
      print(" getSendCartForPaymentList : " + response.toString());

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
      print(" getSendCartForPaymentLists : " + response.toString());

      // prefs.setString(
      //   'setBadgeCountPrefs',
      //   response['payload']['total_item_count'].toString(),
      // );

      return response = SendCartForPaymentModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

////////addresse

  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController houseBuildingController = TextEditingController();
  TextEditingController areaColonyController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  Future<AddressListModel> getAddressList(String id) async {
    // var url = ApiMapping.getURI(apiEndPoint.address_list);

    var requestUrl =
        ApiMapping.BaseAPI + '/user/' + id + '/address?page=0&size=50';

    print(requestUrl.toString());
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

  //get default address
  Future<GetDefaultAddressModel> getDefaultAddressList(String id) async {
    // var url = ApiMapping.getURI(apiEndPoint.address_list);

    var requestUrl = ApiMapping.BaseAPI + '/user/' + id + '/defaultAddress';
    // var requestUrl = ApiMapping.BaseAPI + '/user/' + '346' + '/defaultAddress';
print(requestUrl);
    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      if (kDebugMode) {
        print(" getDefaultAddressList : $response");
      }

      return response = GetDefaultAddressModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<StateModel> getStateAddressList() async {
    // var url = ApiMapping.getURI(apiEndPoint.address_list);
    https: //velocitapiqa.fulgorithmapi.com:443/api/v1/user/130/address?page=0&size=10

    var requestUrl = ApiMapping.BaseAPI + ApiMapping.StateAddress;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      if (kDebugMode) {
        print(" State AddressListModel : " + response.toString());
      }

      return response = StateModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<CityModel> getCityAddressList() async {
    // var url = ApiMapping.getURI(apiEndPoint.address_list);
    https: //velocitapiqa.fulgorithmapi.com:443/api/v1/user/130/address?page=0&size=10

    var requestUrl = ApiMapping.BaseAPI + ApiMapping.CityAddress;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      if (kDebugMode) {
        print(" CityModel AddressListModel : " + response.toString());
      }

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

  Future createAddressPostAPI(Map data, String userId) async {
    if (kDebugMode) {
      print("userId" + userId.toString());
    }
    var url = '/address/user/' + userId.toString();
    var requestUrl = ApiMapping.BaseAPI + url;

    String body = json.encode(data);
    if (kDebugMode) {
      print("jsonMap" + body.toString());
      print("requestUrl" + requestUrl.toString());
    }

    dynamic reply;
    http.Response response = await http.post(Uri.parse(requestUrl),
        body: body, headers: {'content-type': 'application/json'});
    if (kDebugMode) {
      print("response Created address" + response.body.toString());
    }
    // Utils.successToast(response.body.toString());
    return reply;
  }

  Future putAddressApi(dynamic data, int addressId) async {
    // var url = ApiMapping.getURI(apiEndPoint.put_carts);
    final prefs = await SharedPreferences.getInstance();

    if (kDebugMode) {
      print("address ID" + addressId.toString());
    }
    var url = '/address/$addressId';

    var requestUrl = ApiMapping.BaseAPI + url;
    if (kDebugMode) {
      print(requestUrl.toString());
    }

    String body = json.encode(data);
    print("putAddressApi jsonMap" + body.toString());

    try {
      dynamic reply;
      http.Response response = await http.put(Uri.parse(requestUrl),
          body: body, headers: {'content-type': 'application/json'});
      print("response Put Address" + response.body.toString());
      var jsonData = json.decode(response.body);
      print("response post jsonData" + jsonData['payload'].toString());

      // Utils.successToast(response.body.toString());
      return reply;

      return response;
    } catch (e) {
      throw e;
    }
  }

  Future deleteAddressApi(
      int addressId, BuildContext context, bool isAddress) async {
    // var url = ApiMapping.getURI(apiEndPoint.put_carts);
    final prefs = await SharedPreferences.getInstance();

    if (kDebugMode) {
      print("address ID" + addressId.toString());
    }
    var url = '/address/$addressId';

    var requestUrl = ApiMapping.BaseAPI + url;
    if (kDebugMode) {
      print(requestUrl.toString());
    }

    // String body = json.encode(data);
    // print("deleteAddressApi jsonMap" + body.toString());

    /* try {*/
    http.Response response = await http.delete(Uri.parse(requestUrl),
        headers: {'content-type': 'application/json'});

    if (response.statusCode == 200) {
      // print("response delete jsonData" + jsonData['payload'].toString());
      StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';
      var cartId = prefs.getString('directCartIdPref');
      var isBuyNowCart = prefs.getString('isBuyNow');
      if (isAddress == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SavedAddressDetails(),
          ),
        );
      } else {
        if (isBuyNowCart == 'true') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  OrderReviewActivity(cartId: int.parse(cartId.toString())),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OrderReviewActivity(
                  cartId: int.parse(StringConstant.UserCartID.toString())),
            ),
          );
        }
      }
      Utils.successToast('Address deleted successfully');
    } else {
      Utils.errorToast('Something went wrong');
    }
    // Utils.successToast(response.body.toString());

    return response;
    /*  }  catch (e) {
      print("Error on Delete address : " + e.toString());
    }*/
  }

  Future putCartForPayment(dynamic data, int orderBasketID) async {
    // var url = ApiMapping.getURI(apiEndPoint.put_carts);
    final prefs = await SharedPreferences.getInstance();

    if (kDebugMode) {
      print("userId" + orderBasketID.toString());
    }
    var url = '/order-basket/$orderBasketID/attempt_payment';

    var requestUrl = ApiMapping.BaseAPI + url;
    if (kDebugMode) {
      print(requestUrl.toString());
    }

    String body = json.encode(data);
    print("putCartForPayment jsonMap" + body.toString());

    try {
      dynamic reply;
      http.Response response = await http.put(Uri.parse(requestUrl),
          body: body, headers: {'content-type': 'application/json'});
      print("response post" + response.body.toString());
      var jsonData = json.decode(response.body);
      print("response post jsonData" +
          jsonData['payload']['payment_attempt_id'].toString());
      prefs.setString('payment_attempt_id',
          jsonData['payload']['payment_attempt_id'].toString());

      // Utils.successToast(response.body.toString());
      return reply;

      return response;
    } catch (e) {
      throw e;
    }
  }

  Map<dynamic, dynamic> orderDetails = {};

  Future putCartForPaymentUpdate(dynamic data, int orderBasketID) async {
    // var url = ApiMapping.getURI(apiEndPoint.put_carts);

    print("userId" + orderBasketID.toString());
    var url = '/order-basket/$orderBasketID/update_payment';

    var requestUrl = ApiMapping.BaseAPI + url;
    print(requestUrl.toString());

    String body = json.encode(data);
    print("putCartForPayment jsonMap" + body.toString());

    try {
      dynamic reply;
      http.Response response = await http.put(Uri.parse(requestUrl),
          body: body, headers: {'content-type': 'application/json'});
      print("response post" + response.body.toString());
      print("response postputCartForPaymentUpdate" + response.body.toString());
      // Utils.successToast(response.body.toString());
      return reply;

      return response;
    } catch (e) {
      throw e;
    }
  }
}
