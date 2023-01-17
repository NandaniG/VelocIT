class StateModel {
  String? status;
  List<StatePayload>? payload;
  String? timestamp;

  StateModel({this.status, this.payload, this.timestamp});

  StateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['payload'] != null) {
      payload = <StatePayload>[];
      json['payload'].forEach((v) {
        payload!.add(new StatePayload.fromJson(v));
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

class StatePayload {
  int? id;
  List<StateCities>? cities;
  String? name;

  StatePayload({this.id, this.cities, this.name});

  StatePayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['cities'] != null) {
      cities = <StateCities>[];
      json['cities'].forEach((v) {
        cities!.add(new StateCities.fromJson(v));
      });
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    return data;
  }
}

class StateCities {
  int? id;
  String? name;
  String? country;

  StateCities({this.id, this.name, this.country});

  StateCities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country'] = this.country;
    return data;
  }
}
