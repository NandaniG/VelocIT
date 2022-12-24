class CartSpecificIdModel {
  String? status;
  CartPayLoad? payload;
  String? timestamp;

  CartSpecificIdModel({this.status, this.payload, this.timestamp});

  CartSpecificIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
    json['payload'] != null ? new CartPayLoad.fromJson(json['payload']) : null;
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

class CartPayLoad {
  int? id;
  int? userId;
  List<OrdersForPurchase>? ordersForPurchase;
  int? totalItemCount;
  double? totalMrp;
  double? totalDiscountAmount;
  double? totalDeliveryCharges;
  double? totalPayable;

  CartPayLoad(
      {this.id,
        this.userId,
        this.ordersForPurchase,
        this.totalItemCount,
        this.totalMrp,
        this.totalDiscountAmount,
        this.totalDeliveryCharges,
        this.totalPayable});

  CartPayLoad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    if (json['orders_for_purchase'] != null) {
      ordersForPurchase = <OrdersForPurchase>[];
      json['orders_for_purchase'].forEach((v) {
        ordersForPurchase!.add(new OrdersForPurchase.fromJson(v));
      });
    }
    totalItemCount = json['total_item_count'];
    totalMrp = json['total_mrp'];
    totalDiscountAmount = json['total_discount_amount'];
    totalDeliveryCharges = json['total_delivery_charges'];
    totalPayable = json['total_payable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    if (this.ordersForPurchase != null) {
      data['orders_for_purchase'] =
          this.ordersForPurchase!.map((v) => v.toJson()).toList();
    }
    data['total_item_count'] = this.totalItemCount;
    data['total_mrp'] = this.totalMrp;
    data['total_discount_amount'] = this.totalDiscountAmount;
    data['total_delivery_charges'] = this.totalDeliveryCharges;
    data['total_payable'] = this.totalPayable;
    return data;
  }
}

class OrdersForPurchase {
  int? productItemId;
  String? itemName;
  String? deliveryDate;
  double? itemMrpPrice;
  double? itemOfferPrice;
  var merchantId;
  var itemDiscountPercent;
  String? imageUrl;
  var itemRating;
  var itemQty;

  OrdersForPurchase(
      {this.productItemId,
        this.itemName,
        this.deliveryDate,
        this.itemMrpPrice,
        this.itemOfferPrice,
        this.merchantId,
        this.itemDiscountPercent,
        this.imageUrl,
        this.itemRating,
        this.itemQty});

  OrdersForPurchase.fromJson(Map<String, dynamic> json) {
    productItemId = json['product_item_id'];
    itemName = json['item_name'];
    deliveryDate = json['delivery_date'];
    itemMrpPrice = json['item_mrp_price'];
    itemOfferPrice = json['item_offer_price'];
    merchantId = json['merchant_id'];
    itemDiscountPercent = json['item_discount_percent'];
    imageUrl = json['image_url'];
    itemRating = json['item_rating'];
    itemQty = json['item_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_item_id'] = this.productItemId;
    data['item_name'] = this.itemName;
    data['delivery_date'] = this.deliveryDate;
    data['item_mrp_price'] = this.itemMrpPrice;
    data['item_offer_price'] = this.itemOfferPrice;
    data['merchant_id'] = this.merchantId;
    data['item_discount_percent'] = this.itemDiscountPercent;
    data['image_url'] = this.imageUrl;
    data['item_rating'] = this.itemRating;
    data['item_qty'] = this.itemQty;
    return data;
  }
}
