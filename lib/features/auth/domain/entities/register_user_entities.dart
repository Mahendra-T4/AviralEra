class RegisterEntity {
  final String uFirstName;
  final String uLastName;
  final String uEmail;
  final String uMobile;
  final String? uAlternateNumber;
  final String selectedCourse;
  final String selectedCourseType;
  final String uPassword;
  final String uConfirmPassword;
  final String termsAgree;

  RegisterEntity({
    required this.uFirstName,
    required this.uLastName,
    required this.uEmail,
    required this.uMobile,
    this.uAlternateNumber,
    required this.selectedCourse,
    required this.selectedCourseType,
    required this.uPassword,
    required this.uConfirmPassword,
    required this.termsAgree,
  });

  
}
