class CartCreateRetrieveModel {
  String? status;
  Payload? payload;
  String? timestamp;

  CartCreateRetrieveModel({this.status, this.payload, this.timestamp});

  CartCreateRetrieveModel.fromJson(Map<String, dynamic> json) {
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
  Null? ordersForPurchase;
  Null? ordersSavedLater;
  int? tempUserId;
  Null? scratchedTotal;
  Null? mrpTotal;
  Null? totalDiscount;
  Null? totalDeliveryCharges;
  Null? cartType;
  bool? isOpen;
  Null? user;

  Payload(
      {this.id,
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
    ordersForPurchase = json['orders_for_purchase'];
    ordersSavedLater = json['orders_saved_later'];
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
    data['orders_for_purchase'] = this.ordersForPurchase;
    data['orders_saved_later'] = this.ordersSavedLater;
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
