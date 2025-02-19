import 'package:ai_travel_planner/components/expandable_widget.dart';
import 'package:ai_travel_planner/screens/orderDetails/components/price_row.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/tab_items.dart';
import 'components/restaurrant_info.dart';
//display results after using AI planner
class CityDetailsScreen extends StatelessWidget {
  const CityDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding / 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "London, United Kingdom",
                      style: Theme.of(context).textTheme.headlineMedium,
                      maxLines: 1,
                    ),
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
                          iconSrc: "assets/icons/date.svg",
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
              ),
              const SizedBox(height: defaultPadding),
              //Accommodation
              ExpandableWidget(
                initialExpanded: true, // Set to true if you want it expanded initially
                header: Container(
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(155, 194, 222, 162),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Accommodation',
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(Icons.arrow_downward, color: Colors.white), // or use an animated icon
                    ],
                  ),
                ),
                content: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    children: [
                      PriceRow(text: "Hostel", price: 30),
                      SizedBox(height: defaultPadding / 2),
                      PriceRow(text: "Budget Hotel", price: 80),
                      SizedBox(height: defaultPadding / 2),
                      PriceRow(text: "Mid-range Hotel", price: 150),
                      SizedBox(height: defaultPadding / 2),
                      PriceRow(text: "Boutique Hotel", price: 250),
                      SizedBox(height: defaultPadding / 2),
                      PriceRow(text: "Airbnb (private room)", price: 70),
                      SizedBox(height: defaultPadding / 2),
                    ]
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding / 2),
              //Transportation
              ExpandableWidget(
                initialExpanded: true, // Set to true if you want it expanded initially
                header: Container(
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(155, 194, 222, 162),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transportation',
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(Icons.arrow_downward, color: Colors.white), // or use an animated icon
                    ],
                  ),
                ),
                content: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    children: [
                      PriceRow(text: "Hostel", price: 30),
                      SizedBox(height: defaultPadding / 2),
                      PriceRow(text: "Budget Hotel", price: 80),
                      SizedBox(height: defaultPadding / 2),
                      PriceRow(text: "Mid-range Hotel", price: 150),
                      SizedBox(height: defaultPadding / 2),
                      PriceRow(text: "Boutique Hotel", price: 250),
                      SizedBox(height: defaultPadding / 2),
                      PriceRow(text: "Airbnb (private room)", price: 70),
                      SizedBox(height: defaultPadding / 2),
                    ]
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              //including tabs inside
              const TabItems(),
            ],
          ),
        ),
      ),
    );
  }
}
