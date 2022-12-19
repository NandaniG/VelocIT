// import 'dart:convert';
// import 'dart:io';
// import '../../utils/utils.dart';
//
// class ApiCaliing{
//
//
//   Future postApiRequest(Map jsonMap, var url) async {
//
//     dynamic responseJson;
//
//     HttpClient httpClient = new HttpClient();
//     HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
//     request.headers.set('content-type', 'application/json');
//     request.add(utf8.encode(json.encode(jsonMap)));
//
//     HttpClientResponse response = await request.close();
//     // todo - you should check the response.statusCode
//     responseJson = await response.transform(utf8.decoder).join();
//     String rawJson = responseJson.toString();
//
//     Map<String, dynamic> map = jsonDecode(rawJson);
//     String name = map['message'];
//
//
//     if (response.statusCode == 200) {
//       Utils.successToast(name.toString());
//
//
//
//     } else {
//       Utils.errorToast("System is busy, Please try after sometime.");
//     }
//
//     httpClient.close();
//     return responseJson;
//   }
//
// }