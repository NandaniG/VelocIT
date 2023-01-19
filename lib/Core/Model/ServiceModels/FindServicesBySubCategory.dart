class FindServicesbySUbCategoriesModel {
  String? status;
  Payload? payload;
  String? timestamp;

  FindServicesbySUbCategoriesModel({this.status, this.payload, this.timestamp});

  FindServicesbySUbCategoriesModel.fromJson(Map<String, dynamic> json) {
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
  List<ServiceContent>? content;
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
      content = <ServiceContent>[];
      json['content'].forEach((v) {
        content!.add(new ServiceContent.fromJson(v));
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

class ServiceContent {
  var brandCode;
  var brandId;
  var brandName;
  double? defaultDiscount;
  double? defaultMrp;
  double? defaultSellPrice;
  String? deliveryDate;
  String? fmcgdbCategoryCode;
  var gstCode;
  var gstPercent;
  int? id;
  List<ImageUrls>? imageUrls;
  List<Merchants>? merchants;
  String? oneliner;
  List? serviceCategory;
  String? serviceCode;
  double? serviceDeliveryCharges;
  List<ServicesubCategory>? servicesubCategory;
  int? selectedMerchantId;
  String? shortName;

  ServiceContent(
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
        this.serviceCategory,
        this.serviceCode,
        this.serviceDeliveryCharges,
        this.servicesubCategory,
        this.selectedMerchantId,
        this.shortName});

  ServiceContent.fromJson(Map<String, dynamic> json) {
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
      merchants = <Merchants>[];
      json['merchants'].forEach((v) {
        merchants!.add(new Merchants.fromJson(v));
      });
    }
    oneliner = json['oneliner'];
    if (json['serviceCategory'] != null) {
      serviceCategory = <Null>[];
      json['serviceCategory'].forEach((v) {
        // serviceCategory!.add(new Null.fromJson(v));
      });
    }
    serviceCode = json['service_code'];
    serviceDeliveryCharges = json['service_delivery_charges'];
    if (json['servicesubCategory'] != null) {
      servicesubCategory = <ServicesubCategory>[];
      json['servicesubCategory'].forEach((v) {
        servicesubCategory!.add(new ServicesubCategory.fromJson(v));
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
    if (this.merchants != null) {
      data['merchants'] = this.merchants!.map((v) => v.toJson()).toList();
    }
    data['oneliner'] = this.oneliner;
    if (this.serviceCategory != null) {
      // data['serviceCategory'] =
      //     this.serviceCategory!.map((v) => v.toJson()).toList();
    }
    data['service_code'] = this.serviceCode;
    data['service_delivery_charges'] = this.serviceDeliveryCharges;
    if (this.servicesubCategory != null) {
      data['servicesubCategory'] =
          this.servicesubCategory!.map((v) => v.toJson()).toList();
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

class Merchants {
  double? deliveryChargesPerOrder;
  int? deliveryDays;
  int? id;
  String? merchantCode;
  String? merchantName;
  double? merchantRating;
  int? serviceItemId;
  var unitDiscountPerc;
  double? unitMrp;
  double? unitOfferPrice;

  Merchants(
      {this.deliveryChargesPerOrder,
        this.deliveryDays,
        this.id,
        this.merchantCode,
        this.merchantName,
        this.merchantRating,
        this.serviceItemId,
        this.unitDiscountPerc,
        this.unitMrp,
        this.unitOfferPrice});

  Merchants.fromJson(Map<String, dynamic> json) {
    deliveryChargesPerOrder = json['delivery_charges_per_order'];
    deliveryDays = json['delivery_days'];
    id = json['id'];
    merchantCode = json['merchant_code'];
    merchantName = json['merchant_name'];
    merchantRating = json['merchant_rating'];
    serviceItemId = json['service_item_id'];
    unitDiscountPerc = json['unit_discount_perc'];
    unitMrp = json['unit_mrp'];
    unitOfferPrice = json['unit_offer_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_charges_per_order'] = this.deliveryChargesPerOrder;
    data['delivery_days'] = this.deliveryDays;
    data['id'] = this.id;
    data['merchant_code'] = this.merchantCode;
    data['merchant_name'] = this.merchantName;
    data['merchant_rating'] = this.merchantRating;
    data['service_item_id'] = this.serviceItemId;
    data['unit_discount_perc'] = this.unitDiscountPerc;
    data['unit_mrp'] = this.unitMrp;
    data['unit_offer_price'] = this.unitOfferPrice;
    return data;
  }
}

class ServicesubCategory {
  String? serviceSubCategoryCode;
  int? serviceSubCategoryId;
  String? serviceSubcategoryName;

  ServicesubCategory(
      {this.serviceSubCategoryCode,
        this.serviceSubCategoryId,
        this.serviceSubcategoryName});

  ServicesubCategory.fromJson(Map<String, dynamic> json) {
    serviceSubCategoryCode = json['service_sub_category_code'];
    serviceSubCategoryId = json['service_sub_category_id'];
    serviceSubcategoryName = json['service_subcategory_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_sub_category_code'] = this.serviceSubCategoryCode;
    data['service_sub_category_id'] = this.serviceSubCategoryId;
    data['service_subcategory_name'] = this.serviceSubcategoryName;
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
