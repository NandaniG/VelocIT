import 'package:flutter/cupertino.dart';

import '../Model/authenticateModel.dart';
import '../Model/authenticateWithUIDModel.dart';
import '../Model/userModel.dart';
import '../Service/authenticateWithUID_Service.dart';
import '../Service/user_service.dart';

class AuthenticateWithUIDProvider extends ChangeNotifier {
  final service = AuthenticateService();
  final serviceWithUID = AuthenticateWithUIDService();
  bool isLoading = false;
  AuthenticateModel authenticateModel =
  AuthenticateModel();

  AuthenticateModel get todos => authenticateModel;
   var response;

  Future<AuthenticateModel> getAuthenticateWithUID() async {
    isLoading = true;
    authenticateModel = (await service.getAuthentication()) as AuthenticateModel;
    isLoading = false;

    // if (response.status == 200) {
    //   isLoading = false;
    //   authenticateModel = response;
    //
    // } else {
    //   isLoading = true;
    // }
    notifyListeners();
    return authenticateModel;

  }

  AuthenticateWithUIDModel authenticateWithUIDModel =
  AuthenticateWithUIDModel();

  AuthenticateWithUIDModel get getAuthUID => authenticateWithUIDModel;

  Future<AuthenticateWithUIDModel> postAuthenticateWithUID(String userName) async {
    isLoading = true;
    authenticateWithUIDModel = (await serviceWithUID.getAuthenticationWithUID(userName))!;
    isLoading = false;
    // response = await serviceWithUID.getAuthenticationWithUID();
    // if (response.status == 200) {
    //   isLoading = false;
    //   authenticateModel = response;
    //
    // } else {
    //   isLoading = true;
    // }
    return authenticateWithUIDModel;

    notifyListeners();
  }


  final serviceUser = UserService();
  UserModel userModel =
  UserModel();

  var responses;

  Future<UserModel> getUserList() async {
    isLoading = true;
    userModel = (await serviceUser.getUser()) as UserModel ;
    isLoading = false;
    notifyListeners();

    return userModel;
  }

  final serviceUserPost = PostUserService();
  var userData;


  Future<UserModel> postUserData() async {
    isLoading = true;
    userData = (await serviceUserPost.postUserData()) as UserModel ;
    isLoading = false;
    notifyListeners();

    return userData;
  }
}
