import 'dart:convert';

List<ProductDetailsModel> productDetailsFromJson(String str) =>
    List<ProductDetailsModel>.from(
        json.decode(str).map((x) => ProductDetailsModel.fromJson(x)));

String productDetailsToJson(List<ProductDetailsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductDetailsModel {
  String serviceImage;
  String serviceName;
  String sellerName;
  double ratting;
  String discountPrice;
  String originalPrice;
  String offerPercent;
  String availableVariants;
  String cartProductsLength;
  String serviceDescription;
  String maxCounter;
  String deliveredBy;
  int tempCounter;

  ProductDetailsModel({
    required this.serviceImage,
    required this.serviceName,
    required this.sellerName,
    required this.ratting,
    required this.discountPrice,
    required this.originalPrice,
    required this.offerPercent,
    required this.availableVariants,
    required this.cartProductsLength,
    required this.serviceDescription,
    required this.maxCounter,
    required this.deliveredBy,
    required this.tempCounter,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModel(
        serviceImage: json["serviceImage"],
        serviceName: json["serviceName"],
        sellerName: json["sellerName"],
        ratting: json["ratting"],
        discountPrice: json["discountPrice"],
        originalPrice: json["originalPrice"],
        offerPercent: json["offerPercent"],
        availableVariants: json["availableVariants"],
        cartProductsLength: json["cartProductsLength"],
        serviceDescription: json["serviceDescription"],
        maxCounter: json["maxCounter"],
        deliveredBy: json["deliveredBy"],
        tempCounter: json["tempCounter"],
      );

  Map<String, dynamic> toJson() => {
        "serviceImage": serviceImage,
        "serviceName": serviceName,
        "sellerName": sellerName,
        "ratting": ratting,
        "discountPrice": discountPrice,
        "originalPrice": originalPrice,
        "offerPercent": offerPercent,
        "availableVariants": availableVariants,
        "cartProductsLength": cartProductsLength,
        "serviceDescription": serviceDescription,
        "maxCounter": maxCounter,
        "deliveredBy": deliveredBy,
        "tempCounter": tempCounter,
      };
}



