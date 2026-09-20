class PolicyModel {
  int? status;
  String? policyHeading;
  String? policyDescription;
  String? message;

  PolicyModel({
    this.status,
    this.policyHeading,
    this.policyDescription,
    this.message,
  });

  PolicyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    policyHeading = json['policyHeading'];
    policyDescription = json['policyDescription'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['policyHeading'] = this.policyHeading;
    data['policyDescription'] = this.policyDescription;
    data['message'] = this.message;
    return data;
  }
}
