import 'package:ai_travel_planner/components/expandable_widget.dart';
import 'package:ai_travel_planner/functions.dart';
import 'package:ai_travel_planner/screens/orderDetails/components/price_row.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../../constants.dart';
import 'components/tab_items.dart';
import 'components/attraction_info.dart';
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
  Map _budgets = {};
  List _attractionList = [];
  List _hotelList = [];

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
        Map<String, dynamic> parsedData = await parseRawTripDetails(objFromCloud['nodes'][1]['data']);
        if (parsedData['dayResults'] != null){
          //we had data of this city, save it details in state
          setState((){
            _cityDetails = parsedData;
            _budgets = _cityDetails['budgets'];
            _hotelList = _cityDetails['hotelList'];
            _attractionList = _cityDetails['attractions'];
            _isLoading = false;
          });
        }
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
                      ],
                    ),
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
              ),
              const SizedBox(height: defaultPadding),
              //description
              Padding(padding: const EdgeInsets.all(defaultPadding / 2),
                child: Column(children: [
                  Text(
                    _cityDetails['description']??'',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
                ),
              ),
              //history
              Padding(padding: const EdgeInsets.all(defaultPadding / 2),
                child: Column(children: [
                  Text(
                    _cityDetails['history']??'',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
                ),
              ),
              //Budgets
              Padding(
                padding: const EdgeInsets.all(defaultPadding/2),
                child:
                  Text(
                    "Budgets",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
              ),
              const SizedBox(height: defaultPadding / 2),
              for (String budgetKey in _budgets.keys.toList())...[
                ExpandableWidget(
                  initialExpanded: true, // Set to true if you want it expanded initially
                  header: Container(
                    padding: const EdgeInsets.all(defaultPadding / 2),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(155, 194, 222, 162),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          budgetKey.toUpperCase(),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const Icon(Icons.arrow_downward, color: Colors.white), // or use an animated icon
                      ],
                    ),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Column(
                      children: [
                        for (Map budgetInfo in _budgets[budgetKey]) ...[
                          PriceRow(text: budgetInfo['type'], price: budgetInfo['priceUsd']),
                          const SizedBox(height: defaultPadding / 2),
                        ],
                      ]
                    ),
                  ),
                ),
              const SizedBox(height: defaultPadding / 2),
              ],
              //including tabs inside
              TabItems(hotelList: _hotelList, attractions: _attractionList),
            ],
          ),
        ),
      ),
    );
  }
}
