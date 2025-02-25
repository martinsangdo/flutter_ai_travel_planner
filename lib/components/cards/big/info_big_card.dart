import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../sub_list_info_item.dart';
import '../../rating_with_counter.dart';
import 'big_card_image_slide.dart';

class InfoBigCard extends StatelessWidget {
  final List<String> images;
  final String name;
  final double? rating;
  final String? reviewCount, attractionCount;
  final List<String>? subList;
  final VoidCallback press;

  const InfoBigCard({
    super.key,
    required this.name,
    this.rating,
    this.reviewCount,
    this.attractionCount,
    required this.images,
    required this.press,
    this.subList
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // pass list of images here
          BigCardImageSlide(images: images),
          const SizedBox(height: defaultPadding / 2),
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: defaultPadding / 4),
          SubListInfoItem(subList: subList??[]),
          const SizedBox(height: defaultPadding / 4),
          Row(
            children: [
              RatingWithCounter(rating: rating??0, reviewCount: reviewCount??'dd', attractionCount: attractionCount??''),
              const SizedBox(width: defaultPadding / 2),
            ],
          ),
        ],
      ),
    );
  }
}
