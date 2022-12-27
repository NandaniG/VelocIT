class HomePageModelClass {
  List<HomeImageSlider>? homeImageSlider;
  List<ShopByCategoryList>? shopByCategoryList;
  List<BookOurServicesList>? bookOurServicesList;
  List<StepperOfDeliveryList>? stepperOfDeliveryList;
  List<RecommendedForYouList>? recommendedForYouList;
  List<MerchantNearYouList>? merchantNearYouList;
  List<BestDealList>? bestDealList;
  OffersData? offersData;
  String? scannerImage;
  String? filterForSortByPrice;
  List<BudgetBuyList>? budgetBuyList;
  List<CartProductList>? cartProductList;
  List<OrderCheckOut>? orderCheckOut;
  List<MyOrders>? myOrders;
  List<MyAddressList>? myAddressList;
  CustomerSupport? customerSupport;
  AccountSettings? accountSettings;
  List<NotificationsList>? notificationsList;
  List<MyCardList>? myCardList;
  UserAccountList? userAccountList;
  ChangePassword? changePassword;

  HomePageModelClass(
      {this.homeImageSlider,
        this.shopByCategoryList,
        this.bookOurServicesList,
        this.stepperOfDeliveryList,
        this.recommendedForYouList,
        this.merchantNearYouList,
        this.bestDealList,
        this.offersData,
        this.scannerImage,
        this.filterForSortByPrice,
        this.budgetBuyList,
        this.cartProductList,
        this.orderCheckOut,
        this.myOrders,
        this.myAddressList,
        this.customerSupport,
        this.accountSettings,
        this.notificationsList,
        this.myCardList,
        this.userAccountList,
        this.changePassword});

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
    offersData = json['offersData'] != null
        ? new OffersData.fromJson(json['offersData'])
        : null;
    scannerImage = json['scannerImage'];
    filterForSortByPrice = json['filterForSortByPrice'];
    if (json['budgetBuyList'] != null) {
      budgetBuyList = <BudgetBuyList>[];
      json['budgetBuyList'].forEach((v) {
        budgetBuyList!.add(new BudgetBuyList.fromJson(v));
      });
    }
    if (json['cartProductList'] != null) {
      cartProductList = <CartProductList>[];
      json['cartProductList'].forEach((v) {
        cartProductList!.add(new CartProductList.fromJson(v));
      });
    }
    if (json['orderCheckOut'] != null) {
      orderCheckOut = <OrderCheckOut>[];
      json['orderCheckOut'].forEach((v) {
        orderCheckOut!.add(new OrderCheckOut.fromJson(v));
      });
    }
    if (json['myOrders'] != null) {
      myOrders = <MyOrders>[];
      json['myOrders'].forEach((v) {
        myOrders!.add(new MyOrders.fromJson(v));
      });
    }
    if (json['myAddressList'] != null) {
      myAddressList = <MyAddressList>[];
      json['myAddressList'].forEach((v) {
        myAddressList!.add(new MyAddressList.fromJson(v));
      });
    }
    customerSupport = json['customerSupport'] != null
        ? new CustomerSupport.fromJson(json['customerSupport'])
        : null;
    accountSettings = json['accountSettings'] != null
        ? new AccountSettings.fromJson(json['accountSettings'])
        : null;
    if (json['notificationsList'] != null) {
      notificationsList = <NotificationsList>[];
      json['notificationsList'].forEach((v) {
        notificationsList!.add(new NotificationsList.fromJson(v));
      });
    }
    if (json['myCardList'] != null) {
      myCardList = <MyCardList>[];
      json['myCardList'].forEach((v) {
        myCardList!.add(new MyCardList.fromJson(v));
      });
    }
    userAccountList = json['userAccountList'] != null
        ? new UserAccountList.fromJson(json['userAccountList'])
        : null;
    changePassword = json['changePassword'] != null
        ? new ChangePassword.fromJson(json['changePassword'])
        : null;
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
    if (this.offersData != null) {
      data['offersData'] = this.offersData!.toJson();
    }
    data['scannerImage'] = this.scannerImage;
    data['filterForSortByPrice'] = this.filterForSortByPrice;
    if (this.budgetBuyList != null) {
      data['budgetBuyList'] =
          this.budgetBuyList!.map((v) => v.toJson()).toList();
    }
    if (this.cartProductList != null) {
      data['cartProductList'] =
          this.cartProductList!.map((v) => v.toJson()).toList();
    }
    if (this.orderCheckOut != null) {
      data['orderCheckOut'] =
          this.orderCheckOut!.map((v) => v.toJson()).toList();
    }
    if (this.myOrders != null) {
      data['myOrders'] = this.myOrders!.map((v) => v.toJson()).toList();
    }
    if (this.myAddressList != null) {
      data['myAddressList'] =
          this.myAddressList!.map((v) => v.toJson()).toList();
    }
    if (this.customerSupport != null) {
      data['customerSupport'] = this.customerSupport!.toJson();
    }
    if (this.accountSettings != null) {
      data['accountSettings'] = this.accountSettings!.toJson();
    }
    if (this.notificationsList != null) {
      data['notificationsList'] =
          this.notificationsList!.map((v) => v.toJson()).toList();
    }
    if (this.myCardList != null) {
      data['myCardList'] = this.myCardList!.map((v) => v.toJson()).toList();
    }
    if (this.userAccountList != null) {
      data['userAccountList'] = this.userAccountList!.toJson();
    }
    if (this.changePassword != null) {
      data['changePassword'] = this.changePassword!.toJson();
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
  int? id;
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
  int? id;
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
  int? id;
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
  int? id;
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
  int? id;
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
  int? id;
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
  int? id;
  String? merchantNearYouName;
  String? merchantNearYouImage;
  String? merchantNearYouDescription;
  String? merchantNearYouPrice;
  String? merchantNearYoukmAWAY;
  String? merchantNearYouDiscountPrice;
  bool? merchantNearYouIsGridView;
  List<MerchantNearYouFilterList>? merchantNearYouFilterList;
  List<MerchantNearYouMapViewMarkers>? merchantNearYouMapViewMarkers;
  List<SubMerchantList>? subMerchantList;

  MerchantNearYouList(
      {this.id,
        this.merchantNearYouName,
        this.merchantNearYouImage,
        this.merchantNearYouDescription,
        this.merchantNearYouPrice,
        this.merchantNearYoukmAWAY,
        this.merchantNearYouDiscountPrice,
        this.merchantNearYouIsGridView,
        this.merchantNearYouFilterList,
        this.merchantNearYouMapViewMarkers,
        this.subMerchantList});

  MerchantNearYouList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantNearYouName = json['merchantNearYouName'];
    merchantNearYouImage = json['merchantNearYouImage'];
    merchantNearYouDescription = json['merchantNearYouDescription'];
    merchantNearYouPrice = json['merchantNearYouPrice'];
    merchantNearYoukmAWAY = json['merchantNearYoukmAWAY'];
    merchantNearYouDiscountPrice = json['merchantNearYouDiscountPrice'];
    merchantNearYouIsGridView = json['merchantNearYouIsGridView'];
    if (json['merchantNearYouFilterList'] != null) {
      merchantNearYouFilterList = <MerchantNearYouFilterList>[];
      json['merchantNearYouFilterList'].forEach((v) {
        merchantNearYouFilterList!
            .add(new MerchantNearYouFilterList.fromJson(v));
      });
    }
    if (json['merchantNearYouMapViewMarkers'] != null) {
      merchantNearYouMapViewMarkers = <MerchantNearYouMapViewMarkers>[];
      json['merchantNearYouMapViewMarkers'].forEach((v) {
        merchantNearYouMapViewMarkers!
            .add(new MerchantNearYouMapViewMarkers.fromJson(v));
      });
    }
    if (json['subMerchantList'] != null) {
      subMerchantList = <SubMerchantList>[];
      json['subMerchantList'].forEach((v) {
        subMerchantList!.add(new SubMerchantList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchantNearYouName'] = this.merchantNearYouName;
    data['merchantNearYouImage'] = this.merchantNearYouImage;
    data['merchantNearYouDescription'] = this.merchantNearYouDescription;
    data['merchantNearYouPrice'] = this.merchantNearYouPrice;
    data['merchantNearYoukmAWAY'] = this.merchantNearYoukmAWAY;
    data['merchantNearYouDiscountPrice'] = this.merchantNearYouDiscountPrice;
    data['merchantNearYouIsGridView'] = this.merchantNearYouIsGridView;
    if (this.merchantNearYouFilterList != null) {
      data['merchantNearYouFilterList'] =
          this.merchantNearYouFilterList!.map((v) => v.toJson()).toList();
    }
    if (this.merchantNearYouMapViewMarkers != null) {
      data['merchantNearYouMapViewMarkers'] =
          this.merchantNearYouMapViewMarkers!.map((v) => v.toJson()).toList();
    }
    if (this.subMerchantList != null) {
      data['subMerchantList'] =
          this.subMerchantList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MerchantNearYouFilterList {
  int? id;

  MerchantNearYouFilterList({this.id});

  MerchantNearYouFilterList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class MerchantNearYouMapViewMarkers {
  int? id;
  String? merchantNearmarker;

  MerchantNearYouMapViewMarkers({this.id, this.merchantNearmarker});

  MerchantNearYouMapViewMarkers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantNearmarker = json['merchantNearmarker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchantNearmarker'] = this.merchantNearmarker;
    return data;
  }
}

class SubMerchantList {
  int? id;
  String? subMerchantNearYouName;
  String? subMerchantNearYouImage;
  String? subMerchantNearYouDescription;
  String? subMerchantNearYouPrice;
  String? subMerchantNearYoukmAWAY;
  String? subMerchantNearYouDiscountPrice;

  SubMerchantList(
      {this.id,
        this.subMerchantNearYouName,
        this.subMerchantNearYouImage,
        this.subMerchantNearYouDescription,
        this.subMerchantNearYouPrice,
        this.subMerchantNearYoukmAWAY,
        this.subMerchantNearYouDiscountPrice});

  SubMerchantList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subMerchantNearYouName = json['subMerchantNearYouName'];
    subMerchantNearYouImage = json['subMerchantNearYouImage'];
    subMerchantNearYouDescription = json['subMerchantNearYouDescription'];
    subMerchantNearYouPrice = json['subMerchantNearYouPrice'];
    subMerchantNearYoukmAWAY = json['subMerchantNearYoukmAWAY'];
    subMerchantNearYouDiscountPrice = json['subMerchantNearYouDiscountPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subMerchantNearYouName'] = this.subMerchantNearYouName;
    data['subMerchantNearYouImage'] = this.subMerchantNearYouImage;
    data['subMerchantNearYouDescription'] = this.subMerchantNearYouDescription;
    data['subMerchantNearYouPrice'] = this.subMerchantNearYouPrice;
    data['subMerchantNearYoukmAWAY'] = this.subMerchantNearYoukmAWAY;
    data['subMerchantNearYouDiscountPrice'] =
        this.subMerchantNearYouDiscountPrice;
    return data;
  }
}

class BestDealList {
  int? id;
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

class OffersData {
  String? topBanner;
  String? bottomBanner1;
  String? bottomBanner2;
  List<OfferList>? offerList;
  List<OfferByType>? offerByType;

  OffersData(
      {this.topBanner,
        this.bottomBanner1,
        this.bottomBanner2,
        this.offerList,
        this.offerByType});

  OffersData.fromJson(Map<String, dynamic> json) {
    topBanner = json['topBanner'];
    bottomBanner1 = json['bottomBanner1'];
    bottomBanner2 = json['bottomBanner2'];
    if (json['offerList'] != null) {
      offerList = <OfferList>[];
      json['offerList'].forEach((v) {
        offerList!.add(new OfferList.fromJson(v));
      });
    }
    if (json['offerByType'] != null) {
      offerByType = <OfferByType>[];
      json['offerByType'].forEach((v) {
        offerByType!.add(new OfferByType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topBanner'] = this.topBanner;
    data['bottomBanner1'] = this.bottomBanner1;
    data['bottomBanner2'] = this.bottomBanner2;
    if (this.offerList != null) {
      data['offerList'] = this.offerList!.map((v) => v.toJson()).toList();
    }
    if (this.offerByType != null) {
      data['offerByType'] = this.offerByType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfferList {
  int? id;
  String? offerName;
  String? offerImage;
  String? offerDescription;
  String? offerPrice;
  String? offerDiscountPrice;

  OfferList(
      {this.id,
        this.offerName,
        this.offerImage,
        this.offerDescription,
        this.offerPrice,
        this.offerDiscountPrice});

  OfferList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    offerName = json['offerName'];
    offerImage = json['offerImage'];
    offerDescription = json['offerDescription'];
    offerPrice = json['offerPrice'];
    offerDiscountPrice = json['offerDiscountPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['offerName'] = this.offerName;
    data['offerImage'] = this.offerImage;
    data['offerDescription'] = this.offerDescription;
    data['offerPrice'] = this.offerPrice;
    data['offerDiscountPrice'] = this.offerDiscountPrice;
    return data;
  }
}

class OfferByType {
  String? offerTypes;
  List<OfferImages>? offerImages;

  OfferByType({this.offerTypes, this.offerImages});

  OfferByType.fromJson(Map<String, dynamic> json) {
    offerTypes = json['offerTypes'];
    if (json['offerImages'] != null) {
      offerImages = <OfferImages>[];
      json['offerImages'].forEach((v) {
        offerImages!.add(new OfferImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offerTypes'] = this.offerTypes;
    if (this.offerImages != null) {
      data['offerImages'] = this.offerImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfferImages {
  String? imagesForOffer;

  OfferImages({this.imagesForOffer});

  OfferImages.fromJson(Map<String, dynamic> json) {
    imagesForOffer = json['imagesForOffer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagesForOffer'] = this.imagesForOffer;
    return data;
  }
}

class BudgetBuyList {
  int? id;
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

class CartProductList {
  String? cartProductsImage;
  String? cartProductsName;
  String? cartProductsSellerName;
  double? cartProductsRatting;
  String? cartProductsDiscountPrice;
  String? cartProductsOriginalPrice;
  String? cartProductsOfferPercent;
  String? cartProductsAvailableVariants;
  String? cartProductsLength;
  String? cartProductsDescription;
  String? cartProductsMaxCounter;
  String? cartProductsDeliveredBy;
  int? cartProductsTempCounter = 1;
  int? cartProductsTotalOriginalPrice;
  int? cartProductsTotalDiscountPrice;
  int? cartProductsTotalDeliveryChargePrice;
  int? cartProductsTotalGrandAmount;

  CartProductList(
      {this.cartProductsImage,
        this.cartProductsName,
        this.cartProductsSellerName,
        this.cartProductsRatting,
        this.cartProductsDiscountPrice,
        this.cartProductsOriginalPrice,
        this.cartProductsOfferPercent,
        this.cartProductsAvailableVariants,
        this.cartProductsLength,
        this.cartProductsDescription,
        this.cartProductsMaxCounter,
        this.cartProductsDeliveredBy,
        this.cartProductsTempCounter,
        this.cartProductsTotalOriginalPrice,
        this.cartProductsTotalDiscountPrice,
        this.cartProductsTotalDeliveryChargePrice,
        this.cartProductsTotalGrandAmount});

  CartProductList.fromJson(Map<String, dynamic> json) {
    cartProductsImage = json['cartProductsImage'];
    cartProductsName = json['cartProductsName'];
    cartProductsSellerName = json['cartProductsSellerName'];
    cartProductsRatting = json['cartProductsRatting'];
    cartProductsDiscountPrice = json['cartProductsDiscountPrice'];
    cartProductsOriginalPrice = json['cartProductsOriginalPrice'];
    cartProductsOfferPercent = json['cartProductsOfferPercent'];
    cartProductsAvailableVariants = json['cartProductsAvailableVariants'];
    cartProductsLength = json['cartProductsLength'];
    cartProductsDescription = json['cartProductsDescription'];
    cartProductsMaxCounter = json['cartProductsMaxCounter'];
    cartProductsDeliveredBy = json['cartProductsDeliveredBy'];
    cartProductsTempCounter = json['cartProductsTempCounter'];
    cartProductsTotalOriginalPrice = json['cartProductsTotalOriginalPrice'];
    cartProductsTotalDiscountPrice = json['cartProductsTotalDiscountPrice'];
    cartProductsTotalDeliveryChargePrice =
    json['cartProductsTotalDeliveryChargePrice'];
    cartProductsTotalGrandAmount = json['cartProductsTotalGrandAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartProductsImage'] = this.cartProductsImage;
    data['cartProductsName'] = this.cartProductsName;
    data['cartProductsSellerName'] = this.cartProductsSellerName;
    data['cartProductsRatting'] = this.cartProductsRatting;
    data['cartProductsDiscountPrice'] = this.cartProductsDiscountPrice;
    data['cartProductsOriginalPrice'] = this.cartProductsOriginalPrice;
    data['cartProductsOfferPercent'] = this.cartProductsOfferPercent;
    data['cartProductsAvailableVariants'] = this.cartProductsAvailableVariants;
    data['cartProductsLength'] = this.cartProductsLength;
    data['cartProductsDescription'] = this.cartProductsDescription;
    data['cartProductsMaxCounter'] = this.cartProductsMaxCounter;
    data['cartProductsDeliveredBy'] = this.cartProductsDeliveredBy;
    data['cartProductsTempCounter'] = this.cartProductsTempCounter;
    data['cartProductsTotalOriginalPrice'] =
        this.cartProductsTotalOriginalPrice;
    data['cartProductsTotalDiscountPrice'] =
        this.cartProductsTotalDiscountPrice;
    data['cartProductsTotalDeliveryChargePrice'] =
        this.cartProductsTotalDeliveryChargePrice;
    data['cartProductsTotalGrandAmount'] = this.cartProductsTotalGrandAmount;
    return data;
  }
}

class OrderCheckOut {
  String? orderCheckOutStatus;
  String? orderCheckOutResponse;
  String? orderCheckOutOrderID;
  String? orderCheckOutQRCode;
  List<OrderCheckOutDetails>? orderCheckOutDetails;

  OrderCheckOut(
      {this.orderCheckOutStatus,
        this.orderCheckOutResponse,
        this.orderCheckOutOrderID,
        this.orderCheckOutQRCode,
        this.orderCheckOutDetails});

  OrderCheckOut.fromJson(Map<String, dynamic> json) {
    orderCheckOutStatus = json['orderCheckOutStatus'];
    orderCheckOutResponse = json['orderCheckOutResponse'];
    orderCheckOutOrderID = json['orderCheckOutOrderID'];
    orderCheckOutQRCode = json['orderCheckOutQRCode'];
    if (json['orderCheckOutDetails'] != null) {
      orderCheckOutDetails = <OrderCheckOutDetails>[];
      json['orderCheckOutDetails'].forEach((v) {
        orderCheckOutDetails!.add(new OrderCheckOutDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderCheckOutStatus'] = this.orderCheckOutStatus;
    data['orderCheckOutResponse'] = this.orderCheckOutResponse;
    data['orderCheckOutOrderID'] = this.orderCheckOutOrderID;
    data['orderCheckOutQRCode'] = this.orderCheckOutQRCode;
    if (this.orderCheckOutDetails != null) {
      data['orderCheckOutDetails'] =
          this.orderCheckOutDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderCheckOutDetails {
  String? orderCheckOutFullName;
  String? orderCheckOutDeliveryAddress;
  String? orderCheckOutTypeOfAddress;
  String? orderCheckOutContactNumber;
  String? orderCheckOutCartImage;
  String? orderCheckOutCartName;
  String? orderCheckOutCartSellerName;
  double? orderCheckOutCartRatting;
  String? orderCheckOutCartDiscountPrice;
  String? orderCheckOutCartOriginalPrice;
  String? orderCheckOutCartOfferPercent;
  String? orderCheckOutCartAvailableVariants;
  String? orderCheckOutCartLength;
  String? orderCheckOutCartDescription;
  String? orderCheckOutCartMaxCounter;
  String? orderCheckOutCartDeliveredBy;
  int? orderCheckOutCartTempCounter;
  int? orderCheckOutCartTotalOriginalPrice;
  int? orderCheckOutCartTotalDiscountPrice;
  int? orderCheckOutCartTotalDeliveryChargePrice;
  int? orderCheckOutCartTotalGrandAmount;
  String? orderCheckOutPromoCode;
  List<OrderCheckOutChangeAddressList>? orderCheckOutChangeAddressList;

  OrderCheckOutDetails(
      {this.orderCheckOutFullName,
        this.orderCheckOutDeliveryAddress,
        this.orderCheckOutTypeOfAddress,
        this.orderCheckOutContactNumber,
        this.orderCheckOutCartImage,
        this.orderCheckOutCartName,
        this.orderCheckOutCartSellerName,
        this.orderCheckOutCartRatting,
        this.orderCheckOutCartDiscountPrice,
        this.orderCheckOutCartOriginalPrice,
        this.orderCheckOutCartOfferPercent,
        this.orderCheckOutCartAvailableVariants,
        this.orderCheckOutCartLength,
        this.orderCheckOutCartDescription,
        this.orderCheckOutCartMaxCounter,
        this.orderCheckOutCartDeliveredBy,
        this.orderCheckOutCartTempCounter,
        this.orderCheckOutCartTotalOriginalPrice,
        this.orderCheckOutCartTotalDiscountPrice,
        this.orderCheckOutCartTotalDeliveryChargePrice,
        this.orderCheckOutCartTotalGrandAmount,
        this.orderCheckOutPromoCode,
        this.orderCheckOutChangeAddressList});

  OrderCheckOutDetails.fromJson(Map<String, dynamic> json) {
    orderCheckOutFullName = json['orderCheckOutFullName'];
    orderCheckOutDeliveryAddress = json['orderCheckOutDeliveryAddress'];
    orderCheckOutTypeOfAddress = json['orderCheckOutTypeOfAddress'];
    orderCheckOutContactNumber = json['orderCheckOutContactNumber'];
    orderCheckOutCartImage = json['orderCheckOutCartImage'];
    orderCheckOutCartName = json['orderCheckOutCartName'];
    orderCheckOutCartSellerName = json['orderCheckOutCartSellerName'];
    orderCheckOutCartRatting = json['orderCheckOutCartRatting'];
    orderCheckOutCartDiscountPrice = json['orderCheckOutCartDiscountPrice'];
    orderCheckOutCartOriginalPrice = json['orderCheckOutCartOriginalPrice'];
    orderCheckOutCartOfferPercent = json['orderCheckOutCartOfferPercent'];
    orderCheckOutCartAvailableVariants =
    json['orderCheckOutCartAvailableVariants'];
    orderCheckOutCartLength = json['orderCheckOutCartLength'];
    orderCheckOutCartDescription = json['orderCheckOutCartDescription'];
    orderCheckOutCartMaxCounter = json['orderCheckOutCartMaxCounter'];
    orderCheckOutCartDeliveredBy = json['orderCheckOutCartDeliveredBy'];
    orderCheckOutCartTempCounter = json['orderCheckOutCartTempCounter'];
    orderCheckOutCartTotalOriginalPrice =
    json['orderCheckOutCartTotalOriginalPrice'];
    orderCheckOutCartTotalDiscountPrice =
    json['orderCheckOutCartTotalDiscountPrice'];
    orderCheckOutCartTotalDeliveryChargePrice =
    json['orderCheckOutCartTotalDeliveryChargePrice'];
    orderCheckOutCartTotalGrandAmount =
    json['orderCheckOutCartTotalGrandAmount'];
    orderCheckOutPromoCode = json['orderCheckOutPromoCode'];
    if (json['orderCheckOutChangeAddressList'] != null) {
      orderCheckOutChangeAddressList = <OrderCheckOutChangeAddressList>[];
      json['orderCheckOutChangeAddressList'].forEach((v) {
        orderCheckOutChangeAddressList!
            .add(new OrderCheckOutChangeAddressList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderCheckOutFullName'] = this.orderCheckOutFullName;
    data['orderCheckOutDeliveryAddress'] = this.orderCheckOutDeliveryAddress;
    data['orderCheckOutTypeOfAddress'] = this.orderCheckOutTypeOfAddress;
    data['orderCheckOutContactNumber'] = this.orderCheckOutContactNumber;
    data['orderCheckOutCartImage'] = this.orderCheckOutCartImage;
    data['orderCheckOutCartName'] = this.orderCheckOutCartName;
    data['orderCheckOutCartSellerName'] = this.orderCheckOutCartSellerName;
    data['orderCheckOutCartRatting'] = this.orderCheckOutCartRatting;
    data['orderCheckOutCartDiscountPrice'] =
        this.orderCheckOutCartDiscountPrice;
    data['orderCheckOutCartOriginalPrice'] =
        this.orderCheckOutCartOriginalPrice;
    data['orderCheckOutCartOfferPercent'] = this.orderCheckOutCartOfferPercent;
    data['orderCheckOutCartAvailableVariants'] =
        this.orderCheckOutCartAvailableVariants;
    data['orderCheckOutCartLength'] = this.orderCheckOutCartLength;
    data['orderCheckOutCartDescription'] = this.orderCheckOutCartDescription;
    data['orderCheckOutCartMaxCounter'] = this.orderCheckOutCartMaxCounter;
    data['orderCheckOutCartDeliveredBy'] = this.orderCheckOutCartDeliveredBy;
    data['orderCheckOutCartTempCounter'] = this.orderCheckOutCartTempCounter;
    data['orderCheckOutCartTotalOriginalPrice'] =
        this.orderCheckOutCartTotalOriginalPrice;
    data['orderCheckOutCartTotalDiscountPrice'] =
        this.orderCheckOutCartTotalDiscountPrice;
    data['orderCheckOutCartTotalDeliveryChargePrice'] =
        this.orderCheckOutCartTotalDeliveryChargePrice;
    data['orderCheckOutCartTotalGrandAmount'] =
        this.orderCheckOutCartTotalGrandAmount;
    data['orderCheckOutPromoCode'] = this.orderCheckOutPromoCode;
    if (this.orderCheckOutChangeAddressList != null) {
      data['orderCheckOutChangeAddressList'] =
          this.orderCheckOutChangeAddressList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderCheckOutChangeAddressList {
  String? subOrderCheckOutFullName;
  String? subOrderCheckOutAddress;
  String? subOrderCheckOutTypeOfAddress;
  String? subOrderCheckOutContactNumber;

  OrderCheckOutChangeAddressList(
      {this.subOrderCheckOutFullName,
        this.subOrderCheckOutAddress,
        this.subOrderCheckOutTypeOfAddress,
        this.subOrderCheckOutContactNumber});

  OrderCheckOutChangeAddressList.fromJson(Map<String, dynamic> json) {
    subOrderCheckOutFullName = json['subOrderCheckOutFullName'];
    subOrderCheckOutAddress = json['subOrderCheckOutAddress'];
    subOrderCheckOutTypeOfAddress = json['subOrderCheckOutTypeOfAddress'];
    subOrderCheckOutContactNumber = json['subOrderCheckOutContactNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subOrderCheckOutFullName'] = this.subOrderCheckOutFullName;
    data['subOrderCheckOutAddress'] = this.subOrderCheckOutAddress;
    data['subOrderCheckOutTypeOfAddress'] = this.subOrderCheckOutTypeOfAddress;
    data['subOrderCheckOutContactNumber'] = this.subOrderCheckOutContactNumber;
    return data;
  }
}

class MyOrders {
  int? myOrdersMainID;
  String? myOrderId;
  String? myOrderDate;
  String? myOrderPerson;
  String? myOrderDeliveryAddress;
  String? myOrderStatus;
  String? myOrderPrice;
  String? myOrderProgress;
  List<MyOrderDetailList>? myOrderDetailList;
  List<MyOrderCancelList>? myOrderCancelList;
  List<MyOrderReturnList>? myOrderReturnList;

  MyOrders(
      {this.myOrdersMainID,
        this.myOrderId,
        this.myOrderDate,
        this.myOrderPerson,
        this.myOrderDeliveryAddress,
        this.myOrderStatus,
        this.myOrderPrice,
        this.myOrderProgress,
        this.myOrderDetailList,
        this.myOrderCancelList,
        this.myOrderReturnList});

  MyOrders.fromJson(Map<String, dynamic> json) {
    myOrdersMainID = json['myOrdersMainID'];
    myOrderId = json['myOrderId'];
    myOrderDate = json['myOrderDate'];
    myOrderPerson = json['myOrderPerson'];
    myOrderDeliveryAddress = json['myOrderDeliveryAddress'];
    myOrderStatus = json['myOrderStatus'];
    myOrderPrice = json['myOrderPrice'];
    myOrderProgress = json['myOrderProgress'];
    if (json['myOrderDetailList'] != null) {
      myOrderDetailList = <MyOrderDetailList>[];
      json['myOrderDetailList'].forEach((v) {
        myOrderDetailList!.add(new MyOrderDetailList.fromJson(v));
      });
    }
    if (json['myOrderCancelList'] != null) {
      myOrderCancelList = <MyOrderCancelList>[];
      json['myOrderCancelList'].forEach((v) {
        myOrderCancelList!.add(new MyOrderCancelList.fromJson(v));
      });
    }
    if (json['myOrderReturnList'] != null) {
      myOrderReturnList = <MyOrderReturnList>[];
      json['myOrderReturnList'].forEach((v) {
        myOrderReturnList!.add(new MyOrderReturnList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['myOrdersMainID'] = this.myOrdersMainID;
    data['myOrderId'] = this.myOrderId;
    data['myOrderDate'] = this.myOrderDate;
    data['myOrderPerson'] = this.myOrderPerson;
    data['myOrderDeliveryAddress'] = this.myOrderDeliveryAddress;
    data['myOrderStatus'] = this.myOrderStatus;
    data['myOrderPrice'] = this.myOrderPrice;
    data['myOrderProgress'] = this.myOrderProgress;
    if (this.myOrderDetailList != null) {
      data['myOrderDetailList'] =
          this.myOrderDetailList!.map((v) => v.toJson()).toList();
    }
    if (this.myOrderCancelList != null) {
      data['myOrderCancelList'] =
          this.myOrderCancelList!.map((v) => v.toJson()).toList();
    }
    if (this.myOrderReturnList != null) {
      data['myOrderReturnList'] =
          this.myOrderReturnList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyOrderDetailList {
  int? productId;
  String? productImage;
  String? productDetails;
  String? productReview;
  double? productRatting;
  String? price;
  String? vendorDetails;
  bool? isOrderCanceled;
  bool? isOrderReturned;

  MyOrderDetailList(
      {this.productId,
        this.productImage,
        this.productDetails,
        this.productReview,
        this.productRatting,
        this.price,
        this.vendorDetails,
        this.isOrderCanceled,
        this.isOrderReturned});

  MyOrderDetailList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productImage = json['productImage'];
    productDetails = json['productDetails'];
    productReview = json['productReview'];
    productRatting = json['productRatting'];
    price = json['price'];
    vendorDetails = json['vendorDetails'];
    isOrderCanceled = json['isOrderCanceled'];
    isOrderReturned = json['isOrderReturned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productImage'] = this.productImage;
    data['productDetails'] = this.productDetails;
    data['productReview'] = this.productReview;
    data['productRatting'] = this.productRatting;
    data['price'] = this.price;
    data['vendorDetails'] = this.vendorDetails;
    data['isOrderCanceled'] = this.isOrderCanceled;
    data['isOrderReturned'] = this.isOrderReturned;
    return data;
  }
}

class MyOrderCancelList {
  int? cancelId;
  int? productIdForCancel;
  String? whyCancelProduct;
  bool? isCancelProductFor;

  MyOrderCancelList(
      {this.cancelId,
        this.productIdForCancel,
        this.whyCancelProduct,
        this.isCancelProductFor});

  MyOrderCancelList.fromJson(Map<String, dynamic> json) {
    cancelId = json['cancelId'];
    productIdForCancel = json['productIdForCancel'];
    whyCancelProduct = json['whyCancelProduct'];
    isCancelProductFor = json['isCancelProductFor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cancelId'] = this.cancelId;
    data['productIdForCancel'] = this.productIdForCancel;
    data['whyCancelProduct'] = this.whyCancelProduct;
    data['isCancelProductFor'] = this.isCancelProductFor;
    return data;
  }
}

class MyOrderReturnList {
  int? returnId;
  int? productIDForReturn;
  String? whyReturnProduct;
  bool? isReturnProductFor;

  MyOrderReturnList(
      {this.returnId,
        this.productIDForReturn,
        this.whyReturnProduct,
        this.isReturnProductFor});

  MyOrderReturnList.fromJson(Map<String, dynamic> json) {
    returnId = json['returnId'];
    productIDForReturn = json['productIDForReturn'];
    whyReturnProduct = json['whyReturnProduct'];
    isReturnProductFor = json['isReturnProductFor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['returnId'] = this.returnId;
    data['productIDForReturn'] = this.productIDForReturn;
    data['whyReturnProduct'] = this.whyReturnProduct;
    data['isReturnProductFor'] = this.isReturnProductFor;
    return data;
  }
}

class MyAddressList {
  String? myAddressFullName;
  String? myAddressPhoneNumber;
  String? myAddressHouseNoBuildingName;
  String? myAddressAreaColony;
  String? myAddressState;
  String? myAddressCity;
  String? myAddressPincode;
  String? myAddressTypeOfAddress;

  MyAddressList(
      {this.myAddressFullName,
        this.myAddressPhoneNumber,
        this.myAddressHouseNoBuildingName,
        this.myAddressAreaColony,
        this.myAddressState,
        this.myAddressCity,
        this.myAddressPincode,
        this.myAddressTypeOfAddress});

  MyAddressList.fromJson(Map<String, dynamic> json) {
    myAddressFullName = json['myAddressFullName'];
    myAddressPhoneNumber = json['myAddressPhoneNumber'];
    myAddressHouseNoBuildingName = json['myAddressHouseNoBuildingName'];
    myAddressAreaColony = json['myAddressAreaColony'];
    myAddressState = json['myAddressState'];
    myAddressCity = json['myAddressCity'];
    myAddressPincode = json['myAddressPincode'];
    myAddressTypeOfAddress = json['myAddressTypeOfAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['myAddressFullName'] = this.myAddressFullName;
    data['myAddressPhoneNumber'] = this.myAddressPhoneNumber;
    data['myAddressHouseNoBuildingName'] = this.myAddressHouseNoBuildingName;
    data['myAddressAreaColony'] = this.myAddressAreaColony;
    data['myAddressState'] = this.myAddressState;
    data['myAddressCity'] = this.myAddressCity;
    data['myAddressPincode'] = this.myAddressPincode;
    data['myAddressTypeOfAddress'] = this.myAddressTypeOfAddress;
    return data;
  }
}

class CustomerSupport {
  String? customerCareNumber;
  String? ccNumbImage;
  String? emailForQuery;
  String? queryImage;

  CustomerSupport(
      {this.customerCareNumber,
        this.ccNumbImage,
        this.emailForQuery,
        this.queryImage});

  CustomerSupport.fromJson(Map<String, dynamic> json) {
    customerCareNumber = json['customerCareNumber'];
    ccNumbImage = json['ccNumbImage'];
    emailForQuery = json['emailForQuery'];
    queryImage = json['queryImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerCareNumber'] = this.customerCareNumber;
    data['ccNumbImage'] = this.ccNumbImage;
    data['emailForQuery'] = this.emailForQuery;
    data['queryImage'] = this.queryImage;
    return data;
  }
}

class AccountSettings {
  bool? isPushNotifications;

  AccountSettings({this.isPushNotifications});

  AccountSettings.fromJson(Map<String, dynamic> json) {
    isPushNotifications = json['isPushNotifications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isPushNotifications'] = this.isPushNotifications;
    return data;
  }
}

class NotificationsList {
  int? id;
  bool? isOffersOnlyNotification;
  int? newNotificationCounter;
  String? notificationImage;
  String? notificationTitle;
  String? notificationDetails;
  String? notificationTime;

  NotificationsList(
      {this.id,
        this.isOffersOnlyNotification,
        this.newNotificationCounter,
        this.notificationImage,
        this.notificationTitle,
        this.notificationDetails,
        this.notificationTime});

  NotificationsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isOffersOnlyNotification = json['isOffersOnlyNotification'];
    newNotificationCounter = json['newNotificationCounter'];
    notificationImage = json['notificationImage'];
    notificationTitle = json['notificationTitle'];
    notificationDetails = json['notificationDetails'];
    notificationTime = json['notificationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isOffersOnlyNotification'] = this.isOffersOnlyNotification;
    data['newNotificationCounter'] = this.newNotificationCounter;
    data['notificationImage'] = this.notificationImage;
    data['notificationTitle'] = this.notificationTitle;
    data['notificationDetails'] = this.notificationDetails;
    data['notificationTime'] = this.notificationTime;
    return data;
  }
}

class MyCardList {
  String? myCardBankName;
  String? myCardType;
  String? myCardFullName;
  String? myCardNumber;
  String? myCardExpiryDate;

  MyCardList(
      {this.myCardBankName,
        this.myCardType,
        this.myCardFullName,
        this.myCardNumber,
        this.myCardExpiryDate});

  MyCardList.fromJson(Map<String, dynamic> json) {
    myCardBankName = json['myCardBankName'];
    myCardType = json['myCardType'];
    myCardFullName = json['myCardFullName'];
    myCardNumber = json['myCardNumber'];
    myCardExpiryDate = json['myCardExpiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['myCardBankName'] = this.myCardBankName;
    data['myCardType'] = this.myCardType;
    data['myCardFullName'] = this.myCardFullName;
    data['myCardNumber'] = this.myCardNumber;
    data['myCardExpiryDate'] = this.myCardExpiryDate;
    return data;
  }
}

class UserAccountList {
  int? userId;
  String? userName;
  String? userImage;
  String? userEmail;
  String? userMobile;
  String? userPassword;

  UserAccountList(
      {this.userId,
        this.userImage,
        this.userName,
        this.userEmail,
        this.userMobile,
        this.userPassword});

  UserAccountList.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userImage = json['userImage'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    userPassword = json['userPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userImage'] = this.userImage;
    data['userName'] = this.userName;
    data['userEmail'] = this.userEmail;
    data['userMobile'] = this.userMobile;
    data['userPassword'] = this.userPassword;
    return data;
  }
}

class ChangePassword {
  String? currentPassword;
  String? newPassword;

  ChangePassword({this.currentPassword, this.newPassword});

  ChangePassword.fromJson(Map<String, dynamic> json) {
    currentPassword = json['currentPassword'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPassword'] = this.currentPassword;
    data['newPassword'] = this.newPassword;
    return data;
  }
}
