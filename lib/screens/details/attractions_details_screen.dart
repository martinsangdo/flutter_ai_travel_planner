import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import 'components/featured_items.dart';
import 'components/tab_items.dart';
import 'components/restaurrant_info.dart';

class CityDetailsScreen extends StatelessWidget {
  const CityDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: defaultPadding / 2),
              RestaurantInfo(),
              SizedBox(height: defaultPadding),
              FeaturedItems(),  //photo list
              // TabItems(),  //including tabs
            ],
          ),
        ),
      ),
    );
  }
}
