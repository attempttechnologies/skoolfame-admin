class GetMessageModel {
  List<MessageData>? messageData;

  GetMessageModel({this.messageData});

  GetMessageModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      messageData = <MessageData>[];
      json['data'].forEach((v) {
        messageData!.add(new MessageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messageData != null) {
      data['data'] = this.messageData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageData {
  String? sId;
  String? senderId;
  SenderUser? senderUser;
  SenderUser? receiverUser;
  String? messageType;
  String? message;
  int? totalLike;
  int? totalCount;
  bool? isLike;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MessageData(
      {this.sId,
      this.senderUser,
      this.receiverUser,
      this.messageType,
      this.message,
      this.totalLike,
      this.totalCount,
      this.isLike,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.senderId});

  MessageData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderUser = json['sender_user'] != null
        ? new SenderUser.fromJson(json['sender_user'])
        : null;
    receiverUser = json['receiver_user'] != null
        ? new SenderUser.fromJson(json['receiver_user'])
        : null;
    messageType = json['message_type'];
    message = json['message'];
    totalLike = json['total_like'];
    totalCount = json['total_count'];
    isLike = json['isLike'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    senderId = json['sender_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.senderUser != null) {
      data['sender_user'] = this.senderUser!.toJson();
    }
    if (this.receiverUser != null) {
      data['receiver_user'] = this.receiverUser!.toJson();
    }
    data['message_type'] = this.messageType;
    data['message'] = this.message;
    data['total_like'] = this.totalLike;
    data['total_count'] = this.totalCount;
    data['isLike'] = this.isLike;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['sender_id'] = this.senderId;
    return data;
  }
}

class SenderUser {
  String? sId;
  String? firstName;
  String? lastName;
  String? userProfileImage;

  SenderUser({this.sId, this.firstName, this.lastName, this.userProfileImage});

  SenderUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userProfileImage = json['user_profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['user_profile_image'] = this.userProfileImage;
    return data;
  }
}
