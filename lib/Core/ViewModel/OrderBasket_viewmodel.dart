import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../AppConstant/apiMapping.dart';
import '../Model/Orders/ActiveOrdersBasketModel.dart';
import '../data/responses/api_response.dart';
import '../repository/OrderBasket_repository.dart';
import '../repository/auth_repository.dart';
import 'package:http/http.dart'as http;
class OrderBasketViewModel with ChangeNotifier {
  final _myRepo = OrderBasketRepository();


  ApiResponse<ActiveOrderBasketModel> activeOrderBasket = ApiResponse.loading();

 dynamic orderBasketData;
  loadingOrderBasket(ApiResponse<ActiveOrderBasketModel> response) {
    activeOrderBasket = response;
    notifyListeners();
  }

  Future<void> getOrderBasketView(BuildContext context, dynamic data) async {
    loadingOrderBasket(ApiResponse.loading());

    _myRepo.getOrderBasketApi(data).then((value) async {
      loadingOrderBasket(ApiResponse.completed(value));
      orderBasketData = value;
    }).onError((error, stackTrace) {
      print("error : " +error.toString());
      loadingOrderBasket(ApiResponse.error(error.toString()));
    });
  }
}

