import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/Core/data/network/baseApiServices.dart';
import 'package:velocit/Core/data/network/networkApiServices.dart';

import '../AppConstant/apiMapping.dart';

class AuthRepository {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> loginApiWithGet() async {
    var url = ApiMapping.getURI(apiEndPoint.signIn_authenticate_get);

    try {
      dynamic resposnse = await _apiServices.getGetApiResponse(url);
      return resposnse;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> loginApiWithPost(dynamic data) async {
    var url = ApiMapping.getURI(apiEndPoint.signIn_authenticateWithUID_post);

    try {
      dynamic resposnse = await _apiServices.getPostApiResponse(url, data);
      return resposnse;
    } catch (e) {
      throw e;
    }
  }


  Future<dynamic> authSignInUsingPost(dynamic data) async {
    var url = ApiMapping.getURI(apiEndPoint.auth_signIn_using_post);

    try {
      dynamic resposnse = await _apiServices.getPostApiResponse(url, data);
      return resposnse;
    } catch (e) {
      throw e;
    }
  }
  Future<dynamic> authSignUpUsingPost(dynamic data) async {

    var url = ApiMapping.getURI(apiEndPoint.auth_signUp_using_post);
print("SignUp URL "+url.toString());
    // dynamic resposnse = await _apiServices.getPostApiResponse(url, data);
    print("SignUp Data "+data.toString());

    // print(resposnse.toString());
    try {
      dynamic resposnse = await _apiServices.getPostApiResponse(url, data);

      print(resposnse.toString());
      return resposnse;
    } catch (e) {
      print ("SignUp error"+e.toString());
    }
  }
}
