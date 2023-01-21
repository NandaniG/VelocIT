import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocit/Core/Model/CRMModel.dart';
import 'package:velocit/Core/data/responses/api_response.dart';
import '../../pages/Activity/Product_Activities/ProductDetails_activity.dart';
import '../Model/CRMModels/CRMSingleIDModel.dart';
import '../Model/CRMModels/FindCRMBySubCategory.dart';
import '../Model/FindProductBySubCategoryModel.dart';
import '../Model/CartModel.dart';
import '../Model/OfferProductListModel.dart';
import '../Model/ProductAllPaginatedModel.dart';
import '../Model/ProductCategoryModel.dart';
import '../Model/ServiceModels/FindServicesBySubCategory.dart';
import '../Model/ServiceModels/SingleServiceModel.dart';
import '../Model/productSpecificListModel.dart';
import '../Model/scannerModel/SingleProductModel.dart';
import '../Model/scannerModel/productScanModel.dart';
import '../repository/product_subCategory_repository.dart';
import '../repository/productlisting_repository.dart';

class ProductSpecificListViewModel with ChangeNotifier {
  final _myRepo = ProductSpecificListRepository();
  final _mySubCategoryRepo = ProductSubCategoryRepository();
  final _myProductListingRepo = ProductSubCategoryRepository();

  ApiResponse<ProductSpecificListModel> productSpecificList =
      ApiResponse.loading();
  ApiResponse<SingleProductIDModel> singleproductSpecificList =
      ApiResponse.loading();
  ApiResponse<SingleServiceIDModel> singleServiceSpecificList =
      ApiResponse.loading();
  ApiResponse<CRMSingleIDModel> singleCRMSpecificList =
      ApiResponse.loading();

  ApiResponse<CartListModel> cartList = ApiResponse.loading();
  ApiResponse<ProductCategoryModel> productCategories = ApiResponse.loading();
  ApiResponse<FindProductBySubCategoryModel> productSubCategory =
      ApiResponse.loading();
  ApiResponse<FindServicesbySUbCategoriesModel> serviceSubCategory =
      ApiResponse.loading();

  ApiResponse<FindCRMbySUbCategoriesModel> CRMSubCategory =
      ApiResponse.loading();
  ApiResponse<OfferProductsListModel> offerSubCategory =
      ApiResponse.loading();
  ApiResponse<FindByFMCGCodeScannerModel> singleProductScan = ApiResponse.loading();
  ApiResponse<ProductAllPaginatedModel> productListingResponse =
      ApiResponse.loading();
  bool isHome = false;
  bool isBottomAppCart = false;
  //
  // setProductSpecificList(ApiResponse<ProductSpecificListModel> response) {
  //   productSpecificList = response;
  //   notifyListeners();
  // }
  setSingleProductSpecificList(ApiResponse<SingleProductIDModel> response) {
    singleproductSpecificList = response;
    notifyListeners();
  }
  setSingleServiceSpecificList(ApiResponse<SingleServiceIDModel> response) {
    singleServiceSpecificList = response;
    notifyListeners();
  }  setCRMSpecificList(ApiResponse<CRMSingleIDModel> response) {
    singleCRMSpecificList = response;
    notifyListeners();
  }

  setProductSubCategoryList(
      ApiResponse<FindProductBySubCategoryModel> response) {
    productSubCategory = response;
    notifyListeners();
  }
  setServiceSubCategoryList(
      ApiResponse<FindServicesbySUbCategoriesModel> response) {
    serviceSubCategory = response;
    notifyListeners();
  }
  setCRMSubCategoryList(
      ApiResponse<FindCRMbySUbCategoriesModel> response) {
    CRMSubCategory = response;
    notifyListeners();
  }
 setOfferSubCategoryList(
      ApiResponse<OfferProductsListModel> response) {
   offerSubCategory = response;
    notifyListeners();
  }

  setSingleProductScannerList(ApiResponse<FindByFMCGCodeScannerModel> response) {
    singleProductScan = response;
    notifyListeners();
  }

