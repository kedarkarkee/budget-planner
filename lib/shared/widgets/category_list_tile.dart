import 'package:flutter/material.dart';

import '../../models/category.dart';

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({
    super.key,
    required this.category,
    this.subtitle,
    required this.trailing,
    this.isThreeLine = false,
    this.onLongPress,
    this.title,
  });
  final Category category;
  final String? title;
  final Widget? subtitle;
  final Widget trailing;
  final bool isThreeLine;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: onLongPress,
      leading: Center(
        widthFactor: 1,
        child: Container(
          decoration: BoxDecoration(
            color: category.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              category.icon,
              color: category.color,
            ),
          ),
        ),
      ),
      title: Text(title ?? category.title),
      subtitle: subtitle,
      trailing: trailing,
      isThreeLine: isThreeLine,
    );
  }
}
