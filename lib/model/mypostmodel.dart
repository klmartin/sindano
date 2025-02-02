// To parse this JSON data, do
//
//     final myPostModel = myPostModelFromJson(jsonString);

import 'dart:convert';

MyPostModel myPostModelFromJson(String str) =>
    MyPostModel.fromJson(json.decode(str));

String myPostModelToJson(MyPostModel data) => json.encode(data.toJson());

class MyPostModel {
  MyPostModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory MyPostModel.fromJson(Map<String, dynamic> json) => MyPostModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.categoryId,
    this.languageId,
    this.userId,
    this.type,
    this.articleType,
    this.name,
    this.description,
    this.image,
    this.bannerImage,
    this.videoType,
    this.videoPath,
    this.url,
    this.view,
    this.isPaid,
    this.download,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.categoryName,
  });

  int? id;
  String? categoryId;
  String? languageId;
  int? userId;
  int? type;
  String? articleType;
  String? name;
  String? description;
  String? image;
  String? bannerImage;
  String? videoType;
  String? videoPath;
  String? url;
  int? view;
  String? isPaid;
  int? download;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? userName;
  String? categoryName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        userId: json["user_id"],
        type: json["type"],
        articleType: json["article_type"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        bannerImage: json["banner_image"],
        videoType: json["video_type"],
        videoPath: json["video_path"],
        url: json["url"],
        view: json["view"],
        isPaid: json["is_paid"],
        download: json["download"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userName: json["user_name"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "language_id": languageId,
        "user_id": userId,
        "type": type,
        "article_type": articleType,
        "name": name,
        "description": description,
        "image": image,
        "banner_image": bannerImage,
        "video_type": videoType,
        "video_path": videoPath,
        "url": url,
        "view": view,
        "is_paid": isPaid,
        "download": download,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_name": userName,
        "category_name": categoryName,
      };
}
