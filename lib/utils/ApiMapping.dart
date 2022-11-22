// enum apiEndPoint { signIn_authenticate_get, signIn_authenticateWithUID_post }
//
// class ApiMapping {
//   static String baseProtocol = "https";
//   static String baseDomain = "veclocitapi.fulgorithmapi.com";
//   static String basePort = "80";
//   static String apiVersion = "v1";
//   static String username = "/v1/IAM/authenticateWithUID";
//
//   static String ConstructURI(String path) {
//     return baseProtocol +
//         "://" +
//         baseDomain +
//        /* ":" +
//         basePort +*/
//         "/" +
//         apiVersion +
//         path;
//   }
//
//   static String getURI(apiEndPoint ep) {
//     String retVal = "";
//
//     switch (ep) {
//       case apiEndPoint.signIn_authenticate_get:
//         retVal = ConstructURI("/IAM/authenticate");
//         break;
//
//       case apiEndPoint.signIn_authenticateWithUID_post:
//         retVal = ConstructURI("/v1/IAM/authenticateWithUID");
//         break;
//
//       default:
//         retVal = "Error";
//     }
//     return retVal;
//   }
// }
