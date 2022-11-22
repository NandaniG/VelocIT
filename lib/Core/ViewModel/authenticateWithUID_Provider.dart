import 'package:flutter/cupertino.dart';

import '../Model/authenticateWithUIDModel.dart';
import '../Service/authenticateWithUID_Service.dart';

class AuthenticateWithUIDProvider extends ChangeNotifier {
  final service = AuthenticateWithUIDService();
  bool isLoading = false;
  AuthenticateWithUIDModel authenticateWithUIDModel =
      AuthenticateWithUIDModel();

  AuthenticateWithUIDModel get todos => authenticateWithUIDModel;

  Future<void> getAuthenticateWithUID() async {
    final response = await service.getAuthentication();
    if (response.status == 200) {
      isLoading = false;
      authenticateWithUIDModel = response;

    } else {
      isLoading = true;
    }

    notifyListeners();
  }
}
