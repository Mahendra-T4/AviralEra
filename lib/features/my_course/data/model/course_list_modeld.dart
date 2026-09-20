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
  String? courseCode;
  String? courseIcon;
  String? courseColorCode;
  CategoryList? categoryList;
  String? courseKey;

  CourseList({
    this.courseName,
    this.courseCode,
    this.courseIcon,
    this.courseColorCode,
    this.categoryList,
    this.courseKey,
  });

  CourseList.fromJson(Map<String, dynamic> json) {
    courseName = json['courseName'];
    courseCode = json['courseCode'];
    courseIcon = json['courseIcon'];
    courseColorCode = json['courseColorCode'];
    categoryList = json['categoryList'] != null
        ? new CategoryList.fromJson(json['categoryList'])
        : null;
    courseKey = json['courseKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseName'] = this.courseName;
    data['courseCode'] = this.courseCode;
    data['courseIcon'] = this.courseIcon;
    data['courseColorCode'] = this.courseColorCode;
    if (this.categoryList != null) {
      data['categoryList'] = this.categoryList!.toJson();
    }
    data['courseKey'] = this.courseKey;
    return data;
  }
}

class CategoryList {
  String? categoryName;
  String? categorySlug;
  String? categoryKey;

  CategoryList({this.categoryName, this.categorySlug, this.categoryKey});

  CategoryList.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    categorySlug = json['categorySlug'];
    categoryKey = json['categoryKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    data['categorySlug'] = this.categorySlug;
    data['categoryKey'] = this.categoryKey;
    return data;
  }
}
