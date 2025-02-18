import 'dart:convert';

import 'package:ai_travel_planner/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

import '../../components/dot_indicators.dart';
import 'components/onboard_content.dart';
import 'package:http/http.dart' as http;


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  _testGetCities(cityKeyword) async{
    if (cityKeyword.length < 2){
      return [];
    }
    final response = await http.Client().get(Uri.parse(WONDER_PLAN_URI + SEARCH_LOCATION + cityKeyword));
    if (response.statusCode != 200){
        debugPrint('Cannot get locations from cloud');
        
      } else {
        Map<String, dynamic> objResponse = jsonDecode(response.body);
        //debugPrint(objResponse.toString());
        List<Map<String, dynamic>> locationList = [];

        if (objResponse['destinationMetas'] != null){
          for (Map<String, dynamic> item in objResponse['destinationMetas']){
            locationList.add({
              "id": item['id'],
              "country": item['countryMeta']['name'],
              'city': item['cityMeta']['name']
            });
          }
          debugPrint(locationList.toString());
        }
        return locationList;
      }
  }
  _generateNewTripPlanner(locationId) async{
    final headers = {'Content-Type': 'application/json'}; // Important for JSON requests
    
    final response = await http.Client().post(Uri.parse(WONDER_PLAN_URI + GENERATE_NEW_TRIP_PLANNER), 
        headers: headers, body: jsonEncode({
          "destinationDestinationId": locationId,
          "travelAt": "2025-03-20T00:00:00.000Z",
          "days": 3,
          "budgetType": 2,
          "groupType": 1,
          "activityTypes": [
            1,
            5
          ],
          "isVegan": false,
          "isHalal": false
        }));
    //debugPrint(response.body.toString());
    if (response.statusCode != 200){
      //debugPrint('Cannot get content from cloud');
      return {'result': 'FAILED', 'message': 'Cannot create trip ID'};
    } else {
      Map<String, dynamic> objFromCloud = jsonDecode(response.body);
      //debugPrint(objFromCloud.toString());
      return {'result': 'OK', 'id': objFromCloud['id']};
    }
  }

  _getHotelList(cityKeyword, start_date, end_date) async{
    if (cityKeyword.length < 2){
      return [];
    }
    String url = WONDER_PLAN_URI + GET_HOTEL_LIST + 'city=' + cityKeyword + '&start=' + start_date + '&end=' + end_date;
    debugPrint(url);
    final response = await http.Client().get(Uri.parse(url));
    if (response.statusCode != 200){
        debugPrint('Cannot get data from cloud');
        
      } else {
        Map<String, dynamic> objResponse = jsonDecode(response.body);
        //debugPrint(objResponse['data'].toString());
        List<Map<String, dynamic>> resultList = [];

        if (objResponse['data'] != null){
          for (Map<String, dynamic> item in objResponse['data']){
            resultList.add({
              "name": item['name'],
              "price": item['price'],
              'city': item['location']['city'],
              "ratingScore": item['ratingScore'],
              "stars": item['stars'],
              "images": item['images'][0],
              "url": item['url']  //todo replace our aid
            });
          }
          //debugPrint(resultList.toString());
        }
        return resultList;
      }
  }

  @override
  void initState() {
      super.initState();
      //_testGetCities('lond');
      //_generateNewTripPlanner("GB/ENG/London");
      //_getHotelList('london', '2025-02-20','2025-02-23');
      
  } 

  @override
  void dispose() {
    super.dispose();
  }

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 14,
              child: PageView.builder(
                itemCount: demoData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  illustration: demoData[index]["illustration"],
                  title: demoData[index]["title"],
                  text: demoData[index]["text"],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                demoData.length,
                (index) => DotIndicator(isActive: index == currentPage),
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                child: Text("Test".toUpperCase()),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// Demo data for our Onboarding screen
List<Map<String, dynamic>> demoData = [
  {
    "illustration": "assets/Illustrations/Illustrations_1.svg",
    "title": "...",
    "text":
        "....",
  },
  {
    "illustration": "assets/Illustrations/Illustrations_2.svg",
    "title": "Free delivery offers",
    "text":
        "Free delivery for new customers via Apple Pay\nand others payment methods.",
  },
  {
    "illustration": "assets/Illustrations/Illustrations_3.svg",
    "title": "Choose your food",
    "text":
        "Easily find your type of food craving and\nyou’ll get delivery in wide range.",
  },
];
