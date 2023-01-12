import 'dart:convert';

class ServicesSubCategoriesModel {
  List<ServicesSubCategoriesModel> userFromJson(String str) => List<ServicesSubCategoriesModel>.from(json.decode(str).map((x) => ServicesSubCategoriesModel.fromJson(x)));

  int? id;
  String? serviceSubCategoryCode;
  String? fmcgdbCategoryCode;
  String? name;
  int? seqNo;
  bool? enabled;
  String? serviceSubCategoryImageId;
  int? serviceCategoryId;
  String? serviceCategoryCode;
  String? serviceCategoryName;

  ServicesSubCategoriesModel(
      {this.id,
        this.serviceSubCategoryCode,
        this.fmcgdbCategoryCode,
        this.name,
        this.seqNo,
        this.enabled,
        this.serviceSubCategoryImageId,
        this.serviceCategoryId,
        this.serviceCategoryCode,
        this.serviceCategoryName});

  ServicesSubCategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceSubCategoryCode = json['service_sub_category_code'];
    fmcgdbCategoryCode = json['fmcgdb_category_code'];
    name = json['name'];
    seqNo = json['seq_no'];
    enabled = json['enabled'];
    serviceSubCategoryImageId = json['service_sub_category_image_id'];
    serviceCategoryId = json['service_category_id'];
    serviceCategoryCode = json['service_category_code'];
    serviceCategoryName = json['service_category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_sub_category_code'] = this.serviceSubCategoryCode;
    data['fmcgdb_category_code'] = this.fmcgdbCategoryCode;
    data['name'] = this.name;
    data['seq_no'] = this.seqNo;
    data['enabled'] = this.enabled;
    data['service_sub_category_image_id'] = this.serviceSubCategoryImageId;
    data['service_category_id'] = this.serviceCategoryId;
    data['service_category_code'] = this.serviceCategoryCode;
    data['service_category_name'] = this.serviceCategoryName;
    return data;
  }
}
