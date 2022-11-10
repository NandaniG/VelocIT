// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// List<CartModel> cartFromJson(String str) =>
//     List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));
//
// String cartToJson(List<CartModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class CartModel {
//   String? serviceImage;
//   String? serviceName;
//   String? sellerName;
//   double? ratting;
//   String? discountPrice;
//   String? originalPrice;
//   String? offerPercent;
//   String? availableVariants;
//   String? cartProductsLength;
//   String? serviceDescription;
//   String? maxCounter;
//   String? deliveredBy;
//   int? tempCounter;
//   /// PRICE AFTER TOTAL COUNT FROM CART AND CART LIST
//   double? totalOriginalPrice;
//   double? totalDiscountPrice;
//   double? totalDeliveryChargePrice;
//   double? totalGrandAmount;
//
//
//   CartModel({
//     this.serviceImage,
//     this.serviceName,
//     this.sellerName,
//     this.ratting,
//     this.discountPrice,
//     this.originalPrice,
//     this.offerPercent,
//     this.availableVariants,
//     this.cartProductsLength,
//     this.serviceDescription,
//     this.maxCounter,
//     this.deliveredBy,
//     this.tempCounter,
//     this.totalOriginalPrice,
//     this.totalDiscountPrice,
//     this.totalDeliveryChargePrice,
//     this.totalGrandAmount,
//   });
//
//   factory CartModel.fromJson(Map<String, dynamic> json) =>
//       CartModel(
//         serviceImage: json["serviceImage"],
//         serviceName: json["serviceName"],
//         sellerName: json["sellerName"],
//         ratting: json["ratting"],
//         discountPrice: json["discountPrice"],
//         originalPrice: json["originalPrice"],
//         offerPercent: json["offerPercent"],
//         availableVariants: json["availableVariants"],
//         cartProductsLength: json["cartProductsLength"],
//         serviceDescription: json["serviceDescription"],
//         maxCounter: json["maxCounter"],
//         deliveredBy: json["deliveredBy"],
//         tempCounter: json["tempCounter"],
//         totalOriginalPrice: json["totalOriginalPrice"],
//         totalDiscountPrice: json["totalDiscountPrice"],
//         totalDeliveryChargePrice: json["totalDeliveryChargePrice"],
//         totalGrandAmount: json["totalGrandAmount"],
//       );
//
//   Map<String, dynamic> toJson() => {
//     "serviceImage": serviceImage,
//     "serviceName": serviceName,
//     "sellerName": sellerName,
//     "ratting": ratting,
//     "discountPrice": discountPrice,
//     "originalPrice": originalPrice,
//     "offerPercent": offerPercent,
//     "availableVariants": availableVariants,
//     "cartProductsLength": cartProductsLength,
//     "serviceDescription": serviceDescription,
//     "maxCounter": maxCounter,
//     "deliveredBy": deliveredBy,
//     "tempCounter": tempCounter,
//     "totalOriginalPrice": totalOriginalPrice,
//     "totalDiscountPrice": totalDiscountPrice,
//     "totalDeliveryChargePrice": totalDeliveryChargePrice,
//     "totalGrandAmount": totalGrandAmount,
//   };
// }
//
//
//
//
//
// /*
// class CartModel {
//   String serviceImage;
//   String serviceName;
//   String sellerName;
//   String ratting;
//   String discountPrice;
//   String originalPrice;
//   String offerPercent;
//   String availableVariants;
//   String cartProductsLength;
//   String serviceDescription;
//   int conterProducts;
//
//   CartModel({required this.serviceImage,
//     required this.serviceName,
//     required this.sellerName,
//     required this.ratting,
//     required this.discountPrice,
//     required this.originalPrice,
//     required this.offerPercent,
//     required this.availableVariants,
//     required this.cartProductsLength,
//     required this.serviceDescription,
//     required this.conterProducts,
//   });
//
//   factory CartModel.fromJson(Map<String, dynamic> json) =>
//       CartModel(
//           serviceImage: json["serviceImage"],
//           serviceName: json["serviceName"],
//           sellerName: json["sellerName"],
//           ratting: json["ratting"],
//           discountPrice: json["discountPrice"],
//           originalPrice: json["originalPrice"],
//           offerPercent: json["offerPercent"],
//           availableVariants: json["availableVariants"],
//           cartProductsLength: json["cartProductsLength"],
//           serviceDescription: json["serviceDescription"],
//           conterProducts: json["conterProducts"]);
//
//   Map<String, dynamic> toJson() =>
//       {
//         "serviceImage": serviceImage,
//         "serviceName": serviceName,
//         "sellerName": sellerName,
//         "ratting": ratting,
//         "discountPrice": discountPrice,
//         "originalPrice": originalPrice,
//         "offerPercent": offerPercent,
//         "availableVariants": availableVariants,
//         "cartProductsLength": cartProductsLength,
//         "serviceDescription": serviceDescription,
//         "conterProducts": conterProducts
//       };
// }*/
