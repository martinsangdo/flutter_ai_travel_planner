import 'package:ai_travel_planner/components/expandable_widget.dart';
import 'package:ai_travel_planner/functions.dart';
import 'package:ai_travel_planner/screens/orderDetails/components/price_row.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../../constants.dart';
import 'components/tab_items.dart';
import 'components/restaurrant_info.dart';
import 'package:http/http.dart' as http;

//display results after using AI planner
class CityDetailsScreen extends StatefulWidget {
  const CityDetailsScreen({super.key});

  @override
  State<CityDetailsScreen> createState() =>
      _State();
}

class _State extends State<CityDetailsScreen> {
  List<Map<String, dynamic>> _rawCityDetails = [];  //will fetch data into this later
  //call to get details of city
  _fetchRawCityDetails() async {
    String rawTripDetailsUrl = glb_wonder_uri + 'v4/plan/' + test_trip_id + '/__data.json';
    final headers = {'Content-Type': 'application/json'}; // Important for JSON requests
    final response = await http.Client().post(Uri.parse(rawTripDetailsUrl), 
        headers: headers, body: jsonEncode({
          "org_url": rawTripDetailsUrl
        }));
    if (response.statusCode != 200){
      debugPrint('Cannot get content from cloud');
    } else {
      Map<String, dynamic> objFromCloud = jsonDecode(response.body);
      if (objFromCloud['nodes'] != null){
        Map<String, dynamic> parsedData = parseRawTripDetails(objFromCloud['nodes'][1]['data']);
        debugPrint(parsedData.toString());
      }
      return {'result': 'OK', 'id': objFromCloud['id']};
    }
  }
  //
  @override
  void initState() {
    super.initState();
    _fetchRawCityDetails();
  }
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
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 1,
                    ),
                    const SizedBox(height: defaultPadding),
                    Row(
                      children: [
                        const DeliveryInfo(
                          iconSrc: "assets/icons/delivery.svg",
                          text: "USD"
                        ),
                        const SizedBox(width: defaultPadding),
                        const DeliveryInfo(
                          iconSrc: "assets/icons/fast-delivery.svg",
                          text: "19/2/2025 - 23/4/2025",
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
              //description
              const Padding(padding: const EdgeInsets.all(defaultPadding / 2),
                child: Column(children: [
                  Text(
                    "London, the vibrant capital of England and the United Kingdom, is a global city renowned for its rich history, iconic landmarks, diverse culture, and modern advancements.",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
                ),
              ),
              //history
              const Padding(padding: const EdgeInsets.all(defaultPadding / 2),
                child: Column(children: [
                  Text(
                    "London's history stretches back over two millennia, from its Roman origins to its role as a pivotal center of the British Empire. Its landmarks, including the Tower of London and Buckingham Palace, bear witness to its long and fascinating past.",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
                ),
              ),
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
