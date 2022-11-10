// import 'dart:convert';
//
// List<UserAccountDetailModel> CreditCardListFromJson(String str) =>
//     List<UserAccountDetailModel>.from(
//         json.decode(str).map((x) => UserAccountDetailModel.fromJson(x)));
//
// String CreditCardListToJson(List<UserAccountDetailModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class UserAccountDetailModel {
//   int userId;
//   String userName;
//   String usetEmail;
//   String userMobile;
//   var userPassword;
//
//   UserAccountDetailModel({
//     required this.userId,
//     required this.userName,
//     required this.usetEmail,
//     required this.userMobile,
//     required this.userPassword,
//   });
//
//   factory UserAccountDetailModel.fromJson(Map<String, dynamic> json) =>
//       UserAccountDetailModel(
//         userId: json["userId"],
//         userName: json["userName"],
//         usetEmail: json["usetEmail"],
//         userMobile: json["userMobile"],
//         userPassword: json["userPassword"],
//
//
//       );
//
//   Map<String, dynamic> toJson() => {
//     "userId": userId,
//     "userName": userName,
//     "usetEmail": usetEmail,
//     "userMobile": userMobile,
//     "userPassword": userPassword,
//
//   };
// }
//
//
//
