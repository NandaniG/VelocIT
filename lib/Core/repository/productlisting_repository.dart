import 'dart:convert';

import 'package:velocit/Core/Enum/apiEndPointEnums.dart';

import '../AppConstant/apiMapping.dart';
import '../Model/CartModel.dart';
import '../Model/CategoriesModel.dart';
import '../Model/productSpecificListModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

class ProductSpecificListRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<ProductSpecificListModel> getProductSpecificList(dynamic data) async {
    var url = ApiMapping.getURI(apiEndPoint.get_productsListing);

    try {
      dynamic response = await _apiServices.getPostApiResponse(url, data);
      return response = ProductSpecificListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<CartListModel> putProductInCartList(dynamic data) async {
    var url = ApiMapping.getURI(apiEndPoint.put_carts);
    try {
      dynamic response = await _apiServices.getPutApiResponse(url, data);
      print("putProductInCartList list: " + response.toString());

      return response = CartListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
