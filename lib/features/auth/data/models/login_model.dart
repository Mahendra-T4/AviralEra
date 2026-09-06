class LoginModel {
  int? status;
  String? message;
  StudentProfile? studentProfile;

  LoginModel({this.status, this.message, this.studentProfile});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    studentProfile = json['studentProfile'] != null
        ? new StudentProfile.fromJson(json['studentProfile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.studentProfile != null) {
      data['studentProfile'] = this.studentProfile!.toJson();
    }
    return data;
  }
}

class StudentProfile {
  String? uFirstName;
  String? uLastName;
  String? uEmail;
  String? uMobile;
  String? uAlternateNumber;
  String? uImage;
  String? uBio;
  String? userKey;

  StudentProfile({
    this.uFirstName,
    this.uLastName,
    this.uEmail,
    this.uMobile,
    this.uAlternateNumber,
    this.uImage,
    this.uBio,
    this.userKey,
  });

  StudentProfile.fromJson(Map<String, dynamic> json) {
    uFirstName = json['uFirstName'];
    uLastName = json['uLastName'];
    uEmail = json['uEmail'];
    uMobile = json['uMobile'];
    uAlternateNumber = json['uAlternateNumber'];
    uImage = json['uImage'];
    uBio = json['uBio'];
    userKey = json['userKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uFirstName'] = this.uFirstName;
    data['uLastName'] = this.uLastName;
    data['uEmail'] = this.uEmail;
    data['uMobile'] = this.uMobile;
    data['uAlternateNumber'] = this.uAlternateNumber;
    data['uImage'] = this.uImage;
    data['uBio'] = this.uBio;
    data['userKey'] = this.userKey;
    return data;
  }
}
