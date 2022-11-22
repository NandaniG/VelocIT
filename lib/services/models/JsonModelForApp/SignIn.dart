import 'package:http/http.dart' as http;
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';

import '../../../Core/AppConstant/apiMapping.dart';

class SignInModel{

  static signIn(){

    var response = http.get(Uri.parse(ApiMapping.getURI(apiEndPoint.signIn_authenticate_get)));

    print("signIn Response: "+response.toString());

  }
}


