import 'dart:convert';



List<Payload> payloadFromJson(String str) =>
    List<Payload>.from(json.decode(str).map((x) => Payload.fromJson(x)));

String payloadToJson(List<Payload> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Payload {
  String sponsorlogo;

  Payload({
    required this.sponsorlogo,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        sponsorlogo: json["sponsorlogo"],
      );

  Map<String, dynamic> toJson() => {
        "sponsorlogo": sponsorlogo,
      };
}
