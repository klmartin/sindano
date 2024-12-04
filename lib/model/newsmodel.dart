// To parse this JSON data, do
// final newsModel = newsModelFromJson(jsonString);

import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
  int? status;
  String? message;
  List<Result>? result;

  NewsModel({
    this.status,
    this.message,
    this.result,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
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
  int? userId;
  String? categoryId;
  String? languageId;
  String? name;
  String? description;
  int? articleType;
  String? image;
  String? bannerImage;
  String? videoType;
  String? url;
  int? view;
  int? download;
  String? isPaid;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? categoryName;
  String? languageName;
  String? fullName;
  int? isBookmark;
  int? isBuy;

  Result({
    this.id,
    this.userId,
    this.categoryId,
    this.languageId,
    this.name,
    this.description,
    this.articleType,
    this.image,
    this.bannerImage,
    this.videoType,
    this.url,
    this.view,
    this.download,
    this.isPaid,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.languageName,
    this.fullName,
    this.isBookmark,
    this.isBuy,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        name: json["name"],
        description: json["description"],
        articleType: json["article_type"],
        image: json["image"],
        bannerImage: json["banner_image"],
        videoType: json["video_type"],
        url: json["url"],
        view: json["view"],
        download: json["download"],
        isPaid: json["is_paid"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        categoryName: json["category_name"],
        languageName: json["language_name"],
        fullName: json["full_name"],
        isBookmark: json["is_bookmark"],
        isBuy: json["is_buy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "category_id": categoryId,
        "language_id": languageId,
        "name": name,
        "description": description,
        "article_type": articleType,
        "image": image,
        "banner_image": bannerImage,
        "video_type": videoType,
        "url": url,
        "view": view,
        "download": download,
        "is_paid": isPaid,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category_name": categoryName,
        "language_name": languageName,
        "full_name": fullName,
        "is_bookmark": isBookmark,
        "is_buy": isBuy,
      };
}
