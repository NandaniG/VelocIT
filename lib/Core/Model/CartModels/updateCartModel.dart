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
  List? prodItemsForPurchase;
  List? serviceItemsForPurchase;
  List? ordersForPurchase;
  List? ordersSavedLater;
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
      ordersForPurchase = <Null>[];
      // json['orders_for_purchase'].forEach((v) {
      //   ordersForPurchase!.add(new Null.fromJson(v));
      // });
    }
    if (json['orders_saved_later'] != null) {
      ordersSavedLater = <Null>[];
      // json['orders_saved_later'].forEach((v) {
      //   ordersSavedLater!.add(new Null.fromJson(v));
      // });
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

