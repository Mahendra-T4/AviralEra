class OTPVerifyModel {
  int? status;
  String? message;
  String? userKey;

  OTPVerifyModel({this.status, this.message, this.userKey});

  OTPVerifyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userKey = json['userKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['userKey'] = this.userKey;
    return data;
  }
}