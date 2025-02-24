//author: Sang Do
// ignore_for_file: non_constant_identifier_names
//basic info about cities over the world

import 'dart:convert';

import 'package:ai_travel_planner/constants.dart';

class City {
    String uuid;  //random unique ID because Metadata has only 1 record
    late String name;
    late String country;
    // late String continent;
    late int review;
    late String img;
    late int city_id; //ID in trip
    late String imgUrls;  //list of image urls
    late String wonder_id;  //ID in wonder, used to generate the trip id
    late String travel_date;  //cache the date of latest generated Trip ('dd/MM/yyyy')
    late String wonder_trip_id; //cache the trip id in 1 day

  City({
    required this.uuid,
    required this.name,
    required this.country,
    // required this.continent,
    required this.review,
    required this.img,
    required this.city_id,
    required this.imgUrls,
    required this.wonder_id,
    required this.travel_date,
    required this.wonder_trip_id
  });

  City.empty({
    required this.uuid
  });
  //parse JSON data from cloud to local db (we need to check key definitions)
  factory City.fromJson(Map<String, dynamic> json) {
    String _uuid = (json['uuid'] != null) ? json['uuid']: generateUuid();
    String li = (json['li'] != null)?jsonEncode(json['li']): '[]';

    return City(
      uuid: _uuid,
      name: json['n'] as String,
      country: json['c'] as String,
      city_id: json['ci'] as int,
      wonder_id: json['wi'] as String,
      // continent: json['continent'] as String,
      //below can be empty
      review: json['rc']??0,
      img: json['i']??'',
      imgUrls: li,
      travel_date: json['travel_date']??'', //cache travel date
      wonder_trip_id: json['wonder_trip_id']??''  //generated ID when we search in app
    );
  }
  //convert from object to JSON before insert/update to local db
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'country': country,
      // 'continent': continent,
      'review': review,
      'img': img,
      'city_id': city_id,
      'imgUrls': imgUrls,
      'wonder_id': wonder_id,
      'travel_date': travel_date,
      'wonder_trip_id': wonder_trip_id,
      };
  }

  factory City.fromMap(Map<dynamic, dynamic> map) {
    return City(
      uuid: map['uuid'],
      name : map['name'],
      country : map['country'],
      // continent : map['continent'],
      review: map['review'],
      img: map['img'],
      city_id: map['city_id'],
      imgUrls: map['imgUrls'],
      wonder_id: map['wonder_id'],
      travel_date: map['travel_date'],
      wonder_trip_id: map['wonder_trip_id']
    );
  }
}