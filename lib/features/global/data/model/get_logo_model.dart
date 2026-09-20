class GetLogoModel {
  int? status;
  String? message;
  String? logo;
  String? favicon;
  String? icon;

  GetLogoModel({this.status, this.message, this.logo, this.favicon, this.icon});

  GetLogoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    logo = json['logo'];
    favicon = json['favicon'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['logo'] = this.logo;
    data['favicon'] = this.favicon;
    data['icon'] = this.icon;
    return data;
  }
}
