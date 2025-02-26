import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../rating.dart';
//item in homepage list
class InfoMediumCard extends StatelessWidget {
  const InfoMediumCard({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    this.rating,
    required this.reviewCount,
    required this.press,
  });

  final String image, name, location;
  final double? rating;
  final String reviewCount;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.25,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.network(image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: defaultPadding / 4),
            Text(
              location,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: defaultPadding / 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (rating != null)
                  Rating(rating: rating!),
                Text(
                  "$reviewCount reviews",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: titleColor.withOpacity(0.74)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
