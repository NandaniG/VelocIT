class CartListModel {
  Response? response;

  CartListModel({this.response});

  CartListModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  Body? body;
  int? length;

  Response({this.body, this.length});

  Response.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    data['length'] = this.length;
    return data;
  }
}

class Body {
  String? status;
  CartList? cartList;
  String? timestamp;

  Body({this.status, this.cartList, this.timestamp});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    cartList =
    json['payload'] != null ? new CartList.fromJson(json['payload']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.cartList != null) {
      data['payload'] = this.cartList!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class CartList {
  int? id;
  int? userUid;
  int? qty;
  var status;
  String? name;
  bool? enabled;

  CartList(
      {this.id, this.userUid, this.qty, this.status, this.name, this.enabled});

  CartList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userUid = json['user_uid'];
    qty = json['qty'];
    status = json['status'];
    name = json['name'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_uid'] = this.userUid;
    data['qty'] = this.qty;
    data['status'] = this.status;
    data['name'] = this.name;
    data['enabled'] = this.enabled;
    return data;
  }
}
