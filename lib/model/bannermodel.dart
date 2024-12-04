// To parse this JSON data, do
// final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

BannerModel bannerModelFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  int? status;
  String? message;
  List<Result>? result;

  BannerModel({
    this.status,
    this.message,
    this.result,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
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
  int? articleId;
  int? userId;
  String? categoryId;
  String? languageId;
  String? name;
  String? description;
  int? articleType;
  String? videoType;
  String? url;
  int? view;
  int? download;
  String? isPaid;
  String? image;
  String? bannerImage;
  String? categoryName;
  String? languageName;
  String? userName;
  String? fullName;
  String? userImage;
  String? createdAt;
  String? updatedAt;
  int? isBookmark;
  int? isBuy;

  Result({
    this.id,
    this.articleId,
    this.userId,
    this.categoryId,
    this.languageId,
    this.name,
    this.description,
    this.articleType,
    this.videoType,
    this.url,
    this.view,
    this.download,
    this.isPaid,
    this.image,
    this.bannerImage,
    this.categoryName,
    this.languageName,
    this.userName,
    this.fullName,
    this.userImage,
    this.createdAt,
    this.updatedAt,
    this.isBookmark,
    this.isBuy,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        articleId: json["article_id"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        name: json["name"],
        description: json["description"],
        articleType: json["article_type"],
        videoType: json["video_type"],
        url: json["url"],
        view: json["view"],
        download: json["download"],
        isPaid: json["is_paid"],
        image: json["image"],
        bannerImage: json["banner_image"],
        categoryName: json["category_name"],
        languageName: json["language_name"],
        userName: json["user_name"],
        fullName: json["full_name"],
        userImage: json["user_image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isBookmark: json["is_bookmark"],
        isBuy: json["is_buy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "article_id": articleId,
        "user_id": userId,
        "category_id": categoryId,
        "language_id": languageId,
        "name": name,
        "description": description,
        "article_type": articleType,
        "video_type": videoType,
        "url": url,
        "view": view,
        "download": download,
        "is_paid": isPaid,
        "image": image,
        "banner_image": bannerImage,
        "category_name": categoryName,
        "language_name": languageName,
        "user_name": userName,
        "full_name": fullName,
        "user_image": userImage,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_bookmark": isBookmark,
        "is_buy": isBuy,
      };
}
