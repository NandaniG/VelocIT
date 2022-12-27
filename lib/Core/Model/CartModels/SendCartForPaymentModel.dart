
class SendCartForPaymentModel {
  String? status;
  CartForPaymentPayload? payload;
  String? timestamp;

  SendCartForPaymentModel({this.status, this.payload, this.timestamp});

  SendCartForPaymentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
    json['payload'] != null ? new CartForPaymentPayload.fromJson(json['payload']) : null;
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

class CartForPaymentPayload {
  int? orderBasketId;
  int? cartId;
  int? userId;
  double? payableAmount;
  bool? isAddressPresent;
  String? customerName;
  String? deliveryAddress;
  String? customerMobile;
  Cart? cart;

  CartForPaymentPayload(
      {this.orderBasketId,
        this.cartId,
        this.userId,
        this.payableAmount,
        this.isAddressPresent,
        this.customerName,
        this.deliveryAddress,
        this.customerMobile,
        this.cart});

  CartForPaymentPayload.fromJson(Map<String, dynamic> json) {
    orderBasketId = json['order_basket_id'];
    cartId = json['cart_id'];
    userId = json['user_id'];
    payableAmount = json['payable_amount'];
    isAddressPresent = json['is_address_present'];
    customerName = json['customer_name'];
    deliveryAddress = json['delivery_address'];
    customerMobile = json['customer_mobile'];
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_basket_id'] = this.orderBasketId;
    data['cart_id'] = this.cartId;
    data['user_id'] = this.userId;
    data['payable_amount'] = this.payableAmount;
    data['is_address_present'] = this.isAddressPresent;
    data['customer_name'] = this.customerName;
    data['delivery_address'] = this.deliveryAddress;
    data['customer_mobile'] = this.customerMobile;
    if (this.cart != null) {
      data['cart'] = this.cart!.toJson();
    }
    return data;
  }
}

class Cart {
  int? id;
  int? userId;
  List<CartOrdersForPurchase>? ordersForPurchase;
  int? totalItemCount;
  double? totalMrp;
  double? totalDiscountAmount;
  double? totalDeliveryCharges;
  double? totalPayable;

  Cart(
      {this.id,
        this.userId,
        this.ordersForPurchase,
        this.totalItemCount,
        this.totalMrp,
        this.totalDiscountAmount,
        this.totalDeliveryCharges,
        this.totalPayable});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    if (json['orders_for_purchase'] != null) {
      ordersForPurchase = <CartOrdersForPurchase>[];
      json['orders_for_purchase'].forEach((v) {
        ordersForPurchase!.add(new CartOrdersForPurchase.fromJson(v));
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

class CartOrdersForPurchase {
  int? productItemId;
  String? itemName;
  String? deliveryDate;
  double? itemMrpPrice;
  double? itemOfferPrice;
  int? merchantId;
  int? itemDiscountPercent;
  String? imageUrl;
  double? itemRating;
  int? itemQty;

  CartOrdersForPurchase(
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

  CartOrdersForPurchase.fromJson(Map<String, dynamic> json) {
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
