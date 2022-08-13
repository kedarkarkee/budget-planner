import 'package:flutter/material.dart';

class TabCard extends StatelessWidget {
  const TabCard({
    Key? key,
    required this.isActive,
    required this.title,
    required this.onTap,
    this.subtitle,
  }) : super(key: key);
  final bool isActive;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.secondary : Colors.grey[200],
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : null,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: isActive ? Colors.white : null,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
