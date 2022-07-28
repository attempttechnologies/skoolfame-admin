import 'package:skoolfame/Data/Models/album_images_model.dart';

class LoginSuccessResponse {
  int? status;
  String? message;
  UserData? data;
  String? token;

  LoginSuccessResponse({this.status, this.message, this.data, this.token});

  LoginSuccessResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class UserData {
  String? firstName;
  String? lastName;
  String? email;
  String? school;
  String? gender;
  String? dob;
  String? about;
  String? socialMedia;
  List<String>? friends;
  List<ImagesData>? imagesData;
  List<ImagesData>? videos;
  List? feedback;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<String>? relationships;
  String? userProfileImage;
  String? reqSend;
  String? reqReceive;
  String? reqRelationshipSend;
  String? reqRelationshipReceive;
  String? privacy;
  int? votelength;
  bool? isVoted;
  bool? isSelected;

  UserData(
      {this.firstName,
      this.lastName,
      this.email,
      this.school,
      this.gender,
      this.dob,
      this.about,
      this.socialMedia,
      this.friends,
      this.imagesData,
      this.videos,
      this.feedback,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.relationships,
      this.userProfileImage,
      this.reqSend,
      this.reqReceive,
      this.reqRelationshipSend,
      this.reqRelationshipReceive,
      this.privacy,
      this.votelength,
      this.isVoted,
      this.isSelected});

  UserData.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    school = json['school'];
    gender = json['gender'];
    dob = json['dob'];
    about = json['about'];
    socialMedia = json['social_media'];
    friends = json['friends'] == null ? [] : json['friends'].cast<String>();
    if (json['images'] != null) {
      imagesData = <ImagesData>[];
      json['images'].forEach((v) {
        imagesData!.add(ImagesData.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      videos = <ImagesData>[];
      json['videos'].forEach((v) {
        videos!.add(ImagesData.fromJson(v));
      });
    }
    feedback = json['feedback'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    relationships = json['relationships'] == null
        ? []
        : json['relationships'].cast<String>();
    userProfileImage = json['user_profile_image'];
    reqSend = json['req_send'];
    reqReceive = json['req_receive'];
    reqRelationshipSend = json['req_relationship_send'];
    reqRelationshipReceive = json['req_relationship_receive'];
    privacy = json['privacy'];
    votelength = json['votelength'];
    isVoted = json['isVoted'];
    isSelected = json['isSelected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['school'] = school;
    data['gender'] = gender;
    data['dob'] = dob;
    data['about'] = about;
    data['social_media'] = socialMedia;
    data['friends'] = friends;
    if (imagesData != null) {
      data['images'] = imagesData!.map((v) => v.toJson()).toList();
    }
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['feedback'] = feedback;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['relationships'] = this.relationships;
    data['user_profile_image'] = userProfileImage;
    data['req_send'] = reqSend;
    data['req_receive'] = reqReceive;
    data['req_relationship_send'] = this.reqRelationshipSend;
    data['req_relationship_receive'] = this.reqRelationshipReceive;
    data['privacy'] = this.privacy;
    data['votelength'] = this.votelength;
    data['isVoted'] = this.isVoted;
    data['isSelected'] = this.isSelected ?? false;
    return data;
  }
}
