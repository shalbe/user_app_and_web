import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zcart_delivery/helper/constants.dart';
import 'package:zcart_delivery/views/custom/custom_container.dart';

class InformationCardWithIcon extends StatelessWidget {
  final String number;
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;
  const InformationCardWithIcon({
    Key? key,
    required this.number,
    required this.title,
    required this.icon,
    required this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: defaultPadding),
            CircleAvatar(
              radius: defaultPadding * 2,
              backgroundColor: iconColor.withOpacity(0.2),
              child: Icon(
                icon,
                color: iconColor,
                size: defaultPadding * 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCardShimmer extends StatelessWidget {
  const InfoCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(defaultRadius),
          border: Border.all(
            color: Colors.black12,
            width: 2,
          ),
        ),
        child: const SizedBox(
          height: defaultPadding * 6,
          width: double.infinity,
        ),
      ),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
    );
  }
}
