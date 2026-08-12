import 'package:online_course/assets/assets.dart';

class PurchasedCourseModel {
  final String id;
  final String title;
  final String instructor;
  final String imageUrl;
  final double price;
  final double rating;
  final int reviewCount;
  final double progressPercentage;
  final int totalLessons;
  final int completedLessons;
  final String purchaseDate;
  final String category;

  PurchasedCourseModel({
    required this.id,
    required this.title,
    required this.instructor,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.progressPercentage,
    required this.totalLessons,
    required this.completedLessons,
    required this.purchaseDate,
    required this.category,
  });
}

final List<PurchasedCourseModel> purchasedCourses = [
  PurchasedCourseModel(
    id: '1',
    title: 'Flutter App Development',
    instructor: 'John Smith',
    imageUrl: Assets.appDevelopementImage,
    price: 4999,
    rating: 4.8,
    reviewCount: 1250,
    progressPercentage: 75,
    totalLessons: 48,
    completedLessons: 36,
    purchaseDate: '15 Jan 2024',
    category: 'Development',
  ),

  PurchasedCourseModel(
    id: '2',
    title: 'React Native Complete Guide',
    instructor: 'Alex Kumar',
    imageUrl: Assets.reactDevelopmentImage,
    price: 5499,
    rating: 4.5,
    reviewCount: 945,
    progressPercentage: 30,
    totalLessons: 64,
    completedLessons: 19,
    purchaseDate: '08 Apr 2024',
    category: 'Development',
  ),
];
