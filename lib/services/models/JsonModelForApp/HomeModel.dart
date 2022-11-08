class HomePageModelClass {
  List<HomeImageSlider>? homeImageSlider;
  List<ShopByCategoryList>? shopByCategoryList;
  List<BookOurServicesList>? bookOurServicesList;
  List<StepperOfDeliveryList>? stepperOfDeliveryList;
  List<RecommendedForYouList>? recommendedForYouList;
  List<MerchantNearYouList>? merchantNearYouList;
  List<BestDealList>? bestDealList;
  List<BudgetBuyList>? budgetBuyList;


  HomePageModelClass(
      {this.homeImageSlider,
        this.shopByCategoryList,
        this.bookOurServicesList,
        this.stepperOfDeliveryList,
        this.recommendedForYouList,
        this.merchantNearYouList,
        this.bestDealList,
        this.budgetBuyList});

  HomePageModelClass.fromJson(Map<String, dynamic> json) {
    if (json['homeImageSlider'] != null) {
      homeImageSlider = <HomeImageSlider>[];
      json['homeImageSlider'].forEach((v) {
        homeImageSlider!.add(new HomeImageSlider.fromJson(v));
      });
    }
    if (json['shopByCategoryList'] != null) {
      shopByCategoryList = <ShopByCategoryList>[];
      json['shopByCategoryList'].forEach((v) {
        shopByCategoryList!.add(new ShopByCategoryList.fromJson(v));
      });
    }
    if (json['bookOurServicesList'] != null) {
      bookOurServicesList = <BookOurServicesList>[];
      json['bookOurServicesList'].forEach((v) {
        bookOurServicesList!.add(new BookOurServicesList.fromJson(v));
      });
    }
    if (json['stepperOfDeliveryList'] != null) {
      stepperOfDeliveryList = <StepperOfDeliveryList>[];
      json['stepperOfDeliveryList'].forEach((v) {
        stepperOfDeliveryList!.add(new StepperOfDeliveryList.fromJson(v));
      });
    }
    if (json['recommendedForYouList'] != null) {
      recommendedForYouList = <RecommendedForYouList>[];
      json['recommendedForYouList'].forEach((v) {
        recommendedForYouList!.add(new RecommendedForYouList.fromJson(v));
      });
    }
    if (json['merchantNearYouList'] != null) {
      merchantNearYouList = <MerchantNearYouList>[];
      json['merchantNearYouList'].forEach((v) {
        merchantNearYouList!.add(new MerchantNearYouList.fromJson(v));
      });
    }
    if (json['bestDealList'] != null) {
      bestDealList = <BestDealList>[];
      json['bestDealList'].forEach((v) {
        bestDealList!.add(new BestDealList.fromJson(v));
      });
    }
    if (json['budgetBuyList'] != null) {
      budgetBuyList = <BudgetBuyList>[];
      json['budgetBuyList'].forEach((v) {
        budgetBuyList!.add(new BudgetBuyList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.homeImageSlider != null) {
      data['homeImageSlider'] =
          this.homeImageSlider!.map((v) => v.toJson()).toList();
    }
    if (this.shopByCategoryList != null) {
      data['shopByCategoryList'] =
          this.shopByCategoryList!.map((v) => v.toJson()).toList();
    }
    if (this.bookOurServicesList != null) {
      data['bookOurServicesList'] =
          this.bookOurServicesList!.map((v) => v.toJson()).toList();
    }
    if (this.stepperOfDeliveryList != null) {
      data['stepperOfDeliveryList'] =
          this.stepperOfDeliveryList!.map((v) => v.toJson()).toList();
    }
    if (this.recommendedForYouList != null) {
      data['recommendedForYouList'] =
          this.recommendedForYouList!.map((v) => v.toJson()).toList();
    }
    if (this.merchantNearYouList != null) {
      data['merchantNearYouList'] =
          this.merchantNearYouList!.map((v) => v.toJson()).toList();
    }
    if (this.bestDealList != null) {
      data['bestDealList'] = this.bestDealList!.map((v) => v.toJson()).toList();
    }
    if (this.budgetBuyList != null) {
      data['budgetBuyList'] =
          this.budgetBuyList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HomeImageSlider {
  String? homeSliderImage;

  HomeImageSlider({this.homeSliderImage});

  HomeImageSlider.fromJson(Map<String, dynamic> json) {
    homeSliderImage = json['homeSliderImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homeSliderImage'] = this.homeSliderImage;
    return data;
  }
}

class ShopByCategoryList {
  String? id;
  String? shopCategoryName;
  String? shopCategoryImage;
  String? shopCategoryDescription;
  List<SubShopByCategoryList>? subShopByCategoryList;

  ShopByCategoryList(
      {this.id,
        this.shopCategoryName,
        this.shopCategoryImage,
        this.shopCategoryDescription,
        this.subShopByCategoryList});

  ShopByCategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopCategoryName = json['shopCategoryName'];
    shopCategoryImage = json['shopCategoryImage'];
    shopCategoryDescription = json['shopCategoryDescription'];
    if (json['subShopByCategoryList'] != null) {
      subShopByCategoryList = <SubShopByCategoryList>[];
      json['subShopByCategoryList'].forEach((v) {
        subShopByCategoryList!.add(new SubShopByCategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopCategoryName'] = this.shopCategoryName;
    data['shopCategoryImage'] = this.shopCategoryImage;
    data['shopCategoryDescription'] = this.shopCategoryDescription;
    if (this.subShopByCategoryList != null) {
      data['subShopByCategoryList'] =
          this.subShopByCategoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubShopByCategoryList {
  String? id;
  String? subShopCategoryName;
  String? subShopCategoryImage;
  String? subShopCategoryDescription;
  List<ProductsList>? productsList;

  SubShopByCategoryList(
      {this.id,
        this.subShopCategoryName,
        this.subShopCategoryImage,
        this.subShopCategoryDescription,
        this.productsList});

  SubShopByCategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subShopCategoryName = json['subShopCategoryName'];
    subShopCategoryImage = json['subShopCategoryImage'];
    subShopCategoryDescription = json['subShopCategoryDescription'];
    if (json['productsList'] != null) {
      productsList = <ProductsList>[];
      json['productsList'].forEach((v) {
        productsList!.add(new ProductsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subShopCategoryName'] = this.subShopCategoryName;
    data['subShopCategoryImage'] = this.subShopCategoryImage;
    data['subShopCategoryDescription'] = this.subShopCategoryDescription;
    if (this.productsList != null) {
      data['productsList'] = this.productsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsList {
  String? id;
  String? productsListName;
  String? productsListImage;
  String? productsListDescription;
  String? productSellerName;
  String? productRatting;
  String? productDiscountPrice;
  String? productOriginalPrice;
  String? productOfferPercent;
  String? productAvailableVariants;
  String? productCartProductsLength;
  String? productCartMaxCounter;
  String? productDeliveredBy;
  String? productTempCounter;

  ProductsList(
      {this.id,
        this.productsListName,
        this.productsListImage,
        this.productsListDescription,
        this.productSellerName,
        this.productRatting,
        this.productDiscountPrice,
        this.productOriginalPrice,
        this.productOfferPercent,
        this.productAvailableVariants,
        this.productCartProductsLength,
        this.productCartMaxCounter,
        this.productDeliveredBy,
        this.productTempCounter});

  ProductsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productsListName = json['productsListName'];
    productsListImage = json['productsListImage'];
    productsListDescription = json['productsListDescription'];
    productSellerName = json['productSellerName'];
    productRatting = json['productRatting'];
    productDiscountPrice = json['productDiscountPrice'];
    productOriginalPrice = json['productOriginalPrice'];
    productOfferPercent = json['productOfferPercent'];
    productAvailableVariants = json['productAvailableVariants'];
    productCartProductsLength = json['productCartProductsLength'];
    productCartMaxCounter = json['productCartMaxCounter'];
    productDeliveredBy = json['productDeliveredBy'];
    productTempCounter = json['productTempCounter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productsListName'] = this.productsListName;
    data['productsListImage'] = this.productsListImage;
    data['productsListDescription'] = this.productsListDescription;
    data['productSellerName'] = this.productSellerName;
    data['productRatting'] = this.productRatting;
    data['productDiscountPrice'] = this.productDiscountPrice;
    data['productOriginalPrice'] = this.productOriginalPrice;
    data['productOfferPercent'] = this.productOfferPercent;
    data['productAvailableVariants'] = this.productAvailableVariants;
    data['productCartProductsLength'] = this.productCartProductsLength;
    data['productCartMaxCounter'] = this.productCartMaxCounter;
    data['productDeliveredBy'] = this.productDeliveredBy;
    data['productTempCounter'] = this.productTempCounter;
    return data;
  }
}

class BookOurServicesList {
  String? id;
  String? bookOurServicesName;
  String? bookOurServicesImage;
  String? bookOurServicesDescription;

  BookOurServicesList(
      {this.id,
        this.bookOurServicesName,
        this.bookOurServicesImage,
        this.bookOurServicesDescription});

  BookOurServicesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookOurServicesName = json['bookOurServicesName'];
    bookOurServicesImage = json['bookOurServicesImage'];
    bookOurServicesDescription = json['bookOurServicesDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookOurServicesName'] = this.bookOurServicesName;
    data['bookOurServicesImage'] = this.bookOurServicesImage;
    data['bookOurServicesDescription'] = this.bookOurServicesDescription;
    return data;
  }
}

class StepperOfDeliveryList {
  String? id;
  String? stepperOfDeliveryName;
  String? stepperOfDeliveryImage;
  String? stepperOfDeliveryDescription;
  String? stepperOfDeliveryPrice;
  String? stepperOfDeliveryDiscountPrice;

  StepperOfDeliveryList(
      {this.id,
        this.stepperOfDeliveryName,
        this.stepperOfDeliveryImage,
        this.stepperOfDeliveryDescription,
        this.stepperOfDeliveryPrice,
        this.stepperOfDeliveryDiscountPrice});

  StepperOfDeliveryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stepperOfDeliveryName = json['stepperOfDeliveryName'];
    stepperOfDeliveryImage = json['stepperOfDeliveryImage'];
    stepperOfDeliveryDescription = json['stepperOfDeliveryDescription'];
    stepperOfDeliveryPrice = json['stepperOfDeliveryPrice'];
    stepperOfDeliveryDiscountPrice = json['stepperOfDeliveryDiscountPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stepperOfDeliveryName'] = this.stepperOfDeliveryName;
    data['stepperOfDeliveryImage'] = this.stepperOfDeliveryImage;
    data['stepperOfDeliveryDescription'] = this.stepperOfDeliveryDescription;
    data['stepperOfDeliveryPrice'] = this.stepperOfDeliveryPrice;
    data['stepperOfDeliveryDiscountPrice'] =
        this.stepperOfDeliveryDiscountPrice;
    return data;
  }
}

class RecommendedForYouList {
  String? id;
  String? recommendedForYouName;
  String? recommendedForYouImage;
  String? recommendedForYouDescription;
  String? recommendedForYouPrice;
  String? recommendedForYouDiscountPrice;

  RecommendedForYouList(
      {this.id,
        this.recommendedForYouName,
        this.recommendedForYouImage,
        this.recommendedForYouDescription,
        this.recommendedForYouPrice,
        this.recommendedForYouDiscountPrice});

  RecommendedForYouList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recommendedForYouName = json['recommendedForYouName'];
    recommendedForYouImage = json['recommendedForYouImage'];
    recommendedForYouDescription = json['recommendedForYouDescription'];
    recommendedForYouPrice = json['recommendedForYouPrice'];
    recommendedForYouDiscountPrice = json['recommendedForYouDiscountPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recommendedForYouName'] = this.recommendedForYouName;
    data['recommendedForYouImage'] = this.recommendedForYouImage;
    data['recommendedForYouDescription'] = this.recommendedForYouDescription;
    data['recommendedForYouPrice'] = this.recommendedForYouPrice;
    data['recommendedForYouDiscountPrice'] =
        this.recommendedForYouDiscountPrice;
    return data;
  }
}

class MerchantNearYouList {
  String? id;
  String? merchantNearYouName;
  String? merchantNearYouImage;
  String? merchantNearYouDescription;
  String? merchantNearYouPrice;
  String? kmAWAY;
  String? merchantNearYouDiscountPrice;

  MerchantNearYouList(
      {this.id,
        this.merchantNearYouName,
        this.merchantNearYouImage,
        this.merchantNearYouDescription,
        this.merchantNearYouPrice,
        this.kmAWAY,
        this.merchantNearYouDiscountPrice});

  MerchantNearYouList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantNearYouName = json['merchantNearYouName'];
    merchantNearYouImage = json['merchantNearYouImage'];
    merchantNearYouDescription = json['merchantNearYouDescription'];
    merchantNearYouPrice = json['merchantNearYouPrice'];
    kmAWAY = json['kmAWAY'];
    merchantNearYouDiscountPrice = json['merchantNearYouDiscountPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchantNearYouName'] = this.merchantNearYouName;
    data['merchantNearYouImage'] = this.merchantNearYouImage;
    data['merchantNearYouDescription'] = this.merchantNearYouDescription;
    data['merchantNearYouPrice'] = this.merchantNearYouPrice;
    data['kmAWAY'] = this.kmAWAY;
    data['merchantNearYouDiscountPrice'] = this.merchantNearYouDiscountPrice;
    return data;
  }
}

class BestDealList {
  String? id;
  String? bestDealName;
  String? bestDealImage;
  String? bestDealDescription;
  String? bestDealPrice;
  String? bestDealDiscountPrice;

  BestDealList(
      {this.id,
        this.bestDealName,
        this.bestDealImage,
        this.bestDealDescription,
        this.bestDealPrice,
        this.bestDealDiscountPrice});

  BestDealList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bestDealName = json['bestDealName'];
    bestDealImage = json['bestDealImage'];
    bestDealDescription = json['bestDealDescription'];
    bestDealPrice = json['bestDealPrice'];
    bestDealDiscountPrice = json['bestDealDiscountPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bestDealName'] = this.bestDealName;
    data['bestDealImage'] = this.bestDealImage;
    data['bestDealDescription'] = this.bestDealDescription;
    data['bestDealPrice'] = this.bestDealPrice;
    data['bestDealDiscountPrice'] = this.bestDealDiscountPrice;
    return data;
  }
}

class BudgetBuyList {
  String? id;
  String? budgetBuyName;
  String? budgetBuyImage;
  String? budgetBuyDescription;
  String? budgetBuyPrice;
  String? budgetBuyDiscountPrice;
  String? kmAWAY;

  BudgetBuyList(
      {this.id,
        this.budgetBuyName,
        this.budgetBuyImage,
        this.budgetBuyDescription,
        this.budgetBuyPrice,
        this.budgetBuyDiscountPrice,
        this.kmAWAY});

  BudgetBuyList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    budgetBuyName = json['budgetBuyName'];
    budgetBuyImage = json['budgetBuyImage'];
    budgetBuyDescription = json['budgetBuyDescription'];
    budgetBuyPrice = json['budgetBuyPrice'];
    budgetBuyDiscountPrice = json['budgetBuyDiscountPrice'];
    kmAWAY = json['kmAWAY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['budgetBuyName'] = this.budgetBuyName;
    data['budgetBuyImage'] = this.budgetBuyImage;
    data['budgetBuyDescription'] = this.budgetBuyDescription;
    data['budgetBuyPrice'] = this.budgetBuyPrice;
    data['budgetBuyDiscountPrice'] = this.budgetBuyDiscountPrice;
    data['kmAWAY'] = this.kmAWAY;
    return data;
  }
}
