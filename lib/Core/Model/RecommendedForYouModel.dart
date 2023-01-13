class RecommendedForYouModel {
  String? status;
  Payload? payload;
  String? timestamp;

  RecommendedForYouModel({this.status, this.payload, this.timestamp});

  RecommendedForYouModel.fromJson(Map<String, dynamic> json) {
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
  List<RecommendedContent>? content;
  Pageable? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? size;
  int? number;
  Sort? sort;
  bool? first;
  int? numberOfElements;
  bool? empty;

  Payload(
      {this.content,
        this.pageable,
        this.last,
        this.totalElements,
        this.totalPages,
        this.size,
        this.number,
        this.sort,
        this.first,
        this.numberOfElements,
        this.empty});

  Payload.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <RecommendedContent>[];
      json['content'].forEach((v) {
        content!.add(new RecommendedContent.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    last = json['last'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    first = json['first'];
    numberOfElements = json['numberOfElements'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    if (this.pageable != null) {
      data['pageable'] = this.pageable!.toJson();
    }
    data['last'] = this.last;
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['size'] = this.size;
    data['number'] = this.number;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['first'] = this.first;
    data['numberOfElements'] = this.numberOfElements;
    data['empty'] = this.empty;
    return data;
  }
}

class RecommendedContent {
  var brandCode;
  var brandId;
  var brandName;
  double? defaultDiscount;
  double? defaultMrp;
  double? defaultSellPrice;
  String? deliveryDate;
 var fmcgdbCategoryCode;
 var gstCode;
 var gstPercent;
  int? id;
  List<ImageUrls>? imageUrls;
  List? merchants;
  String? oneliner;
  List? productCategory;
  List? productVariants;
  String? productCode;
 var productDeliveryCharges;
  List<ProductsubCategory>? productsubCategory;
  var selectedMerchantId;
  String? shortName;

  RecommendedContent(
      {this.brandCode,
        this.brandId,
        this.brandName,
        this.defaultDiscount,
        this.defaultMrp,
        this.defaultSellPrice,
        this.deliveryDate,
        this.fmcgdbCategoryCode,
        this.gstCode,
        this.gstPercent,
        this.id,
        this.imageUrls,
        this.merchants,
        this.oneliner,
        this.productCategory,
        this.productVariants,
        this.productCode,
        this.productDeliveryCharges,
        this.productsubCategory,
        this.selectedMerchantId,
        this.shortName});

  RecommendedContent.fromJson(Map<String, dynamic> json) {
    brandCode = json['brand_code'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    defaultDiscount = json['default_discount'];
    defaultMrp = json['default_mrp'];
    defaultSellPrice = json['default_sell_price'];
    deliveryDate = json['delivery_date'];
    fmcgdbCategoryCode = json['fmcgdb_category_code'];
    gstCode = json['gst_code'];
    gstPercent = json['gst_percent'];
    id = json['id'];
    if (json['image_urls'] != null) {
      imageUrls = <ImageUrls>[];
      json['image_urls'].forEach((v) {
        imageUrls!.add(new ImageUrls.fromJson(v));
      });
    }
    if (json['merchants'] != null) {
      merchants = <Null>[];
      // json['merchants'].forEach((v) {
      //   merchants!.add(new Null.fromJson(v));
      // });
    }
    oneliner = json['oneliner'];
    if (json['productCategory'] != null) {
      productCategory = <Null>[];
      // json['productCategory'].forEach((v) {
      //   productCategory!.add(new Null.fromJson(v));
      // });
    }
    if (json['productVariants'] != null) {
      productVariants = <Null>[];
      // json['productVariants'].forEach((v) {
      //   productVariants!.add(new Null.fromJson(v));
      // });
    }
    productCode = json['product_code'];
    productDeliveryCharges = json['product_delivery_charges'];
    if (json['productsubCategory'] != null) {
      productsubCategory = <ProductsubCategory>[];
      json['productsubCategory'].forEach((v) {
        productsubCategory!.add(new ProductsubCategory.fromJson(v));
      });
    }
    selectedMerchantId = json['selected_merchant_id'];
    shortName = json['short_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand_code'] = this.brandCode;
    data['brand_id'] = this.brandId;
    data['brand_name'] = this.brandName;
    data['default_discount'] = this.defaultDiscount;
    data['default_mrp'] = this.defaultMrp;
    data['default_sell_price'] = this.defaultSellPrice;
    data['delivery_date'] = this.deliveryDate;
    data['fmcgdb_category_code'] = this.fmcgdbCategoryCode;
    data['gst_code'] = this.gstCode;
    data['gst_percent'] = this.gstPercent;
    data['id'] = this.id;
    if (this.imageUrls != null) {
      data['image_urls'] = this.imageUrls!.map((v) => v.toJson()).toList();
    }
    // if (this.merchants != null) {
    //   data['merchants'] = this.merchants!.map((v) => v.toJson()).toList();
    // }
    data['oneliner'] = this.oneliner;
    if (this.productCategory != null) {
      // data['productCategory'] =
      //     this.productCategory!.map((v) => v.toJson()).toList();
    }
    if (this.productVariants != null) {
      // data['productVariants'] =
      //     this.productVariants!.map((v) => v.toJson()).toList();
    }
    data['product_code'] = this.productCode;
    data['product_delivery_charges'] = this.productDeliveryCharges;
    if (this.productsubCategory != null) {
      data['productsubCategory'] =
          this.productsubCategory!.map((v) => v.toJson()).toList();
    }
    data['selected_merchant_id'] = this.selectedMerchantId;
    data['short_name'] = this.shortName;
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
  String? productSubCategoryCode;
  int? productSubCategoryId;
  String? productSubcategoryName;

  ProductsubCategory(
      {this.productSubCategoryCode,
        this.productSubCategoryId,
        this.productSubcategoryName});

  ProductsubCategory.fromJson(Map<String, dynamic> json) {
    productSubCategoryCode = json['product_sub_category_code'];
    productSubCategoryId = json['product_sub_category_id'];
    productSubcategoryName = json['product_subcategory_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_sub_category_code'] = this.productSubCategoryCode;
    data['product_sub_category_id'] = this.productSubCategoryId;
    data['product_subcategory_name'] = this.productSubcategoryName;
    return data;
  }
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable(
      {this.sort,
        this.offset,
        this.pageNumber,
        this.pageSize,
        this.paged,
        this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['offset'] = this.offset;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['paged'] = this.paged;
    data['unpaged'] = this.unpaged;
    return data;
  }
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  Sort.fromJson(Map<String, dynamic> json) {
    empty = json['empty'];
    sorted = json['sorted'];
    unsorted = json['unsorted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empty'] = this.empty;
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    return data;
  }
}
