import 'package:velocit/Core/AppConstant/apiMapping.dart';

import '../../utils/constants.dart';
import '../Model/FindProductBySubCategoryModel.dart';
import 'package:http/http.dart' as http;

import '../Model/ProductAllPaginatedModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import '../data/app_excaptions.dart';

class ProductSubCategoryRepository {


  BaseApiServices _apiServices = NetworkApiServices();

  Future<FindProductBySubCategoryModel> getProductBySubCategoryList(int page,int size, int subCategoryId) async {


    Map<String, String> productData = {
      'page': page.toString(),
      'size': size.toString(),
      'sub_category_id':subCategoryId.toString(),
    };
    print("Product Query"+productData.toString());
    var url = '/product/findBySubCategoryId';
    String queryString = Uri(queryParameters: productData).query;

    var requestUrl = ApiMapping.BaseAPI +url + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("getProductBySubCategoryList list: " + response.toString());
      return response = FindProductBySubCategoryModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

/*
  Future<ProductAllPaginatedModel> getProductListing(int page,int size, String searchString) async {


    Map<String, String> productListingData = {
      'page': page.toString(),
      'size': size.toString(),
      // 'searchString':searchString.toString(),
    };
    print("getProductListing Query"+productListingData.toString());
    var url = '/product/page-query';
    String queryString = Uri(queryParameters: productListingData).query;

    var requestUrl = ApiMapping.baseAPI +url + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("getProductListing list: " + response.toString());

      return response = ProductAllPaginatedModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
*/

}