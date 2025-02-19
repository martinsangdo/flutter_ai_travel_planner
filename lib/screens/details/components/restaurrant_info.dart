import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../components/sub_list_info_item.dart';
import '../../../components/rating_with_counter.dart';
import '../../../constants.dart';

class RestaurantInfo extends StatelessWidget {
  const RestaurantInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mayfield Bakery & Cafe",
            style: Theme.of(context).textTheme.headlineMedium,
            maxLines: 1,
          ),
          const SizedBox(height: defaultPadding / 2),
          const SubListInfoItem(
            subList: ["Chinese", "American", "Deshi food"],
          ),
          const SizedBox(height: defaultPadding / 2),
          const RatingWithCounter(rating: 4.3, reviewCount: '12,988', attractionCount: '492',),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              const DeliveryInfo(
                iconSrc: "assets/icons/delivery.svg",
                text: "Free",
                subText: "Delivery",
              ),
              const SizedBox(width: defaultPadding),
              const DeliveryInfo(
                iconSrc: "assets/icons/clock.svg",
                text: "25",
                subText: "Minutes",
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeliveryInfo extends StatelessWidget {
  const DeliveryInfo({
    super.key,
    required this.iconSrc,
    required this.text,
    this.subText
  });

  final String iconSrc, text;
  final String? subText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconSrc,
          height: 20,
          width: 20,
          colorFilter: const ColorFilter.mode(
            primaryColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            text: "$text\n",
            style: Theme.of(context).textTheme.labelLarge,
            children: [
              TextSpan(
                text: subText,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ],
    );
  }
}
