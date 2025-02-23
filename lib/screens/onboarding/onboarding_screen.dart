import 'dart:convert';

import 'package:ai_travel_planner/db/city_model.dart';
import 'package:ai_travel_planner/db/database_helper.dart';
import 'package:ai_travel_planner/db/metadata_model.dart';
import 'package:ai_travel_planner/entry_point.dart';
import 'package:ai_travel_planner/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

import 'components/onboard_content.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  _testGetCities(cityKeyword) async{
    if (cityKeyword.length < 2){
      return [];
    }
    final response = await http.Client().get(Uri.parse(glb_wonder_uri + SEARCH_LOCATION + cityKeyword));
    if (response.statusCode != 200){
        debugPrint('Cannot get locations from cloud');
        
      } else {
        Map<String, dynamic> objResponse = jsonDecode(response.body);
        //debugPrint(objResponse.toString());
        List<Map<String, dynamic>> locationList = [];

        if (objResponse['destinationMetas'] != null){
          for (Map<String, dynamic> item in objResponse['destinationMetas']){
            locationList.add({
              "id": item['id'],
              "country": item['countryMeta']['name'],
              'city': item['cityMeta']['name']
            });
          }
          debugPrint(locationList.toString());
        }
        return locationList;
      }
  }
  _generateNewTripPlanner(locationId) async{
    final headers = {'Content-Type': 'application/json'}; // Important for JSON requests
    
    final response = await http.Client().post(Uri.parse(glb_wonder_uri + GENERATE_NEW_TRIP_PLANNER), 
        headers: headers, body: jsonEncode({
          "destinationDestinationId": locationId,
          "travelAt": "2025-03-20T00:00:00.000Z",
          "days": 3,
          "budgetType": 2,
          "groupType": 1,
          "activityTypes": [
            1,
            5
          ],
          "isVegan": false,
          "isHalal": false
        }));
    //debugPrint(response.body.toString());
    if (response.statusCode != 200){
      //debugPrint('Cannot get content from cloud');
      return {'result': 'FAILED', 'message': 'Cannot create trip ID'};
    } else {
      Map<String, dynamic> objFromCloud = jsonDecode(response.body);
      //debugPrint(objFromCloud.toString());
      return {'result': 'OK', 'id': objFromCloud['id']};
    }
  }

  _getHotelList(cityKeyword, start_date, end_date) async{
    if (cityKeyword.length < 2){
      return [];
    }
    String url = glb_wonder_uri + GET_HOTEL_LIST + 'city=' + cityKeyword + '&start=' + start_date + '&end=' + end_date;
    //debugPrint(url);
    final response = await http.Client().get(Uri.parse(url));
    if (response.statusCode != 200){
        debugPrint('Cannot get data from cloud');
        
      } else {
        Map<String, dynamic> objResponse = jsonDecode(response.body);
        //debugPrint(objResponse['data'].toString());
        List<Map<String, dynamic>> resultList = [];

        if (objResponse['data'] != null){
          for (Map<String, dynamic> item in objResponse['data']){
            resultList.add({
              "name": item['name'],
              "price": item['price'],
              'city': item['location']['city'],
              "ratingScore": item['ratingScore'],
              "stars": item['stars'],
              "images": item['images'][0],
              "url": item['url']  //todo replace our aid
            });
          }
          debugPrint(resultList.toString());
        }
        return resultList;
      }
  }

  _getGeneralInfo(tripId) async{
    final response = await http.Client().get(Uri.parse(GET_GENERAL_TRIP_ID + tripId + '/budget:blocking'));
    if (response.statusCode != 200){
        debugPrint('Cannot get data from cloud');
        return {'result': 'FAILED', 'message': 'Cannot create trip ID'};
      } else {
        Map<String, dynamic> objResponse = jsonDecode(response.body);
        debugPrint(objResponse.toString());
        
        return objResponse;
      }
  }
  //
  _find_n_match_attractions(tripId, countryName, dayIndex) async{
    //1. find all locations

    //2. find possible locations in day 1
    String dayUrl = glb_wonder_alias_uri + tripId + '/days/' + dayIndex.toString() + ':blocking';
    final response = await http.Client().get(Uri.parse(dayUrl));
    if (response.statusCode != 200){
      debugPrint('Cannot get data from cloud');
      return {};
    } else {
      Map<String, dynamic> objResponse = jsonDecode(response.body);
      //debugPrint(objResponse.toString());
      if (objResponse['activities'] != null){
        String firstLocation = objResponse['activities'][0]['location'];

        
      }

      return objResponse;
    }
  
    //3. find all info of location
  }
  //1. load metadata of project
    void fetchMetadata() async {
      final response = await http.Client().get(Uri.parse(METADATA_URL));
      if (response.statusCode != 200){
        debugPrint('Cannot get metadata from cloud');
        //display something or check if we had metadata in sqlite
        refreshMetaDataWithCloudData(MetaDataModel.empty(uuid: ""));
      } else {
        final metadataObjFromCloud = MetaDataModel.fromJson(jsonDecode(response.body));
        //Query db & compare with latest data from cloud
        refreshMetaDataWithCloudData(metadataObjFromCloud);
      }
    }
    //
  void refreshMetaDataWithCloudData(MetaDataModel metadataObjFromCloud) async{
    //check if table metadata existed
      final metadataInDB = await DatabaseHelper.instance.rawQuery('SELECT * FROM metadata', []);
        if (metadataInDB.isEmpty){
          //there is no metadata in db
          if (metadataObjFromCloud.uuid != ""){
            //insert new
            DatabaseHelper.instance.insertMetadata(metadataObjFromCloud).then((id){
              debugPrint('Inserted metadata into db');
              updateGlobalVariablesNMove2Home(metadataObjFromCloud, false);
              //insert cities into db
              fetchCities(metadataObjFromCloud.cities_url);
            });
          } else {
            //todo: no data from db neither cloud -> should tell them to close app & try again
          }
        } else if (metadataObjFromCloud.uuid != ""){
          debugPrint('Metadata existed in db time: ${metadataInDB[0]['update_time']}');
          //compare update_time
          var updateTimeInDB =  metadataInDB[0]['update_time'];
          var updateTimeInCloud =  metadataObjFromCloud.update_time;
          if (updateTimeInDB != updateTimeInCloud){
            //update metadata in db
            DatabaseHelper.instance.updateMetadata(metadataObjFromCloud).then((id){
              debugPrint('Updated new metadata into db');
              updateGlobalVariablesNMove2Home(metadataObjFromCloud, false);
              //update cities to db
              fetchCities(metadataObjFromCloud.cities_url);
            });
          } else {
            //do nothing because there is no new info from cloud
            updateGlobalVariablesNMove2Home(metadataObjFromCloud, true);
          }
        } else {
          //do nothing because metadata existed in db & has nothing new from cloud
          updateGlobalVariablesNMove2Home(metadataInDB[0], true);
        }
  }
  //
  //upsert cities data from cloud
  void refreshCitiesWithCloudData(List<City> cities) async{
    //check if there is any city in db or not
    List<Map> result = await DatabaseHelper.instance.rawQuery('SELECT COUNT(*) FROM tb_city', []);
    if (result.isEmpty){
      //no data in db
      if (cities.isEmpty){
        //todo: no data from db neither cloud -> should tell them to close app & try again
      } else {
        updateCityDataAndOpenHome(cities);
      }
    } else {
      //there is city data in db -> insert all
      updateCityDataAndOpenHome(cities);
    }
  }
  //get cities data from cloud
  void fetchCities(String cityUrl) async {
    final response = await http.Client().get(Uri.parse(cityUrl));
    if (response.statusCode != 200){
      debugPrint('Cannot get cities from cloud');
      move2HomePage();
    } else {
      final parsed =
        (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
      List<City> list = parsed.map<City>((json) => City.fromJson(json)).toList();
      refreshCitiesWithCloudData(list);
    }
  }

  void updateCityDataAndOpenHome(List<City> cities) async{
    await DatabaseHelper.instance.upsertBatch(cities);  //ensure data is inserted or update with "await"
    move2HomePage();
  }
  //update app global variables from metadata
  updateGlobalVariablesNMove2Home(metadataObj, isMove2Home){
  //save variables to global space
    glb_gem_key = metadataObj.gem_key;
    glb_gem_uri = metadataObj.gem_uri;
    glb_hotel_booking_aff_id = metadataObj.hotel_booking_aff_id;
    glb_wonder_uri = metadataObj.wonder_uri;
    glb_wonder_alias_uri = metadataObj.wonder_alias_uri;
    glb_trip_uri = metadataObj.trip_uri;
    glb_home_cities = jsonDecode(metadataObj.home_cities);
    if (isMove2Home){
      move2HomePage();
    }
  }
  //
  move2HomePage(){
    if (context.mounted) {
      Future.delayed(const Duration(milliseconds: 3000*1000));  //delay screen 3 secs
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  void initState() {
      super.initState();
      //_testGetCities('lond');
      //_generateNewTripPlanner("GB/ENG/London");
      //_getHotelList('london', '2025-02-20','2025-02-23');
      //_getGeneralInfo('v4-1739894726493-20387');
      //_find_n_match_attractions('v4-1739900073441-75474', 'United Kingdom', 1);
    fetchMetadata();
  } 

  @override
  void dispose() {
    super.dispose();
  }

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 14,
              child: PageView.builder(
                itemCount: demoData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  illustration: demoData[index]["illustration"],
                  title: demoData[index]["title"],
                  text: demoData[index]["text"],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// Demo data for our Onboarding screen
List<Map<String, dynamic>> demoData = [
  {
    "illustration": "assets/images/ai_travel_logo_1024.png",
    "title": "",
    "text":
        "Loading ...",
  }
];
