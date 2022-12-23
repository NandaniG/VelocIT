class FindByFMCGCodeScannerModel {
  String? status;
  Payload? payload;
  String? timestamp;

  FindByFMCGCodeScannerModel({this.status, this.payload, this.timestamp});

  FindByFMCGCodeScannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
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

class Payload {
  List<ImageUrls>? imageUrls;
  List? productCategory;
  List<ProductsubCategory>? productsubCategory;
  List? merchants;
  List? productVariants;
  int? id;
  String? productCode;
  String? fmcgdbCategoryCode;
  String? shortName;
  String? oneliner;
  int? defaultMrp;
  int? defaultSellPrice;
  int? defaultDiscount;
  var gstCode;
  var gstPercent;
  var brandId;
  var brandCode;
  var brandName;

  Payload(
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

  Payload.fromJson(Map<String, dynamic> json) {
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
      productsubCategory = <ProductsubCategory>[];
      json['productsubCategory'].forEach((v) {
        productsubCategory!.add(new ProductsubCategory.fromJson(v));
      });
    }
    if (json['merchants'] != null) {
      merchants = <Null>[];
      // json['merchants'].forEach((v) {
      //   merchants!.add(new Null.fromJson(v));
      // });
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
      // data['productCategory'] =
      //     this.productCategory!.map((v) => v.toJson()).toList();
    }
    if (this.productsubCategory != null) {
      data['productsubCategory'] =
          this.productsubCategory!.map((v) => v.toJson()).toList();
    }
    if (this.merchants != null) {
      // data['merchants'] = this.merchants!.map((v) => v.toJson()).toList();
    }
    if (this.productVariants != null) {
      // data['productVariants'] =
      //     this.productVariants!.map((v) => v.toJson()).toList();
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

class ProductsubCategory {
  int? productSubCategoryId;
  String? productSubCategoryCode;
  String? productSubcategoryName;

  ProductsubCategory(
      {this.productSubCategoryId,
        this.productSubCategoryCode,
        this.productSubcategoryName});

  ProductsubCategory.fromJson(Map<String, dynamic> json) {
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
