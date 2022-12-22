import 'package:flutter/material.dart';

import '../Model/CartModels/CartCreateRetrieveModel.dart';
import '../data/responses/api_response.dart';
import '../repository/cart_repository.dart';

class CartViewModel with ChangeNotifier {
  final _myRepo = CartRepository();

  ApiResponse<CartCreateRetrieveModel> cartCreateRetrieve =
  ApiResponse.loading();

  setCartCreateRetrieveList(ApiResponse<CartCreateRetrieveModel> response) {
    cartCreateRetrieve = response;
    notifyListeners();
  }
  //
  // Future<void> cartCreateRetrieveViewWithGet(
  //     BuildContext context, dynamic data) async {
  //   setCartCreateRetrieveList(ApiResponse.loading());
  //
  //   _myRepo.cartCreateAndRetrieveUsingPost(data).then((value) async {
  //     setCartCreateRetrieveList(ApiResponse.completed(value));
  //   }).onError((error, stackTrace) {
  //     setCartCreateRetrieveList(ApiResponse.error(error.toString()));
  //   });
  // }

}