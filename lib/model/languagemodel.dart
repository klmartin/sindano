import 'dart:convert';

LanguageModel getLanguageFromJson(String str) =>
    LanguageModel.fromJson(json.decode(str));

String getLanguageToJson(LanguageModel data) => json.encode(data.toJson());

class LanguageModel {
  LanguageModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.name,
    this.date,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? date;
  int? status;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        date: json["date"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date": date,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
