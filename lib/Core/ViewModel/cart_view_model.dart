import 'package:flutter/material.dart';

import '../Model/CartModels/CartCreateRetrieveModel.dart';
import '../Model/CartModels/CartSpecificIdModel.dart';
import '../data/responses/api_response.dart';
import '../repository/cart_repository.dart';

class CartViewModel with ChangeNotifier {
  final _myRepo = CartRepository();

  ApiResponse<CartSpecificIdModel> cartSpecificID =
  ApiResponse.loading();

  setCartSpecificIDList(ApiResponse<CartSpecificIdModel> response) {
    cartSpecificID = response;
    notifyListeners();
  }

  Future<void> cartSpecificIDWithGet(
      BuildContext context, String id) async {
    setCartSpecificIDList(ApiResponse.loading());

    _myRepo.getCartSpecificIDList(id).then((value) async {
      setCartSpecificIDList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCartSpecificIDList(ApiResponse.error(error.toString()));
    });
  }

}