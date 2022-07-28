import 'package:skoolfame/Data/Models/login_success_respo_model.dart';

class GetMyRelationshipModel {
  int? status;
  String? message;
  List<RelationshipData>? relationshipData;

  GetMyRelationshipModel({this.status, this.message, this.relationshipData});

  GetMyRelationshipModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      relationshipData = <RelationshipData>[];
      json['data'].forEach((v) {
        relationshipData!.add(new RelationshipData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.relationshipData != null) {
      data['data'] = this.relationshipData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RelationshipData {
  String? sId;
  UserData? sender;
  UserData? receiver;
  String? relationshipRequest;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isActive;
  String? startDate;
  String? endDate;
  String? endReason;
  int? rate;

  RelationshipData(
      {this.sId,
      this.sender,
      this.receiver,
      this.relationshipRequest,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.isActive,
      this.startDate,
      this.endDate,
      this.endReason,
      this.rate});

  RelationshipData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sender = json['sender'] != null ? UserData.fromJson(json['sender']) : null;
    receiver =
        json['receiver'] != null ? UserData.fromJson(json['receiver']) : null;
    relationshipRequest = json['relationship_request'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isActive = json['isActive'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    endReason = json['end_reason'];
    rate = json['rate'];
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
    data['relationship_request'] = this.relationshipRequest;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['isActive'] = this.isActive;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['end_reason'] = this.endReason;
    data['rate'] = this.rate;
    return data;
  }
}
