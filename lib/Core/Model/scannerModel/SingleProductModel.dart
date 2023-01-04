/*
class SingleProductIDModel {
  String? status;
  SingleProductPayload? payload;
  String? timestamp;

  SingleProductIDModel({this.status, this.payload, this.timestamp});

  SingleProductIDModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
    json['payload'] != null ? new SingleProductPayload.fromJson(json['payload']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class SingleProductPayload {
  List<ImageUrls>? imageUrls;
  List? productCategory;
  List<SingleProductsubCategory>? productsubCategory;
  List<Merchants>? merchants;
  List? productVariants;
  int? id;
  String? productCode;
  String? fmcgdbCategoryCode;
  String? shortName;
  String? oneliner;
 double? defaultMrp;
 double? defaultSellPrice;
 var defaultDiscount;
  var gstCode;
  var gstPercent;
  var brandId;
  var brandCode;
  var brandName;

  SingleProductPayload(
      {this.imageUrls,
        this.productCategory,
        this.productsubCategory,
        this.merchants,
        this.productVariants,
        this.id,
        this.productCode,
        this.fmcgdbCategoryCode,
        this.shortName,
        this.oneliner,
        this.defaultMrp,
        this.defaultSellPrice,
        this.defaultDiscount,
        this.gstCode,
        this.gstPercent,
        this.brandId,
        this.brandCode,
        this.brandName});

  SingleProductPayload.fromJson(Map<String, dynamic> json) {
    if (json['image_urls'] != null) {
      imageUrls = <ImageUrls>[];
      json['image_urls'].forEach((v) {
        imageUrls!.add(new ImageUrls.fromJson(v));
      });
    }
    if (json['productCategory'] != null) {
      productCategory = <Null>[];
      // json['productCategory'].forEach((v) {
      //   productCategory!.add(new Null.fromJson(v));
      // });
    }
    if (json['productsubCategory'] != null) {
      productsubCategory = <SingleProductsubCategory>[];
      json['productsubCategory'].forEach((v) {
        productsubCategory!.add(new SingleProductsubCategory.fromJson(v));
      });
    }
    if (json['merchants'] != null) {
      merchants = <Merchants>[];
      json['merchants'].forEach((v) {
        merchants!.add(new Merchants.fromJson(v));
      });
    }
    if (json['productVariants'] != null) {
      productVariants = <Null>[];
      // json['productVariants'].forEach((v) {
      //   productVariants!.add(new Null.fromJson(v));
      // });
    }
    id = json['id'];
    productCode = json['product_code'];
    fmcgdbCategoryCode = json['fmcgdb_category_code'];
    shortName = json['short_name'];
    oneliner = json['oneliner'];
    defaultMrp = json['default_mrp'];
    defaultSellPrice = json['default_sell_price'];
    defaultDiscount = json['default_discount'];
    gstCode = json['gst_code'];
    gstPercent = json['gst_percent'];
    brandId = json['brand_id'];
    brandCode = json['brand_code'];
    brandName = json['brand_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imageUrls != null) {
      data['image_urls'] = this.imageUrls!.map((v) => v.toJson()).toList();
    }
    if (this.productCategory != null) {
      data['productCategory'] =
          this.productCategory!.map((v) => v.toJson()).toList();
    }
    if (this.productsubCategory != null) {
      data['productsubCategory'] =
          this.productsubCategory!.map((v) => v.toJson()).toList();
    }
    if (this.merchants != null) {
      data['merchants'] = this.merchants!.map((v) => v.toJson()).toList();
    }
    if (this.productVariants != null) {
      data['productVariants'] =
          this.productVariants!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['product_code'] = this.productCode;
    data['fmcgdb_category_code'] = this.fmcgdbCategoryCode;
    data['short_name'] = this.shortName;
    data['oneliner'] = this.oneliner;
    data['default_mrp'] = this.defaultMrp;
    data['default_sell_price'] = this.defaultSellPrice;
    data['default_discount'] = this.defaultDiscount;
    data['gst_code'] = this.gstCode;
    data['gst_percent'] = this.gstPercent;
    data['brand_id'] = this.brandId;
    data['brand_code'] = this.brandCode;
    data['brand_name'] = this.brandName;
    return data;
  }
}

class ImageUrls {
  int? id;
  String? imageUrl;

  ImageUrls({this.id, this.imageUrl});

  ImageUrls.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
class Merchants {
  int? id;
  String? merchantCode;
  String? merchantName;

  Merchants({this.id, this.merchantCode, this.merchantName});

  Merchants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantCode = json['merchant_code'];
    merchantName = json['merchant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchant_code'] = this.merchantCode;
    data['merchant_name'] = this.merchantName;
    return data;
  }
}

class SingleProductsubCategory {
  int? productSubCategoryId;
  String? productSubCategoryCode;
  String? productSubcategoryName;

  SingleProductsubCategory(
      {this.productSubCategoryId,
        this.productSubCategoryCode,
        this.productSubcategoryName});

  SingleProductsubCategory.fromJson(Map<String, dynamic> json) {
    productSubCategoryId = json['product_sub_category_id'];
    productSubCategoryCode = json['product_sub_category_code'];
    productSubcategoryName = json['product_subcategory_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_sub_category_id'] = this.productSubCategoryId;
    data['product_sub_category_code'] = this.productSubCategoryCode;
    data['product_subcategory_name'] = this.productSubcategoryName;
    return data;
  }
}

*/

