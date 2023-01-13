import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/Core/Model/RecommendedForYouModel.dart';

import '../../utils/constants.dart';
import '../AppConstant/apiMapping.dart';
import '../Model/BestDealModel.dart';
import '../Model/CRMModel.dart';
import '../Model/CategoriesModel.dart';
import '../Model/Orders/ActiveOrdersBasketModel.dart';
import '../Model/ProductAllPaginatedModel.dart';
import '../Model/ProductCategoryModel.dart';
import '../Model/ProductListingModel.dart';
import '../Model/ProductsModel/Product_by_search_term_model.dart';
import '../Model/ServiceCategoryAndSubCategoriesModel.dart';
import '../Model/SimmilarProductModel.dart';
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

      print("ProductCategoryModel list: for category " + response.toString());

      return response = ProductCategoryModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future<ServiceCategoryModel> getServiceCategoryListing() async {
    var url = ApiMapping.BaseAPI + ApiMapping.ServiceSubCategory;

    try {
      dynamic response = await _apiServices.getGetApiResponse(url);

      print("ServiceSubCategory list:.... " + response.toString());

      return response = ServiceCategoryModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }  Future<CRMModel> getCRMListing() async {
    var url = ApiMapping.BaseAPI + ApiMapping.CRMSubCategory;

    try {
      dynamic response = await _apiServices.getGetApiResponse(url);

      print("CRM list:.... " + response.toString());

      return response = CRMModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

/*
  Future<List<ServicesSubCategoriesModel>> getServiceCategoryListing() async {
    var url = ApiMapping.BaseAPI + ApiMapping.ServiceSubCategory;

    try {
      dynamic response = await _apiServices.getGetApiResponse(url);

      print("ServiceSubCategory list:.... " + response.toString());
      List responseJson = json.decode(response.body);

      return responseJson.map((m) =>  ServicesSubCategoriesModel.fromJson(m)).toList();
    } catch (e) {
      throw e;
    }
  }
*/
  Future<ProductAllPaginatedModel> getProductListing(int page,int size) async {
    Map<String, String> productListingData = {
      'page': page.toString(),
      'size': size.toString(),
    };
    print("getProductListing Query"+productListingData.toString());
    var url = '/product/page-query';
    String queryString = Uri(queryParameters: productListingData).query;

    var requestUrl = ApiMapping.BaseAPI +url + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("getProductListing list: " + response.toString());

      return response = ProductAllPaginatedModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future<RecommendedForYouModel> getRecommendedForYou(int page,int size) async {
    Map<String, String> productListingData = {
      'page': page.toString(),
      'size': size.toString(),
    };
    print("RecommendedForYouModel Query"+productListingData.toString());

    String queryString = Uri(queryParameters: productListingData).query;

    var requestUrl = ApiMapping.BaseAPI +ApiMapping.RecommendForYou + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("RecommendedForYouModel list: " + response.toString());

      return response = RecommendedForYouModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
  Future<BestDealModel> getBestDeal(int page,int size) async {
    Map<String, String> productListingData = {
      'page': page.toString(),
      'size': size.toString(),
    };
    print("BestDealModel Query"+productListingData.toString());

    String queryString = Uri(queryParameters: productListingData).query;

    var requestUrl = ApiMapping.BaseAPI +ApiMapping.BestDeal + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("BestDealModel list: " + response.toString());

      return response = BestDealModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<SimilarProductModel> getSimilarProduct(int page,int size, int productId) async {
    Map<String, String> productListingData = {
      'page': page.toString(),
      'size': size.toString(),
      'product_id': productId.toString(),
    };
    print("SimilarProductModel Query"+productListingData.toString());

    String queryString = Uri(queryParameters: productListingData).query;

    var requestUrl = ApiMapping.BaseAPI +ApiMapping.SimilarProducts + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("SimilarProductModel list: " + response.toString());

      return response = SimilarProductModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<ProductFindBySearchTermModel> getProductBySearchTerms(int page,int size, String searchString) async {
    Map<String, String> productListingData = {
      // 'search_term': searchString.toString(),
      'search_term': searchString.toString(),
      'page': page.toString(),
      'size': size.toString(),
      // 'searchString':searchString.toString(),
    };
    print("getProductBySearchTerms Query"+productListingData.toString());
    var url = '/product/findBySearchTerm';
    String queryString = Uri(queryParameters: productListingData).query;

    var requestUrl = ApiMapping.BaseAPI +url + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("getProductBySearchTerms list: " + response.toString());

      return response = ProductFindBySearchTermModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

}
