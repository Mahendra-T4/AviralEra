class PopularData {
  final String label;
  final String imageUrl;
  final dynamic fees;

  PopularData({required this.label, required this.imageUrl ,required this.fees});
}

List<PopularData> populars = [
  PopularData(
    label: 'Flutter Development',
    imageUrl: 'assets/images/app-covor-image.jpg',
      fees:35000
  ),
  PopularData(
    label: 'React Development',
    imageUrl: 'assets/images/react_covor_image.jpg',
    fees: 40000,  
  ),
  PopularData(
    label: 'Graphic Design',
    imageUrl: 'assets/images/graphic-covor-image.jpg',
    fees: 30000,
  ),
];
