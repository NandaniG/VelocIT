class ServiceCategoryModel {
  String? status;
  List<ServicePayload>? payload;
  String? timestamp;

  ServiceCategoryModel({this.status, this.payload, this.timestamp});

  ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      payload = <ServicePayload>[];
      json['payload'].forEach((v) {
        payload!.add(new ServicePayload.fromJson(v));
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

class ServicePayload {
  int? id;
  String? serviceCategoryCode;
  List<ServiceSimpleSubCats>? simpleSubCats;
 var fmcgdbCategoryCode;
  String? name;
  int? seqNo;
  String? serviceCategoryImageId;

  ServicePayload(
      {this.id,
        this.serviceCategoryCode,
        this.simpleSubCats,
        this.fmcgdbCategoryCode,
        this.name,
        this.seqNo,
        this.serviceCategoryImageId});

  ServicePayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceCategoryCode = json['service_category_code'];
    if (json['simple_sub_cats'] != null) {
      simpleSubCats = <ServiceSimpleSubCats>[];
      json['simple_sub_cats'].forEach((v) {
        simpleSubCats!.add(new ServiceSimpleSubCats.fromJson(v));
      });
    }
    fmcgdbCategoryCode = json['fmcgdb_category_code'];
    name = json['name'];
    seqNo = json['seq_no'];
    serviceCategoryImageId = json['service_category_image_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_category_code'] = this.serviceCategoryCode;
    if (this.simpleSubCats != null) {
      data['simple_sub_cats'] =
          this.simpleSubCats!.map((v) => v.toJson()).toList();
    }
    data['fmcgdb_category_code'] = this.fmcgdbCategoryCode;
    data['name'] = this.name;
    data['seq_no'] = this.seqNo;
    data['service_category_image_id'] = this.serviceCategoryImageId;
    return data ??{};
  }
}

class ServiceSimpleSubCats {
  int? id;
  String? name;
  String? imageUrl;

  ServiceSimpleSubCats({this.id, this.name, this.imageUrl});

  ServiceSimpleSubCats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id??0;
    data['name'] = this.name??"";
    data['image_url'] = this.imageUrl??"";
    return data??{};
  }
}
