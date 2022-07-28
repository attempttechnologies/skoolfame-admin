import 'package:skoolfame/Data/Models/login_success_respo_model.dart';

class GetFriendsSuccessModel {
  int? status;
  String? message;
  List<UserData>? data;

  GetFriendsSuccessModel({this.status, this.message, this.data});

  GetFriendsSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
