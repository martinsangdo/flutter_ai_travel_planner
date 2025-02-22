//author: Martin SangDo
//common functions
//parse to get useful info
import 'dart:convert';

import 'package:ai_travel_planner/constants.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> parseRawTripDetails(rawData){
  Map<String, dynamic> results = {};
  int index = 0;
  for (dynamic item in rawData){
    if (item == ''){
      continue;
    }
    if (index > 20){
      break;
    }
    //debugPrint('Index ======= ' + index.toString());
    if (!isPrimitive(item)){
      //this is object
      if (item is List){
        //this is an array or object
        //debugPrint(item.length.toString());
      } else if (item is Map){
        if (item['locationName'] != null){
          results['locationName'] = rawData[item['locationName']];
        }
      }
    }
    index++;
  }
    

  return results;
}