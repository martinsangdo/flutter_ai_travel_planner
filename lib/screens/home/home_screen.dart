import 'package:flutter/material.dart';

import '../../components/cards/big/big_card_image_slide.dart';
import '../../components/cards/big/info_big_card.dart';
import '../../components/section_title.dart';
import '../../constants.dart';
import '../../demo_data.dart';
import '../details/city_details_screen.dart';
import '../featured/featurred_screen.dart';
import 'components/medium_card_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Column(
          children: [
            Text(
              "Explore".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: primaryColor),
            ),
            const Text(
              "Top destinations",
              style: TextStyle(color: Colors.black),
            )
          ],
        )
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              //part 1
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: BigCardImageSlide(images: homeSliderImages),  //main slider
              ),
              const SizedBox(height: defaultPadding * 2),
              //part 2
              SectionTitle(
                title: "Europe",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const MediumCardList(), //list
              const SizedBox(height: defaultPadding),
              //part 3
              SectionTitle(
                title: "America",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const MediumCardList(),
              const SizedBox(height: defaultPadding),
              //part 4
              SectionTitle(title: "Random pick", press: () {}),
              const SizedBox(height: defaultPadding),
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      defaultPadding, 0, defaultPadding, defaultPadding),
                  child: InfoBigCard(
                    images: homeSliderImages..shuffle(),
                    name: "Paris",
                    rating: 4.3,
                    reviewCount: '99,999',
                    attractionCount: '345',
                    subList: const ["London Eye", "Tower Bridge", "River Thames"],
                    press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CityDetailsScreen(),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: defaultPadding),
              //part 5
              SectionTitle(
                title: "Australia",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const MediumCardList(),
              const SizedBox(height: defaultPadding),
              //part 6
              SectionTitle(
                title: "Africa",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              const MediumCardList(),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
