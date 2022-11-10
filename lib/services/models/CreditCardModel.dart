// import 'dart:convert';
//
// List<CreditCardListModel> CreditCardListFromJson(String str) =>
//     List<CreditCardListModel>.from(
//         json.decode(str).map((x) => CreditCardListModel.fromJson(x)));
//
// String CreditCardListToJson(List<CreditCardListModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class CreditCardListModel {
//   String cardName;
//   String cardType;
//   var cardNumber;
//   String expiryDate;
//
//   CreditCardListModel({
//     required this.cardName,
//     required this.cardType,
//     required this.cardNumber,
//     required this.expiryDate,
//   });
//
//   factory CreditCardListModel.fromJson(Map<String, dynamic> json) =>
//       CreditCardListModel(
//         cardName: json["cardName"],
//         cardType: json["cardType"],
//         cardNumber: json["cardNumber"],
//         expiryDate: json["expiryDate"],
//
//
//       );
//
//   Map<String, dynamic> toJson() => {
//     "cardName": cardName,
//     "cardType": cardType,
//     "cardNumber": cardNumber,
//     "expiryDate": expiryDate,
//
//   };
// }
//
//
//
