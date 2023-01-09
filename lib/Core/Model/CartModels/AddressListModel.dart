/*class AddressListModel {
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
}*/
class AddressListModel {
  String? status;
  AddressPayload? payload;
  String? timestamp;

  AddressListModel({this.status, this.payload, this.timestamp});

  AddressListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
    json['payload'] != null ? new AddressPayload.fromJson(json['payload']) : null;
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

class AddressPayload {
  List<AddressContent>? content;
  Pageable? pageable;
  int? totalElements;
  int? totalPages;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  AddressPayload(
      {this.content,
        this.pageable,
        this.totalElements,
        this.totalPages,
        this.last,
        this.size,
        this.number,
        this.sort,
        this.numberOfElements,
        this.first,
        this.empty});

  AddressPayload.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <AddressContent>[];
      json['content'].forEach((v) {
        content!.add(new AddressContent.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    last = json['last'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    numberOfElements = json['numberOfElements'];
    first = json['first'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    if (this.pageable != null) {
      data['pageable'] = this.pageable!.toJson();
    }
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['last'] = this.last;
    data['size'] = this.size;
    data['number'] = this.number;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
    data['empty'] = this.empty;
    return data;
  }
}

class AddressContent {
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

  AddressContent(
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

  AddressContent.fromJson(Map<String, dynamic> json) {
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

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable(
      {this.sort,
        this.offset,
        this.pageNumber,
        this.pageSize,
        this.paged,
        this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['offset'] = this.offset;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['paged'] = this.paged;
    data['unpaged'] = this.unpaged;
    return data;
  }
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  Sort.fromJson(Map<String, dynamic> json) {
    empty = json['empty'];
    sorted = json['sorted'];
    unsorted = json['unsorted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empty'] = this.empty;
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    return data;
  }
}
