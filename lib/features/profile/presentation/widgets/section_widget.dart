import 'package:flutter/material.dart';

Widget buildSection(
  BuildContext context, {
  required String title,
  required String content,
}) {
  final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      const SizedBox(height: 8),
      if (content.isNotEmpty)
        Text(
          content,
          style: TextStyle(fontSize: 14, color: textColor, height: 1.6),
        ),
    ],
  );
}
