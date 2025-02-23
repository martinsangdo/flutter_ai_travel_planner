import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:uuid/uuid.dart';

// clolors that we use in our app
const titleColor = Color(0xFF010F07);
const primaryColor = Color(0xFF22A45D);
const accentColor = Color(0xFFEF9920);
const bodyTextColor = Color(0xFF868686);
const inputColor = Color(0xFFFBFBFB);

const double defaultPadding = 16;
const Duration kDefaultDuration = Duration(milliseconds: 250);

const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

const EdgeInsets kTextFieldPadding = EdgeInsets.symmetric(
  horizontal: defaultPadding,
  vertical: defaultPadding,
);

// Text Field Decoration
const OutlineInputBorder kDefaultOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(6)),
  borderSide: BorderSide(
    color: Color(0xFFF3F2F2),
  ),
);

const InputDecoration otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  counterText: "",
  errorStyle: TextStyle(height: 0),
);

const kErrorBorderSide = BorderSide(color: Colors.red, width: 1);

//
String generateUuid() {
    const uuid = Uuid();
    return uuid.v4(); // Generate a version 4 (random) UUID
  }

int getCurrentTimestampInSeconds() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;
}

bool isPrimitive(dynamic value) {
  return value is num || value is int || value is bool || value is String || value == null;
}

// Common Text
final Center kOrText = Center(
    child: Text("Or", style: TextStyle(color: titleColor.withOpacity(0.7))));
//my customization
Map<String, String> COMMON_HEADER = { //used when scraping
  'Content-Type': 'application/json',
  "User-Agent": 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36',
};
Map<String, dynamic> COMMON_TRIP_HEAD = {
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
            };
String APP_DATE_FORMAT = 'dd/MM/yyyy';
int DURATION_DAYS = 5;   //no. of days that user will travel
//global variables
String glb_booking_aid = '';  //todo replace our aid
String glb_wonder_uri = 'https://wonderplan.ai/';
String glb_wonder_alias_uri = 'https://sonderback-us-6h6yp6ucpq-uc.a.run.app/v4/trips/';
String glb_backend_uri = 'http://10.115.138.56:8080/';  //our internal BE
String postGetChatboxContent = '';
String postGetRawData = 'post_query_raw_url';
String glb_trip_uri = 'https://us.trip.com/restapi/soa2/';
//message
String CHATBOT_UNAVAILABLE = 'The AI service is unavailable now. Please try in another time.';
//
const SEARCH_LOCATION = "v1/destinations?q=";
const GENERATE_NEW_TRIP_PLANNER = 'v4/trips/generate';
const GET_HOTEL_LIST = 'v4/trips/accommondation?';
const GET_GENERAL_TRIP_ID = '/v4/plan/v4-1739922077865-80005/__data.json';
const GET_DAILY_ACTIVITIES = '';
//trip
const SEARCH_LOCATIONS = '20400/getGsMainSuggestForTripOnline';
const GET_ATTRACTION_OFFICIAL_PHOTOS = '19913/getTripPoiPhotoGallery';
const GET_THINGS_TODO = '14580/json/getCrossRecommendProduct';

//for debugging
bool isDebug = true;  //todo remove this flag when releasing
String test_trip_id = 'v4-1739922077865-80005';   //to test the fixed city, avoid creating many trip ID
int test_attraction_id = 78699;
int test_city_id = 309; //london
String test_currency = 'USD';