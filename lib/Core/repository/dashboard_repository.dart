import 'dart:convert';

import 'package:velocit/Core/Enum/apiEndPointEnums.dart';

import '../AppConstant/apiMapping.dart';
import '../Model/CategoriesModel.dart';
import '../Model/ProductAllPaginatedModel.dart';
import '../Model/ProductCategoryModel.dart';
import '../Model/ProductListingModel.dart';
import '../Model/ProductsModel/Product_by_search_term_model.dart';
import '../Model/servicesModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

class DashBoardRepository {
  BaseApiServices _apiServices = NetworkApiServices();

 /* Future<CategoriesModel> getShopByCategories() async {
    var url = ApiMapping.getURI(apiEndPoint.get_shopByCategories);

    try {
      dynamic response = await _apiServices.getGetApiResponse(url);

      return response = CategoriesModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<ServicesModel> getBookOurServices() async {
    var url = ApiMapping.getURI(apiEndPoint.get_bookOurServices);

    try {
      dynamic response = await _apiServices.getGetApiResponse(url);

      print("get shop");
      return response = ServicesModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }


  Future<ProductsListingModel> getProductListing() async {
    var url = ApiMapping.getURI(apiEndPoint.get_products);

    try {
      dynamic response = await _apiServices.getGetApiResponse(url);

      print("get shop");
      return response = ProductsListingModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

*/
  Future<ProductCategoryModel> getProductCategoryListing() async {
    var url = ApiMapping.getURI(apiEndPoint.get_product_categories);

    try {
      dynamic response = await _apiServices.getGetApiResponse(url);

      print("ProductCategoryModel list: " + response.toString());

      return response = ProductCategoryModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future<ProductAllPaginatedModel> getProductListing(int page,int size) async {
    Map<String, String> productListingData = {
      'page': page.toString(),
      'size': size.toString(),
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

  Future<ProductFindBySearchTermModel> getProductBySearchTerms(int page,int size, String searchString) async {
    Map<String, String> productListingData = {
      // 'search_term': searchString.toString(),
      'search_term': 'Apple',
      'page': page.toString(),
      'size': size.toString(),
      // 'searchString':searchString.toString(),
    };
    print("getProductBySearchTerms Query"+productListingData.toString());
    var url = '/product/findBySearchTerm';
    String queryString = Uri(queryParameters: productListingData).query;

    var requestUrl = ApiMapping.baseAPI +url + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("getProductBySearchTerms list: " + response.toString());

      return response = ProductFindBySearchTermModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

}
