import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:velocit/Core/Enum/apiEndPointEnums.dart';

import '../../pages/Activity/Product_Activities/ProductDetails_activity.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/FindProductBySubCategoryModel.dart';
import '../Model/CartModel.dart';
import '../Model/CategoriesModel.dart';
import '../Model/ProductCategoryModel.dart';
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

  Future<SingleProductIDModel> getSingleProductSpecificList(String productId) async {
    var url = ApiMapping.getURI(apiEndPoint.single_product);

    try {
      dynamic response = await _apiServices.getGetApiResponse(url+productId);
      return response = SingleProductIDModel.fromJson(response);
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
      String FMCGCode,BuildContext context) async {


    Map<String, String> fmcgData = {
      'fmcg_code': FMCGCode.toString(),

    };
    print("getProductBy Query"+fmcgData.toString());
    var url = '/product/findByFmcgCode';
    String queryString = Uri(queryParameters: fmcgData).query;
    var urls = ApiMapping.getURI(apiEndPoint.single_product_scanner);
    var requestUrl = ApiMapping.baseAPI +url + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("ProductScanModel list: " + response.toString());

      final prefs = await SharedPreferences.getInstance();

      print("ProductScanModel list: " + response['payload']['id'].toString());
      prefs.setString('ScannedProductIDPref', response['payload']['id'].toString());

      Navigator.of(context)
          .pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProductDetailsActivity(
            id: response['payload']['id'],
          ),
        ),
      )
       ;

      return response = FindByFMCGCodeScannerModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

// Future<ProductCategoryModel> getProductCategoryList() async {
//   var url = ApiMapping.getURI(apiEndPoint.get_product_categories);
//   try {
//     dynamic response = await _apiServices.getGetApiResponse(url);
//     print("ProductCategoryModel list: " + response.toString());
//
//     return response = ProductCategoryModel.fromJson(response);
//   } catch (e) {
//     throw e;
//   }
// }
// Future<FindProductBySubCategoryModel> getProductBySubCategoryList() async {
//   Map<String, String> productData = {
//     'page': '0',
//     'size': '10',
//     'sub_category_id': '2',
//   };  var url = 'https://velocitapiqa.fulgorithmapi.com:443/api/v1/product/findBySubCategoryId';
//   String queryString = Uri(queryParameters: productData).query;
//
//   var requestUrl = url + '?' + queryString!;
//
//   try {
//     dynamic response = await _apiServices.getGetApiResponse(requestUrl);
//     print("AllProductPaginatedModel list: " + response.toString());
//
//     return response = FindProductBySubCategoryModel.fromJson(response);
//   } catch (e) {
//     throw e;
//   }
//
//   dynamic responseJson;
//   try {
//     final client = http.Client();
//     final response =
//     await client.get(Uri.parse(url)).timeout(Duration(seconds: 10));
//     responseJson = NetworkApiServices().returnResponse(response);
//   } on SocketException {
//     throw FetchDataException('No Internet Connection');
//   }
//   return responseJson;
// }
}
