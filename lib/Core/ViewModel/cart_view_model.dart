import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';
import '../Model/CartModels/AddressListModel.dart';
import '../Model/CartModels/CartCreateRetrieveModel.dart';
import '../Model/CartModels/CartSpecificIDForEmbeddedModel.dart';
import '../Model/CartModels/CartSpecificIdModel.dart';
import '../Model/CartModels/SendCartForPaymentModel.dart';
import '../data/responses/api_response.dart';
import '../repository/cart_repository.dart';

class CartViewModel with ChangeNotifier {
  final _myRepo = CartRepository();

  ApiResponse<CartSpecificIdModel> cartSpecificID = ApiResponse.loading();
  ApiResponse<CartSpecificIDforEmbeddedModel> cartEmbeddedID =
      ApiResponse.loading();
  ApiResponse<SendCartForPaymentModel> sendCartForPayment =
      ApiResponse.loading();
  ApiResponse<AddressListModel> getAddress = ApiResponse.loading();

  setCartSpecificIDList(ApiResponse<CartSpecificIdModel> response) {
    cartSpecificID = response;
    notifyListeners();
  }

  setCartSpecificIDEmbeddedList(
      ApiResponse<CartSpecificIDforEmbeddedModel> response) {
    cartEmbeddedID = response;
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

  Future<void> cartSpecificIDEmbeddedWithGet(
      BuildContext context, String id) async {
    setCartSpecificIDEmbeddedList(ApiResponse.loading());

    _myRepo.getCartSpecificIDEmbeddedList(id).then((value) async {
      setCartSpecificIDEmbeddedList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCartSpecificIDEmbeddedList(ApiResponse.error(error.toString()));
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
