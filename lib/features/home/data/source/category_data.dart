import 'package:online_course/assets/assets.dart';

class CategoryData {
  final String label;
  final String imageUrl;

  CategoryData({required this.label, required this.imageUrl});
}

List<CategoryData> categories = [
  CategoryData(label: 'App Development', imageUrl: Assets.appIcon),
  CategoryData(label: 'Web Development', imageUrl: Assets.webIcon),
  CategoryData(
    label: 'Digital Marketing',
    imageUrl: Assets.digitalMarketingIcon,
  ),
  CategoryData(label: 'Graphics Design', imageUrl: Assets.graphicsIcon),
];
