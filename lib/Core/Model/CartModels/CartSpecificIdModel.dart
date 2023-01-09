

/*class CartSpecificIdModel {
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
  List<OrdersForPurchase>? ordersForPurchase;
  double? totalDeliveryCharges;
  double? totalDiscountAmount;
  double? totalDiscountAmountPercent;
  double? productRating;
  int? totalItemCount;
  double? totalMrp;
  double? totalOffer;
  double? totalPayable;
  int? userId;

  CartPayLoad(
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

  CartPayLoad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orders_for_purchase'] != null) {
      ordersForPurchase = <OrdersForPurchase>[];
      json['orders_for_purchase'].forEach((v) {
        ordersForPurchase!.add(new OrdersForPurchase.fromJson(v));
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

class OrdersForPurchase {
  String? customerContact;
  String? customerName;
  String? deliveryAddressCity;
  String? deliveryAddressLine1;
  String? deliveryAddressLine2;
  String? deliveryAddressPincode;
  String? deliveryAddressState;
  String? deliveryDate;
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
  var itemQty;
  double? productRating;

  OrdersForPurchase(
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

  OrdersForPurchase.fromJson(Map<String, dynamic> json) {
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
}*/


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
  List<OrdersForPurchase>? ordersForPurchase;
  double? totalDeliveryCharges;
  double? totalDiscountAmount;
  double? totalDiscountAmountPercent;
  double? productRating;
  bool? isDelivertAddressSet;
  var deliveryAddressId;
  int? totalItemCount;
  double? totalMrp;
  double? totalOffer;
  double? totalPayable;
  int? userId;

  CartPayLoad(
      {this.id,
        this.ordersForPurchase,
        this.totalDeliveryCharges,
        this.totalDiscountAmount,
        this.totalDiscountAmountPercent,
        this.productRating,
        this.isDelivertAddressSet,
        this.deliveryAddressId,
        this.totalItemCount,
        this.totalMrp,
        this.totalOffer,
        this.totalPayable,
        this.userId});

  CartPayLoad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['orders_for_purchase'] != null) {
      ordersForPurchase = <OrdersForPurchase>[];
      json['orders_for_purchase'].forEach((v) {
        ordersForPurchase!.add(new OrdersForPurchase.fromJson(v));
      });
    }
    totalDeliveryCharges = json['total_delivery_charges'];
    totalDiscountAmount = json['total_discount_amount'];
    totalDiscountAmountPercent = json['total_discount_amount_percent'];
    productRating = json['product_rating'];
    isDelivertAddressSet = json['is_delivert_address_set'];
    deliveryAddressId = json['delivery_address_id'];
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
    data['is_delivert_address_set'] = this.isDelivertAddressSet;
    data['delivery_address_id'] = this.deliveryAddressId;
    data['total_item_count'] = this.totalItemCount;
    data['total_mrp'] = this.totalMrp;
    data['total_offer'] = this.totalOffer;
    data['total_payable'] = this.totalPayable;
    data['user_id'] = this.userId;
    return data;
  }
}

class OrdersForPurchase {
  int? orderId;
  var customerContact;
  var customerName;
  var deliveryAddressCity;
  var deliveryAddressLine1;
  var deliveryAddressLine2;
  var deliveryAddressPincode;
  var deliveryAddressState;
  String? deliveryDate;
  double? discountAmount;
  double? discountPercent;
  String? imageUrl;
  bool? isAccepted;
  bool? isDelivered;
  bool? isOrderPlaced;
  bool? isPacked;
  bool? isShipped;
  int? itemQty;
  int? merchantId;
  double? mrp;
  double? offer;
  String? oneliner;
  int? productId;
  String? productCode;
  var serviceCode;
  int? productItemId;
  var productRating;
  var serviceId;
  var serviceItemId;
  String? shortName;
 var userId;
  double? unitMrp;
  double? unitOffer;
  double? unitDiscount;
  double? unitDiscountPerc;

