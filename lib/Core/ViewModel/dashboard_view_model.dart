import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:velocit/Core/Model/ProductListingModel.dart';
import 'package:velocit/Core/data/responses/api_response.dart';
import 'package:velocit/Core/repository/dashboard_repository.dart';

import '../Model/CategoriesModel.dart';
import '../Model/CategoriesModel.dart';
import '../Model/ProductAllPaginatedModel.dart';
import '../Model/ProductCategoryModel.dart';
import '../Model/ProductsModel/Product_by_search_term_model.dart';
import '../Model/servicesModel.dart';
import '../repository/auth_repository.dart';

class DashboardViewModel with ChangeNotifier {
  final _myRepo = DashBoardRepository();
  final _myProductListingRepo = DashBoardRepository();
  final _myProductPageRepo = DashBoardRepository();

  ApiResponse<CategoriesModel> categoryList = ApiResponse.loading();

  ApiResponse<ServicesModel> serviceList = ApiResponse.loading();
  ApiResponse<ProductsListingModel> productListingList = ApiResponse.loading();
  ApiResponse<ProductCategoryModel> productCategoryList = ApiResponse.loading();
  ApiResponse<ProductAllPaginatedModel> productListingResponse =
      ApiResponse.loading();
  ApiResponse<ProductFindBySearchTermModel> productByTermResponse =
      ApiResponse.loading();

  setCategoryList(ApiResponse<CategoriesModel> response) {
    categoryList = response;
    notifyListeners();
  }

  setServicesList(ApiResponse<ServicesModel> response) {
    serviceList = response;
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

  ///
  getProductListing(ApiResponse<ProductAllPaginatedModel> response) {
    productListingResponse = response;
    notifyListeners();
  }

  getProductByTermsListing(ApiResponse<ProductFindBySearchTermModel> response) {
    productByTermResponse = response;
    notifyListeners();
  }

/*
  Future<void> shopByCategoriesWithGet() async {
    setCategoryList(ApiResponse.loading());

    _myRepo.getShopByCategories().then((value) async {
      setCategoryList(ApiResponse.completed(value));

    }).onError((error, stackTrace) {
      setCategoryList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> bookOurServicesWithGet() async {
    setServicesList(ApiResponse.loading());

    _myRepo.getBookOurServices().then((value) async {

    setServicesList(ApiResponse.completed(value));

    }).onError((error, stackTrace) {
      setServicesList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> productListingWithGet() async {
    setProductListingList(ApiResponse.loading());

    _myRepo.getProductListing().then((value) async {

      setProductListingList(ApiResponse.completed(value));

    }).onError((error, stackTrace) {
      setProductListingList(ApiResponse.error(error.toString()));
    });
  }*/

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
}
