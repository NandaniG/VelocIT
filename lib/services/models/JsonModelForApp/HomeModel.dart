import 'dart:convert';

List<HomeModel> homeModelFromJson(String str) =>
    List<HomeModel>.from(json.decode(str).map((x) => HomeModel.fromJson(x)));

String homeModelToJson(List<HomeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeModel {
  List<HomeImageSlider> homeImageSlider;
  List<ShopByCategoryList> shopByCategoryList;

  // List<BookOurServiceList> bookOurServiceList;
  // List<OrderProgressList> orderProgressList;
  // List<RecommendedForYouList> recommendedForYouList;
  // List<MerchantNearYouList> merchantNearYouList;
  // List<BestDealList> bestDealList;
  // List<BudgetBuyList> budgetBuyList;

  HomeModel({
    required this.homeImageSlider,
    required this.shopByCategoryList,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        homeImageSlider: homeSliderImageListFromJson(json['homeImageSlider']),
        shopByCategoryList: json["shopByCategoryList"],
      );

  Map<String, dynamic> toJson() => {
        "homeImageSlider": homeImageSlider,
        "shopByCategoryList": shopByCategoryList,
      };
}

//-----------------------HomeImage Slider-------------------------

List<HomeImageSlider> homeSliderImageListFromJson(String str) =>
    List<HomeImageSlider>.from(
        json.decode(str).map((x) => HomeImageSlider.fromJson(x)));

String homeSliderImageListToJson(List<HomeImageSlider> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeImageSlider {
  String homeSliderImage;

  HomeImageSlider({
    required this.homeSliderImage,
  });

  factory HomeImageSlider.fromJson(Map<String, dynamic> json) =>
      HomeImageSlider(
        homeSliderImage: json["homeSliderImage"],
      );

  Map<String, dynamic> toJson() => {
        "homeSliderImage": homeSliderImage,
      };
}
//-----------shop by category------------------
List<ShopByCategoryList> shopByCategoryListFromJson(String str) =>
    List<ShopByCategoryList>.from(
        json.decode(str).map((x) => ShopByCategoryList.fromJson(x)));

String shopByCategoryListToJson(List<ShopByCategoryList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShopByCategoryList {
  String shopCategoryImage;
  String shopCategoryName;
  String shopCategoryDescription;

  ShopByCategoryList({
    required this.shopCategoryImage,
    required this.shopCategoryName,
    required this.shopCategoryDescription,
  });

  factory ShopByCategoryList.fromJson(Map<String, dynamic> json) =>
      ShopByCategoryList(
        shopCategoryImage: json["shopCategoryImage"],
        shopCategoryName: json["shopCategoryName"],
        shopCategoryDescription: json["shopCategoryDescription"],
      );

  Map<String, dynamic> toJson() => {
        "shopCategoryImage": shopCategoryImage,
        "shopCategoryName": shopCategoryName,
        "shopCategoryDescription": shopCategoryDescription,
      };
}
