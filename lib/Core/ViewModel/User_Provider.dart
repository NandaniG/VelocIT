import 'package:flutter/cupertino.dart';
import 'package:velocit/Core/Model/userModel.dart';

import '../Service/user_service.dart';

class UsersProvider extends ChangeNotifier {
  final service = UserService();
  bool isLoading = false;
  UserModel userModel =
  UserModel();

  var response;

  Future<UserModel> getUserList() async {
    isLoading = true;
    userModel = (await service.getUser()) as UserModel ;
    isLoading = false;

    // if (response.status == 200) {
    //   isLoading = false;
    //   authenticateModel = response;
    //
    // } else {
    //   isLoading = true;
    // }
    return userModel;
    notifyListeners();
  }


}
