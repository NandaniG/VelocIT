import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:velocit/Core/data/responses/api_response.dart';
import '../Model/CartModel.dart';
import '../Model/productSpecificListModel.dart';
import '../repository/productlisting_repository.dart';

class ProductSpecificListViewModel with ChangeNotifier {
  final _myRepo = ProductSpecificListRepository();

  ApiResponse<ProductSpecificListModel> productSpecificList = ApiResponse.loading();
  ApiResponse<CartListModel> cartList = ApiResponse.loading();
  bool isHome = false;
  bool isBottomAppCart = false;
  setProductSpecificList(ApiResponse<ProductSpecificListModel> response) {
    productSpecificList = response;
    notifyListeners();
  }

  putCartList(ApiResponse<CartListModel> response) {
    cartList = response;
    notifyListeners();
  }
  //   Map data = {'username': 'testuser@test.com'};

  Future<void> productSpecificListWithGet(BuildContext context,dynamic data) async {
    setProductSpecificList(ApiResponse.loading());

    _myRepo.getProductSpecificList(data).then((value) async {
      setProductSpecificList(ApiResponse.completed(value));

    }).onError((error, stackTrace) {
      setProductSpecificList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> cartListWithPut(BuildContext context,dynamic data) async {
    putCartList(ApiResponse.loading());

    _myRepo.putProductInCartList(data).then((value) async {
      putCartList(ApiResponse.completed(value));

    }).onError((error, stackTrace) {
      putCartList(ApiResponse.error(error.toString()));
    });
  }
}
