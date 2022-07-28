import 'package:skoolfame/Data/Models/superlative_model.dart';

class NomineesModel {
  int? status;
  String? message;
  SuperlativeData? superlativeData;

  NomineesModel({this.status, this.message, this.superlativeData});

  NomineesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    superlativeData = json['data'] != null
        ? new SuperlativeData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.superlativeData != null) {
      data['data'] = this.superlativeData!.toJson();
    }
    return data;
  }
}
