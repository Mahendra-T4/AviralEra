import 'package:flutter/material.dart';

class MetorData {
  final String mentorName;
  final IconData imageUrl;

  MetorData({required this.mentorName, required this.imageUrl});
}

List<MetorData> mentors = [
  MetorData(mentorName: 'Bharat Kumar Awtani', imageUrl: Icons.person),
  MetorData(mentorName: 'Mahendra Kuldeep', imageUrl: Icons.person),
];
