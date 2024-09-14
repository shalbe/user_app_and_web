import 'package:flutter/material.dart';

class CustomHeadLine extends StatelessWidget {
  final String title;
  const CustomHeadLine({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title.toUpperCase(),
        style: Theme.of(context).textTheme.headline6!.copyWith(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87));
  }
}
