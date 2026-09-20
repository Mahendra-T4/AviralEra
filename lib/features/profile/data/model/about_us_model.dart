class AboutUSModel {
  int? status;
  String? message;
  String? aboutHeading;
  String? aboutDescription;
  String? whyChooseUsTitle;
  String? whyHeadingOne;
  String? whyTaglineOne;
  String? whyIconOne;
  String? whyHeadingTwo;
  String? whyTaglineTwo;
  String? whyIconTwo;
  String? whyHeadingThree;
  String? whyTaglineThree;
  String? whyIconThree;
  String? whyHeadingFour;
  String? whyTaglineFour;
  String? whyIconFour;
  String? byTheNumberHeading;
  String? byValueOne;
  String? byLabelOne;
  String? byValueTwo;
  String? byLabelTwo;
  String? byValueThree;
  String? byLabelThree;
  String? haveQuestionTitle;
  String? haveQuestionTagline;

  AboutUSModel({
    this.status,
    this.message,
    this.aboutHeading,
    this.aboutDescription,
    this.whyChooseUsTitle,
    this.whyHeadingOne,
    this.whyTaglineOne,
    this.whyIconOne,
    this.whyHeadingTwo,
    this.whyTaglineTwo,
    this.whyIconTwo,
    this.whyHeadingThree,
    this.whyTaglineThree,
    this.whyIconThree,
    this.whyHeadingFour,
    this.whyTaglineFour,
    this.whyIconFour,
    this.byTheNumberHeading,
    this.byValueOne,
    this.byLabelOne,
    this.byValueTwo,
    this.byLabelTwo,
    this.byValueThree,
    this.byLabelThree,
    this.haveQuestionTitle,
    this.haveQuestionTagline,
  });

  AboutUSModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    aboutHeading = json['aboutHeading'];
    aboutDescription = json['aboutDescription'];
    whyChooseUsTitle = json['whyChooseUsTitle'];
    whyHeadingOne = json['whyHeadingOne'];
    whyTaglineOne = json['whyTaglineOne'];
    whyIconOne = json['whyIconOne'];
    whyHeadingTwo = json['whyHeadingTwo'];
    whyTaglineTwo = json['whyTaglineTwo'];
    whyIconTwo = json['whyIconTwo'];
    whyHeadingThree = json['whyHeadingThree'];
    whyTaglineThree = json['whyTaglineThree'];
    whyIconThree = json['whyIconThree'];
    whyHeadingFour = json['whyHeadingFour'];
    whyTaglineFour = json['whyTaglineFour'];
    whyIconFour = json['whyIconFour'];
    byTheNumberHeading = json['byTheNumberHeading'];
    byValueOne = json['byValueOne'];
    byLabelOne = json['byLabelOne'];
    byValueTwo = json['byValueTwo'];
    byLabelTwo = json['byLabelTwo'];
    byValueThree = json['byValueThree'];
    byLabelThree = json['byLabelThree'];
    haveQuestionTitle = json['haveQuestionTitle'];
    haveQuestionTagline = json['haveQuestionTagline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['aboutHeading'] = this.aboutHeading;
    data['aboutDescription'] = this.aboutDescription;
    data['whyChooseUsTitle'] = this.whyChooseUsTitle;
    data['whyHeadingOne'] = this.whyHeadingOne;
    data['whyTaglineOne'] = this.whyTaglineOne;
    data['whyIconOne'] = this.whyIconOne;
    data['whyHeadingTwo'] = this.whyHeadingTwo;
    data['whyTaglineTwo'] = this.whyTaglineTwo;
    data['whyIconTwo'] = this.whyIconTwo;
    data['whyHeadingThree'] = this.whyHeadingThree;
    data['whyTaglineThree'] = this.whyTaglineThree;
    data['whyIconThree'] = this.whyIconThree;
    data['whyHeadingFour'] = this.whyHeadingFour;
    data['whyTaglineFour'] = this.whyTaglineFour;
    data['whyIconFour'] = this.whyIconFour;
    data['byTheNumberHeading'] = this.byTheNumberHeading;
    data['byValueOne'] = this.byValueOne;
    data['byLabelOne'] = this.byLabelOne;
    data['byValueTwo'] = this.byValueTwo;
    data['byLabelTwo'] = this.byLabelTwo;
    data['byValueThree'] = this.byValueThree;
    data['byLabelThree'] = this.byLabelThree;
    data['haveQuestionTitle'] = this.haveQuestionTitle;
    data['haveQuestionTagline'] = this.haveQuestionTagline;
    return data;
  }
}
