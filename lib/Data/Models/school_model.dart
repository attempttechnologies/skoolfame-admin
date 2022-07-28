class SchoolModel {
  int? status;
  String? message;
  List<SchoolData>? schoolData;

  SchoolModel({this.status, this.message, this.schoolData});

  SchoolModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      schoolData = <SchoolData>[];
      json['data'].forEach((v) {
        schoolData!.add(new SchoolData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.schoolData != null) {
      data['data'] = this.schoolData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchoolData {
  String? sId;
  String? name;
  bool? isActive;
  String? address;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SchoolData(
      {this.sId,
      this.name,
      this.address,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SchoolData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
