import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const CustomHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 30,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
