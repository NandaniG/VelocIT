class CRMModel {
  String? status;
  List<CRMPayload>? payload;
  String? timestamp;

  CRMModel({this.status, this.payload, this.timestamp});

  CRMModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      payload = <CRMPayload>[];
      json['payload'].forEach((v) {
        payload!.add(new CRMPayload.fromJson(v));
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

class CRMPayload {
  int? id;
  String? crmCategoryCode;
  List<CRMSimpleSubCats>? simpleSubCats;
  var fmcgdbCategoryCode;
  String? name;
  int? seqNo;
  String? crmCategoryImageId;

  CRMPayload(
      {this.id,
        this.crmCategoryCode,
        this.simpleSubCats,
        this.fmcgdbCategoryCode,
        this.name,
        this.seqNo,
        this.crmCategoryImageId});

  CRMPayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    crmCategoryCode = json['crm_category_code'];
    if (json['simple_sub_cats'] != null) {
      simpleSubCats = <CRMSimpleSubCats>[];
      json['simple_sub_cats'].forEach((v) {
        simpleSubCats!.add(new CRMSimpleSubCats.fromJson(v));
      });
    }
    fmcgdbCategoryCode = json['fmcgdb_category_code'];
    name = json['name'];
    seqNo = json['seq_no'];
    crmCategoryImageId = json['crm_category_image_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['crm_category_code'] = this.crmCategoryCode;
    if (this.simpleSubCats != null) {
      data['simple_sub_cats'] =
          this.simpleSubCats!.map((v) => v.toJson()).toList();
    }
    data['fmcgdb_category_code'] = this.fmcgdbCategoryCode;
    data['name'] = this.name;
    data['seq_no'] = this.seqNo;
    data['crm_category_image_id'] = this.crmCategoryImageId;
    return data;
  }
}

class CRMSimpleSubCats {
  int? id;
  String? name;
  String? imageUrl;

  CRMSimpleSubCats({this.id, this.name, this.imageUrl});

  CRMSimpleSubCats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
