class CourseTypeModel {
  int? status;
  String? message;
  List<CourseList>? courseList;

  CourseTypeModel({this.status, this.message, this.courseList});

  CourseTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['courseList'] != null) {
      courseList = <CourseList>[];
      json['courseList'].forEach((v) {
        courseList!.add(new CourseList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.courseList != null) {
      data['courseList'] = this.courseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CourseList {
  String? courseType;
  String? courseKey;

  CourseList({this.courseType, this.courseKey});

  CourseList.fromJson(Map<String, dynamic> json) {
    courseType = json['courseType'];
    courseKey = json['courseKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseType'] = this.courseType;
    data['courseKey'] = this.courseKey;
    return data;
  }
}