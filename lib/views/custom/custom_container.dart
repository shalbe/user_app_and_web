import 'package:flutter/material.dart';
import 'package:zcart_delivery/helper/constants.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  const CustomContainer({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultRadius),
        border: Border.all(
          color: Colors.black12,
          width: 2,
        ),
      ),
      child: child,
    );
  }
}
