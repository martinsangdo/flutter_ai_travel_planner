//author: Martin SangDo
//common functions
//parse to get useful info
import 'dart:convert';

import 'package:ai_travel_planner/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

//  Gets the current date in UTC and formats it as "YYYY-MM-DDTHH:MM:SS.000Z" -> used to generate the trip
String getCurrentDateInISO8601() {
  DateTime nowUtc = DateTime.now().toUtc(); // Get current time and convert to UTC
  String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.000Z').format(nowUtc);
  return formattedDate;
}
//add X days to the org date
String addDaysToDate(String dateString, int daysToAdd) {
  try {
    // 1. Parse the input date string (ISO 8601 format).
    DateTime dateTime = DateTime.parse(dateString);

    // 2. Add the specified number of days.
    DateTime newDateTime = dateTime.add(Duration(days: daysToAdd));

    // 3. Format the new date to "yyyy-MM-dd".
    String formattedDate = DateFormat('yyyy-MM-dd').format(newDateTime);

    return formattedDate;
  } catch (e) {
    // Handle parsing errors (e.g., invalid date format).
    return 'Invalid date format'; // Or throw an exception if you prefer.
  }
}
//convert from "2025-02-27T00:00:00Z" to 'dd-MM-yyyy'
String formatDateForUI(String inputDate) {
  // Parse the input date string, handling the 'Z' for UTC
  DateTime dateTime = DateTime.parse(inputDate).toLocal(); // Convert to local time

  // Format the date as 'dd-MM-yyyy'
  DateFormat formatter = DateFormat(APP_DATE_FORMAT);
  return formatter.format(dateTime);
}

String getTomorrowDateFormatted() {
  DateTime now = DateTime.now();
  DateTime tomorrow = now.add(const Duration(days: 1)); // Add one day

  var formatter = DateFormat('yyyy-MM-ddTHH:mm:ssZ'); // ISO 8601 format with Z for UTC
  return formatter.format(tomorrow);
}

