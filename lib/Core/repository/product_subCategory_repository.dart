import 'package:flutter/foundation.dart';
import 'package:velocit/Core/AppConstant/apiMapping.dart';

import '../../utils/constants.dart';
import '../Model/CRMModels/FindCRMBySubCategory.dart';
import '../Model/FindProductBySubCategoryModel.dart';
import 'package:http/http.dart' as http;

import '../Model/ProductAllPaginatedModel.dart';
import '../Model/ServiceModels/FindServicesBySubCategory.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import '../data/app_excaptions.dart';

class ProductSubCategoryRepository {


  BaseApiServices _apiServices = NetworkApiServices();

  //for product listing page

  Future<FindProductBySubCategoryModel> getProductBySubCategoryList(int page,int size, int subCategoryId) async {
    Map<String, String> productData = {
      'page': page.toString(),
      'size': size.toString(),
      'sub_category_id':subCategoryId.toString(),
    };
    print("Product Query$productData");
    var url = '/product/findBySubCategoryId';
    String queryString = Uri(queryParameters: productData).query;

    var requestUrl = '${ApiMapping.BaseAPI}$url?${queryString!}';

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("getProductBySubCategoryList list: $response");
      return response = FindProductBySubCategoryModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  //for Service listing page

  Future<FindServicesbySUbCategoriesModel> getServiceBySubCategoryList(int page,int size, int subCategoryId) async {
    Map<String, String> productData = {
      'page': page.toString(),
      'size': size.toString(),
      'sub_category_id':subCategoryId.toString(),
    };
    print("Product Query$productData");
    var url = '/service/findBySubCategoryId';
    String queryString = Uri(queryParameters: productData).query;

    var requestUrl = '${ApiMapping.BaseAPI}$url?$queryString';

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      if (kDebugMode) {
        print("get Service By SubCategoryList list: $response");
      }
      return response = FindServicesbySUbCategoriesModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<FindCRMbySUbCategoriesModel> getCRMBySubCategoryList(int page,int size, int subCategoryId) async {
    Map<String, String> productData = {
      'page': page.toString(),
      'size': size.toString(),
      'sub_category_id':subCategoryId.toString(),
    };
    print("CRM Query$productData");
    var url = '/crm/findBySubCategoryId';
    String queryString = Uri(queryParameters: productData).query;

    var requestUrl = '${ApiMapping.BaseAPI}$url?$queryString';

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      if (kDebugMode) {
        print("get CRM By SubCategoryList list: $response");
      }
      return response = FindCRMbySUbCategoriesModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }



}