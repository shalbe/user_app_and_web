import 'package:flutter/material.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/views/custom/custom_container.dart';

class InformationCard extends StatelessWidget {
  final String number;
  final String title;
  const InformationCard({
    Key? key,
    required this.number,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            number,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
