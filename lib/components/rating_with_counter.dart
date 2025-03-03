import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class RatingWithCounter extends StatelessWidget {
  const RatingWithCounter({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.attractionCount
  });

  final double rating;
  final String reviewCount;
  final String attractionCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (rating > 0)...[
          Text(
          rating.toString(),
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: titleColor.withOpacity(0.74)),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            "assets/icons/rating.svg",
            height: 20,
            width: 20,
            colorFilter: const ColorFilter.mode(
              primaryColor,
              BlendMode.srcIn,
            ),
          ),
        ],
        if (reviewCount.isNotEmpty)...[
          const SizedBox(width: 8),
          Text("$reviewCount Reviews",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                ,
          ),
        ],
        if (attractionCount.isNotEmpty)...[
          const SizedBox(width: 8),
          Text("$attractionCount+ Attractions",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: titleColor.withOpacity(0.74))),
        ],
      ],
    );
  }
}