/*
return:
- city
- country
- start date
- currency
- 
*/
Future<Map<String, dynamic>> parseRawTripDetails(rawData) async {
  //debugPrint(rawData.toString());
  Map<String, dynamic> results = {};
  int index = 0;
  for (dynamic item in rawData){
    if (item == ''){
      index++;
      continue;
    }
    //debugPrint('Index ======= ' + index.toString());
    if (!isPrimitive(item)){
      //this is object
      if (item is List){
        //this is an array or object
        //debugPrint(item.length.toString());
      } else if (item is Map){
        if (item['cityMeta'] != null){
          results['city'] = rawData[rawData[item['cityMeta']]['name']];
        }
        if (item['countryMeta'] != null){
          results['country'] = rawData[rawData[item['countryMeta']]['name']];
        }
        results['locationName'] = (results['city']!=null) ? results['city'] + ', ' + results['country'] : '';
        //begin date
        if (item['travelAt'] != null){
          results['travelAt'] = rawData[item['travelAt']];
          if (results['travelAt'] == null){
            results['travelAt'] = getTomorrowDateFormatted();
          }
          results['travelDate'] = formatDateForUI(results['travelAt']);
        }
        //currency
        if (item['currency'] != null){
          results['currency_name'] = rawData[rawData[item['currency']]['name']];
          results['currency_code'] = rawData[rawData[item['currency']]['code']];
          results['currency_detail'] = results['currency_name']!=null? results['currency_name'] + ' (' +results['currency_code'] +')' : '';
        }
        //
        if (item['description'] != null){
          results['description'] = rawData[item['description']];
        }
        if (item['history'] != null){
          results['history'] = rawData[item['history']];
        }
        // budgets
        if (item['budget'] != null){
          results['budgets'] = {};  //all budget info
          int budgetMetaIndex = item['budget']; //331
          Map<String, dynamic> budgetMeta = rawData[budgetMetaIndex]; //{accommodations, transportations, ...}
          for (String key in budgetMeta.keys){
            if (key == 'summary' || key == ''){
              continue;
            }
            results['budgets'][key] = [];
            //get list of budget types
            for (int keyIndex in rawData[budgetMeta[key]]){
              results['budgets'][key].add({
                'type': rawData[rawData[keyIndex]['type']],
                'priceUsd': double.parse(rawData[rawData[keyIndex]['priceUsd']])
              });
            }
          }
        }
        /*
        {days 80} -> 
        list of days [81, 160, 254] -> 
        {days: 8 -> day index, activities: 82 -> [83, 100, ] -> 
        {'location': 84 -> location name, 'durationMin': 105 -> mins, 'description': 91}}
        */
        //get list of activities in each day
        if (item['tripResult'] != null){
          List<dynamic> daysMetaIndexes = rawData[rawData[item['tripResult']]['days']]; //[84, 195, 278, 340, 397]
          if (daysMetaIndexes != null){
            List dayResults = [];
            for (int dayMetaIndex in daysMetaIndexes){  //dayMetaIndex: day 1, 2, ...
              List<dynamic> activityMetaIndexes = rawData[rawData[dayMetaIndex]['activities']];
              for (int activityMetaIndex in activityMetaIndexes){
                //add all, no follow by each day
                if (rawData[activityMetaIndex]['imageUrl'] != null){
                  dayResults.add({
                    'name': rawData[rawData[activityMetaIndex]['location']], //activity name
                    'description': rawData[rawData[activityMetaIndex]['description']],  //activity description
                    'duration': rawData[rawData[activityMetaIndex]['durationMin']],  //activity duration, in minutes
                    'image': rawData[rawData[activityMetaIndex]['imageUrl']]
                  });
                }
              }
            }
            results['dayResults'] = dayResults;
          }
        }
      }
    } else if (item is String){
      //this can be key or value
      
    }
    index++;
  }
  //get hotel list
  results['hotelList'] = await _getHotelList(results['city'], results['travelAt'], results['currency_code']);
  //get attraction list
  if (results['dayResults'] != null){
    results['attractions'] = await _findMatchedAttractions(results['country'], results['dayResults']);
  }
  //
  return results;
}
//query hotel list in city
Future<List> _getHotelList(city, travelDate, currency) async {
  String endDate = addDaysToDate(travelDate, DEFAULT_DURATION_DAYS);  //add 5 days as default
  travelDate = travelDate.replaceAll('T00:00:00Z', '');
  String hotelListUrl = glb_wonder_uri + 'api/v4/trips/accommondation?city='+city+'&start='+
        travelDate+'&end='+endDate;
  //debugPrint(hotelListUrl);
  final response = await http.Client().get(Uri.parse(hotelListUrl), 
        headers: COMMON_HEADER);
  if (response.statusCode != 200){
    debugPrint('Cannot get content from cloud');
    return [];
  } else {
    Map<String, dynamic> objFromCloud = jsonDecode(response.body);
    //debugPrint(objFromCloud.toString());
    List rawData = objFromCloud['data'];
    List transformedList = [];  
    for (Map item in rawData){
      transformedList.add({
        'name': item["name"],
        'description': item['location']['address'],
        'image': item["images"][0],
        'price': item["price"].isNotEmpty?item["price"]+' ' + currency + '/night': '',
        'rating': item['ratingScore'],
        'url': item["url"]
      });
    }
    return transformedList;
  }
}
//query another service to find attraction detail (optionsl)
_findMatchedAttractions(String country, List orgAttractions) async{
  List attractions = [];  //init it empty
  if (orgAttractions.isNotEmpty){
    for (Map item in orgAttractions){
      Map searchResult = await _searchLocations(item['name'], country);
      if (searchResult['result'] == 'FAILED'){
        //debugPrint('Cannot find this place: ' + item['name']);
      } else {
        //debugPrint(searchResult.toString());
        //add into the final list
        attractions.add({
          'trip_id': searchResult['id'],
          'name': item['name'],
          'description': item['description'],
          'duration': item['duration'],
          'image': item['image']
        });
      }
    }
  }
  return attractions;
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
  //========== some functions for attraction details
  //return list of photo urls
  getAttractionPhotos(trip_id) async{
    if (trip_id == null){
      return [];
    }
    List<String> photoUrls = [];
    //
    final response = await http.Client().post(Uri.parse(glb_trip_uri + GET_ATTRACTION_OFFICIAL_PHOTOS), 
        headers: COMMON_HEADER, body: jsonEncode({
            "poiId": trip_id,
            "index": 1, //page index
            "count": 20,
            "head": COMMON_TRIP_HEAD
        }));
    if (response.statusCode != 200){
      return {'result': 'FAILED', 'message': 'Cannot get content from cloud'};
    } else {
      Map objFromCloud = jsonDecode(response.body);
      if (objFromCloud['recommendPhoto'] != null && objFromCloud['recommendPhoto']['photoList'] != null){
        for (Map photo in objFromCloud['recommendPhoto']['photoList']){
          photoUrls.add(photo['imageUrl']);
        }
      }
    }
    return photoUrls;
  }
  //get tours
  /*
  getAttractionThings2Do(trip_id, currency) async{
    if (trip_id == null){
      return [];
    }
    List thingsTodoList = [];
    //
    final response = await http.Client().post(Uri.parse(glb_trip_uri + GET_THINGS_TODO), 
        headers: COMMON_HEADER, body: jsonEncode({
          "clientInfo": {
              "currency": currency,
              "locale": "en-US",
              "channelId": 116,
              "platformId": 24
          },
          "enviroment": "PROD",
          "sceneId": trip_id,
          "sourcePageType": 11,
          "head": {
              "cid": "09034019213961169233"
          }
      }));
    if (response.statusCode != 200){
      return {'result': 'FAILED', 'message': 'Cannot get content from cloud'};
    } else {
      Map objFromCloud = jsonDecode(response.body);
      if (objFromCloud['data'] != null && objFromCloud['data']['recommends'] != null && objFromCloud['data']['recommends'].length > 0){
        for (Map item in objFromCloud['data']['recommends'][0]["newProducts"]){
          thingsTodoList.add({
            'name': item['name'],
            'reviews': item['reviews'],
            'price': item['minPrice']['price'].toString() + ' ' + item['minPrice']['currency'],
            'imgUrl': item['imgInfo']['imgUrl'],
            'imgUrls': item['mediaInfo']['images'].map((name) => name['url']).toList()
          });
        }
      }
    }
    return thingsTodoList;
  }
  */
  //get restaurants
  getAttractionThings2EatNVisit(city_id, currency) async{
    if (city_id == null){
      return {};
    }
    List places2Visit = [];
    List what2Eat = [];
    //
    final response = await http.Client().post(Uri.parse(glb_trip_uri + GET_THINGS_2_EAT_N_VISIT), 
        headers: COMMON_HEADER, body: jsonEncode({
          "districtId": city_id,
          "moduleList": [
              "classicRecommendSight",
              "classicRecommendRestaurant"
          ],
          "head": COMMON_TRIP_HEAD
      }));
    if (response.statusCode != 200){
      return {'result': 'FAILED', 'message': 'Cannot get content from cloud'};
    } else {
      Map objFromCloud = jsonDecode(response.body);
      if (objFromCloud['moduleList'] != null && objFromCloud['moduleList'].length > 0){
        for (Map module in objFromCloud['moduleList']){
          if (module['typeName'] == 'classicRecommendSight' && module['classicRecommendSightModule']['sightList'] != null && module['classicRecommendSightModule']['sightList'].length > 0){
            for (Map item in module['classicRecommendSightModule']['sightList'][0]['sightList']){
              places2Visit.add({
                'name': item['name'],
                'commentNum': item['commentNum'],
                'imgUrl': item['imageUrl']
              });
            }
          } //end if module
        }
      }
    }
    return {
      'places2Visit': places2Visit,
      'what2Eat': what2Eat
    };
  }