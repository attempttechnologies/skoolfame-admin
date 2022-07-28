import 'package:skoolfame/Data/Models/login_success_respo_model.dart';

class CommentResponseModel {
  int? status;
  String? message;
  List<CommentData>? commentData;

  CommentResponseModel({this.status, this.message, this.commentData});

  CommentResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      commentData = <CommentData>[];
      json['data'].forEach((v) {
        commentData!.add(new CommentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.commentData != null) {
      data['data'] = this.commentData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentData {
  String? sId;
  UserData? user;
  String? postId;
  String? comment;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CommentData(
      {this.sId,
      this.user,
      this.postId,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CommentData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
    postId = json['post_id'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user;
    }
    data['post_id'] = this.postId;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
