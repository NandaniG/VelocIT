class CityModel {
  String? status;
  List<CityPayloadData>? payload;
  String? timestamp;

  CityModel({this.status, this.payload, this.timestamp});

  CityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      payload = <CityPayloadData>[];
      json['payload'].forEach((v) { payload!.add(new CityPayloadData.fromJson(v)); });
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

class CityPayloadData {
  int? id;
  String? name;
  String? country;
  CityState? state;

  CityPayloadData({this.id, this.name, this.country, this.state});

  CityPayloadData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    state = json['state'] != null ? new CityState.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country'] = this.country;
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    return data;
  }
}

class CityState {
  int? id;
  String? name;

  CityState({this.id, this.name});

  CityState.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;

    return data;
  }
}

