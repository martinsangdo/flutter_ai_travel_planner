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
  Map<String, dynamic> _cityDetails = {};  //will fetch data into this later
  bool _isLoading = true;

  //call to get details of city
  _fetchRawCityDetails() async {
    String rawTripDetailsUrl = glb_wonder_uri + 'v4/plan/' + test_trip_id + '/__data.json';
    final response = await http.Client().post(Uri.parse(rawTripDetailsUrl), 
        headers: COMMON_HEADER);
    if (response.statusCode != 200){
      debugPrint('Cannot get content from cloud');
    } else {
      Map<String, dynamic> objFromCloud = jsonDecode(response.body);
      if (objFromCloud['nodes'] != null){
        Map<String, dynamic> parsedData = parseRawTripDetails(objFromCloud['nodes'][1]['data']);
        if (parsedData['dayResults'] != null){
          //we had data of this city, save it details in state
          setState((){
            _cityDetails = parsedData;
            //debugPrint(_cityDetails.toString());
            _isLoading = false;
          });
          //
        }
        
        String country = parsedData['country'];
        for (List<Map> oneDayActivities in parsedData['dayResults']){
          for (Map activity in oneDayActivities){
            Map searchResult = await _searchLocations(activity['name'], country);
            if (searchResult['result'] == 'FAILED'){
              //debugPrint('Cannot find this place: ' + activity['name']);
            } else {
              //debugPrint(searchResult.toString());
            }
          }
        }
      }
      return {'result': 'OK', 'id': objFromCloud['id']};
    }
  }
  //search city id in trip (which could be same country)
  _searchLocations(orgPlaceName, country) async{
    String placeName = orgPlaceName.toLowerCase().replaceAll("'", '').replaceAll(".", '');
    country = country.toLowerCase();
    final response = await http.Client().post(Uri.parse(glb_trip_uri + SEARCH_LOCATIONS), 
        headers: COMMON_HEADER, body: jsonEncode({
            "keyword": placeName,
            "lang": "en",
            "head": {
                "locale": "en-US",
                "extension": [
                    {
                        "name": "locale",
                        "value": "en-US"
                    },
                    {
                        "name": "platform",
                        "value": "Online"
                    },
                    {
                        "name": "currency",
                        "value": "USD"
                    },
                    {
                        "name": "user-agent",
                        "value": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36"
                    }
                ]
            }
        }));
    if (response.statusCode != 200){
      return {'result': 'FAILED', 'message': 'Cannot get content from cloud'};
    } else {
      Map objFromCloud = jsonDecode(response.body);
      // debugPrint(objFromCloud.toString());
      if (objFromCloud['data'] != null){
        List data = objFromCloud['data'];
        for (Map item in data){
          if (item['type'] == 'sight' && item['word'] != null){
            String word = item['word'].replaceAll('<em>', '').replaceAll('</em>', '').toLowerCase().replaceAll("'", '').replaceAll(".", '');
            //debugPrint(word.toString());
            if (word == placeName && item['districtName'] != null && 
                item['districtName'].toLowerCase().contains(country)){
              //this location matched
              return {'result': 'OK', 'id': item['id'], 'name': orgPlaceName};
            }
          }
        }
      }

      return {'result': 'FAILED', 'message': 'Not found'};
    }
  }
  //
  @override
  void initState() {
    super.initState();
    _fetchRawCityDetails();
    findAttractionDetails(78699); //buckingham palace
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
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _cityDetails['locationName']??'...',
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 1,
                    ),
                    const SizedBox(height: defaultPadding),
                    Row(
                      children: [
                        DeliveryInfo(
                          iconSrc: "assets/icons/delivery.svg",
                          text: _cityDetails['currency_detail']??'...'
                        ),
                        const SizedBox(width: defaultPadding),
                        DeliveryInfo(
                          iconSrc: "assets/icons/fast-delivery.svg",
                          text: _cityDetails['travelDate']??'...',
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
