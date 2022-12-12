class CategoriesModel {
  Response? response;

  CategoriesModel({this.response});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
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
  List<CategoryList>? payload;
  String? timestamp;

  Body({this.status, this.payload, this.timestamp});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      payload = <CategoryList>[];
      json['payload'].forEach((v) {
        payload!.add(new CategoryList.fromJson(v));
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

class CategoryList {
  int? id;
  String? categoryCode;
  String? fmcgdbCategoryCode;
  String? name;
  int? seqNo;
  int? imageId;
  String? imageUrl;
  bool? enabled;

  CategoryList(
      {this.id,
        this.categoryCode,
        this.fmcgdbCategoryCode,
        this.name,
        this.seqNo,
        this.imageId,
        this.imageUrl,
        this.enabled});

  CategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryCode = json['category_code'];
    fmcgdbCategoryCode = json['fmcgdb_category_code'];
    name = json['name'];
    seqNo = json['seq_no'];
    imageId = json['image_id'];
    imageUrl = json['image_url'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_code'] = this.categoryCode;
    data['fmcgdb_category_code'] = this.fmcgdbCategoryCode;
    data['name'] = this.name;
    data['seq_no'] = this.seqNo;
    data['image_id'] = this.imageId;
    data['image_url'] = this.imageUrl;
    data['enabled'] = this.enabled;
    return data;
  }
}
