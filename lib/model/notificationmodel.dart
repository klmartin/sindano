// To parse this JSON data, do
// final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  int? status;
  String? message;
  List<Result>? result;

  NotificationModel({
    this.status,
    this.message,
    this.result,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
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
  String? title;
  int? fromUserId;
  int? userId;
  int? articleId;
  int? type;
  String? message;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? userName;
  String? fullName;
  String? userImage;
  String? articleName;
  String? articleImage;

  Result({
    this.id,
    this.title,
    this.fromUserId,
    this.userId,
    this.articleId,
    this.type,
    this.message,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.fullName,
    this.userImage,
    this.articleName,
    this.articleImage,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        fromUserId: json["from_user_id"],
        userId: json["user_id"],
        articleId: json["article_id"],
        type: json["type"],
        message: json["message"],
        image: json["image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userName: json["user_name"],
        fullName: json["full_name"],
        userImage: json["user_image"],
        articleName: json["article_name"],
        articleImage: json["article_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "from_user_id": fromUserId,
        "user_id": userId,
        "article_id": articleId,
        "type": type,
        "message": message,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_name": userName,
        "full_name": fullName,
        "user_image": userImage,
        "article_name": articleName,
        "article_image": articleImage,
      };
}
