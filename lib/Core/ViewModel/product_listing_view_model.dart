import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:velocit/Core/data/responses/api_response.dart';
import '../Model/FindProductBySubCategoryModel.dart';
import '../Model/CartModel.dart';
import '../Model/ProductCategoryModel.dart';
import '../Model/productSpecificListModel.dart';
import '../repository/product_subCategory_repository.dart';
import '../repository/productlisting_repository.dart';

class ProductSpecificListViewModel with ChangeNotifier {
  final _myRepo = ProductSpecificListRepository();
  final _mySubCategoryRepo = ProductSubCategoryRepository();

  ApiResponse<ProductSpecificListModel> productSpecificList =
      ApiResponse.loading();
  ApiResponse<CartListModel> cartList = ApiResponse.loading();
  ApiResponse<ProductCategoryModel> productCategories = ApiResponse.loading();
  ApiResponse<FindProductBySubCategoryModel> productSubCategory = ApiResponse.loading();
  bool isHome = false;
  bool isBottomAppCart = false;

  setProductSpecificList(ApiResponse<ProductSpecificListModel> response) {
    productSpecificList = response;
    notifyListeners();
  }
  setProductSubCategoryList(ApiResponse<FindProductBySubCategoryModel> response) {
    productSubCategory = response;
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

  Future<void> productSpecificListWithGet(
      BuildContext context, dynamic data) async {
    setProductSpecificList(ApiResponse.loading());

    _myRepo.getProductSpecificList(data).then((value) async {
      setProductSpecificList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProductSpecificList(ApiResponse.error(error.toString()));
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


  Future<void> productBySubCategoryWithGet(int page,int size, int subCategoryId) async {
    setProductSubCategoryList(ApiResponse.loading());

    _mySubCategoryRepo.getProductBySubCategoryList(page,size, subCategoryId).then((value) async {
      setProductSubCategoryList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProductSubCategoryList(ApiResponse.error(error.toString()));
    });
  }
/*var productCategoryList ;
  Future<void> productCategorieWithGet() async {
    getProductCategoriesList(ApiResponse.loading());

    _myRepo.getProductCategoryList().then((value) async {

      getProductCategoriesList(ApiResponse.completed(value));
      print('value.productList![1].productCategoryImageId');
      print(value.productList![1].productCategoryImageId);
      productCategoryList =value.productList![1].productCategoryImageId;
    }).onError((error, stackTrace) {

      getProductCategoriesList(ApiResponse.error(error.toString()));
    });
  }*/
}
