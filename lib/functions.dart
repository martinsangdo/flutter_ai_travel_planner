//author: Martin SangDo
//common functions
//parse to get useful info
import 'dart:convert';

import 'package:ai_travel_planner/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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
String formatDate(String inputDate) {
  // Parse the input date string, handling the 'Z' for UTC
  DateTime dateTime = DateTime.parse(inputDate).toLocal(); // Convert to local time

  // Format the date as 'dd-MM-yyyy'
  DateFormat formatter = DateFormat(APP_DATE_FORMAT);
  return formatter.format(dateTime);
}

//find all details of 1 place
  Map findAttractionDetails(intAttractionId){
    Map finalResult = {};
    //1.1 image list https://uk.trip.com/restapi/soa2/18066/searchMomentList
    
    //2. list of reviews https://uk.trip.com/restapi/soa2/19707/getReviewSearch (with photos)

    //(Things to do) day tours https://uk.trip.com/restapi/soa2/14580/json/getCrossRecommendProduct

    //get tour details https://uk.trip.com/restapi/soa2/21052/getProductInfo

    //4. related places (https://uk.trip.com/restapi/soa2/18762/getInternalLinkModuleList)

    //(What to eat) https://www.trip.com/restapi/soa2/23044/getDestinationPageInfo.json

    //recommend cities: saved in db with cities in a country

    return finalResult;
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
          results['travelDate'] = formatDate(results['travelAt']);
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
          int budgetMetaIndex = item['budget'];
          Map<String, dynamic> budgetMeta = rawData[budgetMetaIndex];
          for (String key in budgetMeta.keys){
            if (key == 'summary' || key == ''){
              continue;
            }
            results['budgets'][key] = [];
            //get list of budget types
            for (int accommodationIndex in rawData[budgetMeta[key]]){
              results['budgets'][key].add({
                'type': rawData[rawData[accommodationIndex]['type']],
                'priceUsd': double.parse(rawData[rawData[accommodationIndex]['priceUsd']])
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
          List<dynamic> daysMetaIndexes = rawData[rawData[item['tripResult']]['days']]; //[81, 160, 254]
          List dayResults = [];
          for (int dayMetaIndex in daysMetaIndexes){  //dayMetaIndex: day 1, 2, ...
            List<Map> dayActivities = []; //activities in 1 day
            List<dynamic> activityMetaIndexes = rawData[rawData[dayMetaIndex]['activities']];
            for (int activityMetaIndex in activityMetaIndexes){
              dayActivities.add({
                'name': rawData[rawData[activityMetaIndex]['location']], //activity name
                'description': rawData[rawData[activityMetaIndex]['description']],  //activity description
                'duration': rawData[rawData[activityMetaIndex]['durationMin']]  //activity duration, in minutes
              });
            }
            dayResults.add(dayActivities);
          }
          results['dayResults'] = dayResults;
        }
      }
    } else if (item is String){
      //this can be key or value
      
    }
    index++;
  }
  //get hotel list
  results['hotelList'] = await _getHotelList(results['city'], results['travelAt']);
  //
  return results;
}
//query hotel list in city
Future<List> _getHotelList(city, travelDate) async {
  String endDate = addDaysToDate(travelDate, DURATION_DAYS);  //add 5 days as default
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
        'price': item["price"].isNotEmpty?item["price"]+' /night': '',
        'rating': item['ratingScore'],
        'url': item["url"]
      });
    }
    return transformedList;
  }
}