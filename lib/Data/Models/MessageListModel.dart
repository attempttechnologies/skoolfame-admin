import 'package:skoolfame/Data/Models/login_success_respo_model.dart';

class MessageList {
  List<MessageListData>? messageListdata;

  MessageList({this.messageListdata});

  MessageList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      messageListdata = <MessageListData>[];
      json['data'].forEach((v) {
        messageListdata!.add(new MessageListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messageListdata != null) {
      data['data'] = this.messageListdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageListData {
  UserData? userData;
  Lastmessage? lastmessage;
  String? sId;
  String? groupName;
  String? groupImage;
  String? groupCreatorUser;
  bool? isGroup;

  MessageListData(
      {this.userData,
      this.lastmessage,
      this.sId,
      this.groupName,
      this.groupImage,
      this.groupCreatorUser,
      this.isGroup});

  MessageListData.fromJson(Map<String, dynamic> json) {
    userData =
        json['user'] != null ? new UserData.fromJson(json['user']) : null;
    lastmessage = json['lastmessage'] != null
        ? new Lastmessage.fromJson(json['lastmessage'])
        : null;
    sId = json['_id'];
    groupName = json['group_name'];
    groupImage = json['group_image'];
    groupCreatorUser = json['group_creator_user'];
    isGroup = json['isGroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['user'] = this.userData!.toJson();
    }
    if (this.lastmessage != null) {
      data['lastmessage'] = this.lastmessage!.toJson();
    }
    data['_id'] = this.sId;
    data['group_name'] = this.groupName;
    data['group_image'] = this.groupImage;
    data['group_creator_user'] = this.groupCreatorUser;
    data['isGroup'] = this.isGroup;
    return data;
  }
}

class Lastmessage {
  String? sId;
  String? senderUser;
  String? message;
  String? createdAt;

  Lastmessage({this.sId, this.senderUser, this.message, this.createdAt});

  Lastmessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderUser = json['sender_user'];
    message = json['message'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sender_user'] = this.senderUser;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
