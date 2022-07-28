import 'package:skoolfame/Data/Models/login_success_respo_model.dart';

class GetFriendRequestModel {
  int? status;
  String? message;
  FriendRequestData? friendRequestList;

  GetFriendRequestModel({this.status, this.message, this.friendRequestList});

  GetFriendRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    friendRequestList = json['data'] != null
        ? new FriendRequestData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.friendRequestList != null) {
      data['data'] = this.friendRequestList!.toJson();
    }
    return data;
  }
}

class FriendRequestData {
  List<RequestData>? sendList;
  List<RequestData>? requestList;

  FriendRequestData({this.sendList, this.requestList});

  FriendRequestData.fromJson(Map<String, dynamic> json) {
    if (json['sendList'] != null) {
      sendList = <RequestData>[];
      json['sendList'].forEach((v) {
        sendList!.add(new RequestData.fromJson(v));
      });
    }
    if (json['requestList'] != null) {
      requestList = <RequestData>[];
      json['requestList'].forEach((v) {
        requestList!.add(new RequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sendList != null) {
      data['sendList'] = this.sendList!.map((v) => v.toJson()).toList();
    }
    if (this.requestList != null) {
      data['requestList'] = this.requestList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequestData {
  String? sId;
  UserData? sender;
  UserData? receiver;
  String? friendRequest;
  String? relationshipRequest;
  bool? isDelete;
  String? createdAt;
  String? updatedAt;
  int? iV;

  RequestData(
      {this.sId,
      this.sender,
      this.receiver,
      this.friendRequest,
      this.relationshipRequest,
      this.isDelete,
      this.createdAt,
      this.updatedAt,
      this.iV});

  RequestData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sender = json['sender'] != null ? UserData.fromJson(json['sender']) : null;
    receiver =
        json['receiver'] != null ? UserData.fromJson(json['receiver']) : null;
    friendRequest = json['friend_request'];
    relationshipRequest = json['relationship_request'];
    isDelete = json['isDelete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.sender != null) {
      data['sender'] = this.sender;
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver!.toJson();
    }
    data['friend_request'] = this.friendRequest;
    data['relationship_request'] = this.relationshipRequest;
    data['isDelete'] = this.isDelete;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
