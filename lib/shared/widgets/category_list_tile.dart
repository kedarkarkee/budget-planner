import 'package:flutter/material.dart';

import '../../models/category.dart';

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({
    Key? key,
    required this.category,
    this.subtitle,
    required this.trailing,
    this.isThreeLine = false,
  }) : super(key: key);
  final Category category;
  final Widget? subtitle;
  final Widget trailing;
  final bool isThreeLine;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      title: Text(category.title),
      subtitle: subtitle,
      trailing: trailing,
      isThreeLine: isThreeLine,
    );
  }
}
