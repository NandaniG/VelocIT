class UpdateCartModel {
  String? status;
  Payload? payload;
  String? timestamp;

  UpdateCartModel({this.status, this.payload, this.timestamp});

  UpdateCartModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  // List<Null>? prodItemsForPurchase;
  // List<Null>? serviceItemsForPurchase;
  List? prodItemsForPurchase;
  List? serviceItemsForPurchase;
  List<OrdersForPurchase>? ordersForPurchase;
  List<OrdersSavedLater>? ordersSavedLater;
  int? tempUserId;
  var scratchedTotal;
  var mrpTotal;
  var totalDiscount;
  var totalDeliveryCharges;
  var cartType;
  bool? isOpen;
  var user;

  Payload(
      {this.id,
        this.prodItemsForPurchase,
        this.serviceItemsForPurchase,
        this.ordersForPurchase,
        this.ordersSavedLater,
        this.tempUserId,
        this.scratchedTotal,
        this.mrpTotal,
        this.totalDiscount,
        this.totalDeliveryCharges,
        this.cartType,
        this.isOpen,
        this.user});

  Payload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['prod_items_for_purchase'] != null) {
      prodItemsForPurchase = <Null>[];
      // json['prod_items_for_purchase'].forEach((v) {
      //   prodItemsForPurchase!.add(new Null.fromJson(v));
      // });
    }
    if (json['service_items_for_purchase'] != null) {
      serviceItemsForPurchase = <Null>[];
      // json['service_items_for_purchase'].forEach((v) {
      //   serviceItemsForPurchase!.add(new Null.fromJson(v));
      // });
    }
    if (json['orders_for_purchase'] != null) {
      ordersForPurchase = <OrdersForPurchase>[];
      json['orders_for_purchase'].forEach((v) {
        ordersForPurchase!.add(new OrdersForPurchase.fromJson(v));
      });
    }
    if (json['orders_saved_later'] != null) {
      ordersSavedLater = <OrdersSavedLater>[];
      json['orders_saved_later'].forEach((v) {
        ordersSavedLater!.add(new OrdersSavedLater.fromJson(v));
      });
    }
    tempUserId = json['tempUserId'];
    scratchedTotal = json['scratched_total'];
    mrpTotal = json['mrp_total'];
    totalDiscount = json['total_discount'];
    totalDeliveryCharges = json['total_delivery_charges'];
    cartType = json['cart_type'];
    isOpen = json['is_open'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.prodItemsForPurchase != null) {
      data['prod_items_for_purchase'] =
          this.prodItemsForPurchase!.map((v) => v.toJson()).toList();
    }
    if (this.serviceItemsForPurchase != null) {
      data['service_items_for_purchase'] =
          this.serviceItemsForPurchase!.map((v) => v.toJson()).toList();
    }
    if (this.ordersForPurchase != null) {
      data['orders_for_purchase'] =
          this.ordersForPurchase!.map((v) => v.toJson()).toList();
    }
    if (this.ordersSavedLater != null) {
      data['orders_saved_later'] =
          this.ordersSavedLater!.map((v) => v.toJson()).toList();
    }
    data['tempUserId'] = this.tempUserId;
    data['scratched_total'] = this.scratchedTotal;
    data['mrp_total'] = this.mrpTotal;
    data['total_discount'] = this.totalDiscount;
    data['total_delivery_charges'] = this.totalDeliveryCharges;
    data['cart_type'] = this.cartType;
    data['is_open'] = this.isOpen;
    data['user'] = this.user;
    return data;
  }
}

class OrdersForPurchase {
  int? id;
  String? currentStatus;
  var orderNumber;
  bool? isProductItem;
  bool? isServiceItem;
  bool? isCancelled;
  bool? isUndeliverable;
  var itemQuantity;
var goodsCharges;
  double? deliveryCharges;
  double? discount;
 double? gstAmount;
  double? netPayable;

  OrdersForPurchase(
      {this.id,
        this.currentStatus,
        this.orderNumber,
        this.isProductItem,
        this.isServiceItem,
        this.isCancelled,
        this.isUndeliverable,
        this.itemQuantity,
        this.goodsCharges,
        this.deliveryCharges,
        this.discount,
        this.gstAmount,
        this.netPayable});

  OrdersForPurchase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentStatus = json['current_status'];
    orderNumber = json['orderNumber'];
    isProductItem = json['is_product_item'];
    isServiceItem = json['is_service_item'];
    isCancelled = json['is_cancelled'];
    isUndeliverable = json['is_undeliverable'];
    itemQuantity = json['item_quantity'];
    goodsCharges = json['goods_charges'];
    deliveryCharges = json['delivery_charges'];
    discount = json['discount'];
    gstAmount = json['gst_amount'];
    netPayable = json['net_payable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['current_status'] = this.currentStatus;
    data['orderNumber'] = this.orderNumber;
    data['is_product_item'] = this.isProductItem;
    data['is_service_item'] = this.isServiceItem;
    data['is_cancelled'] = this.isCancelled;
    data['is_undeliverable'] = this.isUndeliverable;
    data['item_quantity'] = this.itemQuantity;
    data['goods_charges'] = this.goodsCharges;
    data['delivery_charges'] = this.deliveryCharges;
    data['discount'] = this.discount;
    data['gst_amount'] = this.gstAmount;
    data['net_payable'] = this.netPayable;
    return data;
  }
}

class OrdersSavedLater {
  int? id;
  String? currentStatus;
  Null? orderNumber;
  bool? isProductItem;
  bool? isServiceItem;
  bool? isCancelled;
  bool? isUndeliverable;
  int? itemQuantity;
  int? goodsCharges;
  int? deliveryCharges;
  int? discount;
  int? gstAmount;
  int? netPayable;

  OrdersSavedLater(
      {this.id,
        this.currentStatus,
        this.orderNumber,
        this.isProductItem,
        this.isServiceItem,
        this.isCancelled,
        this.isUndeliverable,
        this.itemQuantity,
        this.goodsCharges,
        this.deliveryCharges,
        this.discount,
        this.gstAmount,
        this.netPayable});

  OrdersSavedLater.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentStatus = json['current_status'];
    orderNumber = json['orderNumber'];
    isProductItem = json['is_product_item'];
    isServiceItem = json['is_service_item'];
    isCancelled = json['is_cancelled'];
    isUndeliverable = json['is_undeliverable'];
    itemQuantity = json['item_quantity'];
    goodsCharges = json['goods_charges'];
    deliveryCharges = json['delivery_charges'];
    discount = json['discount'];
    gstAmount = json['gst_amount'];
    netPayable = json['net_payable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['current_status'] = this.currentStatus;
    data['orderNumber'] = this.orderNumber;
    data['is_product_item'] = this.isProductItem;
    data['is_service_item'] = this.isServiceItem;
    data['is_cancelled'] = this.isCancelled;
    data['is_undeliverable'] = this.isUndeliverable;
    data['item_quantity'] = this.itemQuantity;
    data['goods_charges'] = this.goodsCharges;
    data['delivery_charges'] = this.deliveryCharges;
    data['discount'] = this.discount;
    data['gst_amount'] = this.gstAmount;
    data['net_payable'] = this.netPayable;
    return data;
  }
}
