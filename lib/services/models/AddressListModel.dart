// import 'dart:convert';
//
// List<AddressListModel> AddressListFromJson(String str) =>
//     List<AddressListModel>.from(
//         json.decode(str).map((x) => AddressListModel.fromJson(x)));
//
// String AddressListToJson(List<AddressListModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class AddressListModel {
//   String fullName;
//   String phoneNumber;
//   String houseNoBuildingName;
//   String areaColony;
//   String state;
//   String city;
//   String typeOfAddress;
//
//   AddressListModel({
//     required this.fullName,
//     required this.phoneNumber,
//     required this.houseNoBuildingName,
//     required this.areaColony,
//     required this.state,
//     required this.city,
//     required this.typeOfAddress,
//   });
//
//   factory AddressListModel.fromJson(Map<String, dynamic> json) =>
//       AddressListModel(
//         fullName: json["fullName"],
//         phoneNumber: json["phoneNumber"],
//         houseNoBuildingName: json["houseNoBuildingName"],
//         areaColony: json["areaColony"],
//         state: json["state"],
//         city: json["city"],
//         typeOfAddress: json["typeOfAddress"],
//
//       );
//
//   Map<String, dynamic> toJson() => {
//     "fullName": fullName,
//     "phoneNumber": phoneNumber,
//     "houseNoBuildingName": houseNoBuildingName,
//     "areaColony": areaColony,
//     "state": state,
//     "city": city,
//     "typeOfAddress": typeOfAddress,
//   };
// }
//
