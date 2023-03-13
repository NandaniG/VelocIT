import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/utils/utils.dart';

import '../../pages/Activity/Product_Activities/ProductDetails_activity.dart';
import '../../utils/constants.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/CRMModels/CRMSingleIDModel.dart';
import '../Model/FindProductBySubCategoryModel.dart';
import '../Model/CartModel.dart';
import '../Model/CategoriesModel.dart';
import '../Model/ProductCategoryModel.dart';
import '../Model/ServiceModels/SingleServiceModel.dart';
import '../Model/productSpecificListModel.dart';
import '../Model/scannerModel/SingleProductModel.dart';
import '../Model/scannerModel/productScanModel.dart';
import '../data/app_excaptions.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

class ProductSpecificListRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  // Future<ProductSpecificListModel> getProductSpecificList(dynamic data) async {
  //   var url = ApiMapping.getURI(apiEndPoint.get_productsListing);
  //
  //   try {
  //     dynamic response = await _apiServices.getPostApiResponse(url, data);
  //     return response = ProductSpecificListModel.fromJson(response);
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<SingleProductIDModel> getSingleProductSpecificList(
      String productId) async {
    var url = ApiMapping.getURI(apiEndPoint.single_product);
print(url+productId);
    try {
      dynamic response = await _apiServices.getGetApiResponse(url + productId);
      return response = SingleProductIDModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future<SingleServiceIDModel> getSingleServiceSpecificList(
      String productId) async {
    var url = ApiMapping.getURI(apiEndPoint.single_service);
print(url+productId);
    try {
      dynamic response = await _apiServices.getGetApiResponse(url + productId);
      return response = SingleServiceIDModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }


 void getCRMForms(
      String formId) async {
    var url = ApiMapping.getURI(apiEndPoint.crm_form);
    print(url+formId);
    try {
      dynamic response = await _apiServices.getGetApiResponse(url + formId);
      print('getCRMForm'+response['']);
      return response;
    } catch (e) {
      throw e;
    }
  }

  // Future getCRMForm( String formId) async {
  //   dynamic responseJson;
  //   try {
  //     var url = ApiMapping.getURI(apiEndPoint.crm_form);
  //     print(url+formId);
  //     final client = http.Client();
  //     final response =
  //     await client.get(Uri.parse(url)).timeout(Duration(seconds: 30));
  //
  //     var responseJson = json.decode(response.body.toString());
  //
  //     print('responseJson'+responseJson['status'].toString());
  //     print('responseJson'+responseJson.toString());
  //   } on SocketException {
  //     throw FetchDataException('No Internet Connection');
  //   } catch (e) {
  //     print("Error on Get : " + e.toString());
  //   }
  //   return responseJson;
  // }

  Future<CRMSingleIDModel> getCRMSpecificList(
      String productId) async {
    var url = ApiMapping.getURI(apiEndPoint.single_CRM);
print(url+productId);
    try {
      dynamic response = await _apiServices.getGetApiResponse(url + productId);
      return response = CRMSingleIDModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<CartListModel> putProductInCartList(dynamic data) async {
    var url = ApiMapping.getURI(apiEndPoint.put_carts);
    try {
      dynamic response = await _apiServices.getPutApiResponse(url, data);
      print("putProductInCartList list: " + response.toString());

      return response = CartListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }


  Future<FindByFMCGCodeScannerModel> getSingleProductScannerList(
      String FMCGCode, BuildContext context) async {
    Map<String, String> fmcgData = {
      'fmcg_code': FMCGCode.toString(),
    };
    print("getProductBy Query" + fmcgData.toString());
    var url = '/product/findByFmcgCode';
    String queryString = Uri(queryParameters: fmcgData).query;
    var urls = ApiMapping.getURI(apiEndPoint.single_product_scanner);
    var requestUrl = ApiMapping.BaseAPI + url + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("ProductScanModel list: " + response.toString());
      print("NOT_FOUND  "+response['status'].toString());
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString(
      //     'ScannedProductIDPref', response['payload']['id'].toString());
      if(response['status'].toString() == 'NOT_FOUND'){
        print("NOT_FOUND....");
        // Navigator.pop(context);
        Utils.flushBarErrorMessage("Please scan proper content", context);
      }else{
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsActivity(
              specificProductId: response['payload']['id'],
              // fromScreen: ,
            ),
          ),
        );
      }

      return response = FindByFMCGCodeScannerModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }


}
