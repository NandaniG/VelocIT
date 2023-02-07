/*class MerchantListModel {
  String? status;
  List<MerchantPayload>? payload;
  String? timestamp;

  MerchantListModel({this.status, this.payload, this.timestamp});

  MerchantListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      payload = <MerchantPayload>[];
      json['payload'].forEach((v) {
        payload!.add(new MerchantPayload.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class MerchantPayload {
  int? id;
  double? merchantRating;
  double? latitude;
  double? longitude;
  String? merchantCode;
  String? name;
  List<Users>? users;
  var kycInfo;
  double? distanceInKm;
  String? merchantStoreImage;

  MerchantPayload(
      {this.id,
        this.merchantRating,
        this.merchantCode,
        this.latitude,
        this.longitude,
        this.name,
        this.users,
        this.kycInfo,
        this.distanceInKm,
        this.merchantStoreImage});

  MerchantPayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantRating = json['merchantRating'];
    merchantCode = json['merchant_code'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    kycInfo = json['kyc_info'];
    distanceInKm = json['distance_in_km'];
    merchantStoreImage = json['merchant_store_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchantRating'] = this.merchantRating;
    data['merchant_code'] = this.merchantCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['name'] = this.name;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['kyc_info'] = this.kycInfo;
    data['distance_in_km'] = this.distanceInKm;
    data['merchant_store_image'] = this.merchantStoreImage;
    return data;
  }
}

class Users {
  String? email;
  int? id;
  var imageUrl;
  String? mobile;
  var qrCodeImageUrl;
  List<Roles>? roles;
  var uniqueQRCode;
  String? username;
  List? addresses;

  Users(
      {this.email,
        this.id,
        this.imageUrl,
        this.mobile,
        this.qrCodeImageUrl,
        this.roles,
        this.uniqueQRCode,
        this.username,
        this.addresses});

  Users.fromJson(Map<String, dynamic> json) {
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
      data['addresses'] = this.addresses!.map((v) => v!.toJson()).toList();
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
}*/

class MerchantListModel {
  String? status;
  List<MerchantPayload>? payload;
  String? timestamp;

  MerchantListModel({this.status, this.payload, this.timestamp});

  MerchantListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      payload = <MerchantPayload>[];
      json['payload'].forEach((v) {
        payload!.add(new MerchantPayload.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class MerchantPayload {
  int? id;
  double? merchantRating;
  String? merchantCode;
  String? name;
  List<Users>? users;
  var kycInfo;
  double? distanceInKm;
  double? latitude;
  double? longitude;
  String? merchantStoreImage;

  MerchantPayload(
      {this.id,
        this.merchantRating,
        this.merchantCode,
        this.name,
        this.users,
        this.kycInfo,
        this.distanceInKm,
        this.latitude,
        this.longitude,
        this.merchantStoreImage});

  MerchantPayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantRating = json['merchantRating'];
    merchantCode = json['merchant_code'];
    name = json['name'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    kycInfo = json['kyc_info'];
    distanceInKm = json['distance_in_km'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    merchantStoreImage = json['merchant_store_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchantRating'] = this.merchantRating;
    data['merchant_code'] = this.merchantCode;
    data['name'] = this.name;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['kyc_info'] = this.kycInfo;
    data['distance_in_km'] = this.distanceInKm;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['merchant_store_image'] = this.merchantStoreImage;
    return data;
  }
}

class Users {
  String? email;
  int? id;
  var imageUrl;
  String? mobile;
  var qrCodeImageUrl;
  List<Roles>? roles;
  var uniqueQRCode;
  String? username;
  List<Null>? addresses;

  Users(
      {this.email,
        this.id,
        this.imageUrl,
        this.mobile,
        this.qrCodeImageUrl,
        this.roles,
        this.uniqueQRCode,
        this.username,
        this.addresses});

  Users.fromJson(Map<String, dynamic> json) {
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
      // data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
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
