class ProductFindBySearchTermModel {
  String? status;
  Payload? payload;
  String? timestamp;

  ProductFindBySearchTermModel({this.status, this.payload, this.timestamp});

  ProductFindBySearchTermModel.fromJson(Map<String, dynamic> json) {
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
  List<SearchProduct>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  Payload(
      {this.content,
        this.pageable,
        this.totalPages,
        this.totalElements,
        this.last,
        this.size,
        this.number,
        this.sort,
        this.numberOfElements,
        this.first,
        this.empty});

  Payload.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <SearchProduct>[];
      json['content'].forEach((v) {
        content!.add(new SearchProduct.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    last = json['last'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    numberOfElements = json['numberOfElements'];
    first = json['first'];
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
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['last'] = this.last;
    data['size'] = this.size;
    data['number'] = this.number;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
    data['empty'] = this.empty;
    return data;
  }
}

class SearchProduct {
  List<ImageUrls>? imageUrls;
  List? productCategory;
  List<ProductsubCategory>? productsubCategory;
  List<Merchants>? merchants;
  List? productVariants;
  int? id;
  String? productCode;
  var fmcgdbCategoryCode;
  String? shortName;
  String? oneliner;
  double? defaultMrp;
  double? defaultSellPrice;
  double? defaultDiscount;
  var gstCode;
  var gstPercent;
  var brandId;
  var brandCode;
  var brandName;

  SearchProduct(
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

  SearchProduct.fromJson(Map<String, dynamic> json) {
    if (json['image_urls'] != null) {
      imageUrls = <ImageUrls>[];
      json['image_urls'].forEach((v) {
        imageUrls!.add(new ImageUrls.fromJson(v));
      });
    }
    if (json['productCategory'] != null) {
      productCategory = [];
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
      merchants = <Merchants>[];
      json['merchants'].forEach((v) {
        merchants!.add(new Merchants.fromJson(v));
      });
    }
    if (json['productVariants'] != null) {
      productVariants = [];
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