  getProductListing(ApiResponse<ProductAllPaginatedModel> response) {
    productListingResponse = response;
    notifyListeners();
  }

  putCartList(ApiResponse<CartListModel> response) {
    cartList = response;
    notifyListeners();
  }

  getProductCategoriesList(ApiResponse<ProductCategoryModel> response) {
    productCategories = response;
    notifyListeners();
  }

  //   Map data = {'username': 'testuser@test.com'};

  // Future<void> productSpecificListWithGet(
  //     BuildContext context, dynamic data) async {
  //   setProductSpecificList(ApiResponse.loading());
  //
  //   _myRepo.getProductSpecificList(data).then((value) async {
  //     setProductSpecificList(ApiResponse.completed(value));
  //   }).onError((error, stackTrace) {
  //     setProductSpecificList(ApiResponse.error(error.toString()));
  //   });
  // }

  Future<void> productSingleIDListWithGet(
      BuildContext context,String productId) async {
    setSingleProductSpecificList(ApiResponse.loading());

    _myRepo.getSingleProductSpecificList(productId).then((value) async {
      setSingleProductSpecificList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setSingleProductSpecificList(ApiResponse.error(error.toString()));
    });
  }
  Future<void> serviceSingleIDListWithGet(
      BuildContext context,String productId) async {
    setSingleServiceSpecificList(ApiResponse.loading());

    _myRepo.getSingleServiceSpecificList(productId).then((value) async {
      setSingleServiceSpecificList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setSingleServiceSpecificList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> CRMSingleIDListWithGet(
      BuildContext context,String productId) async {
    setCRMSpecificList(ApiResponse.loading());

    _myRepo.getCRMSpecificList(productId).then((value) async {
      setCRMSpecificList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCRMSpecificList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> cartListWithPut(BuildContext context, dynamic data) async {
    putCartList(ApiResponse.loading());

    _myRepo.putProductInCartList(data).then((value) async {
      putCartList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      putCartList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> productBySubCategoryWithGet(
      int page, int size, int subCategoryId) async {
    setProductSubCategoryList(ApiResponse.loading());

    _mySubCategoryRepo
        .getProductBySubCategoryList(page, size, subCategoryId)
        .then((value) async {
      // productSubCategory.data!.payload!.content! .addAll(value.payload!.content!);

      setProductSubCategoryList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProductSubCategoryList(ApiResponse.error(error.toString()));
    });
  }
  Future<void> serviceBySubCategoryWithGet(
      int page, int size, int subCategoryId) async {
    setServiceSubCategoryList(ApiResponse.loading());

    _mySubCategoryRepo
        .getServiceBySubCategoryList(page, size, subCategoryId)
        .then((value) async {
      // productSubCategory.data!.payload!.content! .addAll(value.payload!.content!);

      setServiceSubCategoryList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setServiceSubCategoryList(ApiResponse.error(error.toString()));
    });
  }
  Future<void> CRMBySubCategoryWithGet(
      int page, int size, int subCategoryId) async {
    setCRMSubCategoryList(ApiResponse.loading());

    _mySubCategoryRepo
        .getCRMBySubCategoryList(page, size, subCategoryId)
        .then((value) async {
      setCRMSubCategoryList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCRMSubCategoryList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> OfferBySubCategoryWithGet(
      int page, int size, int subCategoryId) async {
    setOfferSubCategoryList(ApiResponse.loading());

    _mySubCategoryRepo
        .getOffersBySubCategoryList(page, size, subCategoryId)
        .then((value) async {
      setOfferSubCategoryList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setOfferSubCategoryList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> getSingleProductScannerWithGet( String subCategoryId,BuildContext context) async {
    setSingleProductScannerList(ApiResponse.loading());

    _myRepo.getSingleProductScannerList(subCategoryId,context).then((value) async {
      // productSubCategory.data!.payload!.content! .addAll(value.payload!.content!);


      setSingleProductScannerList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setSingleProductScannerList(ApiResponse.error(error.toString()));
    });
  }
}
