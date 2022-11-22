class AuthenticateWithUIDModel {
  int? timestamp;
  int? status;
  Payload? payload;
  int? errorCode;
  String? errorObj;
  String? message;

  AuthenticateWithUIDModel(
      {this.timestamp,
        this.status,
        this.payload,
        this.errorCode,
        this.errorObj,
        this.message});

  AuthenticateWithUIDModel.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    status = json['status'];
    payload =
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    errorCode = json['errorCode'];
    errorObj = json['errorObj'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    data['errorCode'] = this.errorCode;
    data['errorObj'] = this.errorObj;
    data['message'] = this.message;
    return data;
  }
}

class Payload {
  int? otp;

  Payload({this.otp});

  Payload.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    return data;
  }
}
