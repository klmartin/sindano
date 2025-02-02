// To parse this JSON data, do
// final generalSettingModel = generalSettingModelFromJson(jsonString);

import 'dart:convert';

GeneralSettingModel generalSettingModelFromJson(String str) =>
    GeneralSettingModel.fromJson(json.decode(str));

String generalSettingModelToJson(GeneralSettingModel data) =>
    json.encode(data.toJson());

class GeneralSettingModel {
  int? status;
  String? message;
  List<Result>? result;

  GeneralSettingModel({
    this.status,
    this.message,
    this.result,
  });

  factory GeneralSettingModel.fromJson(Map<String, dynamic> json) =>
      GeneralSettingModel(
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(
            json["result"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  int? id;
  String? key;
  String? value;

  Result({
    this.id,
    this.key,
    this.value,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
      };
}
