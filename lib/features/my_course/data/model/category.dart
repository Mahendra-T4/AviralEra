class CategoryModel {
  int? status;
  List<CategoryList>? categoryList;
  String? message;

  CategoryModel({this.status, this.categoryList, this.message});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['categoryList'] != null) {
      categoryList = <CategoryList>[];
      json['categoryList'].forEach((v) {
        categoryList!.add(new CategoryList.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.categoryList != null) {
      data['categoryList'] = this.categoryList!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
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