class SingleProductIDModel {
  String? status;
  SingleProductPayload? payload;
  String? timestamp;

  SingleProductIDModel({this.status, this.payload, this.timestamp});

  SingleProductIDModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
    json['payload'] != null ? new SingleProductPayload.fromJson(json['payload']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class SingleProductPayload {
  List<ImageUrls>? imageUrls;
  List? productCategory;
  List<SingleProductsubCategory>? productsubCategory;
  List<SingleModelMerchants> merchants=[];
  List? productVariants;
  int? id;
  String? productCode;
  String? fmcgdbCategoryCode;
  String? shortName;
  String? oneliner;
  double? defaultMrp;
  double? defaultSellPrice;
  double? defaultDiscount;
  var gstCode;
  double? productDeliveryCharges;
  int? selectedMerchantId;
  String? deliveryDate;
  var gstPercent;
  var brandId;
  var brandCode;
  var brandName;

  SingleProductPayload(        this.merchants,

      {this.imageUrls,
        this.productCategory,
        this.productsubCategory,
        this.productVariants,
        this.id,
        this.productCode,
        this.fmcgdbCategoryCode,
        this.shortName,
        this.oneliner,
        this.defaultMrp,
        this.defaultSellPrice,
        this.defaultDiscount,
        this.gstCode,
        this.productDeliveryCharges,
        this.selectedMerchantId,
        this.deliveryDate,
        this.gstPercent,
        this.brandId,
        this.brandCode,
        this.brandName});

  SingleProductPayload.fromJson(Map<String, dynamic> json) {
    if (json['image_urls'] != null) {
      imageUrls = <ImageUrls>[];
      json['image_urls'].forEach((v) {
        imageUrls!.add(new ImageUrls.fromJson(v));
      });
    }
    if (json['productCategory'] != null) {
      productCategory = <Null>[];
      // json['productCategory'].forEach((v) {
      //   productCategory!.add(new Null.fromJson(v));
      // });
    }
    if (json['productsubCategory'] != null) {
      productsubCategory = <SingleProductsubCategory>[];
      json['productsubCategory'].forEach((v) {
        productsubCategory!.add(new SingleProductsubCategory.fromJson(v));
      });
    }
    if (json['merchants'] != null) {
      merchants = <SingleModelMerchants>[];
      json['merchants'].forEach((v) {
        merchants!.add(new SingleModelMerchants.fromJson(v));
      });
    }
    if (json['productVariants'] != null) {
      productVariants = <Null>[];
      // json['productVariants'].forEach((v) {
      //   productVariants!.add(new Null.fromJson(v));
      // });
    }
    id = json['id'];
    productCode = json['product_code'];
    fmcgdbCategoryCode = json['fmcgdb_category_code'];
    shortName = json['short_name'];
    oneliner = json['oneliner'];
    defaultMrp = json['default_mrp'];
    defaultSellPrice = json['default_sell_price'];
    defaultDiscount = json['default_discount'];
    gstCode = json['gst_code'];
    productDeliveryCharges = json['product_delivery_charges'];
    selectedMerchantId = json['selected_merchant_id'];
    deliveryDate = json['delivery_date'];
    gstPercent = json['gst_percent'];
    brandId = json['brand_id'];
    brandCode = json['brand_code'];
    brandName = json['brand_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imageUrls != null) {
      data['image_urls'] = this.imageUrls!.map((v) => v.toJson()).toList();
    }
    if (this.productCategory != null) {
      data['productCategory'] =
          this.productCategory!.map((v) => v.toJson()).toList();
    }
    if (this.productsubCategory != null) {
      data['productsubCategory'] =
          this.productsubCategory!.map((v) => v.toJson()).toList();
    }
    if (this.merchants != null) {
      data['merchants'] = this.merchants!.map((v) => v.toJson()).toList();
    }
    if (this.productVariants != null) {
      data['productVariants'] =
          this.productVariants!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['product_code'] = this.productCode;
    data['fmcgdb_category_code'] = this.fmcgdbCategoryCode;
    data['short_name'] = this.shortName;
    data['oneliner'] = this.oneliner;
    data['default_mrp'] = this.defaultMrp;
    data['default_sell_price'] = this.defaultSellPrice;
    data['default_discount'] = this.defaultDiscount;
    data['gst_code'] = this.gstCode;
    data['product_delivery_charges'] = this.productDeliveryCharges;
    data['selected_merchant_id'] = this.selectedMerchantId;
    data['delivery_date'] = this.deliveryDate;
    data['gst_percent'] = this.gstPercent;
    data['brand_id'] = this.brandId;
    data['brand_code'] = this.brandCode;
    data['brand_name'] = this.brandName;
    return data;
  }
}

class ImageUrls {
  int? id;
  String? imageUrl;

  ImageUrls({this.id, this.imageUrl});

  ImageUrls.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class SingleProductsubCategory {
  int? productSubCategoryId;
  String? productSubCategoryCode;
  String? productSubcategoryName;

  SingleProductsubCategory(
      {this.productSubCategoryId,
        this.productSubCategoryCode,
        this.productSubcategoryName});

  SingleProductsubCategory.fromJson(Map<String, dynamic> json) {
    productSubCategoryId = json['product_sub_category_id'];
    productSubCategoryCode = json['product_sub_category_code'];
    productSubcategoryName = json['product_subcategory_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_sub_category_id'] = this.productSubCategoryId;
    data['product_sub_category_code'] = this.productSubCategoryCode;
    data['product_subcategory_name'] = this.productSubcategoryName;
    return data;
  }
}

class SingleModelMerchants {
  int? id;
  String? merchantCode;
  String merchantName='';
 double? unitMrp;
 double? unitOfferPrice;
  var deliveryChargesPerOrder;
  int? deliveryDays;
  double? merchantRating;
  int? productItemId;
  int? unitDiscountPerc;

  SingleModelMerchants(   this.merchantName,
      {this.id,
        this.merchantCode,

        this.unitMrp,
        this.unitOfferPrice,
        this.deliveryChargesPerOrder,
        this.deliveryDays,
        this.merchantRating,
        this.productItemId,
        this.unitDiscountPerc});

  SingleModelMerchants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantCode = json['merchant_code'];
    merchantName = json['merchant_name'];
    unitMrp = json['unit_mrp'];
    unitOfferPrice = json['unit_offer_price']??0.0;
    deliveryChargesPerOrder = json['delivery_charges_per_order'];
    deliveryDays = json['delivery_days'];
    merchantRating = json['merchant_rating'];
    productItemId = json['product_item_id'];
    unitDiscountPerc = json['unit_discount_perc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchant_code'] = this.merchantCode??"";
    data['merchant_name'] = this.merchantName??"";
    data['unit_mrp'] = this.unitMrp??0.0;
    data['unit_offer_price'] = this.unitOfferPrice??0.0;
    data['delivery_charges_per_order'] = this.deliveryChargesPerOrder??"";
    data['delivery_days'] = this.deliveryDays??"";
    data['merchant_rating'] = this.merchantRating??0.0;
    data['product_item_id'] = this.productItemId??"";
    data['unit_discount_perc'] = this.unitDiscountPerc??"";
    return data;
  }
}

