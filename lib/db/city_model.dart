//author: Sang Do
// ignore_for_file: non_constant_identifier_names
//basic info about cities over the world

import 'dart:convert';

class City {
    String uuid;  //random unique ID because Metadata has only 1 record
    late String name;
    late String country;
    late String continent;
    late int review;
    late String img;
    late int city_id; //ID in trip
    late String imgUrls;  //list of image urls
    late String wonder_id;  //ID in wonder, used to generate the trip id
    late String cache_trip_date;  //cache the date of latest generated Trip (dd-MM-yyyy)
    late String wonder_trip_id; //cache the trip id in 1 day

  City({
    required this.uuid,
    required this.name,
    required this.country,
    required this.continent,
    required this.review,
    required this.img,
    required this.city_id,
    required this.imgUrls,
    required this.wonder_id,
    required this.cache_trip_date,
    required this.wonder_trip_id
  });

  City.empty({
    required this.uuid
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      continent: json['continent'] as String,
      review: json['review'] as int,
      img: json['img'] as String,
      city_id: json['city_id'] as int,
      imgUrls: jsonEncode(json['imgUrls']),
      wonder_id: json['wonder_id'] as String,
      cache_trip_date: json['cache_trip_date'] as String,
      wonder_trip_id: json['wonder_trip_id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'country': country,
      'continent': continent,
      'review': review,
      'img': img,
      'city_id': city_id,
      'imgUrls': imgUrls,
      'wonder_id': wonder_id,
      'cache_trip_date': cache_trip_date,
      'wonder_trip_id': wonder_trip_id,
      };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      uuid: map['uuid'],
      name : map['name'],
      country : map['country'],
      continent : map['continent'],
      review: map['review'],
      img: map['img'],
      city_id: map['city_id'],
      imgUrls: map['imgUrls'],
      wonder_id: map['wonder_id'],
      cache_trip_date: map['cache_trip_date'],
      wonder_trip_id: map['wonder_trip_id']
    );
  }
}