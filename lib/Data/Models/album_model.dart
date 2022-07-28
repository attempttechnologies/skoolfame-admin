class AlbumResponse {
  int? status;
  String? message;
  List<AlbumData>? albumData;

  AlbumResponse({this.status, this.message, this.albumData});

  AlbumResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      albumData = <AlbumData>[];
      json['data'].forEach((v) {
        albumData!.add(new AlbumData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.albumData != null) {
      data['data'] = this.albumData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlbumData {
  String? sId;
  String? title;
  String? description;
  String? path;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AlbumData(
      {this.sId,
      this.title,
      this.description,
      this.path,
      this.createdAt,
      this.updatedAt,
      this.iV});

  AlbumData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    path = json['path'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['path'] = this.path;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
