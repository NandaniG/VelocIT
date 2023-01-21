class ProductOfferModel {
  String? status;
  List<OfferPayload>? payload;
  String? timestamp;

  ProductOfferModel({this.status, this.payload, this.timestamp});

  ProductOfferModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      payload = <OfferPayload>[];
      json['payload'].forEach((v) {
        payload!.add(new OfferPayload.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class OfferPayload {
  double? belowAmount;
  var belowDiscountPercent;
  int? id;
  bool? isAmountBased;
  bool? isDiscountBased;
  int? productSubCategoryId;
  var offerImageUrl;
  String? belowAmountDisplay;
 String? belowDiscountPercentDisplay;
  String? productSubCategoryName;

  OfferPayload(
      {this.belowAmount,
        this.belowDiscountPercent,
        this.id,
        this.isAmountBased,
        this.isDiscountBased,
        this.productSubCategoryId,
        this.offerImageUrl,
        this.belowAmountDisplay,
        this.belowDiscountPercentDisplay,
        this.productSubCategoryName});

  OfferPayload.fromJson(Map<String, dynamic> json) {
    belowAmount = json['below_amount'];
    belowDiscountPercent = json['below_discount_percent'];
    id = json['id'];
    isAmountBased = json['is_amount_based'];
    isDiscountBased = json['is_discount_based'];
    productSubCategoryId = json['product_sub_category_id'];
    offerImageUrl = json['offer_image_url']??"";
    belowAmountDisplay = json['below_amount_display']??'';
    belowDiscountPercentDisplay = json['below_discount_percent_display']??'';
    productSubCategoryName = json['product_sub_category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['below_amount'] = this.belowAmount;
    data['below_discount_percent'] = this.belowDiscountPercent;
    data['id'] = this.id;
    data['is_amount_based'] = this.isAmountBased;
    data['is_discount_based'] = this.isDiscountBased;
    data['product_sub_category_id'] = this.productSubCategoryId;
    data['offer_image_url'] = this.offerImageUrl??"";
    data['below_amount_display'] = this.belowAmountDisplay??'';
    data['below_discount_percent_display'] = this.belowDiscountPercentDisplay??'';
    data['product_sub_category_name'] = this.productSubCategoryName;
    return data;
  }
}
