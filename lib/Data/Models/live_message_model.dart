class LiveMessageModel {
  LiveMessageData? liveMessageData;

  LiveMessageModel({this.liveMessageData});

  LiveMessageModel.fromJson(Map<String, dynamic> json) {
    liveMessageData = json['data'] != null
        ? new LiveMessageData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.liveMessageData != null) {
      data['data'] = this.liveMessageData!.toJson();
    }
    return data;
  }
}

class LiveMessageData {
  String? liveUser;
  List<SenderUser>? senderUser;

  LiveMessageData({this.liveUser, this.senderUser});

  LiveMessageData.fromJson(Map<String, dynamic> json) {
    liveUser = json['live_user'];
    if (json['sender_user'] != null) {
      senderUser = <SenderUser>[];
      json['sender_user'].forEach((v) {
        senderUser!.add(new SenderUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['live_user'] = this.liveUser;
    if (this.senderUser != null) {
      data['sender_user'] = this.senderUser!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SenderUser {
  String? sId;
  User? user;
  String? liveStream;
  String? message;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SenderUser(
      {this.sId,
      this.user,
      this.liveStream,
      this.message,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SenderUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    liveStream = json['live_stream'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['live_stream'] = this.liveStream;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class User {
  String? sId;
  String? firstName;
  String? lastName;
  String? userProfileImage;

  User({this.sId, this.firstName, this.lastName, this.userProfileImage});

  User.fromJson(Map<String, dynamic> json) {
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
