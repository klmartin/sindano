// To parse this JSON data, do
// final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int? status;
  String? message;
  List<Result>? result;

  ProfileModel({
    this.status,
    this.message,
    this.result,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  String? userName;
  String? fullName;
  String? email;
  String? mobileNumber;
  String? image;
  int? type;
  String? bio;
  String? deviceToken;
  int? deviceType;
  String? firebaseId;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isReporter;
  int? isBuy;

  Result({
    this.id,
    this.userName,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.image,
    this.type,
    this.bio,
    this.deviceToken,
    this.deviceType,
    this.firebaseId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isReporter,
    this.isBuy,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        image: json["image"],
        type: json["type"],
        bio: json["bio"],
        deviceToken: json["device_token"],
        deviceType: json["device_type"],
        firebaseId: json["firebase_id"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isReporter: json["is_reporter"],
        isBuy: json["is_buy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "mobile_number": mobileNumber,
        "image": image,
        "type": type,
        "bio": bio,
        "device_token": deviceToken,
        "device_type": deviceType,
        "firebase_id": firebaseId,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_reporter": isReporter,
        "is_buy": isBuy,
      };
}
