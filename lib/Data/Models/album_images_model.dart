class AlbumImagesModel {
  int? status;
  String? message;
  List<ImagesData>? imagesData;

  AlbumImagesModel({this.status, this.message, this.imagesData});

  AlbumImagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      imagesData = <ImagesData>[];
      json['data'].forEach((v) {
        imagesData!.add(new ImagesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = this.message;
    if (this.imagesData != null) {
      data['data'] = this.imagesData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImagesData {
  String? sId;
  String? title;
  String? description;
  String? privacy;
  String? albumId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? path;
  String? thumbnail;

  ImagesData(
      {this.sId,
      this.title,
      this.description,
      this.privacy,
      this.albumId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.path,
      this.thumbnail});

  ImagesData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    privacy = json['privacy'];
    albumId = json['album_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    path = json['path'];
    thumbnail = json['thumb_nail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['privacy'] = this.privacy;
    data['album_id'] = this.albumId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['path'] = this.path;
    data['thumb_nail'] = this.thumbnail;
    return data;
  }
}
