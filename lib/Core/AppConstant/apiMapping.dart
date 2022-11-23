import '../Enum/apiEndPointEnums.dart';

class ApiMapping {
  static String baseProtocol = "https";
  static String baseDomain = "velocitapiqa.fulgorithmapi.com";
  static String basePort = "443";
  static String apiVersion = "v1";
  static String username = "/v1/IAM/authenticateWithUID";

  static String ConstructURI(String path) {
    return baseProtocol +
        "://" +
        baseDomain +
        ":" +
        basePort +
        "/" +
        apiVersion +
        path;
  }

//https://velocitapiqa.fulgorithmapi.com:443/v1/IAM/authenticate
  static String getURI(apiEndPoint ep) {
    String retVal = "";

    switch (ep) {
      case apiEndPoint.signIn_authenticate_get:
        retVal = ConstructURI("/IAM/authenticate");
        break;

      case apiEndPoint.signIn_authenticateWithUID_post:
        retVal = ConstructURI("/IAM/authenticateWithUID");
        break;

      case apiEndPoint.user_get:
        retVal = ConstructURI("/users");
        break;
      case apiEndPoint.user_post:
        retVal = ConstructURI("/users");
        break;

      default:
        retVal = "Error";
    }
    return retVal;
  }
}
