import 'package:flutter/material.dart';
import 'package:velocit/Core/repository/auth_repository.dart';

import '../Model/userModel.dart';
import '../data/responses/api_response.dart';

class CartViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();

ApiResponse<UserModel> userSpecificId = ApiResponse.loading();

  setUserList(ApiResponse<UserModel> response) {
    userSpecificId = response;
    notifyListeners();
  }
  Future<void> userSpecificIDWithGet(BuildContext context, String id) async {
    setUserList(ApiResponse.loading());

    _myRepo.getUserDetailsById(id).then((value) async {
      setUserList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setUserList(ApiResponse.error(error.toString()));
    });
  }

}