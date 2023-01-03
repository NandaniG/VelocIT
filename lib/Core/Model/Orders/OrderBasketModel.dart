
class OrderRatingsModel {
  String? status;
  Payload? payload;
  String? timestamp;

  OrderRatingsModel({this.status, this.payload, this.timestamp});

  OrderRatingsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
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

class Payload {
  bool? saved;

  Payload({this.saved});

  Payload.fromJson(Map<String, dynamic> json) {
    saved = json['saved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['saved'] = this.saved;
    return data;
  }
}
