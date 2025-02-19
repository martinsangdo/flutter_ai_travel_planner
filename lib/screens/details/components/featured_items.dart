import 'package:ai_travel_planner/screens/details/components/photo_item_card.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'featured_item_card.dart';

//used in City detail screen
class FeaturedItems extends StatelessWidget {
  const FeaturedItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text("Photos",
              style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: defaultPadding / 2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                14, // for demo we use 3
                (index) => Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: PhotoItemCard(
                    image: "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/03/de/5d/c1/ho-chi-minh-square.jpg",
                    press: () {},
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
            ],
          ),
        ),
      ],
    );
  }
}
