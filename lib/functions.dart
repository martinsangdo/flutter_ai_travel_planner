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
        //accommodation budget
        if (item['budget'] != null){
          int accommodationsBudgetIndex = item['budget'];
          results['accommodations'] = [];
          //get list of accommodations
          Map acommodationMetaIndexes = rawData[accommodationsBudgetIndex];
          debugPrint(acommodationMetaIndexes.toString());
          for (int accommodationIndex in rawData[acommodationMetaIndexes['accommodations']]){
            results['accommodations'].add({
              'type': rawData[rawData[accommodationIndex]['type']],
              'priceUsd': rawData[rawData[accommodationIndex]['priceUsd']]
            });
          }
        }

      }
    } else if (item is String){
      //this can be key or value
      
    }
    index++;
  }
    

  return results;
}