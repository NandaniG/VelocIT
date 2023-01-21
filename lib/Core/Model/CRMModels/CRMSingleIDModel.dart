class CRMSingleIDModel {
  String? status;
  CRMDetailsPayload? payload;
  String? timestamp;

  CRMSingleIDModel({this.status, this.payload, this.timestamp});

  CRMSingleIDModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
        json['payload'] != null ? new CRMDetailsPayload.fromJson(json['payload']) : null;
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

class CRMDetailsPayload {
  Crm? crm;
  var crmVariantId;
  String? crmCode;
  double? deliveryChargesPerOrder;
  var deliveryDays;
  int? id;
  Merchant? merchant;
  double? unitGstAmount;
  double? unitMrp;
  double? unitOfferPrice;
  int? crmFormId;
  bool? available;

  CRMDetailsPayload(
      {this.crm,
      this.crmVariantId,
      this.crmCode,
      this.deliveryChargesPerOrder,
      this.deliveryDays,
      this.id,
      this.merchant,
      this.unitGstAmount,
      this.unitMrp,
      this.unitOfferPrice,
      this.crmFormId,
      this.available});

  CRMDetailsPayload.fromJson(Map<String, dynamic> json) {
    crm = json['crm'] != null ? new Crm.fromJson(json['crm']) : null;
    crmVariantId = json['crmVariantId'];
    crmCode = json['crm_code'];
    deliveryChargesPerOrder = json['delivery_charges_per_order'];
    deliveryDays = json['delivery_days'];
    id = json['id'];
    merchant = json['merchant'] != null
        ? new Merchant.fromJson(json['merchant'])
        : null;
    unitGstAmount = json['unit_gst_amount'];
    unitMrp = json['unit_mrp'];
    unitOfferPrice = json['unit_offer_price'];
    crmFormId = json['crm_form_id'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.crm != null) {
      data['crm'] = this.crm!.toJson();
    }
    data['crmVariantId'] = this.crmVariantId;
    data['crm_code'] = this.crmCode;
    data['delivery_charges_per_order'] = this.deliveryChargesPerOrder;
    data['delivery_days'] = this.deliveryDays;
    data['id'] = this.id;
    if (this.merchant != null) {
      data['merchant'] = this.merchant!.toJson();
    }
    data['unit_gst_amount'] = this.unitGstAmount;
    data['unit_mrp'] = this.unitMrp;
    data['unit_offer_price'] = this.unitOfferPrice;
    data['crm_form_id'] = this.crmFormId;
    data['available'] = this.available;
    return data;
  }
}

class Crm {
  var brandCode;
  var brandId;
  var brandName;
  List? crmCategory;
  String? crmCode;
  var crmDeliveryCharges;
  List<CrmsubCategory>? crmsubCategory;
  double? defaultDiscount;
  double? defaultMrp;
  double? defaultSellPrice;
  String? fmcgdbCategoryCode;
  var gstCode;
  var gstPercent;
  int? id;
  List<String>? imageUrls;
  String? oneliner;
  var selectedMerchantId;
  String? shortName;

  Crm(
      {this.brandCode,
      this.brandId,
      this.brandName,
      this.crmCategory,
      this.crmCode,
      this.crmDeliveryCharges,
      this.crmsubCategory,
      this.defaultDiscount,
      this.defaultMrp,
      this.defaultSellPrice,
      this.fmcgdbCategoryCode,
      this.gstCode,
      this.gstPercent,
      this.id,
      this.imageUrls,
      this.oneliner,
      this.selectedMerchantId,
      this.shortName});

  Crm.fromJson(Map<String, dynamic> json) {
    brandCode = json['brand_code'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    if (json['crmCategory'] != null) {
      crmCategory = <Null>[];
      json['crmCategory'].forEach((v) {
        // crmCategory!.add(new Null.fromJson(v));
      });
    }
    crmCode = json['crm_code'];
    crmDeliveryCharges = json['crm_delivery_charges'];
    if (json['crmsubCategory'] != null) {
      crmsubCategory = <CrmsubCategory>[];
      json['crmsubCategory'].forEach((v) {
        crmsubCategory!.add(new CrmsubCategory.fromJson(v));
      });
    }
    defaultDiscount = json['default_discount'];
    defaultMrp = json['default_mrp'];
    defaultSellPrice = json['default_sell_price'];
    fmcgdbCategoryCode = json['fmcgdb_category_code'];
    gstCode = json['gst_code'];
    gstPercent = json['gst_percent'];
    id = json['id'];
    imageUrls = json['image_urls'].cast<String>();
    oneliner = json['oneliner'];
    selectedMerchantId = json['selected_merchant_id'];
    shortName = json['short_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand_code'] = this.brandCode;
    data['brand_id'] = this.brandId;
    data['brand_name'] = this.brandName;
    if (this.crmCategory != null) {
      // data['crmCategory'] = this.crmCategory!.map((v) => v.toJson()).toList();
    }
    data['crm_code'] = this.crmCode;
    data['crm_delivery_charges'] = this.crmDeliveryCharges;
    if (this.crmsubCategory != null) {
      data['crmsubCategory'] =
          this.crmsubCategory!.map((v) => v.toJson()).toList();
    }
    data['default_discount'] = this.defaultDiscount;
    data['default_mrp'] = this.defaultMrp;
    data['default_sell_price'] = this.defaultSellPrice;
    data['fmcgdb_category_code'] = this.fmcgdbCategoryCode;
    data['gst_code'] = this.gstCode;
    data['gst_percent'] = this.gstPercent;
    data['id'] = this.id;
    data['image_urls'] = this.imageUrls;
    data['oneliner'] = this.oneliner;
    data['selected_merchant_id'] = this.selectedMerchantId;
    data['short_name'] = this.shortName;
    return data;
  }
}

class CrmsubCategory {
  String? crmSubCategoryCode;
  int? crmSubCategoryId;
  String? crmSubcategoryName;

  CrmsubCategory(
      {this.crmSubCategoryCode,
      this.crmSubCategoryId,
      this.crmSubcategoryName});

  CrmsubCategory.fromJson(Map<String, dynamic> json) {
    crmSubCategoryCode = json['crm_sub_category_code'];
    crmSubCategoryId = json['crm_sub_category_id'];
    crmSubcategoryName = json['crm_subcategory_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crm_sub_category_code'] = this.crmSubCategoryCode;
    data['crm_sub_category_id'] = this.crmSubCategoryId;
    data['crm_subcategory_name'] = this.crmSubcategoryName;
    return data;
  }
}

class Merchant {
  int? id;
  double? merchantRating;
  String? merchantCode;
  String? name;
  List? users;

  Merchant(
      {this.id, this.merchantRating, this.merchantCode, this.name, this.users});

  Merchant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantRating = json['merchantRating'];
    merchantCode = json['merchant_code'];
    name = json['name'];
    if (json['users'] != null) {
      users = <Null>[];
      json['users'].forEach((v) {
        // users!.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchantRating'] = this.merchantRating;
    data['merchant_code'] = this.merchantCode;
    data['name'] = this.name;
    if (this.users != null) {
      // data['users'] = this.users!.map((v) => v!.toJson()).toList();
    }
    return data;
  }
}
