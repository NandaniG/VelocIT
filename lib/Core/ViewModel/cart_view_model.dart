import 'package:flutter/material.dart';

import '../Model/CartModels/AddressListModel.dart';
import '../Model/CartModels/CartCreateRetrieveModel.dart';
import '../Model/CartModels/CartSpecificIdModel.dart';
import '../Model/CartModels/SendCartForPaymentModel.dart';
import '../data/responses/api_response.dart';
import '../repository/cart_repository.dart';

class CartViewModel with ChangeNotifier {
  final _myRepo = CartRepository();

  ApiResponse<CartSpecificIdModel> cartSpecificID = ApiResponse.loading();
  ApiResponse<SendCartForPaymentModel> sendCartForPayment =
      ApiResponse.loading();
  ApiResponse<AddressListModel> getAddress = ApiResponse.loading();

  setCartSpecificIDList(ApiResponse<CartSpecificIdModel> response) {
    cartSpecificID = response;
    notifyListeners();
  }

  setCartForPayment(ApiResponse<SendCartForPaymentModel> response) {
    sendCartForPayment = response;
    notifyListeners();
  }

  getAddressForPayment(ApiResponse<AddressListModel> response) {
    getAddress = response;
    notifyListeners();
  }

  Future<void> cartSpecificIDWithGet(BuildContext context, String id) async {
    setCartSpecificIDList(ApiResponse.loading());

    _myRepo.getCartSpecificIDList(id).then((value) async {
      setCartSpecificIDList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCartSpecificIDList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> sendCartForPaymentWithGet(
      BuildContext context, String id) async {
    setCartForPayment(ApiResponse.loading());

    _myRepo.getSendCartForPaymentList(id).then((value) async {
      setCartForPayment(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCartForPayment(ApiResponse.error(error.toString()));
    });
  }

  Future<void> sendAddressWithGet(BuildContext context, String id) async {
    getAddressForPayment(ApiResponse.loading());

    _myRepo.getAddressList(id).then((value) async {
      getAddressForPayment(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      getAddressForPayment(ApiResponse.error(error.toString()));
    });
  }
}
