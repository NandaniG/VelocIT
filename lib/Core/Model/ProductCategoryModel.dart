class ProductCategoryModel {
  String? status;
  List<ProductList>? productList;
  String? timestamp;

  ProductCategoryModel({this.status, this.productList, this.timestamp});

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      productList = <ProductList>[];
      json['payload'].forEach((v) {
        productList!.add(new ProductList.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.productList != null) {
      data['payload'] = this.productList!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class ProductList {
  int? id;
  String? productCategoryCode;
  List<SimpleSubCats>? simpleSubCats;
  var fmcgdbCategoryCode;
  String? name;
  int? seqNo;
  String? productCategoryImageId;

  ProductList(
      {this.id,
        this.productCategoryCode,
        this.simpleSubCats,
        this.fmcgdbCategoryCode,
        this.name,
        this.seqNo,
        this.productCategoryImageId});

  ProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCategoryCode = json['product_category_code'];
    if (json['simple_sub_cats'] != null) {
      simpleSubCats = <SimpleSubCats>[];
      json['simple_sub_cats'].forEach((v) {
        simpleSubCats!.add(new SimpleSubCats.fromJson(v));
      });
    }
    fmcgdbCategoryCode = json['fmcgdb_category_code'];
    name = json['name'];
    seqNo = json['seq_no'];
    productCategoryImageId = json['product_category_image_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_category_code'] = this.productCategoryCode;
    if (this.simpleSubCats != null) {
      data['simple_sub_cats'] =
          this.simpleSubCats!.map((v) => v.toJson()).toList();
    }
    data['fmcgdb_category_code'] = this.fmcgdbCategoryCode;
    data['name'] = this.name;
    data['seq_no'] = this.seqNo;
    data['product_category_image_id'] = this.productCategoryImageId;
    return data;
  }
}

class SimpleSubCats {
  int? id;
  String? name;
  String? imageUrl;

  SimpleSubCats({this.id, this.name, this.imageUrl});

  SimpleSubCats.fromJson(Map<String, dynamic> json) {
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
