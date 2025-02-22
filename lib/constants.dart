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
// Common Text
final Center kOrText = Center(
    child: Text("Or", style: TextStyle(color: titleColor.withOpacity(0.7))));
//my customization
String appDateFormat = 'dd/MM/yyyy';
//global variables
String glb_booking_aid = '';  //todo replace our aid
String glb_wonder_uri = 'https://wonderplan.ai/api/';
String glb_wonder_alias_uri = 'https://sonderback-us-6h6yp6ucpq-uc.a.run.app/v4/trips/';
String glb_backend_uri = '';  //our internal BE
String postGetChatboxContent = '';
//message
String CHATBOT_UNAVAILABLE = 'The AI service is unavailable now. Please try in another time.';
//
const SEARCH_LOCATION = "v1/destinations?q=";
const GENERATE_NEW_TRIP_PLANNER = 'v4/trips/generate';
const GET_HOTEL_LIST = 'v4/trips/accommondation?';
const GET_GENERAL_TRIP_ID = '';
const GET_DAILY_ACTIVITIES = '';