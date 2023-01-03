/*

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
    itemOfferPrice = json['item_offer_price']??0.0;
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
    data['item_offer_price'] = this.itemOfferPrice??0.0;
    data['merchant_id'] = this.merchantId;
    data['item_discount_percent'] = this.itemDiscountPercent;
    data['image_url'] = this.imageUrl;
    data['item_rating'] = this.itemRating;
    data['item_qty'] = this.itemQty;
    return data;
  }
}
*/
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
  List<CartOrdersForPurchase>? ordersForPurchase;
  double? totalDeliveryCharges;
  double? totalDiscountAmount;
  double? totalDiscountAmountPercent;
  double? productRating;
  int? totalItemCount;
  double? totalMrp;
  double? totalOffer;
  double? totalPayable;
  int? userId;

  Cart(
      {this.id,
        this.ordersForPurchase,
        this.totalDeliveryCharges,
        this.totalDiscountAmount,
        this.totalDiscountAmountPercent,
        this.productRating,
        this.totalItemCount,
        this.totalMrp,
        this.totalOffer,
        this.totalPayable,
        this.userId});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orders_for_purchase'] != null) {
      ordersForPurchase = <CartOrdersForPurchase>[];
      json['orders_for_purchase'].forEach((v) {
        ordersForPurchase!.add(new CartOrdersForPurchase.fromJson(v));
      });
    }
    totalDeliveryCharges = json['total_delivery_charges'];
    totalDiscountAmount = json['total_discount_amount'];
    totalDiscountAmountPercent = json['total_discount_amount_percent'];
    productRating = json['product_rating'];
    totalItemCount = json['total_item_count'];
    totalMrp = json['total_mrp'];
    totalOffer = json['total_offer'];
    totalPayable = json['total_payable'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.ordersForPurchase != null) {
      data['orders_for_purchase'] =
          this.ordersForPurchase!.map((v) => v.toJson()).toList();
    }
    data['total_delivery_charges'] = this.totalDeliveryCharges;
    data['total_discount_amount'] = this.totalDiscountAmount;
    data['total_discount_amount_percent'] = this.totalDiscountAmountPercent;
    data['product_rating'] = this.productRating;
    data['total_item_count'] = this.totalItemCount;
    data['total_mrp'] = this.totalMrp;
    data['total_offer'] = this.totalOffer;
    data['total_payable'] = this.totalPayable;
    data['user_id'] = this.userId;
    return data;
  }
}

class CartOrdersForPurchase {
  String? customerContact;
  String? customerName;
  String? deliveryAddressCity;
  String? deliveryAddressLine1;
  String? deliveryAddressLine2;
  String? deliveryAddressPincode;
  String? deliveryAddressState;
  var deliveryDate;
  String? imageUrl;
  bool? isDelivered;
  bool? isOrderPlaced;
  bool? isPacked;
  bool? isShipped;
  bool? isAccepted;
  double? mrp;
  double? offer;
  double? discountAmount;
  double? discountPercent;
  int? productItemId;
  var serviceItemId;
  int? productId;
 var serviceId;
  int? merchantId;
  String? oneliner;
  String? shortName;
 var userId;
  int? itemQty;
  double? productRating;

  CartOrdersForPurchase(
      {this.customerContact,
        this.customerName,
        this.deliveryAddressCity,
        this.deliveryAddressLine1,
        this.deliveryAddressLine2,
        this.deliveryAddressPincode,
        this.deliveryAddressState,
        this.deliveryDate,
        this.imageUrl,
        this.isDelivered,
        this.isOrderPlaced,
        this.isPacked,
        this.isShipped,
        this.isAccepted,
        this.mrp,
        this.offer,
        this.discountAmount,
        this.discountPercent,
        this.productItemId,
        this.serviceItemId,
        this.productId,
        this.serviceId,
        this.merchantId,
        this.oneliner,
        this.shortName,
        this.userId,
        this.itemQty,
        this.productRating});

  CartOrdersForPurchase.fromJson(Map<String, dynamic> json) {
    customerContact = json['customer_contact'];
    customerName = json['customer_name'];
    deliveryAddressCity = json['delivery_address_city'];
    deliveryAddressLine1 = json['delivery_address_line1'];
    deliveryAddressLine2 = json['delivery_address_line2'];
    deliveryAddressPincode = json['delivery_address_pincode'];
    deliveryAddressState = json['delivery_address_state'];
    deliveryDate = json['delivery_date'];
    imageUrl = json['image_url'];
    isDelivered = json['is_delivered'];
    isOrderPlaced = json['is_order_placed'];
    isPacked = json['is_packed'];
    isShipped = json['is_shipped'];
    isAccepted = json['is_accepted'];
    mrp = json['mrp'];
    offer = json['offer'];
    discountAmount = json['discount_amount'];
    discountPercent = json['discount_percent'];
    productItemId = json['product_item_id'];
    serviceItemId = json['service_item_id'];
    productId = json['product_id'];
    serviceId = json['service_id'];
    merchantId = json['merchant_id'];
    oneliner = json['oneliner'];
    shortName = json['short_name'];
    userId = json['user_id'];
    itemQty = json['item_qty'];
    productRating = json['product_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_contact'] = this.customerContact;
    data['customer_name'] = this.customerName;
    data['delivery_address_city'] = this.deliveryAddressCity;
    data['delivery_address_line1'] = this.deliveryAddressLine1;
    data['delivery_address_line2'] = this.deliveryAddressLine2;
    data['delivery_address_pincode'] = this.deliveryAddressPincode;
    data['delivery_address_state'] = this.deliveryAddressState;
    data['delivery_date'] = this.deliveryDate;
    data['image_url'] = this.imageUrl;
    data['is_delivered'] = this.isDelivered;
    data['is_order_placed'] = this.isOrderPlaced;
    data['is_packed'] = this.isPacked;
    data['is_shipped'] = this.isShipped;
    data['is_accepted'] = this.isAccepted;
    data['mrp'] = this.mrp;
    data['offer'] = this.offer;
    data['discount_amount'] = this.discountAmount;
    data['discount_percent'] = this.discountPercent;
    data['product_item_id'] = this.productItemId;
    data['service_item_id'] = this.serviceItemId;
    data['product_id'] = this.productId;
    data['service_id'] = this.serviceId;
    data['merchant_id'] = this.merchantId;
    data['oneliner'] = this.oneliner;
    data['short_name'] = this.shortName;
    data['user_id'] = this.userId;
    data['item_qty'] = this.itemQty;
    data['product_rating'] = this.productRating;
    return data;
  }
}
