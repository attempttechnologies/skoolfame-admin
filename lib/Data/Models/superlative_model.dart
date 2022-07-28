import 'package:skoolfame/Data/Models/login_success_respo_model.dart';
import 'package:skoolfame/Data/Models/school_model.dart';

class SuperlativeModel {
  int? status;
  String? message;
  List<SuperlativeData>? superlativeData;

  SuperlativeModel({this.status, this.message, this.superlativeData});

  SuperlativeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      superlativeData = <SuperlativeData>[];
      json['data'].forEach((v) {
        superlativeData!.add(new SuperlativeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.superlativeData != null) {
      data['data'] = this.superlativeData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SuperlativeData {
  String? sId;
  String? categoryName;
  SchoolData? school;
  List<UserData>? users;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SuperlativeData(
      {this.sId,
      this.categoryName,
      this.school,
      this.users,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SuperlativeData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryName = json['category_name'];
    school =
        json['school'] != null ? new SchoolData.fromJson(json['school']) : null;
    if (json['users'] != null) {
      users = <UserData>[];
      json['users'].forEach((v) {
        users!.add(new UserData.fromJson(v));
      });
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['category_name'] = this.categoryName;
    if (this.school != null) {
      data['school'] = this.school!.toJson();
    }
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }

    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
