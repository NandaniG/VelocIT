class AddressListModel {
  String? status;
  List<AddressPayload>? payload;
  String? timestamp;

  AddressListModel({this.status, this.payload, this.timestamp});

  AddressListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      payload = <AddressPayload>[];
      json['payload'].forEach((v) {
        payload!.add(new AddressPayload.fromJson(v));
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

class AddressPayload {
  int? id;
  String? name;
  String? addressLine1;
  String? addressLine2;
  String? stateName;
  String? cityName;
  String? addressType;
  String? contactNumber;
  String? pincode;
  double? latitude;
  double? longitude;
  Null? googlePOI;

  AddressPayload(
      {this.id,
        this.name,
        this.addressLine1,
        this.addressLine2,
        this.stateName,
        this.cityName,
        this.addressType,
        this.contactNumber,
        this.pincode,
        this.latitude,
        this.longitude,
        this.googlePOI});

  AddressPayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    stateName = json['state_name'];
    cityName = json['city_name'];
    addressType = json['address_type'];
    contactNumber = json['contact_number'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    googlePOI = json['googlePOI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['state_name'] = this.stateName;
    data['city_name'] = this.cityName;
    data['address_type'] = this.addressType;
    data['contact_number'] = this.contactNumber;
    data['pincode'] = this.pincode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['googlePOI'] = this.googlePOI;
    return data;
  }
}
