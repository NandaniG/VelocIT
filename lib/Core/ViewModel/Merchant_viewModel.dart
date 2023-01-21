import 'package:flutter/material.dart';

import '../Model/MerchantModel/MerchantListByIdModel.dart';
import '../Model/MerchantModel/MerchantListModel.dart';
import '../data/responses/api_response.dart';
import '../repository/Merchant_repository.dart';

class MerchantViewModel with ChangeNotifier {
  final _myRepo = MerchantRepository();


  ApiResponse<MerchantListModel> merchantResponse= ApiResponse.loading();
  ApiResponse<MerchantListByIdModel> merchantListByIdResponse= ApiResponse.loading();

  dynamic orderBasketData;

  loadingMerchantList(ApiResponse<MerchantListModel> response) {
    merchantResponse = response;
    notifyListeners();
  }
  loadingMerchantListWithId(ApiResponse<MerchantListByIdModel> response) {
    merchantListByIdResponse = response;
    notifyListeners();
  }


  Future<void> getPostMerchantNearMe(BuildContext context, dynamic data) async {
    loadingMerchantList(ApiResponse.loading());

    _myRepo.merchantPostAPI(data).then((value) async {
      loadingMerchantList(ApiResponse.completed(value));
      orderBasketData = value;
    }).onError((error, stackTrace) {
      print("error : " +error.toString());
      loadingMerchantList(ApiResponse.error(error.toString()));
    });
  }
  Future<void> merchantByIdWithGet(
      int page, int size, int merchantID) async {
    loadingMerchantListWithId(ApiResponse.loading());

    _myRepo
        .getMerchantByMerchantIdList(page, size, merchantID)
        .then((value) async {
      // productSubCategory.data!.payload!.content! .addAll(value.payload!.content!);

      loadingMerchantListWithId(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      loadingMerchantListWithId(ApiResponse.error(error.toString()));
    });
  }
}