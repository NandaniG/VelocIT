import 'dart:convert';



List<Payloads> payloadFromJson(String str) =>
    List<Payloads>.from(json.decode(str).map((x) => Payloads.fromJson(x)));

String payloadToJson(List<Payloads> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Payloads {
  String sponsorlogo;

  Payloads({
    required this.sponsorlogo,
  });

  factory Payloads.fromJson(Map<String, dynamic> json) => Payloads(
        sponsorlogo: json["sponsorlogo"],
      );

  Map<String, dynamic> toJson() => {
        "sponsorlogo": sponsorlogo,
      };
}
