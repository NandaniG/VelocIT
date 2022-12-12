import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:velocit/Core/Model/ProductListingModel.dart';
import 'package:velocit/Core/data/responses/api_response.dart';
import 'package:velocit/Core/repository/dashboard_repository.dart';

import '../Model/CategoriesModel.dart';
import '../Model/CategoriesModel.dart';
import '../Model/servicesModel.dart';
import '../repository/auth_repository.dart';

class DashboardViewModel with ChangeNotifier {
  final _myRepo = DashBoardRepository();

  ApiResponse<CategoriesModel> categoryList = ApiResponse.loading();

  ApiResponse<ServicesModel> serviceList = ApiResponse.loading();
  ApiResponse<ProductsListingModel> productListingList = ApiResponse.loading();

  setCategoryList(ApiResponse<CategoriesModel> response) {
    categoryList = response;
    notifyListeners();
  }
  setServicesList(ApiResponse<ServicesModel> response) {
    serviceList = response;
    notifyListeners();
  } setProductListingList(ApiResponse<ProductsListingModel> response) {
    productListingList = response;
    notifyListeners();
  }

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
  }
}
