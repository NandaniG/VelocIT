class UserModel {
  String? status;
  Payload? payload;
  String? timestamp;

  UserModel({this.status, this.payload, this.timestamp});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  String? email;
  int? id;
  var imageUrl;
  String? mobile;
  var qrCodeImageUrl;
  List<Roles>? roles;
  var uniqueQRCode;
  String? username;
  List? addresses;

  Payload(
      {this.email,
        this.id,
        this.imageUrl,
        this.mobile,
        this.qrCodeImageUrl,
        this.roles,
        this.uniqueQRCode,
        this.username,
        this.addresses});

  Payload.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    imageUrl = json['image_url'];
    mobile = json['mobile'];
    qrCodeImageUrl = json['qr_code_image_url'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    uniqueQRCode = json['uniqueQRCode'];
    username = json['username'];
    if (json['addresses'] != null) {
      addresses = <Null>[];
      json['addresses'].forEach((v) {
        // addresses!.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    data['mobile'] = this.mobile;
    data['qr_code_image_url'] = this.qrCodeImageUrl;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    data['uniqueQRCode'] = this.uniqueQRCode;
    data['username'] = this.username;
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? name;

  Roles({this.id, this.name});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
