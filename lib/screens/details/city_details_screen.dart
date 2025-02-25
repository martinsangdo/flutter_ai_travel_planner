import 'package:ai_travel_planner/components/expandable_widget.dart';
import 'package:ai_travel_planner/db/city_model.dart';
import 'package:ai_travel_planner/db/database_helper.dart';
import 'package:ai_travel_planner/functions.dart';
import 'package:ai_travel_planner/screens/orderDetails/components/price_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../constants.dart';
import 'components/tab_items.dart';
import 'components/attraction_info.dart';
import 'package:http/http.dart' as http;

//display results after using AI planner
class CityDetailsScreen extends StatefulWidget {
  Map<dynamic, dynamic> cityInfo = {};

  CityDetailsScreen({super.key, required this.cityInfo});

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
  _fetchRawCityDetails(wonder_trip_id) async {
    String rawTripDetailsUrl = glb_wonder_uri + 'v4/plan/' + wonder_trip_id + '/__data.json';
    final response = await http.Client().post(Uri.parse(rawTripDetailsUrl), 
        headers: COMMON_HEADER);
    if (response.statusCode != 200){
      debugPrint('Cannot get content from cloud');
    } else {
      Map<String, dynamic> objFromCloud = jsonDecode(response.body);
      if (objFromCloud['nodes'] != null){
        //debugPrint(objFromCloud['nodes'][1]['data'].toString());
        Map<String, dynamic> parsedData = await parseRawTripDetails(objFromCloud['nodes'][1]['data']);
        if (parsedData['attractions'] != null || parsedData['hotelList'] != null){
          //we had data of this city, save it details in state
          setState((){
            _cityDetails = parsedData;
            //debugPrint(parsedData.toString());
            if (_cityDetails['budgets'] != null){
              _budgets = _cityDetails['budgets'];
            }
            if (_cityDetails['hotelList'] != null){
              _hotelList = _cityDetails['hotelList'];
            }
            if (_cityDetails['attractions'] != null){
              _attractionList = _cityDetails['attractions'];
            }
            // debugPrint(_attractionList.toString());
            _isLoading = false;
          });
        } else {
          //why no day results? -> create trip & get data so fast
          setState(() {
            _isLoading = false;
          });
        }
      }
      return {'result': 'OK', 'id': objFromCloud['id']};
    }
  }
  //the travel date is expired if it happened before TODAY
  _isExpiredTravelDate(travelDate){
    if (travelDate.isNotEmpty){
      try {
        // 1. Parse the date string:
        DateFormat formatter = DateFormat(APP_DATE_FORMAT);
        DateTime date = formatter.parse(travelDate);
        // 2. Get today's date (at midnight):
        DateTime today = DateTime.now();
        DateTime todayMidnight = DateTime(today.year, today.month, today.day);
        // 3. Compare the dates:
        return date.isBefore(todayMidnight);
      } catch (e) {
        return true; //consider it is expired
      }
    } else {
      return true;  //empty means expired
    }
  }
  //generate new trip id and cache it
  _generateNewTripID() async{
    final headers = {'Content-Type': 'application/json'}; // Important for JSON requests
    //generate with default info
    String todayISO = getCurrentDateInISO8601();
    if (!todayISO.contains("Z")){
      todayISO += "Z";
    }
    final response = await http.Client().post(Uri.parse(glb_wonder_uri + GENERATE_NEW_TRIP_PLANNER), 
        headers: headers, body: jsonEncode({
          "destinationDestinationId": widget.cityInfo['wonder_id'],
          "travelAt": todayISO,
          "days": DEFAULT_DURATION_DAYS,
          "budgetType": 2,  //medium
          "groupType": 1, //solo
          "activityTypes": [
            0, 1, 2, 3, 4, 5, 6, 7 //all activities
          ],
          "isVegan": false,
          "isHalal": false
        }));
    if (response.statusCode != 200){
      return {'result': 'FAILED', 'message': 'Cannot create trip ID'};
    } else {
      Map<String, dynamic> objFromCloud = jsonDecode(response.body);
      if (objFromCloud['id'] != null){
        debugPrint('Generated new trip id: ' + objFromCloud['id']);
        //generated successully
        //cache the date and trip id to db
        City newCityInfo = City.fromMap(widget.cityInfo);
        newCityInfo.travel_date = formatDateForUI(todayISO);
        newCityInfo.wonder_trip_id = objFromCloud['id'];
        DatabaseHelper.instance.updateCitydata(newCityInfo).then((id) async {
          //need to wait some minutes for Wonder gerating new data of trip, otherwise some info is null while getting the details
          // await Future.delayed(const Duration(seconds: 10));  //delay 10 secs
          _fetchRawCityDetails(objFromCloud['id']);
          return {'result': 'OK', 'id': objFromCloud['id']};
        });
      } else {
        //something wrong
        return {'result': 'FAILED', 'message': 'Cannot create trip ID'};
      }
    }
  }
  //
  @override
  void initState() {
    super.initState();
    debugPrint('Receiving from homepage:');
    debugPrint(widget.cityInfo.toString());
    debugPrint('----------------');
    if (widget.cityInfo.isNotEmpty && widget.cityInfo['wonder_trip_id'].isNotEmpty){
      //check cache date to avoid generating so many trip in 1 date
      if (_isExpiredTravelDate(widget.cityInfo['travel_date'])){
        debugPrint('_isExpiredTravelDate: ' + widget.cityInfo['travel_date']);
        _generateNewTripID();
      } else {
        //get data based on old trip (existing wonder trip id)
        debugPrint('old trip id: ' + widget.cityInfo['wonder_trip_id']);
        _fetchRawCityDetails(widget.cityInfo['wonder_trip_id']);
      }
    } else {
      //generate new trip id, make sure we have wonder ID
      _generateNewTripID();
    }
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
                      _cityDetails['locationName']??'Loading data ...',
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
                    /*
                    OutlinedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Save"),
                        ),*/
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
              if (_budgets.isNotEmpty)
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
