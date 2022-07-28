class NotificationModel {
  int? status;
  String? message;
  List<NotificationData>? notificationData;

  NotificationModel({this.status, this.message, this.notificationData});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      notificationData = <NotificationData>[];
      json['data'].forEach((v) {
        notificationData!.add(new NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.notificationData != null) {
      data['data'] = this.notificationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  String? sId;
  String? sendUser;
  String? receiveUser;
  String? notificationText;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NotificationData(
      {this.sId,
      this.sendUser,
      this.receiveUser,
      this.notificationText,
      this.createdAt,
      this.updatedAt,
      this.iV});

  NotificationData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sendUser = json['send_user'];
    receiveUser = json['receive_user'];
    notificationText = json['notification_text'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['send_user'] = this.sendUser;
    data['receive_user'] = this.receiveUser;
    data['notification_text'] = this.notificationText;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
