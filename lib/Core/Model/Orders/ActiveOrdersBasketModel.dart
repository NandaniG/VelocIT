class ActiveOrderBasketModel {
  String? status;
  BasketPayload? payload;
  String? timestamp;

  ActiveOrderBasketModel({this.status, this.payload, this.timestamp});

  ActiveOrderBasketModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
    json['payload'] != null ? new BasketPayload.fromJson(json['payload']) : null;
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

class BasketPayload {
  int? basketGroupId;
  List<ConsumerBaskets>? consumerBaskets;
  int? merchantId;

  BasketPayload({this.basketGroupId, this.consumerBaskets, this.merchantId});

  BasketPayload.fromJson(Map<String, dynamic> json) {
    basketGroupId = json['basket_group_id'];
    if (json['consumer_baskets'] != null) {
      consumerBaskets = <ConsumerBaskets>[];
      json['consumer_baskets'].forEach((v) {
        consumerBaskets!.add(new ConsumerBaskets.fromJson(v));
      });
    }
    merchantId = json['merchant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['basket_group_id'] = this.basketGroupId;
    if (this.consumerBaskets != null) {
      data['consumer_baskets'] =
          this.consumerBaskets!.map((v) => v.toJson()).toList();
    }
    data['merchant_id'] = this.merchantId;
    return data;
  }
}

class ConsumerBaskets {
  String? earliestDeliveryDate;
  int? id;
  int? userId;
  List<Orders>? orders;
  String? overallStatus;
  int? ordersTotal;
  int? ordersAcceptanceNoresponse;
  int? ordersAcceptanceAccepted;
  int? ordersAcceptanceRejected;
  int? ordersPackedTotal;
  int? ordersPackedCompleted;
  int? ordersShippedTotal;
  int? ordersShippedCompleted;
  int? ordersDeliveredTotal;
  int? ordersDeliveredCompleted;

  ConsumerBaskets(
      {this.earliestDeliveryDate,
        this.id,
        this.userId,
        this.orders,
        this.overallStatus,
        this.ordersTotal,
        this.ordersAcceptanceNoresponse,
        this.ordersAcceptanceAccepted,
        this.ordersAcceptanceRejected,
        this.ordersPackedTotal,
        this.ordersPackedCompleted,
        this.ordersShippedTotal,
        this.ordersShippedCompleted,
        this.ordersDeliveredTotal,
        this.ordersDeliveredCompleted});

  ConsumerBaskets.fromJson(Map<String, dynamic> json) {
    earliestDeliveryDate = json['earliest_delivery_date'];
    id = json['id'];
    userId = json['user_id'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
    overallStatus = json['overall_status'];
    ordersTotal = json['orders_total'];
    ordersAcceptanceNoresponse = json['orders_acceptance_noresponse'];
    ordersAcceptanceAccepted = json['orders_acceptance_accepted'];
    ordersAcceptanceRejected = json['orders_acceptance_rejected'];
    ordersPackedTotal = json['orders_packed_total'];
    ordersPackedCompleted = json['orders_packed_completed'];
    ordersShippedTotal = json['orders_Shipped_total'];
    ordersShippedCompleted = json['orders_Shipped_completed'];
    ordersDeliveredTotal = json['orders_Delivered_total'];
    ordersDeliveredCompleted = json['orders_Delivered_completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['earliest_delivery_date'] = this.earliestDeliveryDate;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    data['overall_status'] = this.overallStatus;
    data['orders_total'] = this.ordersTotal;
    data['orders_acceptance_noresponse'] = this.ordersAcceptanceNoresponse;
    data['orders_acceptance_accepted'] = this.ordersAcceptanceAccepted;
    data['orders_acceptance_rejected'] = this.ordersAcceptanceRejected;
    data['orders_packed_total'] = this.ordersPackedTotal;
    data['orders_packed_completed'] = this.ordersPackedCompleted;
    data['orders_Shipped_total'] = this.ordersShippedTotal;
    data['orders_Shipped_completed'] = this.ordersShippedCompleted;
    data['orders_Delivered_total'] = this.ordersDeliveredTotal;
    data['orders_Delivered_completed'] = this.ordersDeliveredCompleted;
    return data;
  }
}

class Orders {
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
  int? mrp;
  int? offer;
  String? oneliner;
  String? shortName;
  int? userId;
  int? itemQty;

  Orders(
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
        this.mrp,
        this.offer,
        this.oneliner,
        this.shortName,
        this.userId,
        this.itemQty});

  Orders.fromJson(Map<String, dynamic> json) {
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
    mrp = json['mrp'];
    offer = json['offer'];
    oneliner = json['oneliner'];
    shortName = json['short_name'];
    userId = json['user_id'];
    itemQty = json['item_qty'];
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
    data['mrp'] = this.mrp;
    data['offer'] = this.offer;
    data['oneliner'] = this.oneliner;
    data['short_name'] = this.shortName;
    data['user_id'] = this.userId;
    data['item_qty'] = this.itemQty;
    return data;
  }
}
