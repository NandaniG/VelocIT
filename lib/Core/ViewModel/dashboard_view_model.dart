import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:velocit/Core/Model/ProductListingModel.dart';
import 'package:velocit/Core/data/responses/api_response.dart';
import 'package:velocit/Core/repository/dashboard_repository.dart';

import '../Model/CategoriesModel.dart';
import '../Model/CategoriesModel.dart';
import '../Model/Orders/ActiveOrdersBasketModel.dart';
import '../Model/ProductAllPaginatedModel.dart';
import '../Model/ProductCategoryModel.dart';
import '../Model/ProductsModel/Product_by_search_term_model.dart';
import '../Model/RecommendedForYouModel.dart';
import '../Model/ServiceSubCategoriesModel.dart';
import '../repository/auth_repository.dart';

class DashboardViewModel with ChangeNotifier {
  final _myRepo = DashBoardRepository();
  final _myProductListingRepo = DashBoardRepository();
  final _myProductPageRepo = DashBoardRepository();

  ApiResponse<CategoriesModel> categoryList = ApiResponse.loading();

  ApiResponse<ProductsListingModel> productListingList = ApiResponse.loading();
  ApiResponse<ProductCategoryModel> productCategoryList = ApiResponse.loading();
  ApiResponse<List<ServicesSubCategoriesModel>> serviceCategoryList = ApiResponse.loading();
  ApiResponse<RecommendedForYouModel> recommendedList = ApiResponse.loading();

  ApiResponse<ProductAllPaginatedModel> productListingResponse =
      ApiResponse.loading();
  ApiResponse<ProductFindBySearchTermModel> productByTermResponse =
      ApiResponse.loading();

  setCategoryList(ApiResponse<CategoriesModel> response) {
    categoryList = response;
    notifyListeners();
  }


  setProductListingList(ApiResponse<ProductsListingModel> response) {
    productListingList = response;
    notifyListeners();
  }

  getProductCategoryListingList(ApiResponse<ProductCategoryModel> response) {
    productCategoryList = response;
    notifyListeners();
  }
  getServiceCategoryListingList(ApiResponse<List<ServicesSubCategoriesModel>> response) {
    serviceCategoryList = response;
    notifyListeners();
  }


  getProductListing(ApiResponse<ProductAllPaginatedModel> response) {
    productListingResponse = response;
    notifyListeners();
  }
  getRecommended(ApiResponse<RecommendedForYouModel> response) {
    recommendedList = response;
    notifyListeners();
  }

  getProductByTermsListing(ApiResponse<ProductFindBySearchTermModel> response) {
    productByTermResponse = response;
    notifyListeners();
  }


  Future<void> productListingWithGet(
      int page, int size) async {
    getProductListing(ApiResponse.loading());

    _myProductListingRepo
        .getProductListing(page, size)
        .then((value) async {
      getProductListing(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      getProductListing(ApiResponse.error(error.toString()));
    });
  }

  Future<void> recommendedWithGet(
      int page, int size) async {
    getRecommended(ApiResponse.loading());

    _myProductListingRepo
        .getRecommendedForYou(page, size)
        .then((value) async {
      getRecommended(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      getRecommended(ApiResponse.error(error.toString()));
    });
  }

  Future<void> getProductBySearchTermsWithGet(
      int page, int size, String searchString) async {
    getProductByTermsListing(ApiResponse.loading());

    _myProductPageRepo
        .getProductBySearchTerms(page, size, searchString)
        .then((value) async {
      getProductByTermsListing(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      getProductByTermsListing(ApiResponse.error(error.toString()));
    });
  }

  Future<void> productCategoryListingWithGet() async {
    getProductCategoryListingList(ApiResponse.loading());

    _myRepo.getProductCategoryListing().then((value) async {
      getProductCategoryListingList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      getProductCategoryListingList(ApiResponse.error(error.toString()));
    });
  }
  Map<dynamic, dynamic> jsonData = {};

  loadJson() async {
    try {


      String jsonContents = await DashBoardRepository().getServiceCategoryListing();
      // DashBoardRepository().getServiceCategoryListing();

      jsonData = json.decode(jsonContents);

      print("____________loadJson______________________");

      // print(jsonData["payload"]['consumer_baskets'].toString());

      notifyListeners();
    }catch(e){}}

    /*  Future<void> serviceCategoryListingWithGet() async {
    getServiceCategoryListingList(ApiResponse.loading());

    _myRepo.getServiceCategoryListing().then((value) async {
      getServiceCategoryListingList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      getServiceCategoryListingList(ApiResponse.error(error.toString()));
    });
  }*/
}
