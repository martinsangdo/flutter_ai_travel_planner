//author: Martin SangDo
//common functions
//parse to get useful info
import 'dart:convert';

import 'package:ai_travel_planner/constants.dart';
import 'package:flutter/material.dart';

/*
return:
- city
- country
- start date
- currency
- 
*/
Map<String, dynamic> parseRawTripDetails(rawData){
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
        //begin date
        if (item['travelAt'] != null){
          results['travelAt'] = rawData[item['travelAt']];
        }
        //currency

        //
        if (item['description'] != null){
          results['description'] = rawData[item['description']];
        }
        if (item['history'] != null){
          results['history'] = rawData[item['history']];
        }
        // budgets
        if (item['budget'] != null){
          int budgetMetaIndex = item['budget'];
          Map<String, dynamic> budgetMeta = rawData[budgetMetaIndex];
          for (String key in budgetMeta.keys){
            if (key == 'summary'){
              continue;
            }
            results[key] = [];
            //get list of budget types
            for (int accommodationIndex in rawData[budgetMeta[key]]){
              results[key].add({
                'type': rawData[rawData[accommodationIndex]['type']],
                'priceUsd': rawData[rawData[accommodationIndex]['priceUsd']]
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
        //todo get hotel list
      }
    } else if (item is String){
      //this can be key or value
      
    }
    index++;
  }
    

  return results;
}