class ContactUSModel {
  int? status;
  String? primaryMobile;
  String? secondaryMobile;
  String? primaryEmail;
  String? secondaryEmail;
  String? headOfficeAddress;
  String? facebookURL;
  String? instagramURL;
  String? youtubeURL;
  String? twitterURL;
  String? linkedinURL;
  String? pinterestURL;
  String? googleMapEmbeddedLink;
  String? message;

  ContactUSModel({
    this.status,
    this.primaryMobile,
    this.secondaryMobile,
    this.primaryEmail,
    this.secondaryEmail,
    this.headOfficeAddress,
    this.facebookURL,
    this.instagramURL,
    this.youtubeURL,
    this.twitterURL,
    this.linkedinURL,
    this.pinterestURL,
    this.googleMapEmbeddedLink,
    this.message,
  });

  ContactUSModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    primaryMobile = json['primaryMobile'];
    secondaryMobile = json['secondaryMobile'];
    primaryEmail = json['primaryEmail'];
    secondaryEmail = json['secondaryEmail'];
    headOfficeAddress = json['headOfficeAddress'];
    facebookURL = json['facebookURL'];
    instagramURL = json['instagramURL'];
    youtubeURL = json['youtubeURL'];
    twitterURL = json['twitterURL'];
    linkedinURL = json['linkedinURL'];
    pinterestURL = json['pinterestURL'];
    googleMapEmbeddedLink = json['googleMapEmbeddedLink'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['primaryMobile'] = this.primaryMobile;
    data['secondaryMobile'] = this.secondaryMobile;
    data['primaryEmail'] = this.primaryEmail;
    data['secondaryEmail'] = this.secondaryEmail;
    data['headOfficeAddress'] = this.headOfficeAddress;
    data['facebookURL'] = this.facebookURL;
    data['instagramURL'] = this.instagramURL;
    data['youtubeURL'] = this.youtubeURL;
    data['twitterURL'] = this.twitterURL;
    data['linkedinURL'] = this.linkedinURL;
    data['pinterestURL'] = this.pinterestURL;
    data['googleMapEmbeddedLink'] = this.googleMapEmbeddedLink;
    data['message'] = this.message;
    return data;
  }
}
