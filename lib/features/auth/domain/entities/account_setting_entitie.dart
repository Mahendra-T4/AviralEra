import 'dart:io';

class AccountEntity {
  String uFirstName;
  String uLastName;
  String uEmail;
  String uMobile;
  String uAlternateNumber;
  String uBio;
  File? image;

  AccountEntity({
    required this.uFirstName,
    required this.uLastName,
    required this.uEmail,
    required this.uMobile,
    required this.uAlternateNumber,
    required this.uBio,
    required this.image,
  });
}
