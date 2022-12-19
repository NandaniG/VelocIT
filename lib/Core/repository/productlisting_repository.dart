import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:velocit/Core/Enum/apiEndPointEnums.dart';

import '../AppConstant/apiMapping.dart';
import '../Model/FindProductBySubCategoryModel.dart';
import '../Model/CartModel.dart';
import '../Model/CategoriesModel.dart';
import '../Model/ProductCategoryModel.dart';
import '../Model/productSpecificListModel.dart';
import '../data/app_excaptions.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

class ProductSpecificListRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<ProductSpecificListModel> getProductSpecificList(dynamic data) async {
    var url = ApiMapping.getURI(apiEndPoint.get_productsListing);

    try {
      dynamic response = await _apiServices.getPostApiResponse(url, data);
      return response = ProductSpecificListModel.fromJson(response);
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

  Future<ProductCategoryModel> getProductCategoryList() async {
    var url = ApiMapping.getURI(apiEndPoint.get_product_categories);
    try {
      dynamic response = await _apiServices.getGetApiResponse(url);
      print("ProductCategoryModel list: " + response.toString());

      return response = ProductCategoryModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future<FindProductBySubCategoryModel> getProductBySubCategoryList() async {
    Map<String, String> productData = {
      'page': '0',
      'size': '10',
      'sub_category_id': '2',
    };  var url = 'https://velocitapiqa.fulgorithmapi.com:443/api/v1/product/findBySubCategoryId';
    String queryString = Uri(queryParameters: productData).query;

    var requestUrl = url + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("AllProductPaginatedModel list: " + response.toString());

      return response = FindProductBySubCategoryModel.fromJson(response);
    } catch (e) {
      throw e;
    }

    dynamic responseJson;
    try {
      final client = http.Client();
      final response =
      await client.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson = NetworkApiServices().returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }
}