  OrdersForPurchase(
      {this.orderId,
        this.customerContact,
        this.customerName,
        this.deliveryAddressCity,
        this.deliveryAddressLine1,
        this.deliveryAddressLine2,
        this.deliveryAddressPincode,
        this.deliveryAddressState,
        this.deliveryDate,
        this.discountAmount,
        this.discountPercent,
        this.imageUrl,
        this.isAccepted,
        this.isDelivered,
        this.isOrderPlaced,
        this.isPacked,
        this.isShipped,
        this.itemQty,
        this.merchantId,
        this.mrp,
        this.offer,
        this.oneliner,
        this.productId,
        this.productCode,
        this.serviceCode,
        this.productItemId,
        this.productRating,
        this.serviceId,
        this.serviceItemId,
        this.shortName,
        this.userId,
        this.unitMrp,
        this.unitOffer,
        this.unitDiscount,
        this.unitDiscountPerc});

  OrdersForPurchase.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    customerContact = json['customer_contact'];
    customerName = json['customer_name'];
    deliveryAddressCity = json['delivery_address_city'];
    deliveryAddressLine1 = json['delivery_address_line1'];
    deliveryAddressLine2 = json['delivery_address_line2'];
    deliveryAddressPincode = json['delivery_address_pincode'];
    deliveryAddressState = json['delivery_address_state'];
    deliveryDate = json['delivery_date'];
    discountAmount = json['discount_amount'];
    discountPercent = json['discount_percent'];
    imageUrl = json['image_url'];
    isAccepted = json['is_accepted'];
    isDelivered = json['is_delivered'];
    isOrderPlaced = json['is_order_placed'];
    isPacked = json['is_packed'];
    isShipped = json['is_shipped'];
    itemQty = json['item_qty'];
    merchantId = json['merchant_id'];
    mrp = json['mrp'];
    offer = json['offer'];
    oneliner = json['oneliner'];
    productId = json['product_id'];
    productCode = json['product_code'];
    serviceCode = json['service_code'];
    productItemId = json['product_item_id'];
    productRating = json['product_rating'];
    serviceId = json['service_id'];
    serviceItemId = json['service_item_id'];
    shortName = json['short_name'];
    userId = json['user_id'];
    unitMrp = json['unit_mrp'];
    unitOffer = json['unit_offer'];
    unitDiscount = json['unit_discount'];
    unitDiscountPerc = json['unit_discount_perc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['customer_contact'] = this.customerContact;
    data['customer_name'] = this.customerName;
    data['delivery_address_city'] = this.deliveryAddressCity;
    data['delivery_address_line1'] = this.deliveryAddressLine1;
    data['delivery_address_line2'] = this.deliveryAddressLine2;
    data['delivery_address_pincode'] = this.deliveryAddressPincode;
    data['delivery_address_state'] = this.deliveryAddressState;
    data['delivery_date'] = this.deliveryDate;
    data['discount_amount'] = this.discountAmount;
    data['discount_percent'] = this.discountPercent;
    data['image_url'] = this.imageUrl;
    data['is_accepted'] = this.isAccepted;
    data['is_delivered'] = this.isDelivered;
    data['is_order_placed'] = this.isOrderPlaced;
    data['is_packed'] = this.isPacked;
    data['is_shipped'] = this.isShipped;
    data['item_qty'] = this.itemQty;
    data['merchant_id'] = this.merchantId;
    data['mrp'] = this.mrp;
    data['offer'] = this.offer;
    data['oneliner'] = this.oneliner;
    data['product_id'] = this.productId;
    data['product_code'] = this.productCode;
    data['service_code'] = this.serviceCode;
    data['product_item_id'] = this.productItemId;
    data['product_rating'] = this.productRating;
    data['service_id'] = this.serviceId;
    data['service_item_id'] = this.serviceItemId;
    data['short_name'] = this.shortName;
    data['user_id'] = this.userId;
    data['unit_mrp'] = this.unitMrp;
    data['unit_offer'] = this.unitOffer;
    data['unit_discount'] = this.unitDiscount;
    data['unit_discount_perc'] = this.unitDiscountPerc;
    return data;
  }
}







