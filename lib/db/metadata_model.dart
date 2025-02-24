//author: Sang Do
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class MetaDataModel {
    String uuid;  //random unique ID because Metadata has only 1 record
    late String gem_key;
    late String gem_uri;
    late String backend_uri;
    late int update_time;
    late String home_cities;  //this is a json
    late String hotel_booking_aff_id;
    late String wonder_uri;
    late String wonder_alias_uri;
    late String trip_uri;
    late String android_version;
    late String ios_version;
    late String cities_url; //link to get city data

  MetaDataModel({
    required this.uuid,
    required this.gem_key,
    required this.gem_uri,
    required this.backend_uri,
    required this.update_time,
    required this.home_cities,
    required this.hotel_booking_aff_id,
    required this.wonder_uri,
    required this.wonder_alias_uri,
    required this.trip_uri,
    required this.android_version,
    required this.ios_version,
    required this.cities_url
  });

  MetaDataModel.empty({
    required this.uuid
  });

  //parse JSON data from cloud to local db (we need to check key definitions)
  factory MetaDataModel.fromJson(Map<String, dynamic> json) {
    return MetaDataModel(
      uuid: json['uuid'] as String,
      gem_key: json['gem_key'] as String,
      gem_uri: json['gem_uri'] as String,
      backend_uri: json['backend_uri'] as String,
      update_time: json['update_time'] as int,
      home_cities: jsonEncode(json['home_cities']),
      hotel_booking_aff_id: json['hotel_booking_aff_id'] as String,
      wonder_uri: json['wonder_uri'] as String,
      wonder_alias_uri: json['wonder_alias_uri'] as String,
      trip_uri: json['trip_uri'] as String,
      android_version: json['android_version'] as String,
      ios_version: json['ios_version'] as String,
      cities_url: json['cities_url'] as String
    );
  }
  //convert from object to JSON before insert/update to local db
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'gem_key': gem_key,
      'gem_uri': gem_uri,
      'backend_uri': backend_uri,
      'update_time': update_time,
      'home_cities': home_cities,
      'hotel_booking_aff_id': hotel_booking_aff_id,
      'wonder_uri': wonder_uri,
      'wonder_alias_uri': wonder_alias_uri,
      'trip_uri': trip_uri,
      'android_version': android_version,
      'ios_version': ios_version,
      'cities_url': cities_url
      };
  }

  factory MetaDataModel.fromMap(Map<String, dynamic> map) {
    return MetaDataModel(
      uuid: map['uuid'],
      gem_key : map['gem_key'],
      gem_uri : map['gem_uri'],
      backend_uri : map['backend_uri'],
      update_time: map['update_time'],
      home_cities: map['home_cities'],
      hotel_booking_aff_id: map['hotel_booking_aff_id'],
      wonder_uri: map['wonder_uri'],
      wonder_alias_uri: map['wonder_alias_uri'],
      trip_uri: map['trip_uri'],
      android_version: map['android_version'],
      ios_version: map['ios_version'],
      cities_url: map['cities_url']
    );
  }
}