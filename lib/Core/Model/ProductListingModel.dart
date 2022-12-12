class ProductsListingModel {
  Response? response;

  ProductsListingModel({this.response});

  ProductsListingModel.fromJson(Map<String, dynamic> json) {
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
  List<ProductListing>? productListing;
  String? timestamp;

  Body({this.status, this.productListing, this.timestamp});

  Body.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      productListing = <ProductListing>[];
      json['payload'].forEach((v) {
        productListing!.add(new ProductListing.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.productListing != null) {
      data['payload'] = this.productListing!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class ProductListing {
  int? id;
  var categoryId;
  String? categoryCode;
  var productCode;
  String? shortName;
  var oneliner;
  double? scrappedPrice = 0.0??0.0;
  double? currentPrice= 0.0??0.0;
  var image1Id;
  String? image1Url;
  var image2Id;
  var image2Url;
  var image3Id;
  var image3Url;
  var image4Id;
  var image4Url;
  var image5Id;
  var image5Url;

  ProductListing(
      {this.id,
        this.categoryId,
        this.categoryCode,
        this.productCode,
        this.shortName,
        this.oneliner,
        this.scrappedPrice= 0.0??0.0,
        this.currentPrice= 0.0??0.0,
        this.image1Id,
        this.image1Url,
        this.image2Id,
        this.image2Url,
        this.image3Id,
        this.image3Url,
        this.image4Id,
        this.image4Url,
        this.image5Id,
        this.image5Url});

  ProductListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    categoryCode = json['category_code'];
    productCode = json['product_code'];
    shortName = json['short_name'];
    oneliner = json['oneliner'];
    scrappedPrice = json['scrapped_price'];
    currentPrice = json['current_price'];
    image1Id = json['image1_id'];
    image1Url = json['image1_url'];
    image2Id = json['image2_id'];
    image2Url = json['image2_url'];
    image3Id = json['image3_id'];
    image3Url = json['image3_url'];
    image4Id = json['image4_id'];
    image4Url = json['image4_url'];
    image5Id = json['image5_id'];
    image5Url = json['image5_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['category_code'] = this.categoryCode;
    data['product_code'] = this.productCode;
    data['short_name'] = this.shortName;
    data['oneliner'] = this.oneliner;
    data['scrapped_price'] = this.scrappedPrice;
    data['current_price'] = this.currentPrice;
    data['image1_id'] = this.image1Id;
    data['image1_url'] = this.image1Url;
    data['image2_id'] = this.image2Id;
    data['image2_url'] = this.image2Url;
    data['image3_id'] = this.image3Id;
    data['image3_url'] = this.image3Url;
    data['image4_id'] = this.image4Id;
    data['image4_url'] = this.image4Url;
    data['image5_id'] = this.image5Id;
    data['image5_url'] = this.image5Url;
    return data;
  }
}
