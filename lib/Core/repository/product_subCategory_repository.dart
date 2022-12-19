import 'package:velocit/Core/AppConstant/apiMapping.dart';

import '../Model/FindProductBySubCategoryModel.dart';
import 'package:http/http.dart' as http;

import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import '../data/app_excaptions.dart';

class ProductSubCategoryRepository {


  BaseApiServices _apiServices = NetworkApiServices();

  Future<FindProductBySubCategoryModel> getProductBySubCategoryList(int page,int size, int subCategoryId) async {


    Map<String, String> productData = {
      'page': page.toString(),
      'size': size.toString(),
      'sub_category_id':subCategoryId.toString(),
    };
    print("Product Query"+productData.toString());
    var url = '/product/findBySubCategoryId';
    String queryString = Uri(queryParameters: productData).query;

    var requestUrl = ApiMapping.baseAPI +url + '?' + queryString!;

    try {
      dynamic response = await _apiServices.getGetApiResponse(requestUrl);
      print("AllProductPaginatedModel list: " + response.toString());

      return response = FindProductBySubCategoryModel.fromJson(response);
    } catch (e) {
      throw e;
    }

 /*   dynamic responseJson;
    try {
      final client = http.Client();
      final response =
      await client.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson = NetworkApiServices().returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;*/
  }

}