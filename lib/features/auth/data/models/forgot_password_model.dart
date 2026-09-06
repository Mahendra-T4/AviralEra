class ForgotPasswordModel {
  int? status;
  String? message;
  dynamic uOTP;

  ForgotPasswordModel({this.status, this.message, this.uOTP});

  ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    uOTP = json['uOTP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['uOTP'] = this.uOTP;
    return data;
  }
}
