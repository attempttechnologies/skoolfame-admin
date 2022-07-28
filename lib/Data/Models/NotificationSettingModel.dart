class NotificationSettingModel {
  int? status;
  String? message;
  SettingData? settingData;

  NotificationSettingModel({this.status, this.message, this.settingData});

  NotificationSettingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    settingData =
        json['data'] != null ? new SettingData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.settingData != null) {
      data['data'] = this.settingData!.toJson();
    }
    return data;
  }
}

class SettingData {
  String? sId;
  String? user;
  String? comment;
  String? friendRequest;
  String? relationshipRequest;
  String? message;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SettingData(
      {this.sId,
      this.user,
      this.comment,
      this.friendRequest,
      this.relationshipRequest,
      this.message,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SettingData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    comment = json['comment'];
    friendRequest = json['friend_request'];
    relationshipRequest = json['relationship_request'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['comment'] = this.comment;
    data['friend_request'] = this.friendRequest;
    data['relationship_request'] = this.relationshipRequest;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
