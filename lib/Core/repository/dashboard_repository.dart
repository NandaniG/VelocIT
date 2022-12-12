import 'dart:convert';

import 'package:velocit/Core/Enum/apiEndPointEnums.dart';

import '../AppConstant/apiMapping.dart';
import '../Model/CategoriesModel.dart';
import '../Model/ProductListingModel.dart';
import '../Model/servicesModel.dart';
import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

class DashBoardRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<CategoriesModel> getShopByCategories() async {
    var url = ApiMapping.getURI(apiEndPoint.get_shopByCategories);

    try {
      dynamic response = await _apiServices.getGetApiResponse(url);

      return response = CategoriesModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<ServicesModel> getBookOurServices() async {
    var url = ApiMapping.getURI(apiEndPoint.get_bookOurServices);

    try {
      dynamic response = await _apiServices.getGetApiResponse(url);

      print("get shop");
      return response = ServicesModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }


  Future<ProductsListingModel> getProductListing() async {
    var url = ApiMapping.getURI(apiEndPoint.get_products);

    try {
      dynamic response = await _apiServices.getGetApiResponse(url);

      print("get shop");
      return response = ProductsListingModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

}
