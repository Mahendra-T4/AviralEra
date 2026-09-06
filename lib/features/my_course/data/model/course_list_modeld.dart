class CourseListModel {
  int? status;
  String? message;
  List<CourseList>? courseList;

  CourseListModel({this.status, this.message, this.courseList});

  CourseListModel.fromJson(Map<String, dynamic> json) {
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
  String? courseName;
  String? courseKey;

  CourseList({this.courseName, this.courseKey});

  CourseList.fromJson(Map<String, dynamic> json) {
    courseName = json['courseName'];
    courseKey = json['courseKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseName'] = this.courseName;
    data['courseKey'] = this.courseKey;
    return data;
  }
}
