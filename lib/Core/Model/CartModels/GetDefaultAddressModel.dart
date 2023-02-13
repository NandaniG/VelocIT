class GetDefaultAddressModel {
  String? status;
  DefaultAddressPayload? payload;
  String? timestamp;

  GetDefaultAddressModel({this.status, this.payload, this.timestamp});

  GetDefaultAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
    json['payload'] != null ? new DefaultAddressPayload.fromJson(json['payload']) : null;
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

class DefaultAddressPayload {
  String? addressLine1;
  String? addressLine2;
  String? addressType;
  String? cityName;
  String? contactNumber;
 var googlePOI;
  int? id;
  double? latitude;
  double? longitude;
  String? name;
  String? pincode;
  String? stateName;

  DefaultAddressPayload(
      {this.addressLine1,
        this.addressLine2,
        this.addressType,
        this.cityName,
        this.contactNumber,
        this.googlePOI,
        this.id,
        this.latitude,
        this.longitude,
        this.name,
        this.pincode,
        this.stateName});

  DefaultAddressPayload.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    addressType = json['address_type'];
    cityName = json['city_name'];
    contactNumber = json['contact_number'];
    googlePOI = json['googlePOI'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json['name'];
    pincode = json['pincode'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['address_type'] = this.addressType;
    data['city_name'] = this.cityName;
    data['contact_number'] = this.contactNumber;
    data['googlePOI'] = this.googlePOI;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['name'] = this.name;
    data['pincode'] = this.pincode;
    data['state_name'] = this.stateName;
    return data;
  }
}
