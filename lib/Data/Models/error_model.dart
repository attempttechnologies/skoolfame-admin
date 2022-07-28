class ErrorModel {
  int? result;
  String? message;

  ErrorModel({this.message, this.result});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    result = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = result;
    return data;
  }
}
