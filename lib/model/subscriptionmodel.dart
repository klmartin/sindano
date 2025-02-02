// To parse this JSON data, do
// final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) =>
    SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) =>
    json.encode(data.toJson());

class SubscriptionModel {
  int? status;
  String? message;
  List<Result>? result;

  SubscriptionModel({
    this.status,
    this.message,
    this.result,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
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
  String? name;
  int? price;
  String? image;
  String? currencyType;
  String? androidProductPackage;
  String? iosProductPackage;
  String? time;
  String? type;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isBuy;

  Result({
    this.id,
    this.name,
    this.price,
    this.image,
    this.currencyType,
    this.androidProductPackage,
    this.iosProductPackage,
    this.time,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isBuy,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
        currencyType: json["currency_type"],
        androidProductPackage: json["android_product_package"],
        iosProductPackage: json["ios_product_package"],
        time: json["time"],
        type: json["type"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isBuy: json["is_buy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": image,
        "currency_type": currencyType,
        "android_product_package": androidProductPackage,
        "ios_product_package": iosProductPackage,
        "time": time,
        "type": type,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_buy": isBuy,
      };
}
