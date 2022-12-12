class ServicesModel {
  Response? response;

  ServicesModel({this.response});

  ServicesModel.fromJson(Map<String, dynamic> json) {
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
  List<ServiceList>? serviceList;
  String? timestamp;

  Body({this.status, this.serviceList, this.timestamp});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      serviceList = <ServiceList>[];
      json['payload'].forEach((v) {
        serviceList!.add(new ServiceList.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.serviceList != null) {
      data['payload'] = this.serviceList!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class ServiceList {
  int? id;
  String? servCategoryCode;
  String? name;
  Null? imageId;
  String? imageUrl;
  int? seqNo;
  String? enabled;

  ServiceList(
      {this.id,
        this.servCategoryCode,
        this.name,
        this.imageId,
        this.imageUrl,
        this.seqNo,
        this.enabled});

  ServiceList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    servCategoryCode = json['serv_category_code'];
    name = json['name'];
    imageId = json['image_id'];
    imageUrl = json['image_url'];
    seqNo = json['seq_no'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serv_category_code'] = this.servCategoryCode;
    data['name'] = this.name;
    data['image_id'] = this.imageId;
    data['image_url'] = this.imageUrl;
    data['seq_no'] = this.seqNo;
    data['enabled'] = this.enabled;
    return data;
  }
}
